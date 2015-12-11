//
//  POPDecayAnimationViewController.m
//  SuperDemo
//
//  Created by tanyugang on 15/7/30.
//  Copyright (c) 2015年 TYG. All rights reserved.
//

#import "POPDecayAnimationViewController.h"
#import "TYGPopAnimationManager.h"
#import <pop/POP.h>
#import "TYG_allHeadFiles.h"
#import "IQActionSheetPickerView.h"

@interface POPDecayAnimationViewController ()<IQActionSheetPickerViewDelegate>{
    NSArray *layerAnimationTypes;
    NSArray *viewAnimationTypes;
    
    NSString *layerAnimationType;
    NSString *viewAnimationType;
    
    BOOL isAnimation;
    CALayer *layer;
}

@end

@implementation POPDecayAnimationViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self drawNav];
    
    layerAnimationTypes = @[kPOPLayerBackgroundColor,kPOPLayerBounds,kPOPLayerOpacity,kPOPLayerPosition,kPOPLayerRotation,
                            kPOPLayerScaleXY,kPOPLayerSize,kPOPLayerTranslationXY,kPOPLayerRotationX, kPOPLayerRotationY];
    viewAnimationTypes = @[kPOPViewAlpha,kPOPViewBackgroundColor,kPOPViewBounds,kPOPViewCenter,kPOPViewFrame,kPOPViewScaleX,kPOPViewScaleXY,kPOPViewScaleY,kPOPViewSize,kPOPViewTintColor];
    
    viewAnimationType = kPOPViewScaleXY;
    layerAnimationType = kPOPLayerPositionX;
    
    [self resetLayer];
    [self performAnimation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawNav{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Effects" style:UIBarButtonItemStylePlain target:self action:@selector(changeEffects:)];
}

//设置动效
-(void)setAnimation{
    
    /*
     1.velocity 速率
     2.deceleration 负加速度,默认是就是我们地球的 0.998
     */
    
    [self.popCircle.layer pop_removeAllAnimations];
    
    POPDecayAnimation *anim = [POPDecayAnimation animationWithPropertyNamed:layerAnimationType];
    
    [TYGPopAnimationManager decayObject:self.popCircle.layer configAnimation:anim WithType:layerAnimationType andAnimated:isAnimation andVelocitySlider:self.velocitySlider];
    
    anim.deceleration = self.decelerationSlider.value;
    isAnimation = !isAnimation;
    
    anim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            
            [self performAnimation];
        }
    };
    
    
    [self.popCircle.layer pop_addAnimation:anim forKey:@"Animation"];
    
}

-(void)performAnimation{
    [self setAnimation];
}

- (IBAction)sliderValueChange:(id)sender {
    [self resetLayer];
    [self performAnimation];
}

//修改动效
- (void)changeEffects:(id)sender {
    
    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"Effects" delegate:self];
    
    [picker setTag:1];
    [picker setTitlesForComponenets:[NSArray arrayWithObjects:
                                     layerAnimationTypes,
                                     nil]];
    picker.selectedTitles = @[layerAnimationType];
    
    [picker show];
}


#pragma mark - layer
- (void)resetLayer{
    [self.popCircle.layer pop_removeAllAnimations];
    self.popCircle.layer.opacity = 1.0;
    self.popCircle.layer.transform = CATransform3DIdentity;
    [self.popCircle.layer setMasksToBounds:YES];
    [self.popCircle.layer setBackgroundColor:[UIColor colorWithRed:0.16 green:0.72 blue:1.0 alpha:1.0].CGColor];
    [self.popCircle.layer setCornerRadius:25.0f];
    [self.popCircle setBounds:CGRectMake(0.0f, 0.0f, 50.0f, 50.0f)];
    self.popCircle.layer.position = CGPointMake(self.view.center.x, 180.0);
    isAnimation = NO;
}

#pragma mark - IQActionSheetPickerViewDelegate
-(void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didSelectTitles:(NSArray *)titles{
    
    NSString *title = [titles firstObject];
    
    switch (pickerView.tag){
        case 0:{
            viewAnimationType = title;
            break;
        }
        case 1:{
            layerAnimationType = title;
            break;
        }
        default:
            break;
    }
    
    [self resetLayer];
    [self performAnimation];
}




@end
