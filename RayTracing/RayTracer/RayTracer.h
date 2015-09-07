//
//  RayTracer.h
//  Ray tracing
//
//  Created by Fabrizio Duroni on 07/07/15.
//  Copyright (c) 2015 Fabrizio Duroni. All rights reserved.
//

#import "Lighting.h"

@import Foundation;

@class ViewPlane;
@class Sphere;

@interface RayTracer : NSObject

/// View plane.
@property (strong, nonatomic) ViewPlane *vplane;

/*!
 Init the ray tracer.
 
 @param viewPlane view plane used to render the scene.
 @param sceneIdentifier the identifier of the scene to be loaded.
 @param lighting light model used in the scene (see LightModel.h).
 @param cameraPosition the position of the camera.
 @param isAntialiasingActive used to check if Ineed to apply antialiaing.
 @param isSoftShadowActive used to check if Ineed to apply soft shadow.
 
 returns a Ray tracer instance.
 */
- (instancetype)initWithViewPlane:viewPlane
                         andScene:(NSInteger)sceneIdentifier
                      andLighting:(LightingModel)lighting
                andCameraPosition:(NSInteger)cameraPosition
            andAntialiasingActive:(BOOL)isAntialiasingActive
              andSoftShadowActive:(BOOL)isSoftShadowActive;

/*!
 Start the ray tracer to compute each pixel of the image.
 The viewport and view plane are of the same dimension (and position). 
 No need to scale or transform. The method runs asyn and returns the 
 result in a block.
 
 @param scene A dictionary that contain all scene objects.
 @param finishTracking a block used to return the pixels color calculated.
 */
- (void)runRayTracer:(void (^)(NSMutableArray *, float, float))endTracer;

@end