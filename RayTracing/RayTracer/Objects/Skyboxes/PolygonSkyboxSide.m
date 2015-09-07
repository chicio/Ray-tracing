//
//  PolygonSkybox.m
//  Ray tracing
//
//  Created by Fabrizio Duroni on 09/08/15.
//  Copyright © 2015 Fabrizio Duroni. All rights reserved.
//

#import "Point3D.h"
#import "Vector3D.h"
#import "Ray.h"
#import "Material.h"
#import "PolygonSkyboxSide.h"
#import "Texture.h"

@interface PolygonSkyboxSide()

/// Texture of the polygon.
@property (nonatomic, strong) Texture *texture;
/// Side identifier.
@property (nonatomic, assign) PolygonSkyboxSideIdentifier sideIdentifier;

@end

@implementation PolygonSkyboxSide

#pragma mark init

- (instancetype)initWithSideIdentifier:(PolygonSkyboxSideIdentifier)polygonSkyboxSideIdentifier
                           textureName:(NSString *)textureName {
    
    NSMutableArray *vertexList = [PolygonSkyboxSide getVertexListForSide:polygonSkyboxSideIdentifier];
    
    self = [super initWithVertexList:vertexList];
    
    if (self) {
        
        //Set side identifier.
        self.sideIdentifier = polygonSkyboxSideIdentifier;

        //Set center.
        self.pointOnPlane = [self getPointOnPlaneForSide:polygonSkyboxSideIdentifier];
        
        //Setup texture.
        self.texture = [[Texture alloc] initWithImageName:textureName];
        
        //Setup a default diffuse material.
        self.material = [Material matte];
    }
    
    return self;
}

/*!
 Method used to get the vertex of the side for the identifier passed as parameter.
 
 @param identifier the side identifier.
 
 @returns a list of vertex as Point3D.
 */
+ (NSMutableArray *)getVertexListForSide:(PolygonSkyboxSideIdentifier)identifier {
    
    NSMutableArray *vertexList;
    
    switch (identifier) {
        case Bottom:
            vertexList = [[NSMutableArray alloc]initWithObjects:
                          [[Point3D alloc]initX:0    Y:0    Z:0],
                          [[Point3D alloc]initX:0    Y:0    Z:1024],
                          [[Point3D alloc]initX:1024 Y:0    Z:1024],
                          [[Point3D alloc]initX:1024 Y:0    Z:0], nil];
            break;
        case Left:
            vertexList = [[NSMutableArray alloc]initWithObjects:
                          [[Point3D alloc]initX:0    Y:0    Z:0],
                          [[Point3D alloc]initX:0    Y:1024 Z:0],
                          [[Point3D alloc]initX:0    Y:1024 Z:1024],
                          [[Point3D alloc]initX:0    Y:0    Z:1024], nil];
            break;
        case Right:
            vertexList = [[NSMutableArray alloc]initWithObjects:
                          [[Point3D alloc]initX:1024 Y:0    Z:0],
                          [[Point3D alloc]initX:1024 Y:0    Z:1024],
                          [[Point3D alloc]initX:1024 Y:1024 Z:1024],
                          [[Point3D alloc]initX:1024 Y:1024 Z:0], nil];
            break;
        case Front:
            vertexList = [[NSMutableArray alloc]initWithObjects:
                          [[Point3D alloc]initX:0    Y:0    Z:0],
                          [[Point3D alloc]initX:1024 Y:0    Z:0],
                          [[Point3D alloc]initX:1024 Y:1024 Z:0],
                          [[Point3D alloc]initX:0    Y:1024 Z:0], nil];
            break;
        case Back:
            vertexList = [[NSMutableArray alloc]initWithObjects:
                          [[Point3D alloc]initX:0    Y:0    Z:1024],
                          [[Point3D alloc]initX:0    Y:1024 Z:1024],
                          [[Point3D alloc]initX:1024 Y:1024 Z:1024],
                          [[Point3D alloc]initX:1024 Y:0    Z:1024], nil];
            break;
        case Top:
            vertexList = [[NSMutableArray alloc]initWithObjects:
                          [[Point3D alloc]initX:0    Y:1024 Z:1024],
                          [[Point3D alloc]initX:0    Y:1024 Z:0],
                          [[Point3D alloc]initX:1024 Y:1024 Z:0],
                          [[Point3D alloc]initX:1024 Y:1024 Z:1024], nil];
            break;
        default:
            break;
    }

    return vertexList;
}

/*!
 Method use to get a point on the plane (It could be also a vertex....but anyway leave 
 it for clarity of implementation).
 
 @param identifier the side identifier.
 
 @returns a Point3D that reside on the plane of the polygon side.
 */
- (Point3D *)getPointOnPlaneForSide:(PolygonSkyboxSideIdentifier)identifier {
    
    Point3D *pointOnPlane;
    
    switch (identifier) {
        case Bottom:
            pointOnPlane = [[Point3D alloc] initX:512  Y:0    Z:512];
            break;
        case Left:
            pointOnPlane = [[Point3D alloc] initX:0    Y:512  Z:512];
            break;
        case Right:
            pointOnPlane = [[Point3D alloc] initX:1024 Y:512  Z:512];
            break;
        case Front:
            pointOnPlane = [[Point3D alloc] initX:512  Y:512  Z:0];
            break;
        case Back:
            pointOnPlane = [[Point3D alloc] initX:512  Y:512  Z:1024];
            break;
        case Top:
            pointOnPlane = [[Point3D alloc] initX:512  Y:1024 Z:512];
            break;
        default:
            break;
    }
    
    return pointOnPlane;
}

#pragma mark Read polygon skybox texture

/*!
 Read the texture associated with the polygon side.
 
 @param intersectionPoint the intersection point.
 
 @returns a texel color as Vector3D.
 */
- (Vector3D *)readPolygonSkyboxTexture:(Point3D *)intersectionPoint {
    
    TextureCoordinate coordinate;
    
    switch (self.sideIdentifier) {
        case Bottom:
            coordinate.u = intersectionPoint.x/1024;
            coordinate.v = 1 - intersectionPoint.z/1024;
            break;
        case Left:
            coordinate.u = 1 - intersectionPoint.z/1024;
            coordinate.v = intersectionPoint.y/1024;
            break;
        case Right:
            coordinate.u = 1 - intersectionPoint.z/1024; //Symmetric to left texture.
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