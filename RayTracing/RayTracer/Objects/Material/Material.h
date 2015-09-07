//
//  Material.h
//  Ray tracing
//
//  Created by Fabrizio Duroni on 05/07/15.
//  Copyright (c) 2015 Fabrizio Duroni. All rights reserved.
//

@import Foundation;

@class PerlinTexture;
@class BumpMap;
@class Vector3D;

/*!
 Material class.
 All material data taken from the link below.
 
 @see http://globe3d.sourceforge.net/g3d_html/gl-materials__ads.htm
 */
@interface Material : NSObject

/// Emissive component.
@property (nonatomic, strong) Vector3D *ke;
/// Ambient component.
@property (nonatomic, strong) Vector3D *ka;
/// Diffusive component.
@property (nonatomic, strong) Vector3D *kd;
/// Specular component.
@property (nonatomic, strong) Vector3D *ks;
/// Shiness property.
@property (nonatomic, assign) float sh;
/// Flag used to check if material is refractive.
@property (nonatomic, assign) BOOL isReflective;
/// Flag used to check if material is transmissive.
@property (nonatomic, assign) BOOL isTransmissive;
/// Refractive index.
@property (nonatomic, assign) float refractiveIndex;
/// Perlin texture associated with the material (Marble, turbulence...), if there's one.
@property (nonatomic, strong) PerlinTexture *perlinTexture;
/// Set a bump mapping texture, if there's one.
@property (nonatomic, strong) BumpMap *bumpMap;

/*!
 Convenience initializer: Jade.
 */
+ (Material *)jade;

/*!
 Convenience initializer: Bronze.
 */
+ (Material *)bronze;

/*!
 Convenience initializer: Generic violet.
 */
+ (Material *)violet;

/*!
 Convenience initializer: Generic orange.
 */
+ (Material *)orange;

/*!
 Generic diffuse material
 */
+ (Material *)matte;

/*!
 Convenience initializer: Chrome.
 */
+ (Material *)chrome;

/*!
 Convenience initializer: Silver.
 */
+ (Material *)silver;

/******* TRANSMISSIVE MATERIALS *******/

/*!
 Convenience initializer: Glass.
 */
+ (Material *)glass;

/*!
 Convenience initializer: Glass.
 */
+ (Material *)glasswater;

/******* MATERIALS WITH PROCEDURAL TEXTURE / BUMP MAP *******/

/*!
 Convenience initializer: Ruby with surface bump mapper.
 
 @param scale of the bump map.
 */
+ (Material *)rubyBumpMapped:(float)scale;

/*!
 Convenience initializer: Marble with color of flames.
 */
+ (Material *)flameMarble;

/*!
 Convenience initializer: Blue turbulence.
 */
+ (Material *)blueTurbulence;

@end