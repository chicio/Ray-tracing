//
//  Light.h
//  Ray tracing
//
//  Created by Fabrizio Duroni on 06/07/15.
//  Copyright (c) 2015 Fabrizio Duroni. All rights reserved.
//

@import Foundation;

@class Point3D;
@class Vector3D;

/*!
 Implementation of a basic light (point light).
 */
@interface Light : NSObject

/// Origin of the light.
@property (nonatomic, strong) Point3D *origin;
/// Color of the light.
@property (nonatomic, strong) Vector3D *color;

/*!
 Init a basic light.
 
 @param origin origin of the light.
 @param color the color of the light.
 
 @returns an Light instance.
 */
- (instancetype)initWithOrigin:(Point3D *)origin andColor:(Vector3D *)color;

@end