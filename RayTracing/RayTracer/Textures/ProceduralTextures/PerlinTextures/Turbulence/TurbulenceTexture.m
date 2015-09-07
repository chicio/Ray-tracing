//
//  MarbleTexture.m
//  Ray tracing
//
//  Created by Fabrizio Duroni on 15/08/15.
//  Copyright (c) 2015 Fabrizio Duroni. All rights reserved.
//

#import "PerlinNoise.h"
#import "Point3D.h"
#import "Vector3D.h"
#import "TurbulenceTexture.h"

@implementation TurbulenceTexture

#pragma mark turbulence

- (Vector3D *)texture:(Point3D *)point {
    
    //I scale coordinate to zoom in/out
    //on the texture. Change value of scale
    //to obtain different result.
    double x = point.x/16;
    double y = point.y/16;
    double z = point.z/16;

    double turbulence = 0;
    double amplitude = 1.0;
    double frequency = 1.0;
    
    //Standard implementation of turbulence.
    //Change the number of octaves to change
    //the details of the texture (usually
    //0 - 8 range).
    for (int numberOctaves = 0; numberOctaves < 8; numberOctaves++) {
        
        //We take the absolute value of noise.
        //(e.g. fractal sum doesn't use abs).
        double noise = [[PerlinNoise sharedInstance]noise:frequency * x andY:frequency * y andZ:frequency * z];
        turbulence += amplitude * fabs(noise);
        
        amplitude *= 0.5;
        frequency *= 2;
    }
    
    Vector3D *color1 = [self.color1 productWithScalar:turbulence];
    Vector3D *color2 = [self.color2 productWithScalar:(1.0f - turbulence)];
    
    return [color1 sum:color2];
}

@end