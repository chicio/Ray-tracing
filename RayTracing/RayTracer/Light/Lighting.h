//
//  LightModel.h
//  Ray tracing
//
//  Created by Fabrizio Duroni on 01/08/15.
//  Copyright (c) 2015 Fabrizio Duroni. All rights reserved.
//

#import "Model.h"

@import Foundation;

@class Vector3D;
@class Point3D;

@interface Lighting : NSObject

/*!
 Light model avaiable in the ray tracer.
 */
typedef NS_ENUM(NSInteger, LightingModel) {
    Phong,
    BlinnPhong
};

/*!
 Get emissive light for an object.
 
 @param object object I use in calculation.
 
 @returns the Emissive color as Vector3D.
 */
+ (Vector3D *)emissiveLight:(id<Model>)object;

/*!
 Get ambient light for an object
 
 @param intersectionPoint intersection point.
 @param object object I use in calculation.
 @param lightColor color of the light.
 
 @returns the Ambient color as Vector3D.
 */
+ (Vector3D *)ambientLight:(Point3D *)intersectionPoint
                 forObject:(id<Model>)object
             andLightColor:(Vector3D *)lightColor;

/*!
 Get diffuse and specular light for an object.
 Specular light component is calculated with one of the following
 model based on the lighting value passed:
 - Phong
 - Blinn-Phong
 
 @see prof. Ciocca/Bianco Slide.
 @see http://web.cs.wpi.edu/~emmanuel/courses/cs563/write_ups/zackw/realistic_raytracing.html (soft shadow).
 
 @param lightingModel the lighting model to be used (see enum above).
 @param ray The ray used in calculation.
 @param intersectionData data of intersection (object, normal, point...).
 @param light Light object (Standard or AreaLight).
 @param softShadowPercentage the percentage of received light (used with soft shadow).
 
 @results Vector3D that represent specular and diffusive light contribution based on phong lighting model.
 */
+ (Vector3D *)diffuseAndSpecularWithModel:(LightingModel)lightingModel
                                  withRay:(Ray *)ray
                      andIntersectionData:(NSMutableDictionary *)intersectionData
                                withLight:(Light *)light
                  andSoftShadowPercentage:(float)softShadowPercentage;

@end