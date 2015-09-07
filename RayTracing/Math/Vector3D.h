//
//  Vector3D.h
//  Ray tracing
//
//  Created by Fabrizio Duroni on 05/07/15.
//  Copyright (c) 2015 Fabrizio Duroni. All rights reserved.
//

@import Foundation;

@interface Vector3D : NSObject

/// x component of the Vector3D.
@property (nonatomic, assign) float x;
/// y component of the Vector3D.
@property (nonatomic, assign) float y;
/// z component of the Vector3D.
@property (nonatomic, assign) float z;
/// w component (Homogenous coordinate)
@property (nonatomic, assign) float w;

/*!
 Initialize a vector with each component.

 @param x x component.
 @param y y component.
 @param z z component.
 
 @returns a Vector3D.
 */
- (id)initX:(float)x Y:(float)y Z:(float)z;

/*!
 Dot product bewtween vectors.
 
 @param otherVector the other vector used in multiplication.
 
 @returns a float as result of the dot product.
 */
- (float)dot:(Vector3D *)otherVector;

/*!
 Product Vector * Scalar
 
 @param scalar the scalar used in the product.
 
 @returns a Vector multiplied with the scalar received as parameter.
 */
- (Vector3D *)productWithScalar:(float)scalar;

/*!
 Product component * component Vector.
 
 @param otherVector the other vector used in the product.
 
 @returns a Vector with each component is the product of the components of the two vector.
 */
- (Vector3D *)pprod:(Vector3D *)otherVector;

/*!
 Normalize the Vector.
 */
- (void)normalize;

/*!
 Magnitude of the vector.
 */
- (float)magnitude;

/*!
 Difference between vector.
 
 @param otherVector the other vector used in the difference.
 
 @returns a difference Vector.
 */
- (Vector3D *)diff:(Vector3D *)otherVector;

/*!
 Sum between vector.
 
 @param otherVector the other vector used in the sum.
 
 @returns a sum Vector.
 */
- (Vector3D *)sum:(Vector3D *)otherVector;

/*!
 Cross product between vectors.
 
 @param otherVector the other vector used in the cross product.
 
 @returns a Vector3D
 */
- (Vector3D *)cross:(Vector3D *)otherVector;

@end