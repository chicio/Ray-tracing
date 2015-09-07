//
//  Texture.h
//  Ray tracing
//
//  Created by Fabrizio Duroni on 26/07/15.
//  Copyright (c) 2015 Fabrizio Duroni. All rights reserved.
//

@import Foundation;

@class Vector3D;

@interface Texture : NSObject

/*!
 Texture coordinate data type.
 */
typedef struct TextureCoordinate {
    float u;
    float v;
} TextureCoordinate;

/*!
 Initialize a texture with an image.
 I extract raw data pixel in an array.
 Every 4 component of the array represent a pixel as a component RGBA.
 
 @param imageName the name of the image to be loaded as texture.
 
 @returns a Texture instance.
 */
- (id)initWithImageName:(NSString *)imageName;

/*!
 Read texel color at specific texture coordinate.
 
 @see "Ray tracing from the ground up", page 650 cap. "Texture mapping".
 
 @param textureCoordinate The texture coordinate to be read.
 
 @returns a texel from texture as Vector3D.
 */
- (Vector3D *)readTexture:(TextureCoordinate)textureCoordinate;

@end