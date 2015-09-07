//
//  ViewPlane.h
//  Ray tracing
//
//  Created by Fabrizio Duroni on 07/07/15.
//  Copyright (c) 2015 Fabrizio Duroni. All rights reserved.
//

@import Foundation;

@interface ViewPlane : NSObject

/// Width of the view plane.
@property (assign, nonatomic) float width;
/// Height of the view plane.
@property (assign, nonatomic) float height;
/// Area of the view plane.
@property (assign, nonatomic) float area;
/// View Plane height.

/*!
 Init of the view plane.
 
 @attention Semplification: viewplane and viewport are the same (position and dimension).
 
 @param width the width of the view plane.
 @param height the height of the view plane.
 
 @returns a View Plane instance.
 */
- (instancetype)initWithWidth:(float)width andHeigth:(float)height;

@end