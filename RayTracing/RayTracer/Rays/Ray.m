//
//  Ray.m
//  Ray tracing
//
//  Created by Fabrizio Duroni on 06/07/15.
//  Copyright (c) 2015 Fabrizio Duroni. All rights reserved.
//

#import "Constants.h"
#import "Material.h"
#import "Light.h"
#import "Sphere.h"
#import "Point3D.h"
#import "Vector3D.h"
#import "Utils.h"
#import "Ray.h"

@implementation Ray

#pragma mark Init

- (instancetype)initWithOrigin:(Point3D *)origin andDirectionVector:(Vector3D *)directionVector {
    
    self = [super init];
    
    if (self) {
        
        //Setup a ray with its data.
        self.origin = origin;
        self.direction = directionVector;
    }
    
    return self;
}

#pragma mark Description

- (NSString*) description {
    
    return [NSString stringWithFormat:@"Ray[Origin(%f, %f, %f) - Distance(%f, %f, %f)]",
            self.origin.x,
            self.origin.y,
            self.origin.z,
            self.direction.x,
            self.direction.y,
            self.direction.z];
}

#pragma mark Epsilon addition

/*!
 Add e small quantity to the origins of ray.
 In this way I avoid self intersection with the object itself
 during intersection test.
 
 @see "Ray tracing from the ground up", page 301 cap. "Shadows".
 
 @param point point to be shifted.
 @param direction the direction along which Ishift the point (direction of the ray).
 
 @returns the point shifted.
 */
+ (Point3D *)addEpsilonToPoint:(Point3D *)point toAvoidSelfIntersectionAlongDirection:(Vector3D *)direction {
    
    Vector3D *distanceToAvoidSelfIntersection = [direction productWithScalar:epsilon];
    [distanceToAvoidSelfIntersection normalize];
    point = [point sumVector:distanceToAvoidSelfIntersection];
    
    return point;
}

#pragma mark Reflection

- (Ray *)reflectedRay:(Vector3D *)normal intersectionPoint:(Point3D *)point andCosI:(float)cosI {
    
    cosI = -1 * cosI;
    
    //Calculate direction.
    Vector3D *reflectedRayDirection = [self.direction sum:[[normal productWithScalar:cosI]productWithScalar:2]];
    
    //Origin became the intersection point.
    //Modify it to avoid self intersection.
    Point3D *reflectedRayOrigin = [Ray addEpsilonToPoint:point toAvoidSelfIntersectionAlongDirection:reflectedRayDirection];
    
    Ray *rayReflected = [[Ray alloc] initWithOrigin:reflectedRayOrigin andDirectionVector:reflectedRayDirection];
    
    return rayReflected;
}

- (float)reflectiveFresnelPercentage:(id<Model>)object
                           andNormal:(Vector3D *)normal
                             andCosI:(float)cosI
               andFresnelFactorModel:(FresnelFactorModel)model {
    
    float fresnelReflected;
    float n1;
    float n2;
    
    //The default refractive index for n1 is 1 (vacuum).
    if(cosI < 0) {
        
        //I am going from air inside our
        //transmissive material.
        n1 = 1.0;
        n2 = object.material.refractiveIndex;
        cosI = -1.0 * cosI;
    } else {
        
        //I am going from inside our
        //transmissive material to the air.
        n1 = object.material.refractiveIndex;
        n2 = 1.0;
    }
    
    if(model == FresnelEquations) {
        
        //Fresnel equations.
        
        float n = n1/n2;
        float cosThetaT = sqrtf(1.0 - powf(n, 2) * (1.0 - (powf(cosI, 2))));
        float reflectionPerpendicular = (n1 * cosI - n2 * cosThetaT) / (n1 * cosI + n2 * cosThetaT);
        float reflectionParallel = (n2 * cosI - n1 * cosThetaT) / (n2 * cosI + n1 * cosThetaT);
        fresnelReflected = (powf(reflectionPerpendicular, 2) + powf(reflectionParallel, 2)) / 2.0;
    } else {
        
        //Schlick's approximation.
        
        float r0 = powf(((n1 - n2) / (n1 + n2)), 2);
        fresnelReflected = r0 + (1.0 - r0) * powf(1.0 - cosI, 5);
    }
    
    return fresnelReflected;
}

#pragma mark Refraction

- (Ray *)refractedRay:(id<Model>)object andNormal:(Vector3D *)normal intersectionPoint:(Point3D *)point andCosI:(float)cosI {
    
    float n;
    
    //ATTENTION:
    //All vectors used in calculation must be normalized.
    //If you don't do this, expect strange result.
    //See also prof. Ciocca/Bianco slide for refraction ray formula.
    
    //The default refractive index for n1 is 1 (vacuum).
    if(cosI < 0) {
        
        //I am going from air inside our
        //transmissive material.
        n = 1.0 / object.material.refractiveIndex;
        cosI = -1.0 * cosI;
    } else {
        
        //I am going from inside our
        //transmissive material to the air.
        //(If the outer medium change
        //remember to divide the refractive index
        //of the object with the new one).
        n = object.material.refractiveIndex;
    }
    
    float cosThetaT = sqrtf(1.0 - powf(n, 2) * (1.0 - (powf(cosI, 2))));
    
    if (cosThetaT <= 0) {
        
        //Total internal reflection.
        return nil;
    }
    
    Vector3D *temp1 = [self.direction productWithScalar:n];
    Vector3D *temp2 = [normal productWithScalar:(n * cosI - cosThetaT)];
    Vector3D *refractedRayDirection = [temp1 sum:temp2];
    
    //Origin became the intersection point.
    //Modify it to avoid self intersection.
    Point3D *refractedRayOrigin = [Ray addEpsilonToPoint:point toAvoidSelfIntersectionAlongDirection:refractedRayDirection];
    
    Ray *rayRefracted = [[Ray alloc] initWithOrigin:refractedRayOrigin andDirectionVector:refractedRayDirection];
    
    return rayRefracted;
}

#pragma mark Shadow

+ (NSDictionary *)shadowRay:(Point3D *)intersectionPoint andLight:(Point3D *)lightOrigin {
    
    Vector3D *shadowRayDirection = [lightOrigin diff:intersectionPoint];
    float magnitude = [shadowRayDirection magnitude];
    
    //Normalize the shadow ray direction.
    [shadowRayDirection normalize];
    
    //Origin became the intersection point.
    //Modify it to avoid self intersection.
    Point3D *shadowRayOrigin = [Ray addEpsilonToPoint:intersectionPoint toAvoidSelfIntersectionAlongDirection:shadowRayDirection];
    
    Ray *shadowRay = [[Ray alloc] initWithOrigin:shadowRayOrigin andDirectionVector:shadowRayDirection];
    
    NSMutableDictionary *shadowRayData = [NSMutableDictionary new];
    [shadowRayData setObject:shadowRay forKey:@"shadowRay"];
    [shadowRayData setObject:[NSNumber numberWithFloat:magnitude] forKey:@"d"];
    
    return shadowRayData;
}

@end