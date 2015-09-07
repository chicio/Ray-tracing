//
//  SkyboxTexture.h
//  Ray tracing
//
//  Created by Fabrizio Duroni on 26/07/15.
//  Copyright (c) 2015 Fabrizio Duroni. All rights reserved.
//

@import Foundation;

@class Texture;
@class Vector3D;
@class Ray;

/*!
 This class implement a standar cube mapping to render
 a skybox if a ray doesn't intersect and object.
 */
@interface CubeMappingSkybox : NSObject

/*!
 Method used to read from a skybox texture.
 
 @attention: implementation follow the guide linked below.
 Very simple implementation with math trick to render a cube map skybox.
 
 @see http://www.ics.uci.edu/~gopi/CS211B/RayTracing%20tutorial.pdf
 
 @param ray the ray to be tested.
 
 @returns The texel color.
 */
- (Vector3D *)readSkyboxTexture:(Ray *)ray;

@end