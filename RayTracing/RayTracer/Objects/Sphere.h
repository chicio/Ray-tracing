//
//  Sphere.h
//  Ray tracing
//
//  Created by Fabrizio Duroni on 05/07/15.
//  Copyright (c) 2015 Fabrizio Duroni. All rights reserved.
//

#import "Model.h"

@import Foundation;

@class Point3D;
@class Material;
@class Vector3D;

@interface Sphere : NSObject <Model>

/// Center of the sphere as a Point3D.
@property (nonatomic, strong) Point3D *center;
/// Radius of the sphere,
@property (nonatomic, assign) float radius;
/// Material assigned to the sphere.
@property (nonatomic, strong) Material *material;

/*!
 Calculate normal for a point on the sphere.
 
 @param pointOnSphere the point on the sphere for which I want to calculate the normal.
 
 @returns a Vector3D normal to the pointOnSphere.
 */
- (Vector3D *)normal:(Point3D *)pointOnSphere;

/*!
 Calculate the intersection of the sphere with a ray.
 
 @param ray the ray used to calculate the intersection.
 
 @returns a dictionary that contains t, intersection point, normal and the sphere itself.
 */
- (NSMutableDictionary *)intersect:(Ray *)ray;

@end