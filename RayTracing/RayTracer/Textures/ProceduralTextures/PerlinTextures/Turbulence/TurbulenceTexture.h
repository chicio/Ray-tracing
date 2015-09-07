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
 Turbulence texture. Implemented as standard with
 twice the frequency and half the amplitude for 
 each octaves.
 
 @see "Ray tracing from the ground up", page 691 cap. "Noise-based Textures".
 @see http://freespace.virgin.net/hugo.elias/models/m_perlin.htm
 @see http://www.ics.uci.edu/~gopi/CS211B/RayTracing%20tutorial.pdf
 */
@interface TurbulenceTexture : PerlinTexture 

/*!
 Turbulence texture using perlin noise.
 
 @see PerlinTexture super class for details.
 
 @param point point to which I apply texture.
 
 @return color of the texture in a Vector3D.
 */
- (Vector3D *)texture:(Point3D *)point;

@end