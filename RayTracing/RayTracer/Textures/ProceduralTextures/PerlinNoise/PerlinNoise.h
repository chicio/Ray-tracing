//
//  PerlinNoise.h
//  Ray tracing
//
//  Created by Fabrizio Duroni on 14/08/15.
//  Copyright (c) 2015 Fabrizio Duroni. All rights reserved.
//

@import Foundation;

/*!
 Class used to generate Perlin Noise.
 This is a porting of the improved version created by Kevin
 Perlin and contained in the second link below.
 The noise are used to generate procedural texture.
 Below there are linked also the references I used to get a better
 understand of the details of Perlin Noise.

 @see http://mrl.nyu.edu/~perlin/paper445.pdf (2002 paper of Kevin Perlin that describe improvement to the algorithm)
 @see http://mrl.nyu.edu/~perlin/noise/ (original Kevin Perlin improved version Java)
 @see http://www.ics.uci.edu/~gopi/CS211B/RayTracing%20tutorial.pdf (porting of the code in the previous link in C++)
 @see http://mrl.nyu.edu/~perlin/doc/oscar.html#noise (original first Kevin Perlin implementation)
 @see http://freespace.virgin.net/hugo.elias/models/m_perlin.htm
 @see http://flafla2.github.io/2014/08/09/perlinnoise.html
 */
@interface PerlinNoise : NSObject

/*!
 Access share instance.
 */
+ (id)sharedInstance;

/*!
 Generate noise given coordinate values.
 
 @param x x coordinate
 @param y y coordinate
 @param z z coordinate
 
 @return noise generated with the given parameter.
 */
- (double)noise:(double)x andY:(double)y andZ:(double)z;

@end