//
//  MarbleTexture.h
//  Ray tracing
//
//  Created by Fabrizio Duroni on 15/08/15.
//  Copyright (c) 2015 Fabrizio Duroni. All rights reserved.
//

#import "PerlinTexture.h"

@import Foundation;

@class Vector3D;
@class Point3D;

/*!
 Marble texture.
 
 @see http://www.ics.uci.edu/~gopi/CS211B/RayTracing%20tutorial.pdf
 @see http://people.wku.edu/qi.li/teaching/446/cg13_texturing.pdf pag. 5
 */
@interface MarbleTexture : PerlinTexture

/*!
 Marble texture using perlin noise.
 
 @see PerlinTexture super class for details.
 
 @param point point to which I apply texture.
 
 @return color of the texture in a Vector3D.
 */
- (Vector3D *)texture:(Point3D *)point;

@end