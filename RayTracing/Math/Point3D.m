//
//  Point3D.m
//  Ray tracing
//
//  Created by Fabrizio Duroni on 06/07/15.
//  Copyright (c) 2015 Fabrizio Duroni. All rights reserved.
//

#import "Vector3D.h"
#import "Point3D.h"

@implementation Point3D

#pragma mark Init

- (id)initX:(float)x Y:(float)y Z:(float)z {
    
    if(self = [super init]) {
        
        self.x = x;
        self.y = y;
        self.z = z;
        self.w = 1;
    }
    
    return self;
}

#pragma mark Description

- (NSString*) description {
    
    return [NSString stringWithFormat:@"Point3D[Coordinate(%f, %f, %f]", self.x, self.y, self.z];
}

#pragma mark Operations

- (Point3D *)sumVector:(Vector3D *)vector {
    
    return [[Point3D alloc] initX:(vector.x + self.x)
                                Y:(vector.y + self.y)
                                Z:(vector.z + self.z)];
}

- (Vector3D *)diff:(Point3D *)otherPoint {
    
    Vector3D *resultVector = [[Vector3D alloc] initX:(self.x - otherPoint.x)
                                                   Y:(self.y - otherPoint.y)
                                                   Z:(self.z - otherPoint.z)];
    
    return resultVector;
}

@end