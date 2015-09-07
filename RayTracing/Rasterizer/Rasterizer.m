//
//  Rasterizer.m
//  Ray tracing
//
//  Created by Fabrizio Duroni on 05/07/15.
//  Copyright (c) 2015 Fabrizio Duroni. All rights reserved.
//

#import "Constants.h"
#import "Vector3D.h"
#import "Rasterizer.h"

@interface Rasterizer() {

    /// Device dependent colorspace.
    CGColorSpaceRef _colorSpace;
}

@end

@implementation Rasterizer

#pragma mark Init

- (instancetype)init
{
    self = [super init];

    if (self) {
        
        _colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    return self;
}

#pragma mark Rasterization

- (UIImage *)rasterize:(NSMutableArray *)pixelsColorData andHeight:(float)height andWidth:(float)width {
    
    int area = height * width;
    
    unsigned char *pixelData =  (unsigned char *) calloc(height * width * 4, sizeof(unsigned char));;
        
    //Fill the pixels.
    for (size_t i = 0; i < area; ++i) {
        
        const size_t offset = i * bytesPerPixel;
        
        Vector3D *colorPerPixel = pixelsColorData[i];
        
        pixelData[offset] = colorPerPixel.x; //red
        pixelData[offset+1] = colorPerPixel.y; //green
        pixelData[offset+2] =  colorPerPixel.z; //blue
        pixelData[offset+3] = 255; // alpha not considered.
    }
    
    //Create bitmap context.
    const size_t BytesPerRow = ((bitsPerComponent * width) / 8) * bytesPerPixel;
    CGContextRef gtx = CGBitmapContextCreate(pixelData, width, height, bitsPerComponent, BytesPerRow, _colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    //Create UIImage.
    CGImageRef toCGImage = CGBitmapContextCreateImage(gtx);
    UIImage *screenImage = [[UIImage alloc] initWithCGImage:toCGImage];
    
    //Invert y coordinate.
    screenImage = [UIImage imageWithCGImage:screenImage.CGImage scale:screenImage.scale orientation:UIImageOrientationDownMirrored];
    
    CGImageRelease(toCGImage);
    CGContextRelease(gtx);
    free(pixelData);
    
    return screenImage;
}

- (void)dealloc {
    
    CGColorSpaceRelease(_colorSpace);
}

@end