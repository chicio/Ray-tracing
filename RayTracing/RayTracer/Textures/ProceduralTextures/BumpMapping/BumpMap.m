//
//  BumpMappingTexture.m
//  Ray tracing
//
//  Created by Fabrizio Duroni on 14/08/15.
//  Copyright (c) 2015 Fabrizio Duroni. All rights reserved.
//

#import "PerlinNoise.h"
#import "Point3D.h"
#import "Vector3D.h"
#import "BumpMap.h"

@interface BumpMap()

/// Scale factor to be applied during normal bump map.
@property (nonatomic, assign) float scale;

@end

@implementation BumpMap

#pragma mark init

- (instancetype)initWithScale:(float)scale {

    self = [super init];

    if (self) {
    
        self.scale = scale;
    }
    
    return self;
}

#pragma mark bump map

- (Vector3D *)bumpMapTexture:(Point3D *)point applyToNormal:(Vector3D *)normal {
    
    double x = point.x / self.scale;
    double y = point.y / self.scale;
    double z = point.z / self.scale;
    
    //We apply a scale to let the noise
    //have an impact on our coordinate system.
    //Change it to change the final result.
    float noiseCoefx = [[PerlinNoise sharedInstance]noise:x andY:y andZ:z] * 15;
    float noiseCoefy = [[PerlinNoise sharedInstance]noise:y andY:z andZ:x] * 15;
    float noiseCoefz = [[PerlinNoise sharedInstance]noise:z andY:x andZ:y] * 15;
    
    Vector3D *noiseVector = [[Vector3D alloc] initX:noiseCoefx Y:noiseCoefy Z:noiseCoefz];
    normal = [normal sum:noiseVector];
    
    return normal;
}

@end