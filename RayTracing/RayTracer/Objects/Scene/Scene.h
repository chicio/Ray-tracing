//
//  Scene.h
//  Ray tracing
//
//  Created by Fabrizio Duroni on 15/07/15.
//  Copyright (c) 2015 Fabrizio Duroni. All rights reserved.
//

@import Foundation;

@class Point3D;
@class Light;
@class CubeMappingSkybox;

/*!
 Scene is a class that keeps a reference to the objects to be represented on screen.
 */
@interface Scene : NSObject

/// Light used during rendering.
@property (strong, nonatomic) Light *light;
/// Objects to be rendered.
@property (strong, nonatomic) NSMutableArray *objects;
/// Skybox used for cube mapping.
@property (strong, nonatomic) CubeMappingSkybox *cubeMappingSkybox;
/// View reference point used for the camera.
@property (strong, nonatomic) Point3D *viewReferencePoint;
/// Look at point used with the camera.
@property (strong, nonatomic) Point3D *lookAtPoint;
/// View plane distance used in camera.
@property (assign, nonatomic) float viewPlaneDistance;

/*!
 Init a scene selected from the interface.
 
 @param sceneId identifier of the scene.
 @param cameraPositon position of the camera.
 @param isSoftShadowActive flag used to check if I need an area light or point light.
 */
- (id)initWithIdentifier:(long)sceneId
        andCameraPositon:(long)cameraPosition
     andSoftShadowActive:(BOOL)isSoftShadowActive;

@end