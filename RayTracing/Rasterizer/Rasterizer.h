//
//  Rasterizer.h
//  Ray tracing
//
//  Created by Fabrizio Duroni on 05/07/15.
//  Copyright (c) 2015 Fabrizio Duroni. All rights reserved.
//

@import Foundation;
@import UIKit;

@interface Rasterizer : NSObject

/*!
 Rasterize a sequence of pixel to the screen as UIImage.

 @param pixelsColorData the color of each pixel of the image.
 @param height height of the image part to be rendered.
 @param width width of the image to be rendered.
 
 @returns an UIImage created from the sequence of pixel received.
 */
- (UIImage *)rasterize:(NSMutableArray *)pixelsColorData andHeight:(float)height andWidth:(float)width;

@end