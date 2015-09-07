//
//  Point3D.h
//  Ray tracing
//
//  Created by Fabrizio Duroni on 06/07/15.
//  Copyright (c) 2015 Fabrizio Duroni. All rights reserved.
//

@import Foundation;

@class Vector3D;

@interface Point3D : NSObject

/// x component of the Point3D.
@property (nonatomic, assign) float x;
/// y component of the Point3D.
@property (nonatomic, assign) float y;
/// z component of the Point3D.
@property (nonatomic, assign) float z;
/// w component (Homogenous coordinate)
@property (nonatomic, assign) float w;

/*!
 Initialize a Point3D with each component.
 
 @param x x component.
 @param y y component.
 @param z z component.
 
 @returns a Point3D.
 */
- (id)initX:(float)x Y:(float)y Z:(float)z;

/*!
 Sum a point with a Vector3D. Return a Point3D.
 
 @param vector the vector used in the calculation.
 
 @returns a Point3D as a result of the operation.
 */
- (Point3D *)sumVector:(Vector3D *)vector;

/*!
 Difference between Point3D. Return a Vector3D.
 
 @param a Point3D to be subtracted.
 
 @returns a Point3D as a result of the operation.
 */
- (Vector3D *)diff:(Point3D *)otherPoint;

@end