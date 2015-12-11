//
//  PopBasicViewController.m
//  SuperDemo
//
//  Created by tanyugang on 15/5/19.
//  Copyright (c) 2015年 TYG. All rights reserved.
//

#import "PopBasicViewController.h"
#import <pop/POP.h>
#import "TYG_allHeadFiles.h"

@interface PopBasicViewController (){
    BOOL isAnimation;
}

@end

@implementation PopBasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  基本动画
 */
- (void)basicViewAnimationIndex:(NSInteger)index{
    
    switch (index) {
        case 0:{
            NSInteger height = CGRectGetHeight(self.view.bounds);
            NSInteger width = CGRectGetWidth(self.view.bounds);
            
            CGFloat centerX = arc4random() % width;
            CGFloat centerY = arc4random() % height;
            
            POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
            anim.toValue = [NSValue valueWithCGPoint:CGPointMake(centerX, centerY)];
            anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            anim.duration = 0.4;
            [self.basicView pop_addAnimation:anim forKey:@"basicViewAnimation"];
            break;
        }
        case 1:{

            POPBasicAnimation *anim = [POPBasicAnimation animation];
            anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            anim.duration = 10;//动画持续时间
            
            POPAnimatableProperty * prop = [POPAnimatableProperty propertyWithName:@"count" initializer:^(POPMutableAnimatableProperty *prop) {
                prop.readBlock = ^(id obj, CGFloat values[]) {
                    values[0] = [[obj description] floatValue];};
                    prop.writeBlock = ^(id obj, const CGFloat values[]) {
                        [obj setText:[NSString stringWithFormat:@"%.2f",values[0]]];
                    };
                    prop.threshold = 0.01;//动画的变化阀值
                }];
            
            anim.property = prop;
            anim.fromValue = @(0.0);
            anim.toValue = @(100.0);
            
            [self.basicLabel pop_addAnimation:anim forKey:@"basicLabelAnimation11"];
            break;
        }
        default:
            break;
    }
    

}

/**
 *  弹簧动画
 */
- (void)springAnimationIndex:(NSInteger)index{
    /*
     1.springBounciness 弹簧弹力 取值范围为[0, 20]，默认值为4
     2.springSpeed 弹簧速度，速度越快，动画时间越短 [0, 20]，默认为12，和springBounciness一起决定着弹簧动画的效果
     3.dynamicsTension 弹簧的张力,影响回弹力度以及速度
     4.dynamicsFriction 弹簧摩擦,如果开启，动画会不断重复，幅度逐渐削弱，直到停止。
     5.dynamicsMass 质量,细微的影响动画的回弹力度以及速度 。
     张力，摩擦，质量这三者可以从更细的粒度上替代springBounciness和springSpeed控制弹簧动画的效果
     */
    
    switch (index) {
        case 0:{
            //
            NSInteger height = CGRectGetHeight(self.view.bounds);
            NSInteger width = CGRectGetWidth(self.view.bounds);
            
            CGFloat centerX = arc4random() % width;
            CGFloat centerY = arc4random() % height;
            
            POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
            anim.toValue = [NSValue valueWithCGPoint:CGPointMake(centerX, centerY)];
            anim.springBounciness = 16;//弹簧弹力 取值范围为[0, 20]，默认值为4
            anim.springSpeed = 6;//弹簧速度，速度越快，动画时间越短 [0, 20]
            [self.basicView pop_addAnimation:anim forKey:@"springAnimation"];

            break;
        }
        case 1:{
            POPSpringAnimation *anim1 = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
            if (isAnimation) {
                anim1.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
            }
            else{
                anim1.toValue = [NSValue valueWithCGPoint:CGPointMake(2.0, 2.0)];
            }
            anim1.springBounciness = 4.0;
            anim1.springSpeed = 12.0;
            anim1.completionBlock = ^(POPAnimation *animition, BOOL finished){
                if (finished) {
                    isAnimation = !isAnimation;
                    [self springAnimationIndex:1];
                }
            };
            
            [self.basicView pop_addAnimation:anim1 forKey:@"springAnimation1"];
            break;
        }
        case 2:{
            //移动中间

            POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
            anim.toValue = [NSValue valueWithCGRect:CGRectMake(8, 200, SCREEN_WIDTH - 8*2, 25)];
            anim.springBounciness = 16;//弹簧弹力 取值范围为[0, 20]，默认值为4
            anim.springSpeed = 6;//弹簧速度，速度越快，动画时间越短 [0, 20]
            [self.basicView pop_addAnimation:anim forKey:@"springAnimation220"];
            
            //绘制路径
            CAShapeLayer *progressLayer = [CAShapeLayer layer];
//            progressLayer.strokeColor = [UIColor colorWithWhite:1.0 alpha:0.98].CGColor;
            progressLayer.strokeColor = [UIColor redColor].CGColor;
            progressLayer.lineWidth = 26.0;
            
            UIBezierPath *progressline = [UIBezierPath bezierPath];
            [progressline moveToPoint:CGPointMake(25.0, 25.0)];
            [progressline addLineToPoint:CGPointMake(700.0, 25.0)];
            progressLayer.path = progressline.CGPath;
            
            //缩小
            POPSpringAnimation *scaleAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
            scaleAnim.toValue = [NSValue valueWithCGPoint:CGPointMake(0.5, 0.5)];
            
            //更改
            POPSpringAnimation *boundsAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
            boundsAnim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 800, 50)];
            boundsAnim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
                if (finished) {
                    CGSize viewSize = self.basicView.frame.size;
                    UIGraphicsBeginImageContextWithOptions(viewSize, NO, 0.0);
                    POPBasicAnimation *progressBoundsAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPShapeLayerStrokeEnd];
                    progressBoundsAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                    progressBoundsAnim.toValue = @1.0;
                    progressBoundsAnim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
                        if (finished) {
                            UIGraphicsEndImageContext();
                        }
                    };
                    [progressLayer pop_addAnimation:progressBoundsAnim forKey:@"AnimateBounds"]; 
                }
            };
            
            
            [self.basicView.layer pop_addAnimation:scaleAnim forKey:@"springAnimation221"];
            [self.basicView.layer pop_addAnimation:boundsAnim forKey:@"springAnimation222"];
 
            break;
        }
        default:
            break;
    }
    
    
}


/**
 *  衰减动画
 */
- (void)decayAnimationIndex:(NSInteger)index{
    switch (index) {
        case 0:{
            CAShapeLayer *progressLayer = [CAShapeLayer layer];
            progressLayer.strokeColor = [UIColor redColor].CGColor;
            progressLayer.lineWidth = 26.0;
            
            UIBezierPath *progressline = [UIBezierPath bezierPath];
            [progressline moveToPoint:CGPointMake(25.0, 25.0)];
            [progressline addLineToPoint:CGPointMake(700.0, 25.0)];
            progressLayer.path = progressline.CGPath;
            
            
            POPSpringAnimation *scaleAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
            scaleAnim.toValue = [NSValue valueWithCGPoint:CGPointMake(0.3, 0.3)];
            
            POPSpringAnimation *boundsAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
            boundsAnim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 800, 50)];
            boundsAnim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
                if (finished) {
                    UIGraphicsBeginImageContextWithOptions(self.basicView.frame.size, NO, 0.0);
                    POPBasicAnimation *progressBoundsAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPShapeLayerStrokeEnd];
                    progressBoundsAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                    progressBoundsAnim.toValue = @1.0;
                    progressBoundsAnim.completionBlock = ^(POPAnimation *anim, BOOL finished) {if (finished) {UIGraphicsEndImageContext();}};   
                    [progressLayer pop_addAnimation:progressBoundsAnim forKey:@"AnimateBounds"]; 
                } 
            };
            break;
        }
        case 1:{
            
            break;
        }
        case 2:{
            
            break;
        }
        default:
            break;
    }
}

/**
 *  自定义动画
 */
- (void)customAnimation{

}

- (IBAction)buttonClick:(UIButton *)button{
    
    [self.basicView pop_removeAllAnimations];
    [self.basicView.layer pop_removeAllAnimations];
    
    [self.basicLabel pop_removeAllAnimations];
    
    switch (button.tag) {
        case 10:{
            [self basicViewAnimationIndex:0];
            break;
        }
        case 11:{
            [self basicViewAnimationIndex:1];
            break;
        }
        case 20:{
            [self springAnimationIndex:0];
            break;
        }
        case 21:{
            [self springAnimationIndex:1];
            break;
        }
        case 22:{
            [self springAnimationIndex:2];
            break;
        }
        case 30:{
            [self decayAnimationIndex:0];
            break;
        }
        case 31:{
            [self decayAnimationIndex:1];
            break;
        }
        case 32:{
            [self decayAnimationIndex:2];
            break;
        }
        default:
            break;
    }
}

@end
