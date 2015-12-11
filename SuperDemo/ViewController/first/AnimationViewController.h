//
//  AnimationViewController.h
//  StudyiOS
//
//  Created by ZhangYiCheng on 11-9-28.
//  Copyright 2011 ZhangYiCheng. All rights reserved.
//
//  16种视图切换动画

#import <UIKit/UIKit.h>


@interface AnimationViewController : UIViewController {
    UIImageView *blueView;
    UIImageView *greenView;
    
    NSInteger typeID;
}
@property (nonatomic, retain) IBOutlet UIImageView *blueView;
@property (nonatomic, retain) IBOutlet UIImageView *greenView;

@property (nonatomic, assign) NSInteger typeID;

- (IBAction)buttonPressed1:(id)sender;
- (IBAction)buttonPressed2:(id)sender;

@end
