//
//  Object.h
//  Ray tracing
//
//  Created by Duroni Fabrizio on 09/07/15.
//  Copyright (c) 2015 Fabrizio Duroni. All rights reserved.
//

@import Foundation;

@class Ray;
@class Material;

/*!
 Protocol that all object must adopt to be
 managed by the ray tracer.
 */
@protocol Model <NSObject>

/// Material assigned to the Object that I model.
@property (nonatomic, strong) Material *material;

/*!
 All objects must be able to test if they intersect with a ray.
 
 @param ray the ray to be tested.
 
 @results intersection data: intersection point, t, normal, object
 */
- (NSMutableDictionary *)intersect:(Ray *)ray;

@end