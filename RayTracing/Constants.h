//
//  Constants.h
//  Ray tracing
//
//  Created by Fabrizio Duroni on 08/08/15.
//  Copyright © 2015 Fabrizio Duroni. All rights reserved.
//

#import <stddef.h>
#import "FresnelFactorModel.h"

@import Foundation;

#pragma mark Raster configuration

/// Number of bytes used to represent a pixel (RGBA).
static size_t const bytesPerPixel = 4;
/// Bits used for each pixel array element.
static size_t const bitsPerComponent = 8;

#pragma mark Ray configuration

/// Number of shadow ray.
static int const numberOfShadowRay = 16;
/// Constant used to add small quantitiy to origins of rays to avoid self intersection.
static float const epsilon = 0.0001;
/// Max number of bounce done by rays in ray tracer loop.
static int const maxNumberOfBounce = 3;

#pragma mark light attenuation factor

//N.B.: Use the value commented to simulate a quadratic attenuation on the scene 2a).
//@see http://www.ozone3d.net/tutorials/glsl_lighting_phong_p4.php

/// Constant attenuation.
static float const c1 = 1; //0
/// Linear attenuation.
static float const c2 = 0; //0
/// Quadratic attenuation
static float const c3 = 0; //0.000005

#pragma mark Reflection/Refraction

/// Set true to simulate dieletric material (reflection + reflaction flag set true on material components).
static BOOL const dieletric = false;
/// Fresnel factor model used for dieletric (used when previous to true - see FresnelFactorEnum.h)
static FresnelFactorModel const fresnelFactorModel = FresnelEquations;