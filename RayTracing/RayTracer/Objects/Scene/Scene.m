//
//  Scene.m
//  Ray tracing
//
//  Created by Fabrizio Duroni on 15/07/15.
//  Copyright (c) 2015 Fabrizio Duroni. All rights reserved.
//

#import "CubeMappingSkybox.h"
#import "Vector3D.h"
#import "Light.h"
#import "AreaLight.h"
#import "Sphere.h"
#import "Polygon.h"
#import "PolygonSkyboxSide.h"
#import "Point3D.h"
#import "Material.h"
#import "Scene.h"
#import "Texture.h"

@implementation Scene

/*
 This class is not very clean: it is a infinite list of parameter used to init the various scene.
 
 TODO: Maybe it is better to create a SceneFactory to generate the scene. 
 TODO: Maybe Scene from JSON or plist.
 */

#pragma mark Init

- (id)initWithIdentifier:(long)sceneId andCameraPositon:(long)cameraPosition andSoftShadowActive:(BOOL)isSoftShadowActive {
    
    if (self = [super init]) {
        
        switch (sceneId) {
            case 0:
                [self loadDefaultScene:isSoftShadowActive cameraPosition:cameraPosition];
                break;
            case 1:
                [self loadDefaultScene2:isSoftShadowActive cameraPosition:cameraPosition];
                break;
            case 2:
                [self loadDefaultScene3:isSoftShadowActive cameraPosition:cameraPosition];
                break;
            default:
                break;
        }
    }
    
    return self;
}

#pragma mark Scene 1.

- (void)loadDefaultScene:(BOOL)isSoftShadowActive cameraPosition:(long)cameraPosition {
    
    //Reset all container variables.
    self.objects = [NSMutableArray new];
    self.cubeMappingSkybox = nil;
    
    //Setup reference point
    switch (cameraPosition) {
        case 0:
            self.viewReferencePoint = [[Point3D alloc] initX:215 Y:250 Z:490]; //Middle left.
            //self.viewReferencePoint = [[Point3D alloc] initX:250 Y:250 Z:500]; //Front.
            break;
        case 1:
            self.viewReferencePoint = [[Point3D alloc] initX:250 Y:250 Z:-300]; //Back.
            break;
        case 2:
            self.viewReferencePoint = [[Point3D alloc] initX:650 Y:250 Z:270]; //Right
            break;
        case 3:
            self.viewReferencePoint = [[Point3D alloc] initX:-250 Y:250 Z:270]; //Left.
            break;
        case 4:
            self.viewReferencePoint = [[Point3D alloc] initX:215 Y:0 Z:455]; //Bottom.
            break;
        case 5:
            self.viewReferencePoint = [[Point3D alloc] initX:250 Y:750 Z:240]; //Top.
            break;
        default:
            break;
    }
    
    //Set up look at point.
    self.lookAtPoint = [[Point3D alloc] initX:250 Y:250 Z:250];
    
    //Set view plane distance.
    self.viewPlaneDistance = 240; //180
    
    if(isSoftShadowActive == true) {
        
        //For soft shadow Ineed an area light.
        //Init Area light.
        self.light = [[AreaLight alloc] initWithOrigin:[[Point3D alloc]initX:0 Y:300 Z:400] andColor:[[Vector3D alloc] initX:255 Y:255 Z:255] andRadius:60];
    } else {
        
        //Init Point light.
        self.light = [[Light alloc] initWithOrigin:[[Point3D alloc]initX:0 Y:300 Z:400] andColor:[[Vector3D alloc] initX:255 Y:255 Z:255]];
    }
    
    /******* Sphere *****/
    Sphere *sphere = [[Sphere alloc] init];
    sphere.center = [[Point3D alloc] initX:300 Y:300 Z:250];
    sphere.radius = 90;
    sphere.material = [Material glass];
    
    /********* Sphere 1 ********/
    Sphere *sphere1 = [[Sphere alloc] init];
    sphere1.center = [[Point3D alloc] initX:230 Y:380 Z:50];
    sphere1.radius = 100;
    sphere1.material = [Material jade];
    
    /********* Sphere 2 ********/
    //Create sphere.
    Sphere *sphere2 = [[Sphere alloc] init];
    sphere2.center = [[Point3D alloc] initX:110 Y:150 Z:150];
    sphere2.radius = 90;
    sphere2.material = [Material bronze];
    
    /********* Sphere 3 ********/
    Sphere *sphere3 = [[Sphere alloc] init];
    sphere3.center = [[Point3D alloc] initX:340 Y:130 Z:250];
    sphere3.radius = 60;
    sphere3.material = [Material rubyBumpMapped:4.0];
    
    /********* Sphere 4 ********/
    Sphere *sphere4 = [[Sphere alloc] init];
    sphere4.center = [[Point3D alloc] initX:250 Y:100 Z:30];
    sphere4.radius = 90;
    sphere4.material = [Material violet];
    //sphere4.material = [Material cloudTurbulence];
    
    /****** Skybox texture ********/
    self.cubeMappingSkybox = [[CubeMappingSkybox alloc] init];
    
    [self.objects addObject:sphere];
    [self.objects addObject:sphere1];
    [self.objects addObject:sphere2];
    [self.objects addObject:sphere3];
    [self.objects addObject:sphere4];    
}

#pragma mark Scene 2

- (void)loadDefaultScene2:(BOOL)isSoftShadowActive cameraPosition:(long)cameraPosition {
    
    //Reset all container variables.
    self.objects = [NSMutableArray new];
    self.cubeMappingSkybox = nil;
    
    if(isSoftShadowActive == true) {
        
        //For soft shadow I need an area light.
        self.light = [[AreaLight alloc] initWithOrigin:[[Point3D alloc]initX:700 Y:400 Z:900] andColor:[[Vector3D alloc] initX:255 Y:255 Z:255] andRadius:60];
    } else {
        
        //Init Point light.
        self.light = [[Light alloc] initWithOrigin:[[Point3D alloc]initX:700 Y:400 Z:900] andColor:[[Vector3D alloc] initX:255 Y:255 Z:255]];
    }
    
    //Set view reference point.
    //Setup reference point
    switch (cameraPosition) {
        case 0:
            self.viewReferencePoint = [[Point3D alloc] initX:512 Y:100 Z:1023]; //Front
            break;
        case 1:
            self.viewReferencePoint = [[Point3D alloc] initX:512 Y:100 Z:1]; //Back.
            break;
        case 2:
            self.viewReferencePoint = [[Point3D alloc] initX:1023 Y:500 Z:512]; //Right
            break;
        case 3:
            self.viewReferencePoint = [[Point3D alloc] initX:1 Y:500 Z:512]; //Left.
            break;
        case 4:
            self.viewReferencePoint = [[Point3D alloc] initX:512 Y:100 Z:1023]; //NO Bottom.
            break;
        case 5:
            self.viewReferencePoint = [[Point3D alloc] initX:512 Y:700 Z:513]; //Top.
            break;
        default:
            break;
    }
    
    //Set look at point.
    self.lookAtPoint = [[Point3D alloc] initX:512 Y:100 Z:512];
    
    //Set view plane distance.
    self.viewPlaneDistance = 250; //190 - 400
    
    /********* Polygon Skybox ********/
    PolygonSkyboxSide *polygonSkyboxBottom = [[PolygonSkyboxSide alloc] initWithSideIdentifier:Bottom textureName:@"BottomIndoor"];
    PolygonSkyboxSide *polygonSkyboxLeft = [[PolygonSkyboxSide alloc] initWithSideIdentifier:Left textureName:@"LeftIndoor"];
    PolygonSkyboxSide *polygonSkyboxRight = [[PolygonSkyboxSide alloc] initWithSideIdentifier:Right textureName:@"RightIndoor"];
    PolygonSkyboxSide *polygonSkyboxFront = [[PolygonSkyboxSide alloc] initWithSideIdentifier:Front textureName:@"FrontIndoor"];
    PolygonSkyboxSide *polygonSkyboxBack = [[PolygonSkyboxSide alloc] initWithSideIdentifier:Back textureName:@"BackIndoor"];
    PolygonSkyboxSide *polygonSkyboxTop = [[PolygonSkyboxSide alloc] initWithSideIdentifier:Top textureName:@"TopIndoor"];
    
    /********* Box ********/
    Polygon *front = [[Polygon alloc]initWithVertexList:
                      [[NSMutableArray alloc]initWithObjects:
                       [[Point3D alloc]initX:50 Y:0 Z:550],
                       [[Point3D alloc]initX:250 Y:0 Z:550],
                       [[Point3D alloc]initX:250 Y:200 Z:550],
                       [[Point3D alloc]initX:50 Y:200 Z:550], nil]
                      ];
    front.pointOnPlane = [[Point3D alloc] initX:120 Y:100 Z:550];
    front.material = [Material bronze];
    
    Polygon *right = [[Polygon alloc]initWithVertexList:
                      [[NSMutableArray alloc]initWithObjects:
                       [[Point3D alloc]initX:250 Y:0 Z:550],
                       [[Point3D alloc]initX:250 Y:0 Z:350],
                       [[Point3D alloc]initX:250 Y:200 Z:350],
                       [[Point3D alloc]initX:250 Y:200 Z:550], nil]
                      ];
    right.pointOnPlane = [[Point3D alloc] initX:250 Y:100 Z:450];
    right.material = [Material bronze];
    
    Polygon *top = [[Polygon alloc]initWithVertexList:
                    [[NSMutableArray alloc]initWithObjects:
                     [[Point3D alloc]initX:50 Y:200 Z:550],
                     [[Point3D alloc]initX:250 Y:200 Z:550],
                     [[Point3D alloc]initX:250 Y:200 Z:350],
                     [[Point3D alloc]initX:50 Y:200 Z:350], nil]
                    ];
    top.pointOnPlane = [[Point3D alloc] initX:250 Y:200 Z:450];
    top.material = [Material bronze];
    
    Polygon *left = [[Polygon alloc]initWithVertexList:
                     [[NSMutableArray alloc]initWithObjects:
                      [[Point3D alloc]initX:50 Y:0 Z:550],
                      [[Point3D alloc]initX:50 Y:0 Z:350],
                      [[Point3D alloc]initX:50 Y:200 Z:350],
                      [[Point3D alloc]initX:50 Y:200 Z:550], nil]
                     ];
    left.pointOnPlane = [[Point3D alloc] initX:50 Y:100 Z:450];
    left.material = [Material bronze];
    
    Polygon *back = [[Polygon alloc]initWithVertexList:
                     [[NSMutableArray alloc]initWithObjects:
                      [[Point3D alloc]initX:50 Y:0 Z:350],
                      [[Point3D alloc]initX:250 Y:0 Z:350],
                      [[Point3D alloc]initX:250 Y:200 Z:350],
                      [[Point3D alloc]initX:50 Y:200 Z:350], nil]
                     ];
    back.pointOnPlane = [[Point3D alloc] initX:120 Y:100 Z:350];
    back.material = [Material bronze];
        
    /******* Sphere *****/
    Sphere *sphere = [[Sphere alloc] init];
    sphere.center = [[Point3D alloc] initX:850 Y:60 Z:620];
    sphere.radius = 60;
    sphere.material = [Material glasswater];
    
    /********* Sphere 1 ********/
    Sphere *sphere1 = [[Sphere alloc] init];
    sphere1.center = [[Point3D alloc] initX:600 Y:90 Z:600];
    sphere1.radius = 90;
    sphere1.material = [Material flameMarble];
    
    /********* Sphere 2 ********/
    //Create sphere.
    Sphere *sphere2 = [[Sphere alloc] init];
    sphere2.center = [[Point3D alloc] initX:150 Y:280 Z:450];
    sphere2.radius = 80;
    sphere2.material = [Material blueTurbulence];

    /********* Sphere 3 ********/
    //Create sphere.
    Sphere *sphere3 = [[Sphere alloc] init];
    sphere3.center = [[Point3D alloc] initX:450 Y:60 Z:720];
    sphere3.radius = 60;
    sphere3.material = [Material chrome];

    /********* Sphere 4 ********/
    //Create sphere.
    Sphere *sphere4 = [[Sphere alloc] init];
    sphere4.center = [[Point3D alloc] initX:490 Y:30 Z:840];
    sphere4.radius = 30;
    sphere4.material = [Material rubyBumpMapped:6.0];
    
    /********* Sphere 3 ********/
    //Create sphere.
    Sphere *sphere5 = [[Sphere alloc] init];
    sphere5.center = [[Point3D alloc] initX:200 Y:30 Z:630];
    sphere5.radius = 30;
    sphere5.material = [Material silver];

    [self.objects addObject:polygonSkyboxBottom];
    [self.objects addObject:polygonSkyboxLeft];
    [self.objects addObject:polygonSkyboxRight];
    [self.objects addObject:polygonSkyboxFront];
    [self.objects addObject:polygonSkyboxBack];
    [self.objects addObject:polygonSkyboxTop];
    
    [self.objects addObject:sphere];
    [self.objects addObject:sphere1];
    [self.objects addObject:sphere2];
    [self.objects addObject:sphere3];
    [self.objects addObject:sphere4];
    [self.objects addObject:sphere5];
    
    [self.objects addObject:front];
    [self.objects addObject:right];
    [self.objects addObject:top];
    [self.objects addObject:left];
    [self.objects addObject:back];
}

#pragma mark Scene 3

- (void)loadDefaultScene3:(BOOL)isSoftShadowActive cameraPosition:(long)cameraPosition {
    
    //Reset all container variables.
    self.objects = [NSMutableArray new];
    self.cubeMappingSkybox = nil;
    
    if(isSoftShadowActive == true) {
        
        //For soft shadow Ineed an area light.
        self.light = [[AreaLight alloc] initWithOrigin:[[Point3D alloc]initX:700 Y:700 Z:900] andColor:[[Vector3D alloc] initX:255 Y:255 Z:255] andRadius:60];
    } else {
        
        //Init Point light.
        self.light = [[Light alloc] initWithOrigin:[[Point3D alloc]initX:700 Y:700 Z:900] andColor:[[Vector3D alloc] initX:255 Y:255 Z:255]];
    }

    //Set look at point.
    self.lookAtPoint = [[Point3D alloc] initX:512 Y:100 Z:512];
    
    //Set view reference point.
    //Setup reference point
    switch (cameraPosition) {
        case 0:
            self.viewReferencePoint = [[Point3D alloc] initX:512 Y:100 Z:1023]; //Front
            break;
        case 1:
            self.viewReferencePoint = [[Point3D alloc] initX:512 Y:100 Z:1]; //Back.
            break;
        case 2:
            self.viewReferencePoint = [[Point3D alloc] initX:1023 Y:500 Z:512]; //Right
            break;
        case 3:
            self.lookAtPoint = [[Point3D alloc] initX:512 Y:100 Z:515]; //Custom look-at point
            self.viewReferencePoint = [[Point3D alloc] initX:500 Y:100 Z:515]; //Left.
            break;
        case 4:
            self.viewReferencePoint = [[Point3D alloc] initX:512 Y:100 Z:1023]; //NO Bottom.
            break;
        case 5:
            self.viewReferencePoint = [[Point3D alloc] initX:512 Y:700 Z:513]; //Top.
            break;
        default:
            break;
    }
    
    //Set view plane distance.
    self.viewPlaneDistance = 250;
    //self.viewPlaneDistance = 190; //vp 400

    /********* Polygon Skybox ********/
    PolygonSkyboxSide *polygonSkyboxBottom = [[PolygonSkyboxSide alloc] initWithSideIdentifier:Bottom textureName:@"BottomIndoor"];
    PolygonSkyboxSide *polygonSkyboxLeft = [[PolygonSkyboxSide alloc] initWithSideIdentifier:Left textureName:@"LeftIndoor"];
    PolygonSkyboxSide *polygonSkyboxRight = [[PolygonSkyboxSide alloc] initWithSideIdentifier:Right textureName:@"RightIndoor"];
    PolygonSkyboxSide *polygonSkyboxFront = [[PolygonSkyboxSide alloc] initWithSideIdentifier:Front textureName:@"FrontIndoor"];
    PolygonSkyboxSide *polygonSkyboxBack = [[PolygonSkyboxSide alloc] initWithSideIdentifier:Back textureName:@"BackIndoor"];
    PolygonSkyboxSide *polygonSkyboxTop = [[PolygonSkyboxSide alloc] initWithSideIdentifier:Top textureName:@"TopIndoor"];
    
    /********* Box ********/
    Polygon *front = [[Polygon alloc]initWithVertexList:
                      [[NSMutableArray alloc]initWithObjects:
                       [[Point3D alloc]initX:50 Y:0 Z:550],
                       [[Point3D alloc]initX:250 Y:0 Z:550],
                       [[Point3D alloc]initX:250 Y:200 Z:550],
                       [[Point3D alloc]initX:50 Y:200 Z:550], nil]
                      ];
    front.pointOnPlane = [[Point3D alloc] initX:120 Y:100 Z:550];
    front.material = [Material jade];
    
    Polygon *right = [[Polygon alloc]initWithVertexList:
                      [[NSMutableArray alloc]initWithObjects:
                       [[Point3D alloc]initX:250 Y:0 Z:550],
                       [[Point3D alloc]initX:250 Y:0 Z:350],
                       [[Point3D alloc]initX:250 Y:200 Z:350],
                       [[Point3D alloc]initX:250 Y:200 Z:550], nil]
                      ];
    right.pointOnPlane = [[Point3D alloc] initX:250 Y:100 Z:450];
    right.material = [Material jade];
    
    Polygon *top = [[Polygon alloc]initWithVertexList:
                      [[NSMutableArray alloc]initWithObjects:
                       [[Point3D alloc]initX:50 Y:200 Z:550],
                       [[Point3D alloc]initX:250 Y:200 Z:550],
                       [[Point3D alloc]initX:250 Y:200 Z:350],
                       [[Point3D alloc]initX:50 Y:200 Z:350], nil]
                      ];
    top.pointOnPlane = [[Point3D alloc] initX:250 Y:200 Z:450];
    top.material = [Material jade];

    Polygon *left = [[Polygon alloc]initWithVertexList:
                      [[NSMutableArray alloc]initWithObjects:
                       [[Point3D alloc]initX:50 Y:0 Z:550],
                       [[Point3D alloc]initX:50 Y:0 Z:350],
                       [[Point3D alloc]initX:50 Y:200 Z:350],
                       [[Point3D alloc]initX:50 Y:200 Z:550], nil]
                      ];
    left.pointOnPlane = [[Point3D alloc] initX:50 Y:100 Z:450];
    left.material = [Material jade];

    Polygon *back = [[Polygon alloc]initWithVertexList:
                      [[NSMutableArray alloc]initWithObjects:
                       [[Point3D alloc]initX:50 Y:0 Z:350],
                       [[Point3D alloc]initX:250 Y:0 Z:350],
                       [[Point3D alloc]initX:250 Y:200 Z:350],
                       [[Point3D alloc]initX:50 Y:200 Z:350], nil]
                      ];
    back.pointOnPlane = [[Point3D alloc] initX:120 Y:100 Z:350];
    back.material = [Material jade];
    
    /****** Prism ******/
    Polygon *sideOne = [[Polygon alloc]initWithVertexList:
                        [[NSMutableArray alloc]initWithObjects:
                         [[Point3D alloc]initX:800 Y:0 Z:400],
                         [[Point3D alloc]initX:800 Y:0 Z:520],
                         [[Point3D alloc]initX:860 Y:300 Z:460], nil]
                        ];
    sideOne.pointOnPlane = [[Point3D alloc]initX:860 Y:300 Z:460];
    sideOne.material = [Material blueTurbulence];

    Polygon *sideTwo = [[Polygon alloc]initWithVertexList:
                        [[NSMutableArray alloc]initWithObjects:
                         [[Point3D alloc]initX:800 Y:0 Z:520],
                         [[Point3D alloc]initX:920 Y:0 Z:520],
                         [[Point3D alloc]initX:860 Y:300 Z:460], nil]
                        ];
    sideTwo.pointOnPlane = [[Point3D alloc]initX:860 Y:300 Z:460];
    sideTwo.material = [Material blueTurbulence];

    Polygon *sideThree = [[Polygon alloc]initWithVertexList:
                          [[NSMutableArray alloc]initWithObjects:
                           [[Point3D alloc]initX:920 Y:0 Z:520],
                           [[Point3D alloc]initX:920 Y:0 Z:400],
                           [[Point3D alloc]initX:860 Y:300 Z:460], nil]
                          ];
    sideThree.pointOnPlane = [[Point3D alloc]initX:860 Y:300 Z:460];
    sideThree.material = [Material blueTurbulence];

    Polygon *sideFour = [[Polygon alloc]initWithVertexList:
                          [[NSMutableArray alloc]initWithObjects:
                           [[Point3D alloc]initX:920 Y:0 Z:400],
                           [[Point3D alloc]initX:800 Y:0 Z:400],
                           [[Point3D alloc]initX:860 Y:300 Z:460], nil]
                          ];
    sideFour.pointOnPlane = [[Point3D alloc]initX:860 Y:300 Z:460];
    sideFour.material = [Material blueTurbulence];

    /******* Sphere 1 *****/
    Sphere *sphere = [[Sphere alloc] init];
    sphere.center = [[Point3D alloc] initX:730 Y:30 Z:500];
    sphere.radius = 30;
    sphere.material = [Material chrome];
    
    /********* Sphere 1 ********/
    Sphere *sphere1 = [[Sphere alloc] init];
    sphere1.center = [[Point3D alloc] initX:800 Y:60 Z:650];
    sphere1.radius = 60;
    sphere1.material = [Material glasswater];
    
    [self.objects addObject:polygonSkyboxBottom];
    [self.objects addObject:polygonSkyboxLeft];
    [self.objects addObject:polygonSkyboxRight];
    [self.objects addObject:polygonSkyboxFront];
    [self.objects addObject:polygonSkyboxBack];
    [self.objects addObject:polygonSkyboxTop];

    [self.objects addObject:sphere];
    [self.objects addObject:sphere1];

    [self.objects addObject:sideOne];
    [self.objects addObject:sideTwo];
    [self.objects addObject:sideThree];
    [self.objects addObject:sideFour];
}

@end