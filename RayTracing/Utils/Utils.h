//
//  Utils.h
//  Ray tracing
//
//  Created by Fabrizio Duroni on 08/07/15.
//  Copyright (c) 2015 Fabrizio Duroni. All rights reserved.
//

@import Foundation;

@class Vector3D;

@interface Utils : NSObject

/*!
 Normalize color components.
 Limit colors component range between 0 and 255.
 
 @param color the color to be normalized as Vector3D.
 
 @returns color normalized.
 */
+ (Vector3D *)normalizeColorComponents:(Vector3D *)color;

/*!
 Print the current time with a message associated.
 
 @param message a message to be concatenated with the time.
 */
+ (void)currentTime:(NSString *)message;

@end