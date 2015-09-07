//
//  Vector3D.m
//  Ray tracing
//
//  Created by Fabrizio Duroni on 05/07/15.
//  Copyright (c) 2015 Fabrizio Duroni. All rights reserved.
//

#import "Vector3D.h"

@implementation Vector3D

#pragma mark init

-(id)initX:(float)x Y:(float)y Z:(float)z {

    if(self = [super init]) {
    
        self.x = x;
        self.y = y;
        self.z = z;
        self.w = 0;
    }
    
    return self;
}

#pragma mark description

- (NSString*)description {
    
    return [NSString stringWithFormat:@"Vector3D[Components(%f, %f, %f)]", self.x, self.y, self.z];
}

#pragma Operations

- (float)dot:(Vector3D *)otherVector {
    
    float dotResult = (self.x * otherVector.x) + (self.y * otherVector.y) + (self.z * otherVector.z);
    
    return dotResult;
}

- (Vector3D *)productWithScalar:(float)scalar {
    
    Vector3D *resultVector = [[Vector3D alloc] initX:(self.x * scalar) Y:(self.y * scalar) Z:(self.z * scalar)];
    
    return resultVector;
}

- (Vector3D *)pprod:(Vector3D *)otherVector {
    
    Vector3D *resultVector = [[Vector3D alloc] initX:(self.x * otherVector.x) Y:(self.y * otherVector.y) Z:(self.z * otherVector.z)];
    
    return resultVector;
}

- (void)normalize {
    
    float magnitude = [self magnitude]; 
    
    //Normalize.
    self.x = self.x / magnitude;
    self.y = self.y / magnitude;
    self.z = self.z / magnitude;
}

- (float)magnitude {

    float magnitude = sqrtf([self dot:self]);

    return magnitude;
}

- (Vector3D *)diff:(Vector3D *)otherVector {
 
    Vector3D *resultVector = [[Vector3D alloc] initX:(self.x - otherVector.x) Y:(self.y - otherVector.y) Z:(self.z - otherVector.z)];

    return resultVector;
}

- (Vector3D *)sum:(Vector3D *)otherVector {
    
    Vector3D *resultVector = [[Vector3D alloc] initX:(self.x + otherVector.x) Y:(self.y + otherVector.y) Z:(self.z + otherVector.z)];
    
    return resultVector;
}

- (Vector3D *)cross:(Vector3D *)otherVector {
    
    float x = self.y * otherVector.z - self.z * otherVector.y;
    float y = self.z * otherVector.x - self.x * otherVector.z;
    float z = self.x * otherVector.y - self.y * otherVector.x;
    
    return [[Vector3D alloc]initX:x Y:y Z:z];
}

@end