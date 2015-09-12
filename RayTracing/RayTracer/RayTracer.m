//
//  RayTracer.m
//  Ray tracing
//
//  Created by Fabrizio Duroni on 07/07/15.
//  Copyright (c) 2015 Fabrizio Duroni. All rights reserved.
//

#include <libkern/OSAtomic.h>

#import <UIKit/UIKit.h>

#import "Constants.h"
#import "Scene.h"
#import "AreaLight.h"
#import "Light.h"
#import "Camera.h"
#import "Vector3D.h"
#import "Point3D.h"
#import "ViewPlane.h"
#import "PerlinTexture.h"
#import "Material.h"
#import "Sphere.h"
#import "Polygon.h"
#import "Ray.h"
#import "Utils.h"
#import "CubeMappingSkybox.h"
#import "PolygonSkyboxSide.h"
#import "RayTracer.h"

@interface RayTracer()

/// Bool used to check if I need to apply antialiasing.
@property (nonatomic, assign) BOOL isAntialiasingActive;
/// Bool used to check if I need to apply soft shadow.
@property (nonatomic, assign) BOOL isSoftShadowActive;
/// Light model
@property (nonatomic, assign) LightingModel lighting;
/// Scene data.
@property (nonatomic, strong) Scene *scene;

@end

@implementation RayTracer

#pragma mark init

- (instancetype)initWithViewPlane:viewPlane
                         andScene:(NSInteger)sceneIdentifier
                      andLighting:(LightingModel)lighting
                andCameraPosition:(NSInteger)cameraPosition
            andAntialiasingActive:(BOOL)isAntialiasingActive
              andSoftShadowActive:(BOOL)isSoftShadowActive {
    
    if(self = [super init]) {
        
        //Init the scene selected.
        self.scene = [[Scene alloc] initWithIdentifier:sceneIdentifier andCameraPositon:cameraPosition andSoftShadowActive:isSoftShadowActive];
        
        //Init of the view plane.
        self.vplane = viewPlane;
        
        //Option flags.
        self.lighting = lighting;
        self.isAntialiasingActive = isAntialiasingActive;
        self.isSoftShadowActive = isSoftShadowActive;
    }
    
    return self;
}

#pragma mark Run ray tracer

- (void)runRayTracer:(void (^)(NSMutableArray *, float, float))endTracer {
    
    //Camera setup.
    Camera *camera = [[Camera alloc]
                      initWithViewReferencePoint:self.scene.viewReferencePoint
                      andLookAtPoint:self.scene.lookAtPoint
                      andViewUp:[[Vector3D alloc] initX:0 Y:1 Z:0]
                      andViewPlane:self.vplane
                      andViewPlaneDistance:self.scene.viewPlaneDistance];
    
    //The ray instance is always the same.
    //I update its direction in the loops (origin is common to every ray).
    //In this way we avoid to have other autorelease object to be
    //cleaned in the autorelease pool (see below).
    Ray *ray = [[Ray alloc] init];
    ray.origin = self.scene.viewReferencePoint;
    
    //Start time
    [Utils currentTime:@"Start"];
    
    //Start ray tracer.
    //I use the new queue management available since iOS8.
    //This version of iOS gives us thread quality of service (QOS) classes.
    //I use QOS_CLASS_USER_INITIATED: this kind of class doesn't block the
    //UI but it runs with a priority that is almost the same.
    //So great performance and update to UI possible (but drain battery fast).
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        NSMutableArray *pixels = [[NSMutableArray alloc] initWithCapacity:self.vplane.area];
        
        int currentPixelPosition = 0;
        
        for (int y = 0; y < self.vplane.height; y++) {
            
            //On each iteration of the outer loop
            //a lot of obect are created in autorelease. So we need to use
            //an autorelease pool to force release/free those objects on the
            //next iteration (so the start of the next row).
            //This is a mandatory operation because ARC with autorelease
            //generate thousands of objects not released until the end of the entire
            //outer loop if you remove the autorelease pool (and the app will crash).
            @autoreleasepool {
                
                for (int x = 0;  x < self.vplane.width;  x++) {
                    
                    Vector3D *color = [[Vector3D alloc]initX:0 Y:0 Z:0];
                    
                    if(self.isAntialiasingActive == true) {
                        
                        //ANTIALIASING.
                        
                        //Distributed ray tracing.
                        //I apply antialiasing using supersampling, 4 subpixel for each pixel.
                        for (int i = 0; i < 2; i++) {
                            for (int j = 0;  j < 2;  j++) {
                                
                                float u = x + ((i + 0.5) / 2);
                                float v = y + ((j + 0.5) / 2);
                                
                                //Compute ray direction in camera coordinate.
                                //SEE THE COMMENT IN THE TYPE SIGNATURE OF THE METHOD AND
                                //IN THE METHOD ITSELF for a brief examplanation.
                                ray.direction = [camera rayInCameraCoordinateSystemWithX:u andY:v];
                                
                                //Trace ray.
                                color = [color sum:[self trace:ray bounce:maxNumberOfBounce]];
                            }
                        }
                        
                        color = [color productWithScalar:0.25];
                    } else {
                        
                        //NO ANTIALIASING.
                        
                        //Compute ray direction in camera coordinate.
                        //SEE THE COMMENT IN THE TYPE SIGNATURE OF THE METHOD AND
                        //IN THE METHOD ITSELF for a brief examplanation.
                        ray.direction = [camera rayInCameraCoordinateSystemWithX:x andY:y];
                        
                        //Trace ray.
                        color = [self trace:ray bounce:maxNumberOfBounce];
                    }
                    
                    [pixels insertObject:color atIndex:currentPixelPosition++];
                }
                
                if((y + 1)% 25 == 0) {
                    
                    endTracer([pixels copy], y+1, self.vplane.width);
                }
            }
        }
        
        //Remove this comment if you need to print the final image at the end of computation.
        //(Comment also the call to endTracer above).
        //endTracer(pixels, self.vplane.height, self.vplane.width);
        
        //Start time
        [Utils currentTime:@"End"];
    });
}

#pragma mark trace

/*!
 Trace a ray through the scene.
 The algorithm is recursive with a limit of bounce for reflective materials.
 
 @param ray the ray launched in the scene.
 @param bounce the limit of bounce. This paramter is decrement on each ray bounce.
 
 @returns the color of the pixel as a Vector3D.
 */
- (Vector3D *)trace:(Ray *)ray bounce:(int)bounce {
    
    Vector3D *color;
    
    NSMutableDictionary *intesectionPointData = [self closestIntersection:ray forShadowRay:false];
    
    if(intesectionPointData == nil){
        
        if(self.scene.cubeMappingSkybox != nil) {
            
            //Here I read CUBE MAPPING SKYBOX with the appropriate method.
            //Not all scene have a cube mapping so I have a fallback to black color.
            //Some scene implements the skybox using a standard polygon square that wrap all the
            //scene (to highlight soft shadow rendering).
            color = [self.scene.cubeMappingSkybox readSkyboxTexture:ray];
        } else {
            
            //Default background color.
            color = [[Vector3D alloc]initX:0 Y:0 Z:0];
        }
    } else {
        
        //Apply shade on the current object.
        color = [self shade:intesectionPointData withRay:ray bounce:bounce];
    }
    
    return color;
}

#pragma mark Closest intersection

/*!
 Method used to check the closest intersection of the ray with the scene objects.
 
 @param ray the ray to be checked for intersection.
 @param isForShadowRay flag used to check if I am checking intersection for shadow 
 (in this case I avoid to check some objects (PolygonSkybox)).
 
 @returns a dictionary with Intersection data, if there's one, or nil.
 */
- (NSMutableDictionary *)closestIntersection:(Ray *)ray forShadowRay:(BOOL)isForShadowRay {
    
    float t = -1;
    NSMutableDictionary *closestIntersectionData;
    
    for (id<Model> object in self.scene.objects) {
        
        //Optimization trick:
        //If the scene use PolygonSkybox object,
        //I skip them if I am checking for intersection during soft
        //shadow (Them will never shadow other object because
        //are used as a skybox for the scene).
        if(isForShadowRay == true && [object isKindOfClass:[PolygonSkyboxSide class]]) {
            
            continue;
        }
        
        NSMutableDictionary *intersectionData = [object intersect:ray];
        
        //If there's an intersection.
        if(intersectionData != nil) {
            
            float intersectionT = [[intersectionData objectForKey:@"t"] floatValue];
            
            //If intersectionT < t the intersection is near then the previous one.
            //(t == -1 means that this is the first intersection).
            if(t == -1 || intersectionT < t) {
                
                t = intersectionT;
                closestIntersectionData = intersectionData;
            }
        }
    }
    
    return closestIntersectionData;
}

#pragma Shade

/*!
 Shading operation for the intersected object.
 
 @param intersectionData data of intersected object.
 @param ray the ray that generated the intersection.
 @param bounce the limit of bounce. This parameter is
 decrement on each internal call of trace method.
 
 @returns the color for the intersection point as a Vector3D.
 */
- (Vector3D *)shade:(NSMutableDictionary *)intersectionData withRay:(Ray *)ray bounce:(int)bounce {
    
    //Extract intersection data.
    id<Model> closestObject = [intersectionData objectForKey:@"object"];
    Point3D *closestIntersectionPoint = [intersectionData objectForKey:@"point"];
    Vector3D *normal = [intersectionData objectForKey:@"normal"];

    //Init color.
    Vector3D *color = [[Vector3D alloc]initX:0.0 Y:0.0 Z:0.0];
    
    //EMISSIVE AND AMBIENT LIGHT.
    
    //Add ambient and emissive components.
    //I need them ALWAYS in case of shadow or light point.
    //(See prof. Ciocca/Bianco ray tracing pseudo algorithm).
    color = [color sum:[Lighting emissiveLight:closestObject]];
    color = [color sum:[Lighting ambientLight:closestIntersectionPoint
                                    forObject:closestObject
                                andLightColor:self.scene.light.color]];
    
    //SHADOW.
    
    if(self.isSoftShadowActive == false) {
        
        //STANDARD SHADOW.
        
        //Stadard shadow ray calculation (one shadow ray).
        BOOL inShadow = [self inShadow:closestIntersectionPoint withPointOnLight:self.scene.light.origin];
        
        if(!inShadow) {
            
            //Apply lighting model.
            color = [color sum:[Lighting diffuseAndSpecularWithModel:self.lighting
                                                             withRay:ray
                                                 andIntersectionData:intersectionData
                                                           withLight:self.scene.light
                                             andSoftShadowPercentage:1.0f]];
        }
    } else {
        
        //SOFT SHADOW.
        //Distributed ray tracing.
        
        //Soft shadow calculation.
        //Used n shadow ray to sample penumbra shadow area
        //(see Constants.h - default 16).
        float softShadowPercentage = [self softShadow:closestIntersectionPoint];
        
        //Apply lighting model.
        color = [color sum:[Lighting diffuseAndSpecularWithModel:self.lighting
                                                         withRay:ray
                                             andIntersectionData:intersectionData
                                                       withLight:self.scene.light
                                         andSoftShadowPercentage:softShadowPercentage]];
    }
    
    //LIMIT OF BOUNCE FOR EACH RAY.
    //For example: if rays start to bounce between
    //object with reflective material, I stop the
    //bounces after n possible iteration (defined in
    //Constants.h - default 3).
    if(bounce == 0) {
        
        return color;
    }
    
    //Normalize normal.
    //I normalize here because during lighting I
    //need the normal not normalized (for example
    //for bump mapping).
    [normal normalize];
    
    //If the material is a pure reflective
    //or pure transmissive the percentage of
    //reflected or refracted ray is 1, and obviously
    //ONLY ONE TYPE OF RAY WILL BE TRACED.
    float fresnelReflected = 1.0;
    float fresnelRefracted = 1.0;
    
    //Calculate cosI between ray and normal.
    float cosI = [ray.direction dot:normal];
    
    //Realistic simulation of DIELETRICS.
    //Material like glass usually are not only transmissive.
    //They are also reflective and the percentage of light
    //reflected/refracted is calculated with one of the
    //following models:
    // - Fresnel equations.
    // - Schlick Approximation (faster but less accurate).
    //(defined in Constants.h - default FresnelEquations)
    if(closestObject.material.isTransmissive == true && closestObject.material.isReflective == true) {
        
        fresnelReflected = [ray reflectiveFresnelPercentage:closestObject andNormal:normal andCosI:cosI andFresnelFactorModel:fresnelFactorModel];
        fresnelRefracted = 1 - fresnelReflected;
    }
    
    Vector3D *reflectiveColor = [[Vector3D alloc]initX:0 Y:0 Z:0];
    Vector3D *refractiveColor = [[Vector3D alloc]initX:0 Y:0 Z:0];
    
    //REFLECTION.
    
    if (closestObject.material.isReflective == true) {
        
        //If object is reflective ray trace the reflective ray.
        Ray *reflectionRay = [ray reflectedRay:normal intersectionPoint:closestIntersectionPoint andCosI:cosI];
        reflectiveColor = [[self trace:reflectionRay bounce:bounce - 1] productWithScalar:fresnelReflected];
    }
    
    //REFRACTION.
    
    if(closestObject.material.isTransmissive == true) {
        
        //If the object is transmissive ray trace the refracted ray.
        Ray *refractedRay = [ray refractedRay:closestObject andNormal:normal intersectionPoint:closestIntersectionPoint andCosI:cosI];
        
        if(refractedRay != nil) {
            
            refractiveColor = [[self trace:refractedRay bounce:bounce - 1] productWithScalar:fresnelRefracted];
        }
    }
    
    color = [[color sum:reflectiveColor]sum:refractiveColor];
    
    return [Utils normalizeColorComponents:color];
}

#pragma mark Shadow

/*!
 Calculate soft shadow percentage for a intersection point.
 
 @param closestIntersectionPoint intersection point.
 
 @returns percentage of soft shadow as float.
 */
- (float)softShadow:(Point3D *)closestIntersectionPoint {
    
    __block int32_t intersectionsWithLight = 0;
    
    //I test if the point of intersection is visible
    //with n shadow ray generated from random points on an
    //area light sphere.
    
    //GDC multithreading shadow ray calculation.
    //https://developer.apple.com/library/ios/documentation/Performance/Reference/GCD_libdispatch_Ref/
    dispatch_group_t d_group = dispatch_group_create();
    dispatch_queue_t bg_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    for (Point3D *randomLightSpherePoint in ((AreaLight *)self.scene.light).randomSpherePoints) {
        
        dispatch_group_async(d_group, bg_queue, ^{
            
            bool inShadow = [self inShadow:closestIntersectionPoint withPointOnLight:randomLightSpherePoint];
            
            if(inShadow == false) {
                
                OSAtomicIncrement32(&intersectionsWithLight);
            }
        });
    }
    
    dispatch_group_wait(d_group, DISPATCH_TIME_FOREVER);
    
    //Last point is in shadow.
    return ((float)intersectionsWithLight)/numberOfShadowRay;
}

/*!
 Check if a point is in shadow or not.
 This method is used for standard and soft shadow.
 
 @param intersectionPoint intersection point.
 @param lightPoint point of light (from Light or sample point on AreaLight).
 
 @returns YES if point is in shadow.
 */
- (BOOL)inShadow:(Point3D *)intersectionPoint withPointOnLight:(Point3D *)lightPoint {
    
    //Shadow ray calculation.
    NSDictionary *shadowRayData = [Ray shadowRay:intersectionPoint andLight:lightPoint];
    Ray *shadowRay = [shadowRayData objectForKey:@"shadowRay"];
    
    NSMutableDictionary *intersectionData = [self closestIntersection:shadowRay forShadowRay:true];
    
    //No intersection of the ray that goes from the last
    //intersection point to the light source. So the last
    //intersection point is NOT in shadow.
    if(intersectionData == nil) {
        
        return false;
    }
    
    //Extract t (intersection distance) and d (distance from light).
    float t = [[intersectionData objectForKey:@"t"] floatValue];
    float d = [[shadowRayData objectForKey:@"d"] floatValue];
    
    //If the intersection distance is greater than
    //the distance between intersectionPoint and light
    //then the point is NOT in shadow.
    if(t > d) {
        
        return false;
    }
    
    //Ok, the point is in shadow.
    return true;
}

@end