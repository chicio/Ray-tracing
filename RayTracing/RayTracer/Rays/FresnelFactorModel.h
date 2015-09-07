//
//  FresnelFactorEnum.h
//  Ray tracing
//
//  Created by Fabrizio Duroni on 29/08/15.
//  Copyright (c) 2015 Fabrizio Duroni. All rights reserved.
//

/*!
 Enum that identify the method used to simulate 
 realistic dieletric objects during ray tracing.

 @see "Ray tracing from the ground up", page 593 cap. "Realistic transparency".
 @see prof. Ciocca/Bianco slide for Fresnel equation (ray tracing transmitted light).
 @see prof. Ciocca/Bianco slide Cook-Torrance method for a brief introduction to Schlick's approximation.
 @see https://en.wikipedia.org/wiki/Schlick%27s_approximation
 */
typedef enum FresnelFactorModel {
    FresnelEquations,
    SchlickApproximation
} FresnelFactorModel;