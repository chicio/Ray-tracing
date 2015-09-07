//
//  Material.m
//  Ray tracing
//
//  Created by Fabrizio Duroni on 05/07/15.
//  Copyright (c) 2015 Fabrizio Duroni. All rights reserved.
//

#import "Constants.h"
#import "BumpMap.h"
#import "MarbleTexture.h"
#import "TurbulenceTexture.h"
#import "Vector3D.h"
#import "Material.h"

@implementation Material

#pragma mark Refractive

+ (Material *)glass {
    
    Material *material = [[Material alloc] init];
    
    material.ke = [[Vector3D alloc] initX:0.0      Y:0.0      Z:0.0];
    material.ka = [[Vector3D alloc] initX:0.0      Y:0.0      Z:0.0];
    material.kd = [[Vector3D alloc] initX:0.588235 Y:0.670588 Z:0.729412];
    material.ks = [[Vector3D alloc] initX:0.9      Y:0.9      Z:0.9];
    material.sh = 96.0;
    //Refractive index CROWN glass.
    material.refractiveIndex = 1.50;
    
    if(dieletric) {
        
        //Dieletric simulation enabled.
        //Material is reflective and refractive.
        material.isTransmissive = true;
        material.isReflective = true;
    } else {

        material.isTransmissive = true;
        material.isReflective = false;
    }
    
    return material;
}

+ (Material *)glasswater {
    
    Material *material = [[Material alloc] init];
    
    material.ke = [[Vector3D alloc] initX:0.0      Y:0.0      Z:0.0];
    material.ka = [[Vector3D alloc] initX:0.0      Y:0.0      Z:0.0];
    material.kd = [[Vector3D alloc] initX:0.588235 Y:0.670588 Z:0.729412];
    material.ks = [[Vector3D alloc] initX:0.9      Y:0.9      Z:0.9];
    material.sh = 96.0;
    //Refractive index water (ice).
    material.refractiveIndex = 1.31;

    if(dieletric) {
        
        //Dieletric simulation enabled.
        //Material si reflective and refractive.
        material.isTransmissive = true;
        material.isReflective = true;
    } else {
        
        material.isTransmissive = true;
        material.isReflective = false;
    }
    
    return material;
}

#pragma mark Standard

+ (Material *)jade {
    
    Material *material = [[Material alloc] init];
    
    material.ke = [[Vector3D alloc] initX:0.0      Y:0.0      Z:0.0];
    material.ka = [[Vector3D alloc] initX:0.135    Y:0.2225   Z:0.1575];
    material.kd = [[Vector3D alloc] initX:0.54     Y:0.89     Z:0.63];
    material.ks = [[Vector3D alloc] initX:0.316228 Y:0.316228 Z:0.316228];
    material.sh = 99;
    material.isTransmissive = false;
    material.isReflective = false;
    
    return material;
}

+ (Material *)violet {
    
    Material *material = [[Material alloc] init];
    
    //Create material.
    material = [[Material alloc] init];
    material.ke = [[Vector3D alloc] initX:0.0      Y:0.0    Z:0.0];
    material.ka = [[Vector3D alloc] initX:0.0      Y:0.0    Z:0.0];
    material.kd = [[Vector3D alloc] initX:0.635294 Y:0.0    Z:1.0];
    material.ks = [[Vector3D alloc] initX:0.0225   Y:0.0225 Z:0.0225];
    material.sh = 76.8;
    material.isTransmissive = false;
    material.isReflective = false;
    
    return material;
}


+ (Material *)orange {
    
    Material *material = [[Material alloc] init];
    
    material = [[Material alloc] init];
    material.ke = [[Vector3D alloc] initX:0.0      Y:0.0      Z:0.0];
    material.ka = [[Vector3D alloc] initX:0.0      Y:0.0      Z:0.0];
    material.kd = [[Vector3D alloc] initX:0.992157 Y:0.513726 Z:0.0];
    material.ks = [[Vector3D alloc] initX:0.0225   Y:0.0225   Z:0.0225];
    material.sh = 12.8;
    material.isTransmissive = false;
    material.isReflective = false;
    
    return material;
}

+ (Material *)matte {
    
    Material *material = [[Material alloc] init];
    
    material = [[Material alloc] init];
    material.ke = [[Vector3D alloc] initX:0.0 Y:0.0 Z:0.0];
    material.ka = [[Vector3D alloc] initX:0.2 Y:0.2 Z:0.2];
    material.kd = [[Vector3D alloc] initX:0.9 Y:0.9 Z:0.9];
    material.ks = [[Vector3D alloc] initX:0.0 Y:0.0 Z:0.0];
    material.sh = 0.0;
    material.isTransmissive = false;
    material.isReflective = false;
    
    return material;
}

#pragma mark Reflective

+ (Material *)bronze {
    
    Material *material = [[Material alloc] init];
    
    material.ke = [[Vector3D alloc] initX:0.0      Y:0.0      Z:0.0];
    material.ka = [[Vector3D alloc] initX:0.2125   Y:0.1275   Z:0.054];
    material.kd = [[Vector3D alloc] initX:0.714    Y:0.4284   Z:0.18144];
    material.ks = [[Vector3D alloc] initX:0.393548 Y:0.271906 Z:0.166721];
    material.sh = 25.6;
    material.isTransmissive = false;
    material.isReflective = true;
    
    return material;
}

+ (Material *)chrome {
    
    Material *material = [[Material alloc] init];
    
    material = [[Material alloc] init];
    material.ke = [[Vector3D alloc] initX:0.0      Y:0.0      Z:0.0];
    material.ka = [[Vector3D alloc] initX:0.25     Y:0.25     Z:0.25];
    material.kd = [[Vector3D alloc] initX:0.4      Y:0.4      Z:0.4];
    material.ks = [[Vector3D alloc] initX:0.774597 Y:0.774597 Z:0.774597];
    material.sh = 76.8;
    material.isTransmissive = false;
    material.isReflective = true;
    
    return material;
}

+ (Material *)silver {
    
    Material *material = [[Material alloc] init];
    
    //Create material.
    material = [[Material alloc] init];
    material.ke = [[Vector3D alloc] initX:0.0      Y:0.0      Z:0.0];
    material.ka = [[Vector3D alloc] initX:0.19225  Y:0.19225  Z:0.19225];
    material.kd = [[Vector3D alloc] initX:0.50754  Y:0.50754  Z:0.50754];
    material.ks = [[Vector3D alloc] initX:0.508273 Y:0.508273 Z:0.508273];
    material.sh = 51.2;
    material.isTransmissive = false;
    material.isReflective = true;
    
    return material;
}

#pragma mark Procedural texture

+ (Material *)rubyBumpMapped:(float)scale {
    
    Material *material = [[Material alloc] init];
    
    material.ke = [[Vector3D alloc] initX:0.0      Y:0.0      Z:0.0];
    material.ka = [[Vector3D alloc] initX:0.1745   Y:0.01175  Z:0.01175];
    material.kd = [[Vector3D alloc] initX:0.61424  Y:0.04136  Z:0.04136];
    material.ks = [[Vector3D alloc] initX:0.727811 Y:0.626959 Z:0.626959];
    material.sh = 76.8;
    material.isTransmissive = false;
    material.isReflective = false;
    material.bumpMap = [[BumpMap alloc] initWithScale:scale];
    
    return material;
}

+ (Material *)flameMarble {
    
    Material *material = [[Material alloc] init];
    
    //Create material.
    material = [[Material alloc] init];
    material.ke = [[Vector3D alloc] initX:0.0      Y:0.0      Z:0.0];
    material.ka = [[Vector3D alloc] initX:0.3      Y:0.2      Z:0.2]; //Predominance of red color
    material.kd = [[Vector3D alloc] initX:0.9      Y:0.9      Z:0.9];
    material.ks = [[Vector3D alloc] initX:0.727811 Y:0.626959 Z:0.626959];
    material.sh = 76.8;
    material.isTransmissive = false;
    material.isReflective = false;
    material.perlinTexture = [[MarbleTexture alloc]initWithColor1:[[Vector3D alloc]initX:162.0 Y:5.0 Z:1.0]
                                                        andColor2:[[Vector3D alloc]initX:254 Y:190.0 Z:3.0]];
    
    return material;
}

+ (Material *)blueTurbulence {
    
    Material *material = [[Material alloc] init];
    
    //Create material.
    material = [[Material alloc] init];
    material.ke = [[Vector3D alloc] initX:0.0 Y:0.0 Z:0.0];
    material.ka = [[Vector3D alloc] initX:0.2 Y:0.2 Z:0.3]; //Predominance of blue color
    material.kd = [[Vector3D alloc] initX:0.9 Y:0.9 Z:0.9];
    material.ks = [[Vector3D alloc] initX:0.6 Y:0.6 Z:0.6];
    material.sh = 50.0;
    material.isTransmissive = false;
    material.isReflective = false;
    material.perlinTexture = [[TurbulenceTexture alloc]initWithColor1:[[Vector3D alloc]initX:255.0 Y:255.0 Z:255.0]
                                                            andColor2:[[Vector3D alloc]initX:0.0 Y:0.0 Z:200.0]];
    
    return material;
}

@end