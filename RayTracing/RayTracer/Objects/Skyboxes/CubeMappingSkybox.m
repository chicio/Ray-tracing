//
//  SkyboxTexture.m
//  Ray tracing
//
//  Created by Fabrizio Duroni on 26/07/15.
//  Copyright (c) 2015 Fabrizio Duroni. All rights reserved.
//

#import "Vector3D.h"
#import "Ray.h"
#import "Texture.h"
#import "CubeMappingSkybox.h"

@interface CubeMappingSkybox ()

/// Top texture.
@property (nonatomic, strong) Texture *top;
/// Bottom texture.
@property (nonatomic, strong) Texture *bottom;
/// Right texture.
@property (nonatomic, strong) Texture *right;
/// Left texture.
@property (nonatomic, strong) Texture *left;
/// Front texture.
@property (nonatomic, strong) Texture *front;
/// Back texture.
@property (nonatomic, strong) Texture *back;

@end

@implementation CubeMappingSkybox

#pragma mark Init

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        self.front = [[Texture alloc] initWithImageName:@"Front"];
        self.top = [[Texture alloc] initWithImageName:@"Top"];
        self.bottom = [[Texture alloc] initWithImageName:@"Bottom"];
        self.back = [[Texture alloc] initWithImageName:@"Back"];
        self.right = [[Texture alloc] initWithImageName:@"Right"];
        self.left = [[Texture alloc] initWithImageName:@"Left"];
    }
    
    return self;
}

#pragma mark Read cube mapping skybox texture

- (Vector3D *)readSkyboxTexture:(Ray *)ray {
    
    TextureCoordinate textureCoordinate;
    Vector3D *skyboxPixelColor = [[Vector3D alloc]initX:0 Y:0 Z:0];
    
    //The component that is greater, as absolute value, of the other two
    //is the one that the ray points to. Then jsut checking the sign of it
    //it is possible to find the side:
    //* x => left or right
    //* y => top or bottom
    //* z => front or back
    
    if ((fabsf(ray.direction.x) >= fabsf(ray.direction.y)) && (fabsf(ray.direction.x) >= fabsf(ray.direction.z))) {
        
        if (ray.direction.x > 0.0f) {
            
            textureCoordinate.u = 1.0f - (ray.direction.z / ray.direction.x +  1.0f) * 0.5f;
            textureCoordinate.v = (ray.direction.y / ray.direction.x + 1.0f) * 0.5f;
            skyboxPixelColor = [self.right readTexture:textureCoordinate];
        } else if (ray.direction.x < 0.0f) {
            
            textureCoordinate.u = 1.0f - (ray.direction.z / ray.direction.x + 1.0f) * 0.5f;
            textureCoordinate.v = 1.0f - (ray.direction.y / ray.direction.x + 1.0f) * 0.5f;
            skyboxPixelColor = [self.left readTexture:textureCoordinate];
        }
    } else if ((fabsf(ray.direction.y) >= fabsf(ray.direction.x)) && (fabsf(ray.direction.y) >= fabsf(ray.direction.z))) {
        
        if (ray.direction.y > 0.0f) {
            
            textureCoordinate.u = (ray.direction.x / ray.direction.y + 1.0f) * 0.5f;
            textureCoordinate.v = 1.0f - (ray.direction.z / ray.direction.y + 1.0f) * 0.5f;
            skyboxPixelColor = [self.top readTexture:textureCoordinate];
        }else if (ray.direction.y < 0.0f) {
            
            textureCoordinate.u = 1.0f - (ray.direction.x / ray.direction.y + 1.0f) * 0.5f;
            textureCoordinate.v = (ray.direction.z/ray.direction.y + 1.0f) * 0.5f;
            skyboxPixelColor = [self.bottom readTexture:textureCoordinate];
        }
    }else if ((fabsf(ray.direction.z) >= fabsf(ray.direction.x)) && (fabsf(ray.direction.z) >= fabsf(ray.direction.y))) {
        
        if (ray.direction.z > 0.0f) {
            
            textureCoordinate.u = (ray.direction.x / ray.direction.z + 1.0f) * 0.5f;
            textureCoordinate.v = (ray.direction.y / ray.direction.z + 1.0f) * 0.5f;
            skyboxPixelColor = [self.front readTexture:textureCoordinate];
        }else if (ray.direction.z < 0.0f) {
            
            textureCoordinate.u = (ray.direction.x / ray.direction.z + 1.0f) * 0.5f;
            textureCoordinate.v = 1.0f - (ray.direction.y / ray.direction.z + 1) * 0.5f;
            skyboxPixelColor = [self.back readTexture:textureCoordinate];
        }
    }
    
    return skyboxPixelColor;
}

@end