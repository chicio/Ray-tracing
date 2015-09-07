//
//  ScreenViewController.m
//  Ray tracing
//
//  Created by Fabrizio Duroni on 04/07/15.
//  Copyright (c) 2015 Fabrizio Duroni. All rights reserved.
//

#import "Scene.h"
#import "ViewPlane.h"
#import "RayTracer.h"
#import "Rasterizer.h"
#import "ScreenViewController.h"

@interface ScreenViewController ()

/// View used to raster the image obtained.
@property (weak, nonatomic) IBOutlet UIImageView *screenView;
/// Rasterizer reference.
@property (strong, nonatomic) Rasterizer *raster;
/// UISwitch used to manage antialiasing option.
@property (weak, nonatomic) IBOutlet UISwitch *isAntialiasingActiveSwitch;
/// UISwitch used to manage soft shaodw option.
@property (weak, nonatomic) IBOutlet UISwitch *isSoftShadowActiveSwitch;
/// Label used to show the percentage completed.
@property (weak, nonatomic) IBOutlet UILabel *percentageLabel;
/// Segment control used to selecte the scene.
@property (weak, nonatomic) IBOutlet UISegmentedControl *sceneSegmentControl;
/// Segment control used to choose the camera.
@property (weak, nonatomic) IBOutlet UISegmentedControl *cameraSegmentControl;
/// Segment control used to choose the light model.
@property (weak, nonatomic) IBOutlet UISegmentedControl *lightModelSegmentControl;
/// A reference to the ray tracer.
@property (strong, nonatomic) RayTracer *rayTracer;

@end

@implementation ScreenViewController 

- (void)viewDidLoad {
    
    //Init the raster.
    self.raster = [[Rasterizer alloc] init];
}

- (IBAction)startRayTracingAction:(UIButton *)sender {
    
    //Reset UIImage and label.
    self.screenView.image = nil;
    self.percentageLabel.text = [NSString stringWithFormat:@"0%%"];
    
    //Init view plane.
    //ViewPlane *vplane = [[ViewPlane alloc] initWithWidth:400 andHeigth:400];
    ViewPlane *vplane = [[ViewPlane alloc] initWithWidth:550 andHeigth:550];
    
    //Init ray tracer.
    self.rayTracer = [[RayTracer alloc]
                            initWithViewPlane:vplane
                            andScene:self.sceneSegmentControl.selectedSegmentIndex
                            andLighting:self.lightModelSegmentControl.selectedSegmentIndex
                            andCameraPosition:self.cameraSegmentControl.selectedSegmentIndex
                            andAntialiasingActive:self.isAntialiasingActiveSwitch.on
                            andSoftShadowActive:self.isSoftShadowActiveSwitch.on];
        
    //Run ray tracer.
    [self.rayTracer runRayTracer:^(NSMutableArray *pixels, float height, float width) {

        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIImage *screenImage = [self.raster rasterize:pixels andHeight:height andWidth:width];
            
            //Show screen image.
            if (screenImage != nil) {
                
                self.screenView.image = screenImage;
            }
            
            //Show percentage completed.
            self.percentageLabel.text = [NSString stringWithFormat:@"%d%%", ((int)height * 100) / (int)vplane.height];
        });
    }];
}

@end