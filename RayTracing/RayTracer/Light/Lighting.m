//
//  LightModel.m
//  Ray tracing
//
//  Created by Fabrizio Duroni on 01/08/15.
//  Copyright (c) 2015 Fabrizio Duroni. All rights reserved.
//

#import "Utils.h"
#import "Constants.h"
#import "Ray.h"
#import "Polygon.h"
#import "Vector3D.h"
#import "Point3D.h"
#import "Material.h"
#import "Light.h"
#import "PolygonSkyboxSide.h"
#import "TurbulenceTexture.h"
#import "MarbleTexture.h"
#import "BumpMap.h"
#import "PerlinNoise.h"
#import "Lighting.h"

@implementation Lighting

#pragma mark Emissive

+ (Vector3D *)emissiveLight:(id<Model>)object {
    
    //Emission is max light * ke.
    //Pure additive component.
    Vector3D *emission = [[[Vector3D alloc]initX:255 Y:255 Z:255] pprod:object.material.ke];
    
    return emission;
}

#pragma mark Ambient

+ (Vector3D *)ambientLight:(Point3D *)intersectionPoint forObject:(id<Model>)object andLightColor:(Vector3D *)lightColor {
    
    Vector3D *ambient;
    
    if(object.material.perlinTexture != nil) {
        
        //If the material has a perlin procedural texture, base color for ambient light
        //is the texel of the texture, modulated with ka material constant.
        //(This is a choice I made. Another possibility is to use the texture only for
        //the diffuse part, and use only ka as ambient component).
        Vector3D *texelModulated = [[object.material.perlinTexture texture:intersectionPoint] pprod:object.material.ka];
        //The texel modulated color is also influenced by the light color.
        ambient = [[texelModulated pprod:lightColor]productWithScalar:1.0/255.0];
    } else if([object isKindOfClass:[PolygonSkyboxSide class]]) {
        
        //Same as perlin texture.
        //Change only the method used to read the texel.
        Vector3D *texelModulatedWithmaterial = [[((PolygonSkyboxSide *)object) readPolygonSkyboxTexture:intersectionPoint] pprod:object.material.ka];
        ambient = [[texelModulatedWithmaterial pprod:lightColor] productWithScalar:1.0/255.0];
    } else {
        
        //If the material doesn't have a texture, get base color from light using material property ka.
        ambient = [object.material.ka pprod:lightColor];
    }
    
    return ambient;
}

#pragma mark Diffuse

/*!
 Get diffuse component.
 
 @param normal the normal of the object.
 @param point the point of intersection.
 @param lightDirection the light direction.
 @param lightWithSoftShadowAttenuation the light (attenuated with soft shadow percentage).
 @param object the object I use in calculation.
 
 @returns diffuse components as RGB Vector3D.
 */
+ (Vector3D *)diffuseLight:(Vector3D *)normal
      andIntersectionPoint:(Point3D *)point
         andLightDirection:(Vector3D *)lightDirection
andLightWithSoftShadowAttenuation:(Vector3D *)lightWithSoftShadowAttenuation
                 andObject:(id<Model>)object {
    
    //Calculate diffuse weight.
    float cosTetha = MAX(0, [normal dot:lightDirection]);
    Vector3D *diffuse;
    
    if(object.material.perlinTexture != nil) {
        
        //If the material has a perlin procedural texture, I apply it considering
        //the quantity of light (cosTetha) and eventually the penumbra (soft shadow).
        //The value of texture is modulated with kd material (This is one possible choice.
        //Alternatively the texture override the material kd)
        Vector3D *texelModulated = [[object.material.perlinTexture texture:point] pprod:object.material.kd];
        diffuse = [[[texelModulated productWithScalar:cosTetha] pprod:lightWithSoftShadowAttenuation] productWithScalar:1.0/255.0];
    } else if([object isKindOfClass:[PolygonSkyboxSide class]]) {
        
        //Same as perlin texture.
        //Change only the method used to read the texel.
        Vector3D *texelModulated = [[((PolygonSkyboxSide *)object) readPolygonSkyboxTexture:point] pprod:object.material.kd];
        diffuse = [[[texelModulated productWithScalar:cosTetha] pprod:lightWithSoftShadowAttenuation] productWithScalar:1.0/255.0];
    } else {
        
        //Standard case. No procedural texture. Read material parameter.
        Vector3D *kdd = [object.material.kd productWithScalar:cosTetha];
        diffuse = [lightWithSoftShadowAttenuation pprod:kdd];
    }
    
    return diffuse;
}

#pragma mark Specular

+ (Vector3D *)diffuseAndSpecularWithModel:(LightingModel)lightingModel
                                  withRay:(Ray *)ray
                      andIntersectionData:(NSMutableDictionary *)intersectionData
                                withLight:(Light *)light
                  andSoftShadowPercentage:(float)softShadowPercentage {
    
    id<Model>object = [intersectionData objectForKey:@"object"];
    Vector3D *normal = [intersectionData objectForKey:@"normal"];
    Point3D *point = [intersectionData objectForKey:@"point"];
    
    //If the material has bump mapping
    //apply distorsion to the normal.
    if (object.material.bumpMap != nil) {
        
        //Get bumped normal.
        normal =  [object.material.bumpMap bumpMapTexture:point applyToNormal:normal];
    }
    
    //Apply soft shadow to light intensity.
    //http://web.cs.wpi.edu/~emmanuel/courses/cs563/write_ups/zackw/realistic_raytracing.html
    Vector3D *lightWithSoftShadowAttenuation = [light.color productWithScalar:softShadowPercentage];
    
    //Normalize normal.
    [normal normalize];
    
    //Calculate light direction.
    Vector3D *lightDirection = [light.origin diff:point];
    [lightDirection normalize];
    
    //DIFFUSE.
    
    Vector3D *diffuse = [Lighting diffuseLight:normal
                          andIntersectionPoint:point
                             andLightDirection:lightDirection
             andLightWithSoftShadowAttenuation:lightWithSoftShadowAttenuation
                                     andObject:object];
    
    //SPECULAR.
    
    Vector3D *specular;
    Vector3D *kss;

    Vector3D *Vn = [ray.origin diff:point];
    [Vn normalize];
    
    if(lightingModel == Phong) {
        
        //Phong model.
        Vector3D *productNormalLightDirection = [normal productWithScalar:2 * [lightDirection dot:normal]];
        Vector3D *R = [productNormalLightDirection diff:lightDirection];
        [R normalize];
        
        float cosAlpha = powf(MAX(0, [R dot:Vn]), object.material.sh);
        
        kss = [object.material.ks productWithScalar:cosAlpha];
    } else {
        
        //Blinn-Phong model.
        Vector3D *H = [lightDirection sum:Vn];
        [H normalize];
        
        float cosGamma = powf(MAX(0, [H dot:normal]), object.material.sh);
        
        kss = [object.material.ks productWithScalar:cosGamma];
    }
    
    specular = [lightWithSoftShadowAttenuation pprod:kss];
    
    //Sum diffuse and specular.
    Vector3D *diffuseAndSpecular = [specular sum:diffuse];
    
    //LIGHT ATTENUTATION.
    
    float d = [[light.origin diff:point] magnitude];
    diffuseAndSpecular = [diffuseAndSpecular productWithScalar:MIN(1.0/(c1 + c2 * d + c3 * powf(d, 2)), 1)];
    
    return [Utils normalizeColorComponents:diffuseAndSpecular];
}

@end