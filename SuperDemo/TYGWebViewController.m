//
//  TYGWebViewController.m
//  SuperDemo
//
//  Created by tanyugang on 15/6/10.
//  Copyright (c) 2015年 TYG. All rights reserved.
//

#import "TYGWebViewController.h"
#import "TYG_allHeadFiles.h"

@interface TYGWebViewController ()<UIWebViewDelegate>{
    UIActivityIndicatorView *loadingView;
}

@end

@implementation TYGWebViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        self.webShowStatus = showTSMessage;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    if (self.url && ![[NSNull null] isEqual:self.url]) {
        NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
        [self.mainWebView loadRequest:request];
    }
    else{
        [self.mainWebView loadHTMLString:self.htmlString baseURL:nil];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark- UIWebViewDelegate 方法
// 开始请求前，执行该方法。
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    //    NSLog(@"请求前的检查，返回YES，将请求；返回NO：将不在请求。");
    return YES;
    
}

// 当网页视图开始加载内容时将调用这个方法
- (void)webViewDidStartLoad:(UIWebView *)webView{
    // 显示加载状态
    switch (self.webShowStatus) {
        case showTSMessage: {
            [SVProgressHUD showWithStatus:@"数据加载中…" maskType:SVProgressHUDMaskTypeBlack];
            break;
        }
        case showActivityIndicatorView: {
            if (nil == loadingView) {
                loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                loadingView.center=CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
                [self.view addSubview:loadingView];
            }
            
            [loadingView startAnimating];
            break;
        }
        case showNetworkActivityIndicatorVisible: {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            break;
        }
        default: {
            break;
        }
    }
    
}

// 当网页视图完成加载时将调用这个方法
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    // 隐藏加载状态
    switch (self.webShowStatus) {
        case showTSMessage: {
            [SVProgressHUD dismiss];
            break;
        }
        case showActivityIndicatorView: {
            [loadingView stopAnimating];
            break;
        }
        case showNetworkActivityIndicatorVisible: {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            break;
        }
        default: {
            break;
        }
    }
    
    //字体大小
    //    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '330%'"];
}

// 当因加载出错(例如:因网络问题而断开可连接)而导致停止加载时将调用这方法
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    [TSMessage showNotificationWithTitle:@"页面加载失败！" type:TSMessageNotificationTypeError];
    
    switch (self.webShowStatus) {
        case showTSMessage: {
            [SVProgressHUD dismiss];
            break;
        }
        case showActivityIndicatorView: {
            [loadingView stopAnimating];
            break;
        }
        case showNetworkActivityIndicatorVisible: {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            break;
        }
        default: {
            break;
        }
    }
}


@end
