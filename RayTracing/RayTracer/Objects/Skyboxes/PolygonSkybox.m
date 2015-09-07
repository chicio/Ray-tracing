//
//  PolygonSkybox.m
//  ChicioRayTracing
//
//  Created by Fabrizio Duroni on 09/08/15.
//  Copyright © 2015 Fabrizio Duroni. All rights reserved.
//

#import "Point3D.h"
#import "Vector3D.h"
#import "Ray.h"
#import "PolygonSkybox.h"
#import "Texture.h"

@interface PolygonSkybox()

/// Texture of the polygon.
@property (nonatomic, strong) Texture *texture;
///// Side identifier.
//@property (nonatomic, assign) PolygonSkyboxSideIdentifier sideIdentifier;

@end

@implementation PolygonSkybox

#pragma mark init

- (instancetype)initWithSideIdentifier:(PolygonSkyboxSideIdentifier)polygonSkyboxSideIdentifier  TextureName:(NSString *)textureName {
    
    NSMutableArray *vertexList = [PolygonSkybox getVertexListForSide:polygonSkyboxSideIdentifier];
    
    self = [super initWithVertexList:vertexList];
    
    if (self) {
        
        //Set side identifier.
        self.sideIdentifier = polygonSkyboxSideIdentifier;

        //Set center.
        self.center = [PolygonSkybox getCenterForSide:polygonSkyboxSideIdentifier];
        
        //Setup texture.
        self.texture = [[Texture alloc] initWithImageName:textureName];
    }
    
    return self;
}

+ (NSMutableArray *)getVertexListForSide:(PolygonSkyboxSideIdentifier)identifier {
    
    NSMutableArray *vertexList;
    
    switch (identifier) {
        case Bottom:
            vertexList = [[NSMutableArray alloc]initWithObjects:
                          [[Point3D alloc]initX:0 Y:0 Z:0],
                          [[Point3D alloc]initX:0 Y:0 Z:1024],
                          [[Point3D alloc]initX:1024 Y:0 Z:1024],
                          [[Point3D alloc]initX:1024 Y:0 Z:0], nil];
            break;
        case Left:
            vertexList = [[NSMutableArray alloc]initWithObjects:
                          [[Point3D alloc]initX:0 Y:0 Z:0],
                          [[Point3D alloc]initX:0 Y:1024 Z:0],                          
                          [[Point3D alloc]initX:0 Y:1024 Z:1024],
                          [[Point3D alloc]initX:0 Y:0 Z:1024], nil];
            break;
        case Right:
            vertexList = [[NSMutableArray alloc]initWithObjects:
                          [[Point3D alloc]initX:1024 Y:1024 Z:1024],
                          [[Point3D alloc]initX:1024 Y:0 Z:1024],
                          [[Point3D alloc]initX:1024 Y:0 Z:0],
                          [[Point3D alloc]initX:1024 Y:1024 Z:0], nil];
            break;
        case Front:
            vertexList = [[NSMutableArray alloc]initWithObjects:
                          [[Point3D alloc]initX:0 Y:0 Z:0],
                          [[Point3D alloc]initX:1024 Y:0 Z:0],
                          [[Point3D alloc]initX:1024 Y:1024 Z:0],
                          [[Point3D alloc]initX:0 Y:1024 Z:0], nil];
            break;
        case Back:
            vertexList = [[NSMutableArray alloc]initWithObjects:
                          [[Point3D alloc]initX:0 Y:0 Z:1024],
                          [[Point3D alloc]initX:1024 Y:0 Z:1024],
                          [[Point3D alloc]initX:1024 Y:1024 Z:1024],
                          [[Point3D alloc]initX:0 Y:1024 Z:1024], nil];
            break;
        case Top:
            vertexList = [[NSMutableArray alloc]initWithObjects:
                          [[Point3D alloc]initX:0 Y:1024 Z:1024],
                          [[Point3D alloc]initX:1024 Y:1024 Z:1024],
                          [[Point3D alloc]initX:1024 Y:1024 Z:0],
                          [[Point3D alloc]initX:0 Y:1024 Z:0], nil];
            break;
        default:
            break;
    }

    return vertexList;
}

+ (Point3D *)getCenterForSide:(PolygonSkyboxSideIdentifier)identifier {
    
    Point3D *center;
    
    switch (identifier) {
        case Bottom:
            center = [[Point3D alloc] initX:512 Y:0 Z:512];
            break;
        case Left:
            center = [[Point3D alloc] initX:0 Y:512 Z:512];
            break;
        case Right:
            center = [[Point3D alloc] initX:1024 Y:512 Z:512];
            break;
        case Front:
            center = [[Point3D alloc] initX:512 Y:512 Z:0];
            break;
        case Back:
            center = [[Point3D alloc] initX:512 Y:512 Z:1024];
            break;
        case Top:
            center = [[Point3D alloc] initX:512 Y:1024 Z:512];
            break;
        default:
            break;
    }
    
    return center;
}

#pragma mark Read polygib skybox texture

- (Vector3D *)readPolygonSkyboxTexture:(Point3D *)intersectionPoint {
    
    TextureCoordinate coordinate;
    
    switch (self.sideIdentifier) {
        case Bottom:
            coordinate.u = intersectionPoint.x/1024;
            coordinate.v = 1 - intersectionPoint.z/1024;
            break;
        case Left:
            coordinate.u = 1 - intersectionPoint.z/1024;
            coordinate.v = 1 - intersectionPoint.y/1024;
            break;
        case Right:
            coordinate.u = 1 - intersectionPoint.z/1024;
            coordinate.v = intersectionPoint.y/1024;
            break;
        case Front:
            coordinate.u = intersectionPoint.x/1024;
            coordinate.v = intersectionPoint.y/1024;
            break;
        case Back:
            coordinate.u = intersectionPoint.x/1024;
            coordinate.v = 1 - intersectionPoint.y/1024;
            break;
        case Top:
            coordinate.u = intersectionPoint.x/1024;
            coordinate.v = 1 - intersectionPoint.z/1024;
            break;
        default:
            break;
    }

    Vector3D *color = [self.texture readTexture:coordinate];
    
    return color;
}

@end