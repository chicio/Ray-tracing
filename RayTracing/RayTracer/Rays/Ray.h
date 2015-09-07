//
//  Ray.h
//  Ray tracing
//
//  Created by Fabrizio Duroni on 06/07/15.
//  Copyright (c) 2015 Fabrizio Duroni. All rights reserved.
//

#import "Model.h"
#import "Constants.h"

@import Foundation;

@class Light;
@class Sphere;
@class Point3D;
@class Vector3D;

@interface Ray : NSObject

/// Origin of the ray.
@property (nonatomic, strong) Point3D *origin;
/// Direction vector of the ray.
@property (nonatomic, strong) Vector3D *direction;

/*!
 Init a Ray used to calculate the color of each pixel.
 
 @param origin the origin.
 @param distanceVector the distance vector.
 
 @returns a Ray instance.
 */
- (instancetype)initWithOrigin:(Point3D *)origin andDirectionVector:(Vector3D *)directionVector;

/*!
 Calculate a reflective ray for an object with reflective material.

 @see Prof. Ciocca/Bianco slides for the process of calculation.
 @see https://www.cs.unc.edu/~rademach/xroads-RT/RTarticle.html

 @param normal normal of the reflective object.
 @param point the point of intersection.
 @param cosI dot product between ray and normal.
 
 @returns a Reflective ray.
 */
- (Ray *)reflectedRay:(Vector3D *)normal intersectionPoint:(Point3D *)point andCosI:(float)cosI;

/*!
 Calculate the percentage of reflected light using Fresnel equations
 or Schlick's approximation
 
 @see "Ray tracing from the ground up", page 593 cap. "Realistic transparency".
 @see prof. Ciocca/Bianco slide for Fresnel equation (ray tracing transmitted light).
 @see prof. Ciocca/Bianco slide Cook-Torrance for a brief introduction to Schlick's approximation.
 @see https://en.wikipedia.org/wiki/Schlick%27s_approximation
 
 @param object object to be used in calcualtion.
 @param normal normal of the object.
 @param cosI dot product between ray and normal.
 @param model the model to be used (see FresnelFactorModel.h)
 
 @returns the reflection percentage.
 */
- (float)reflectiveFresnelPercentage:(id<Model>)object andNormal:(Vector3D *)normal andCosI:(float)cosI andFresnelFactorModel:(FresnelFactorModel)model;

/*!
 Calculate a refractive ray for an object with transmissive material.
 
 @see Prof. Ciocca/Bianco slides fot the formula.
 @see List of refractive index https://en.wikipedia.org/wiki/List_of_refractive_indices
 @see https://www.cs.unc.edu/~rademach/xroads-RT/RTarticle.html
 
 @param object transmissive object.
 @param normal object normal.
 @param point the point of intersection.
 
 @returns a Refract ray.
 */
- (Ray *)refractedRay:(id<Model>)object andNormal:(Vector3D *)normal intersectionPoint:(Point3D *)point andCosI:(float)cosI;

/*!
 Calculate a shadow ray, used to generate shadow.
 
 @attention The method return a ray and its original direction magnitude.
 This one is used in the shadow test by the ray tracer to check
 that an intersection with an object of the shadow ray is
 BETWEEN THE ORIGIN (ORIGINAL INTERSECTION POINT) AND THE LIGHT POSITION.
 
 @see Prof. Ciocca/Bianco slides for details about shadow calculation process.
 @see @see http://web.cs.wpi.edu/~emmanuel/courses/cs563/write_ups/zackw/realistic_raytracing.html for soft shadow.
 
 @param intersectionPoint the point of intersection.
 @param lightOrigin the origin of the light.
 
 @returns a Dictionary that contain a Shadow ray instance and its direction original magnitude.
 */
+ (NSDictionary *)shadowRay:(Point3D *)intersectionPoint andLight:(Point3D *)lightOrigin;

@end