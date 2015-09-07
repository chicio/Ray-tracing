//
//  BumpMappingTexture.h
//  Ray tracing
//
//  Created by Fabrizio Duroni on 14/08/15.
//  Copyright (c) 2015 Fabrizio Duroni. All rights reserved.
//

@import Foundation;

@class Vector3D;
@class Point3D;

/*!
 Class used to generate a bump map from perlin noise.
 This class create a bump map texture used to apply
 distorsion of normal to add detail to the object
 without modifying their geometry. The map is generated
 from perlin noise (see PerlinNoise class for details),
 so is a little bit different from standard implementation
 using bump map monochromatic image (on which the normal are 
 //calculated usually).
 
 @see http://www.ics.uci.edu/~gopi/CS211B/RayTracing%20tutorial.pdf
 @see Perlin noise improved bump map reference inserted in PerlinNoise class.
 */
@interface BumpMap : NSObject

/*!
 Init the bump map.
 
 @param scale the scale factor applied to the normal calculation.
 
 @returns a bump map instance.
 */
- (instancetype)initWithScale:(float)scale;

/*!
 Return the normal of the object modified using the bump map.
 
 @param point the point to which I apply the bump map.
 @param normal normal to be modified.
 
 @param the new normal to be used in light calculation.
 */
- (Vector3D *)bumpMapTexture:(Point3D *)point applyToNormal:(Vector3D *)normal;

@end