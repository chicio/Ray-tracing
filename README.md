# Ray-tracing
Ray tracer for iPad developed as final project for my <a href="https://www.disco.unimib.it/upload/pag/1667904909074911183/f1/f1801q120informaticagrafica20132014engv2.pdf">computer graphics course at University Milano-Bicocca.</a>

***

###Main features
- Support sphere and convex polygon
- Phong and Blinn-Phong lighting model 
    * light attenuation factor
- Reflection and Refraction
    * Reflective objects
    * Transparent objects
    * <a href="http://www.cs.cornell.edu/courses/cs465/2004fa/lectures/22advray/22advray.pdf">Realistic transparency for dieletrics</a> using:
         * <a href="https://en.wikipedia.org/wiki/Fresnel_equations">Fresnel equations</a>
         * <a href="https://en.wikipedia.org/wiki/Schlick%27s_approximation">Schlick's approximation</a>
    * Multiple reflective objects in the same scene.
- Camera
- <a href="https://en.wikipedia.org/wiki/Umbra,_penumbra_and_antumbra">Soft shadow</a>
- Antialiasing (Supersampling)
- <a href="https://en.wikipedia.org/wiki/Cube_mapping#Skyboxes">Cube mapping (used for skybox at infinite distance)</a>
- Procedural texture with <a href="https://en.wikipedia.org/wiki/Perlin_noise">Perlin Noise</a>
    * Marble
    * Turbulence
- <a href="https://en.wikipedia.org/wiki/Bump_mapping">Bump mapping</a>

***

###Screenshot

These are some images rendered using the ray tracer. For each one there's a complete list of the setup used during rendering.

**Scene 1**: Antialisasing, soft shadow (128 shadow feeler ray), Phong lighting, cube mapping infinite skybox, bump mapping, transparent sphere (glass refractive index)

![Scena 1 Antialisasing soft shadow (128 shadow feeler ray) Phong lighting](https://raw.githubusercontent.com/chicio/Ray-tracing/master/Screenshots/scene1_antialiasing_softshadow128_phong.png)

**Scene 1**: Antialisasing, soft shadow (64 shadow feeler ray), Blinn-Phong lighting, cube mapping infinite skybox, bump mapping, transparent sphere (glass refractive index)

![Scena 1 Antialisasing soft shadow (64 shadow feeler ray) Blinn phong lighting, cube mapping infinite skybox, bump mapping](https://raw.githubusercontent.com/chicio/Ray-tracing/master/Screenshots/scene1_antialiasing_softshadow64_blinnphong.png)

**Scene 1**: Antialisasing, soft shadow (32 shadow feeler ray), Phong lighting, cube mapping infinite skybox, bump mapping, ***sphere dielectric (glass refractive index) using Fresnel equation***

![Scena 1 Antialisasing soft shadow (32 shadow feeler ray) Phong lighting, cube mapping infinite skybox, bump mapping, glass dielectric using Fresnel equation](https://raw.githubusercontent.com/chicio/Ray-tracing/master/Screenshots/scene1_antialiasing_softshadow32_phong_dieletricfresnel.png)

**Scene 2a**: Antialisasing, soft shadow (16 shadow feeler ray), Phong lighting, polygon skybox, bump mapping, procedural texture with perlin noise

![Scena 2a Antialisasing soft shadow (16 shadow feeler ray) Phong lighting](https://raw.githubusercontent.com/chicio/Ray-tracing/master/Screenshots/scene2a_antialiasing_softshadow16_phong.png)

**Scene 2a**:  Antialisasing, soft shadow (16 shadow feeler ray), Phong lighting, polygon skybox, bump mapping, procedural texture with perlin noise, quadratic light attenuation

![Scena 2a Antialisasing soft shadow (16 shadow feeler ray) Phong lighting Quadratic attenuation](https://raw.githubusercontent.com/chicio/Ray-tracing/master/Screenshots/scene2a_antialiasing_softshadow16_phong_quadratic.png)

**Scene 2b**: Antialisasing, Blinn-Phong lighting, polygon skybox, camera on left side, procedural texture with perlin noise, transparent sphere (ice refractive index)

![Scena 2b Antialisasing Blinn-Phong lighting](https://github.com/chicio/Ray-tracing/raw/master/Screenshots/scene2b_antialiasing_blinnphong.png)

**Scene 2b**: Antialisasing, soft shadow (16 shadow feeler ray), Phong lighting lighting, procedural texture with perlin noise, camera on left side, ***sphere dielectric (ice refractive index) using Schlick's approximation***

![Scena 2b Antialisasing, soft shadow (16 shadow feeler ray), Phong lighting lighting, procedural texture with perlin noise, camera on left side, glass dielectric using Schlick's approximation](https://raw.githubusercontent.com/chicio/Ray-tracing/master/Screenshots/scene2b_antialiasing_softshadow16_phong_dieletricschrick.png)

***

###Description

The ray tracer is developed entirely in Objective-C as an iPad app.
The interface let the user manage some of the options available:
- change of scene to be rendered
- turn on/off antialiasing
- turn on/off softshadow
- choose the camera position between 6 predefined option
- Phong/Blinn-Phong lighting model

There are other option defined as constant in the file Constants.h that affected the behaviour of the ray tracer. In particular it is possible to set/change:
- the max number ray bounce (default 3 bounce)
- the number of shadow feeler ray (default 16)
- the light attenuation factors
- dieletric simulation (default off/false) 
   * the equation used for fresnel factor (used only if dieletric simulation is on - default Fresnel equation).

This is a screenshot of the application interface.

![Application interface](https://raw.githubusercontent.com/chicio/Ray-tracing/master/Screenshots/application_interface_with_ipad.png)

The part of the image already calculated is shown to the user, so that it could have a feedback during rendering operation.
This is done using an asynchronous block submitted to a <a href="https://developer.apple.com/library/prerelease/ios/documentation/Performance/Conceptual/EnergyGuide-iOS/PrioritizeWorkWithQoS.html">new quality of service class</a> available in iOS 8 and above.

To speed up the entire process of ray tracing some part of the ray tracer are splitted across multiple threads. 
Usually the tecnique used is to divide in n pieces the image to be rendered, one for every core of the cpu on which you will execute the ray tracing operation in a thread and then sum up the the various result. In this case I used a different approch: the heavy part of the computation is releated to the soft shadows calculation, so I use <a href="https://developer.apple.com/library/ios/documentation/Performance/Reference/GCD_libdispatch_Ref/">Grand Central Dispatch</a> to execute each shadow feeler ray calculation in a dedicated asynchronous block. In this way I can output the image rows already calculated using the technique describe above (my rasterizer need continuos block of image data to generate the piece of the image).

Finally, most of the core implementation of the ray tracer are inspired by the course material and by studying/reading the book "Ray tracing from the ground up", Kevin Suffern 2007, used as main additional material to the course slides. See the list below for a complete reference to the main study documents.

***

###Documentation

All classes, methods and variables are documented with comments using sourcekit tags. Using XCode it is possible to access the documentation while reading the code using Alt + left mouse click.

![Documentation](https://raw.githubusercontent.com/chicio/Ray-tracing/master/Screenshots/documentation.png)

***

###References

Main references:
* Course slides
* ["Ray tracing from the ground up", Kevin Suffern 2007](http://www.raytracegroundup.com)
* [Ray tracing Tutorial by Codermind team](http://www.ics.uci.edu/~gopi/CS211B/RayTracing%20tutorial.pdf)
* [Ray Tracing: Graphics for the Masses](https://www.cs.unc.edu/~rademach/xroads-RT/RTarticle.html)

Other link to the documentation and code examples used during development are referenced inside every method comment using sourcekit tag @see (see "Documentation" section).
