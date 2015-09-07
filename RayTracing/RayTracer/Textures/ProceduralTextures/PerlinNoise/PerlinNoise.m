//
//  PerlinNoise.m
//  Ray tracing
//
//  Created by Fabrizio Duroni on 14/08/15.
//  Copyright (c) 2015 Fabrizio Duroni. All rights reserved.
//

#import "PerlinNoise.h"

@interface PerlinNoise() {
    
    /// Permutation array use in the noise generation procedure.
    int _p[512];
}

@end

@implementation PerlinNoise

static PerlinNoise *sharedPerlinNoise;

#pragma mark init

+ (id)sharedInstance {
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedPerlinNoise = [[self alloc] init];
    });
    
    return sharedPerlinNoise;
}

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        int permutation[] = { 151,160,137,91,90,15,
            131,13,201,95,96,53,194,233,7,225,140,36,103,30,69,142,8,99,37,240,21,10,23,
            190,6,148,247,120,234,75,0,26,197,62,94,252,219,203,117,35,11,32,57,177,33,
            88,237,149,56,87,174,20,125,136,171,168,68,175,74,165,71,134,139,48,27,166,
            77,146,158,231,83,111,229,122,60,211,133,230,220,105,92,41,55,46,245,40,244,
            102,143,54, 65,25,63,161, 1,216,80,73,209,76,132,187,208,89,18,169,200,196,
            135,130,116,188,159,86,164,100,109,198,173,186,3,64,52,217,226,250,124,123,
            5,202,38,147,118,126,255,82,85,212,207,206,59,227,47,16,58,17,182,189,28,42,
            23,183,170,213,119,248,152, 2,44,154,163, 70,221,153,101,155,167,43,172,9,
            129,22,39,253,19,98,108,110,79,113,224,232,178,185, 112,104,218,246,97,228,
            251,34,242,193,238,210,144,12,191,179,162,241,81,51,145,235,249,14,239,107,
            49,192,214, 31,181,199,106,157,184, 84,204,176,115,121,50,45,127,4,150,254,
            138,236,205,93,222,114,67,29,24,72,243,141,128,195,78,66,215,61,156,180
        };
        
        for (int i = 0; i < 256; i++) {
            _p[256+i] = _p[i] = permutation[i];
        }
    }
    
    return self;
}

#pragma mark Internal methods

/*!
 Ease/fade curve. The curve used is
 6t^5 - 15t^4 + 10t^3
 */
double fade(double t) {
    
    return t * t * t * (t * (t * 6 - 15) + 10);
}

/*!
 Linear interpolation.
 */
double lerp(double t, double a, double b) {
    
    return a + t * (b - a);
}

/*!
 Calculate dot product between of the gradient
 selected and the 8 location vectors.
 */
double grad(int hash, double x, double y, double z) {
    
    int h = hash & 15;
    // CONVERT 4 BITS OF HASH CODE INTO 12 GRADIENT DIRECTIONS.
    double u = h<8||h==12||h==13 ? x : y, v = h < 4||h == 12||h == 13 ? y : z;
    return ((h & 1) == 0 ? u : -u) + ((h&2) == 0 ? v : -v);
}

#pragma mark Noise

- (double)noise:(double)x andY:(double)y andZ:(double)z {
    
    int X = (int)floor(x) & 255, // FIND UNIT CUBE THAT
        Y = (int)floor(y) & 255, // CONTAINS POINT.
        Z = (int)floor(z) & 255;
    
    x -= floor(x); // FIND RELATIVE X,Y,Z
    y -= floor(y); // OF POINT IN CUBE.
    z -= floor(z);

    double u = fade(x), // COMPUTE FADE CURVES
           v = fade(y), // FOR EACH OF X,Y,Z.
           w = fade(z);

    int A  = _p[X]+Y,   // HASH COORDINATES OF
        AA = _p[A]+Z,   // THE 8 CUBE CORNERS,
        AB = _p[A+1]+Z,
        B  = _p[X+1]+Y,
        BA = _p[B]+Z,
        BB = _p[B+1]+Z;
    
    return lerp(w, lerp(v, lerp(u, grad(_p[AA], x, y, z), // AND ADD
                         grad(_p[BA], x-1, y, z)),        // BLENDED
                 lerp(u, grad(_p[AB], x, y-1, z),         // RESULTS
                      grad(_p[BB], x-1, y-1, z))),        // FROM 8
         lerp(v, lerp(u, grad(_p[AA+1], x, y, z-1),       // CORNERS
                      grad(_p[BA+1], x-1, y, z-1)),       // OF CUBE
              lerp(u, grad(_p[AB+1], x, y-1, z-1 ),
                   grad(_p[BB+1], x-1, y-1, z-1 ))));
}

@end