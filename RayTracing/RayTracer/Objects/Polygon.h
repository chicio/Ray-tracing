//
//  Square.h
//  Ray tracing
//
//  Created by Fabrizio Duroni on 08/08/15.
//  Copyright © 2015 Fabrizio Duroni. All rights reserved.
//

#import "Model.h"

@import Foundation;

@class Point3D;
@class Texture;
@class Material;

/*!
 Class used to represent CONVEX polygon.
 
 @see https://sites.google.com/site/justinscsstuff/object-intersection
 */
@interface Polygon : NSObject <Model>

/// Origin of the plane as a Point3D. It could be a vertex of the polygon.
@property (nonatomic, strong) Point3D *pointOnPlane;
/// Plane normal.
@property (nonatomic, strong) Vector3D *normal;
/// Material assigned to the polygon.
@property (nonatomic, strong) Material *material;
/// Vertex list of the polygon.
@property (nonatomic, strong) NSMutableArray *vertexList;

/*!
 Init the polygon.
 
 @attention: normal is calculated using the first three vertex of the list.
 
 @param vertexList a list of vertex of the polygon.
 
 @returns a Polygon instance.
 */
- (instancetype)initWithVertexList:(NSMutableArray *)vertexList;

/*!
 Calculate the intersection of the square with a ray.
 
 @attention for the intersection I use the method contained
 in the document linked below.
 It is a general version of the triangle intersection test in which I check
 that an intersection point is on the left of every edge. This method work
 only for CONVEX polygon. For other kind of polygon something like winding
 number rule or odd even rule must be used.
 
 @see https://sites.google.com/site/justinscsstuff/object-intersection
 
 @param ray the ray used to calculate the intersection.
 
 @returns a dictionary that contains t, intersection point, normal and the polygon itself.
 */
- (NSMutableDictionary *)intersect:(Ray *)ray;

@end