//
//  Camera.h
//  Ray tracing
//
//  Created by Fabrizio Duroni on 13/07/15.
//  Copyright (c) 2015 Fabrizio Duroni. All rights reserved.
//

@import Foundation;

@class ViewPlane;
@class Point3D;
@class Vector3D;

/*!
 Implementation of a camera.
 */
@interface Camera : NSObject

/*!
 Init a camera used to render the scene.
 
 @param viewReferencePoint view reference point.
 @param lookAtPoint look-at point.
 @param viewUp view up direction vector.
 @param viewPlane the view plane.
 @param viewPlaneDistance the distance of the camera from the view plane.
 
 @returns a Camera instance.
 */
- (instancetype)initWithViewReferencePoint:(Point3D *)viewReferencePoint
                            andLookAtPoint:(Point3D *)lookAtPoint
                                 andViewUp:(Vector3D *)viewUp
                              andViewPlane:(ViewPlane *)viewPlane
                      andViewPlaneDistance:(float)viewPlaneDistance;

/*!
 Method used to generate a ray in the camera coordinate reference system.
 
 @attention After reading "Ray tracing from the ground up" 
 I decided to implement the technique contained in its 
 cap. "A pratical viewing system", page 151. It's a very intersting technique. 
 See comment in the method for other information.

 @see "Ray tracing from the ground up", page 151 cap. "A pratical viewing system".
 
 @param viewPlaneX a x component of a point on the view plane.
 @param viewPlaneY a y component of a point on the view plane.
 
 @returns a Vector3D used as ray distance vector.
 */
- (Vector3D *)rayInCameraCoordinateSystemWithX:(float)viewPlaneX andY:(float)viewPlaneY;

@end