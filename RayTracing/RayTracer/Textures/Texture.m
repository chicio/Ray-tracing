//
//  Texture.m
//  Ray tracing
//
//  Created by Fabrizio Duroni on 26/07/15.
//  Copyright (c) 2015 Fabrizio Duroni. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Constants.h"
#import "Texture.h"
#import "Vector3D.h"

@interface Texture () {
    
    //Raw pixel data.
    unsigned char *_rawData;
}

/// Width of the image.
@property (assign, nonatomic) NSUInteger width;
/// Height of the image.
@property (assign, nonatomic) NSUInteger height;
/// Number of bytes on each row.
@property (assign, nonatomic) NSUInteger bytesPerRow;

@end

@implementation Texture

#pragma mark Init

- (id)initWithImageName:(NSString *)imageName {
    
    if(self = [super init]) {
        
        UIImage *image = [UIImage imageNamed:imageName];
        
        //Setup image.
        self.width = CGImageGetWidth(image.CGImage);
        self.height = CGImageGetHeight(image.CGImage);
        
        //Array structure.
        _rawData = (unsigned char *) calloc(self.height * self.width * 4, sizeof(unsigned char));
        
        self.bytesPerRow = bytesPerPixel * self.width;
        
        //Extract data in the array of pixel.
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = CGBitmapContextCreate(_rawData, self.width, self.height, bitsPerComponent, self.bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
        CGContextDrawImage(context, CGRectMake(0, 0, self.width, self.height), image.CGImage);

        CGContextRelease(context);
        CGColorSpaceRelease(colorSpace);
    }
    
    return self;
}

#pragma mark Read texture

- (Vector3D *)getTexelFromImageAtx:(int)xp atY:(int)yp {
    
    //Iaccess directly to the pixels of the image from the array precalculated.
    //Y coordinate must be inverted (Core Graphics).
    unsigned long byteIndex = (self.bytesPerRow * ((self.height - 1) - yp)) + xp * bytesPerPixel;
    
    Vector3D *texel = [Vector3D new];
    texel.x = _rawData[byteIndex];
    texel.y = _rawData[byteIndex + 1];
    texel.z = _rawData[byteIndex + 2];

    return texel;
}

- (Vector3D *)readTexture:(TextureCoordinate)textureCoordinate {
    
    //Ray tracing from the ground up pag. 650.
    int x = (self.width - 1) * textureCoordinate.u;
    int y = (self.height - 1) * textureCoordinate.v;
    
    Vector3D *color = [self getTexelFromImageAtx:x atY:y];
        
    return color;
}

- (void)dealloc {
    
    free(_rawData);
}

@end