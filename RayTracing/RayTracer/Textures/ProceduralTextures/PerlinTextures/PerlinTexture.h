//
//  PerlinTexture.h
//  Ray tracing
//
//  Created by Fabrizio Duroni on 15/08/15.
//  Copyright (c) 2015 Fabrizio Duroni. All rights reserved.
//

@import Foundation;

@class Vector3D;
@class Point3D;

/*!
 Perlin texture are procedural texture 
 generated using Perlin Noise (see PerlinNoise class for details).
*/
@interface PerlinTexture : NSObject

/// First color used in a texture.
@property (nonatomic, strong) Vector3D *color1;
/// Second color used in a texture.
@property (nonatomic, strong) Vector3D *color2;

/*!
 Init a perlin texture.
 
 @param color1 first color
 @param color2 second color
 
 @returns a PerlinTexture instance
 */
- (instancetype)initWithColor1:(Vector3D *)color1 andColor2:(Vector3D *)color2;

/*!
 Method used to get the color of a texture
 in a specific point. THE DEFAULT IMPLEMENTATION
 IS EMPTY. OVERRIDE IN SUBCLASS TO GENERATE TEXTURE.
 
 @param point coordinate point.
 
 @returns a texel color.
 */
- (Vector3D *)texture:(Point3D *)point;

@end