//
//  PerlinTexture.m
//  Ray tracing
//
//  Created by Fabrizio Duroni on 15/08/15.
//  Copyright (c) 2015 Fabrizio Duroni. All rights reserved.
//

#import "Vector3D.h"
#import "PerlinTexture.h"

@implementation PerlinTexture

#pragma mark init

- (instancetype)initWithColor1:(Vector3D *)color1 andColor2:(Vector3D *)color2 {
    
    self = [super init];
    
    if (self) {
        
        self.color1 = color1;
        self.color2 = color2;
    }
    
    return self;
}

#pragma mark texture.

- (Vector3D *)texture:(Point3D *)point {
 
    //Default implementation does nothing.
    //Simply return black.
    return [[Vector3D alloc] initX:0 Y:0 Z:0];
}

@end