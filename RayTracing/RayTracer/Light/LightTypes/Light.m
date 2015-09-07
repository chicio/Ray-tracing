//
//  Light.m
//  Ray tracing
//
//  Created by Fabrizio Duroni on 06/07/15.
//  Copyright (c) 2015 Fabrizio Duroni. All rights reserved.
//

#import "Light.h"

@implementation Light

#pragma mark Init

- (instancetype)initWithOrigin:(Point3D *)origin andColor:(Vector3D *)color {

    self = [super init];
    
    if (self) {
        
        //Light setup.
        self.color = color;
        self.origin = origin;
    }
    
    return self;
}

@end