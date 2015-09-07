 //
//  Camera.m
//  Ray tracing
//
//  Created by Fabrizio Duroni on 13/07/15.
//  Copyright (c) 2015 Fabrizio Duroni. All rights reserved.
//

#import "ViewPlane.h"
#import "Point3D.h"
#import "Vector3D.h"
#import "Camera.h"

@interface Camera()

/// Position of the camera in the world.
@property (nonatomic, strong) Point3D *viewReferencePoint;
/// Look at point (used in view plane normal calculation).
@property (nonatomic, strong) Point3D *lookat;
/// Up direction of the camera.
@property (nonatomic, strong) Vector3D *viewUp;
/// Distance of the camera from the view plane.
@property (nonatomic, assign) float viewPlanedistance;
/// U unit vector.
@property (nonatomic, strong) Vector3D *u;
/// V unit vector.
@property (nonatomic, strong) Vector3D *v;
/// N unit vector.
@property (nonatomic, strong) Vector3D *n;
/// Vector used in the calculation of the rays in the camera coordinate system.
/// It is a scaling of the n vector so that it would to be coherent with the view
/// plane distance (because I need it to do the diff during camera ray direction
/// calculation, see below).
@property (nonatomic, strong) Vector3D *nComponent;
/// Half view plane width. Used during camera calculation (see below).
@property (nonatomic, assign) float viewPlaneHalfWidth;
/// Half view plane height. Used during camera calculation (see below).
@property (nonatomic, assign) float viewPlaneHalfHeight;

@end

@implementation Camera

#pragma mark init

- (instancetype)initWithViewReferencePoint:(Point3D *)viewReferencePoint
                            andLookAtPoint:(Point3D *)lookAtPoint
                                 andViewUp:(Vector3D *)viewUp
                              andViewPlane:(ViewPlane *)viewPlane
                      andViewPlaneDistance:(float)viewPlaneDistance {
    
    self = [super init];

    if (self) {
        
        self.viewReferencePoint = viewReferencePoint;
        self.lookat = lookAtPoint;
        self.viewUp = viewUp;
        self.viewPlanedistance = viewPlaneDistance;
        
        //Set up the camera coordinate system
        [self setupCameraCoordinateSystem];
        
        //I calculate here the n component used in the ray generation and
        //the half view plane width/height.
        //I init them here avoid to repeat this operation for every ray.
        //Scale n vector to be coherent with the view plane distance
        //(because I need it to do the diff in the next operation).
        self.nComponent = [self.n productWithScalar:self.viewPlanedistance];
        
        //Half plane.
        self.viewPlaneHalfHeight = viewPlane.height * 0.5;
        self.viewPlaneHalfWidth = viewPlane.width * 0.5;
    }
    
    return self;
}

#pragma mark Camera coordinate system generation

- (void)setupCameraCoordinateSystem {

    Vector3D *nNotNormalized = [self.viewReferencePoint diff:self.lookat];
    
    //Standard camera coordinate system (see prof. Ciocca/Bianco slide).
    self.n = [[Vector3D alloc] initX:nNotNormalized.x Y:nNotNormalized.y Z:nNotNormalized.z];
    [self.n normalize];
    
    //U is the cross product between the view up and the view plane normal n
    self.u = [self.viewUp cross:nNotNormalized];
    [self.u normalize];
    
    self.v = [self.n cross:self.u];
}

#pragma mark Ray generation

- (Vector3D *)rayInCameraCoordinateSystemWithX:(float)viewPlaneX andY:(float)viewPlaneY {

    //"Ray tracing from the ground up", page 151 cap. "A pratical viewing system".
    //It's the same as concept on the prof. Ciocca/Bianco slide,
    //because I calculate u v n coordinate system
    //for our camera (formulas are the same that could be
    //found on prof. Ciocca/Bianco slide).
    //The u v n is an orthonormal basis and we use it
    //to convert the ray in camera ray.
    //SO INSTEAD OF TRANSFORM THE ENTIRE SCENE IN CAMERA CRS (as usually is
    //applied to the various objects of it), we SIMPLY CONVERT IT.
    
    //I need to shift the coordinate on the view plane because
    //the reference system of the camera uvn is CENTERED IN THE
    //CENTER of the view plane.
    float xTemp = viewPlaneX - self.viewPlaneHalfWidth;
    float yTemp = viewPlaneY - self.viewPlaneHalfHeight;
    
    //Calculate components on the uv plane.
    Vector3D *uComponent = [self.u productWithScalar:xTemp];
    Vector3D *vComponent = [self.v productWithScalar:yTemp];
    
    //Ray direction normalized.
    //We consider also the distance from the view plane (see init method nComponent).
    //From ray tracing from the ground up:
    //"The nice thing about an ONB is that we can express any vector as a linear
    //combination of its basis vectors. We can therefore write the primary ray d
    //as d = x_vp * u + y_vp * v - distancevp * n"
    Vector3D *rayDirection = [[uComponent sum:vComponent]diff:self.nComponent];
    [rayDirection normalize];
    
    return rayDirection;
}

@end