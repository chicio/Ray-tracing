//
//  Utils.m
//  Ray tracing
//
//  Created by Fabrizio Duroni on 08/07/15.
//  Copyright (c) 2015 Fabrizio Duroni. All rights reserved.
//

#import "Vector3D.h"
#import "Utils.h"

@implementation Utils

+ (Vector3D *)normalizeColorComponents:(Vector3D *)color {

    //Normalize each component on the upper and
    //lower bound of rgb scale.
    color.x = color.x > 255 ? 255 : color.x;
    color.x = color.x < 0 ? 0 : color.x;
    color.y = color.y > 255 ? 255 : color.y;
    color.y = color.y < 0 ? 0 : color.y;
    color.z = color.z > 255 ? 255 : color.z;
    color.z = color.z < 0 ? 0 : color.z;
        
    return color;
}

@end