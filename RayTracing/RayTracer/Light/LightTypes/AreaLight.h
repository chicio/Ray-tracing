//
//  AreaLight.h
//  Ray tracing
//
//  Created by Fabrizio Duroni on 29/07/15.
//  Copyright (c) 2015 Fabrizio Duroni. All rights reserved.
//

#import "Light.h"

@import Foundation;

@class Point3D;
@class Sphere;

/*!
 Implementation of an spherical area light.
 It inherits from Light the property origin and color.
 Origin is used as origin of the sphere that
 rpresent the area light.
 */
@interface AreaLight : Light

/// Array used to maintain a list of random point on the sphere surface. Used in soft shadow rendering.
@property (nonatomic, strong) NSMutableArray *randomSpherePoints;

/*!
 Init a area light with an origin, a color and a radius
 used to determine its size.
 The area light is implemented as a sphere.
 (Theorically it's possible in this way to show it as a
 standard object during rendering using a material 
 completely emissive).
 
 @param origin origin of the area light. It corresponds to the center of the area.
 @param color the color of the area light.
 @param radius the radius of the sphere used as area light.
 
 @returns an AreaLight instance.
 */
- (instancetype)initWithOrigin:(Point3D *)origin andColor:(Vector3D *)color andRadius:(float)radius;

@end