//
//  ViewPlane.m
//  Ray tracing
//
//  Created by Fabrizio Duroni on 07/07/15.
//  Copyright (c) 2015 Fabrizio Duroni. All rights reserved.
//

#import "ViewPlane.h"

@implementation ViewPlane

#pragma mark init

- (instancetype)initWithWidth:(float)width andHeigth:(float)height {
    
    self = [super init];

    if (self) {
        
        self.width = width;
        self.height = height;
        self.area = width * height;
    }
    
    return self;
}

@end