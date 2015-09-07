//
//  PolygonSkybox.h
//  Ray tracing
//
//  Created by Fabrizio Duroni on 09/08/15.
//  Copyright © 2015 Fabrizio Duroni. All rights reserved.
//

@import Foundation;

#import "Polygon.h"

@class Vector3D;
@class Point3D;

/*!
 Subclass of polygon used when I render a SIDE of a CUBE WRAPPER (skybox)
 for the scene, simulating a closed room (some sort of skybox but with a 
 limited distance). Used to higlight soft shadow in some scenes.
 
 @attention I need ONE INSTANCE of this class FOR EACH SIDE. The method 
 that read the texture is common for all direction of ray (simply drop a 
 component based on intersection point)
 */
@interface PolygonSkyboxSide : Polygon

/*!
 Indetifier of each side as enum.
 */
typedef NS_ENUM(NSInteger, PolygonSkyboxSideIdentifier) {
    Back,
    Bottom,
    Front,
    Left,
    Right,
    Top
};

/*!
 Init a polygon skybox.
 
 @param polygonSkyboxSideIdentifier identifier of the side of the cube wrapper 
 that the polygon represents.
 
 @param textureName name of the texture to be used.
 
 @returns a PolygonSkyboxSide instance.
 */
- (instancetype)initWithSideIdentifier:(PolygonSkyboxSideIdentifier)polygonSkyboxSideIdentifier textureName:(NSString *)textureName;

/*!
 Method used to read the texture data based on the coordinate
 of the intersection point. The Polygon sides are align with the 
 axes so is easy to do the map: drop the coordinate to 0 and 
 apply a conversion to texture coordinate system as a percentage
 of height/width.
 
 @param intersectionPoint the point of intersection
 
 @returns A Vector3D with rgb components of the texture texel.
 */
- (Vector3D *)readPolygonSkyboxTexture:(Point3D *)intersectionPoint;

@end