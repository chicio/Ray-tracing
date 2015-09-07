//
//  Square.m
//  Ray tracing
//
//  Created by Fabrizio Duroni on 08/08/15.
//  Copyright © 2015 Fabrizio Duroni. All rights reserved.
//

#import "Texture.h"
#import "Point3D.h"
#import "Vector3D.h"
#import "Ray.h"
#import "Polygon.h"

@interface Polygon()

/// Edge list. I calculate them on init. Used only for intersection test.
@property (nonatomic, strong) NSMutableArray *edgeList;

@end

@implementation Polygon

- (instancetype)initWithVertexList:(NSMutableArray *)vertexList {
    
    self = [super init];

    if (self) {
        
        //Setup vertex list.
        self.vertexList = vertexList;
        
        //Setup normal.
        Point3D *v1 = [self.vertexList objectAtIndex:0];
        Point3D *v2 = [self.vertexList objectAtIndex:1];
        Point3D *v3 = [self.vertexList objectAtIndex:2];
        Vector3D *normal = [[v1 diff:v2] cross:[v1 diff:v3]];
        [normal normalize];
        
        self.normal = normal;
        
        //Setup edge list.
        self.edgeList = [NSMutableArray new];
        NSUInteger numberOfVertex = self.vertexList.count;

        for (int i = 0; i < numberOfVertex; i++) {

            Point3D *nextVertex = [self.vertexList objectAtIndex:((i + 1) % numberOfVertex)];
            Point3D *currentVertex = [self.vertexList objectAtIndex:i];
            
            Vector3D *edge = [nextVertex diff:currentVertex];
            [self.edgeList addObject:edge];
        }
    }
    
    return self;
}

#pragma mark Description

- (NSString *)description {
    
    return [NSString stringWithFormat:@"Polygon[Normal(%@), Origin(%@)]", self.normal, self.pointOnPlane];
}

#pragma mark Intersect

/*!
 Check the intersection of ray with the plane
 of the polygon.
 
 @see prof. Ciocca/Bianco slide.
 
 @param ray 
 
 @returns t if intersect or -1
 */
- (float)intersectWithPlaneOfPolygon:(Ray *)ray {
    
    //Calculate denominator.
    float denominator = [ray.direction dot:self.normal];
    
    //Ray perpendicular to plane normal, so no intersection.
    //See prof. Ciocca/Bianco slide "ray tracing 1.pdf" slide 25.
    if(denominator == 0) {
        
        return -1;
    }
    
    //Calculate numerator.
    float numerator = -1.0 * [[ray.origin diff:self.pointOnPlane] dot:self.normal];
    
    float t = numerator/denominator;
    
    //No intersection.
    if (t <= 0) {
        
        return -1;
    }
    
    return t;
}

- (NSMutableDictionary *)intersect:(Ray *)ray {

    //Check intersection of ray with polygon ray.
    float t = [self intersectWithPlaneOfPolygon:ray];
    
    if(t == -1) {
        
        return nil;
    }
    
    Vector3D *prodvs = [ray.direction productWithScalar:t];
    Point3D *intersectionPoint = [ray.origin sumVector:prodvs];
    
    //Check that the intersection point is inside the polygon.    
    for (int i = 0; i < self.vertexList.count; i++) {
        
        Point3D *currentVertex = [self.vertexList objectAtIndex:i];
        Vector3D *edge = [self.edgeList objectAtIndex:i];
        Vector3D *vectorWithIntersection = [intersectionPoint diff:currentVertex];
        Vector3D *crossProduct = [edge cross:vectorWithIntersection];
        
        float dotProduct = [crossProduct dot:self.normal];
        
        if(dotProduct < 0) {
            
            //Point is outside polygon.
            return nil;
        }
    }
    
    NSMutableDictionary *result = [NSMutableDictionary new];
    [result setObject:intersectionPoint forKey:@"point"];
    [result setObject:[NSNumber numberWithFloat:t] forKey:@"t"];
    [result setObject:self.normal forKey:@"normal"];
    [result setObject:self forKey:@"object"];
    
    return result;
}

@end