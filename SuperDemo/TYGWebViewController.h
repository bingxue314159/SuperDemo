//
//  TYGWebViewController.h
//  SuperDemo
//
//  Created by tanyugang on 15/6/10.
//  Copyright (c) 2015年 TYG. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WebShowStatusEnum) {
    showTSMessage = 0,//TSMessage显示进度
    showActivityIndicatorView,//系统自带菊花显示
    showNetworkActivityIndicatorVisible,//状态栏显示网络状态
};

@interface TYGWebViewController : UIViewController

@property (nonatomic,strong) NSURL *url;
@property (weak, nonatomic) IBOutlet UIWebView *mainWebView;
@property (nonatomic,strong) NSString *htmlString;//如果url==nil，加载htmlString
@property (nonatomic,assign) WebShowStatusEnum webShowStatus;

@end
