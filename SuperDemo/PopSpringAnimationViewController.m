//
//  PopSpringAnimationViewController.m
//  SuperDemo
//
//  Created by tanyugang on 15/7/30.
//  Copyright (c) 2015年 TYG. All rights reserved.
//

#import "PopSpringAnimationViewController.h"
#import "TYGPopAnimationManager.h"
#import <pop/POP.h>
#import "TYG_allHeadFiles.h"
#import "IQActionSheetPickerView.h"

@interface PopSpringAnimationViewController ()<IQActionSheetPickerViewDelegate>{
    NSArray *layerAnimationTypes;
    NSArray *viewAnimationTypes;
    
    NSString *layerAnimationType;
    NSString *viewAnimationType;
    
    BOOL isAnimation;
    CALayer *layer;
}

@end

@implementation PopSpringAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self drawNav];
    
    layerAnimationTypes = @[kPOPLayerBackgroundColor,kPOPLayerBounds,kPOPLayerOpacity,kPOPLayerPosition,kPOPLayerRotation,
                            kPOPLayerScaleXY,kPOPLayerSize,kPOPLayerTranslationXY,kPOPLayerRotationX, kPOPLayerRotationY];
    viewAnimationTypes = @[kPOPViewAlpha,kPOPViewBackgroundColor,kPOPViewBounds,kPOPViewCenter,kPOPViewFrame,kPOPViewScaleX,kPOPViewScaleXY,kPOPViewScaleY,kPOPViewSize,kPOPViewTintColor];
    
    viewAnimationType = kPOPViewScaleXY;
    layerAnimationType = kPOPLayerScaleXY;
    
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
     1.springBounciness 弹簧弹力 取值范围为[0, 20]，默认值为4
     2.springSpeed 弹簧速度，速度越快，动画时间越短 [0, 20]，默认为12，和springBounciness一起决定着弹簧动画的效果
     3.dynamicsTension 弹簧的张力,影响回弹力度以及速度
     4.dynamicsFriction 弹簧摩擦,如果开启，动画会不断重复，幅度逐渐削弱，直到停止。
     5.dynamicsMass 质量,细微的影响动画的回弹力度以及速度 。
     张力，摩擦，质量这三者可以从更细的粒度上替代springBounciness和springSpeed控制弹簧动画的效果
     */
    
    switch (self.seg.selectedSegmentIndex) {
        case 0:{
            //view
            [self.animationView pop_removeAllAnimations];

            POPSpringAnimation *spring = [POPSpringAnimation animationWithPropertyNamed:viewAnimationType];
            [TYGPopAnimationManager springPopViewConfigAnimation:spring WithType:viewAnimationType andAnimated:isAnimation];
            
            isAnimation = !isAnimation;
            
            spring.springBounciness = self.bouncinessSlider.value;
            spring.springSpeed = self.speedSlide.value;
            
            if (self.tensionSwitch.isOn) {
                spring.dynamicsTension = self.tensionSlide.value;
            }
            
            if (self.frictionSwitch.isOn) {
                spring.dynamicsFriction = self.frictionSlide.value;
            }
            
            if (self.massSwitch.isOn) {
                spring.dynamicsMass = self.massSlide.value;
            }
            
            spring.completionBlock = ^(POPAnimation *anim, BOOL finished) {
                if (finished) {
                    [self performAnimation];
                }
            };
            
            [self.animationView pop_addAnimation:spring forKey:@"springAnimation"];
            break;
        }
        case 1:{
            //layer
            [layer pop_removeAllAnimations];
            POPSpringAnimation *spring = [POPSpringAnimation animationWithPropertyNamed:layerAnimationType];
            [TYGPopAnimationManager springObject:layer configAnimation:spring WithType:layerAnimationType andAnimated:isAnimation];
            
            isAnimation = !isAnimation;
            
            spring.springBounciness = self.bouncinessSlider.value;
            spring.springSpeed = self.speedSlide.value;
            
            if (self.tensionSwitch.isOn) {
                spring.dynamicsTension = self.tensionSlide.value;
            }
            
            if (self.frictionSwitch.isOn) {
                spring.dynamicsFriction = self.frictionSlide.value;
            }
            
            if (self.massSwitch.isOn) {
                spring.dynamicsMass = self.massSlide.value;
            }
            
            spring.completionBlock = ^(POPAnimation *anim, BOOL finished) {
                if (finished) {
                    [self performAnimation];
                }
            };
            
            [layer pop_addAnimation:spring forKey:@"springAnimation"];
            break;
        }
        default:
            break;
    }

}

-(void)performAnimation{
    [self setAnimation];
}

- (IBAction)slideValueChange:(id)sender {
    [self resetLayer];
    [self performAnimation];
    
}
- (IBAction)switchValueChange:(id)sender {
    [self resetLayer];
    [self performAnimation];
}

//修改动效
- (void)changeEffects:(id)sender {
    
    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"Effects" delegate:self];
    
    switch (self.seg.selectedSegmentIndex) {
        case 0:{
            //view
            [picker setTag:0];
            [picker setTitlesForComponenets:[NSArray arrayWithObjects:
                                             viewAnimationTypes,
                                             nil]];
            picker.selectedTitles = @[viewAnimationType];
            break;
        }
        case 1:{
            //layer
            [picker setTag:1];
            [picker setTitlesForComponenets:[NSArray arrayWithObjects:
                                             layerAnimationTypes,
                                             nil]];
            picker.selectedTitles = @[layerAnimationType];
            break;
        }
        default:
            break;
    }
    
    [picker show];
}

//切换动效模式
- (IBAction)segValueChange:(id)sender {
    
    switch (self.seg.selectedSegmentIndex) {
        case 0:{
            //view
            [layer pop_removeAllAnimations];
            [layer removeFromSuperlayer];
            layer = nil;
            
            self.animationView.hidden = NO;
            
            [self performAnimation];
            break;
        }
        case 1:{
            //layer
            [self.animationView pop_removeAllAnimations];
            self.animationView.hidden = YES;
            
            layer = [CALayer layer];
            [self resetLayer];
            [self.subView.layer addSublayer:layer];
            
            [self performAnimation];
            break;
        }
        default:
            break;
    }
    
}

#pragma mark - layer
- (void)resetLayer{
    switch (self.seg.selectedSegmentIndex) {
        case 0:{
            //view

            break;
        }
        case 1:{
            //layer
            [layer pop_removeAllAnimations];
            layer.opacity = 1.0;
            layer.transform = CATransform3DIdentity;
            [layer setMasksToBounds:YES];
            [layer setBackgroundColor:[UIColor colorWithRed:0.16 green:0.72 blue:1 alpha:1].CGColor];
            [layer setCornerRadius:25.0f];
            [layer setBounds:CGRectMake(0.0f, 0.0f, 50.0f, 50.0f)];
            layer.position = CGPointMake(SCREEN_WIDTH/2.0, 130);
            break;
        }
        default:
            break;
    }
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
