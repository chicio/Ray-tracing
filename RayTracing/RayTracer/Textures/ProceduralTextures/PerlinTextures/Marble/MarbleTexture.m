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
#import "MarbleTexture.h"

@implementation MarbleTexture

#pragma mark marble

- (Vector3D *)texture:(Point3D *)point {
    
    double x = point.x;
    double y = point.y;
    double z = point.z;

    double turbulence = 0;
    double amplitude = 0;
    double frequency = 0;
    
    //In this texture I used the implementation available
    //on the tutorial by codermine.
    //Here we modify the amplitude and frequency to change
    //the final result (see TurbulenceTexture class to see
    //standard implementation). I leave the counter of the
    //loop named as "numberOctaves" for convenience, but here
    //the change of frequence is not an octave (so is not twice
    //the frequency (like the distance between pitch in music :))).
    for (int numberOctaves = 1; numberOctaves < 10; numberOctaves++) {
        
        amplitude = 1.0f / numberOctaves; //x^-1
        frequency = numberOctaves * 0.05; //linear
        
        double noise = [[PerlinNoise sharedInstance]noise:frequency * x andY:frequency * y andZ:frequency * z];
        turbulence += amplitude * fabs(noise);
    }
    
    //Marble is obtained as a
    //phase shift of turbulence.
    double marble = 0.5f * sinf((x + y) * 0.05f + turbulence) + 0.5f;
    
    Vector3D *color1 = [self.color1 productWithScalar:marble];
    Vector3D *color2 = [self.color2 productWithScalar:(1.0f - marble)];

    return [color1 sum:color2];
}

@end