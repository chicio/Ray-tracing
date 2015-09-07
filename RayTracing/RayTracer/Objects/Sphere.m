//
//  Sphere.m
//  Ray tracing
//
//  Created by Fabrizio Duroni on 05/07/15.
//  Copyright (c) 2015 Fabrizio Duroni. All rights reserved.
//

#import "Vector3D.h"
#import "Ray.h"
#import "Point3D.h"
#import "Material.h"
#import "Sphere.h"

@implementation Sphere

#pragma mark Description

- (NSString *)description {
    
    return [NSString stringWithFormat:@"Sphere[Radius(%f), Origin(%@)]", self.radius, self.center];
}

#pragma mark Normal

- (Vector3D *)normal:(Point3D *)pointOnSphere {
    
    //Normal is just a difference between the point on the sphere and the center of the sphere.
    Vector3D * normal = [pointOnSphere diff:self.center];
    
    return normal;
}

#pragma mark Intersect

- (NSMutableDictionary *)intersect:(Ray *)ray {
    
    Vector3D *delta = [ray.origin diff:self.center];
    
    float A = [ray.direction dot:ray.direction];
    float B = 2 * [delta dot:ray.direction];
    float C = [delta dot:delta] - self.radius * self.radius;
    
    float discr = B * B - 4 * A * C;
    
    if(discr < 0) {
        
        return nil;
    }
    
    float s = sqrtf(discr);
    float t0 = (-B - s)/(2*A);
    float t1 = (-B + s)/(2*A);
    float t = -1;
    
    //Test all condition.
    //Prof Ciocca/Bianco "ray tracing 1.pdf" slide 23.
    if (t0 > 0 && t1 > 0) {
        t = MIN(t0, t1);
    }else if (t0 > 0 && t1 < 0) {
        t = t0;
    } else if (t0 < 0 && t1 > 0) {
        t = t1;
    } else {
        return nil;
    }
    
    Vector3D *prodvs = [ray.direction productWithScalar:t];
    Point3D *intersection = [ray.origin sumVector:prodvs];
    
    NSMutableDictionary *result = [NSMutableDictionary new];
    [result setObject:intersection forKey:@"point"];
    [result setObject:[NSNumber numberWithFloat:t] forKey:@"t"];
    [result setObject:[intersection diff:self.center] forKey:@"normal"];
    [result setObject:self forKey:@"object"];
    
    return result;
}

@end