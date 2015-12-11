//
//  TYGIBView.h
//  testTabBar
//
//  Created by tanyugang on 15/8/12.
//  Copyright (c) 2015年 tanyugang. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface TYGIBView : UIView

@property (nonatomic,assign) IBInspectable CGFloat cornerRadius;
@property (nonatomic,assign) IBInspectable CGFloat borderWidth;
@property (nonatomic,strong) IBInspectable UIColor *borderColor;
@property (nonatomic,assign) IBInspectable BOOL masksToBounds;

@end
