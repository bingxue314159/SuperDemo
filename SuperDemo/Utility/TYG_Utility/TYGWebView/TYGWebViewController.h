//
//  TYGWebViewController.h
//  SuperDemo
//
//  Created by tanyugang on 15/6/10.
//  Copyright (c) 2015年 TYG. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WebShowStatusEnum) {
    WebShowSVProgressHUD = 0,//TSMessage显示进度
    WebShowActivityIndicatorView,//系统自带菊花显示
    WebShowNetworkActivityIndicatorVisible,//状态栏显示网络状态
};

@interface TYGWebViewController : UIViewController

@property (nonatomic,strong) NSURL *url;
@property (nonatomic,strong) NSString *htmlString;//如果url==nil，加载htmlString
@property (nonatomic,assign) WebShowStatusEnum webShowStatus;
@property (nonatomic,readonly) id mainWebView;

@end
