//
//  TYGWebViewController.m
//  SuperDemo
//
//  Created by tanyugang on 15/6/10.
//  Copyright (c) 2015年 TYG. All rights reserved.
//

#import "TYGWebViewController.h"
#import "TYG_allHeadFiles.h"
#import <BlocksKit+UIKit.h>
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
#import <WebKit/WebKit.h>
#endif

@interface TYGWebViewController ()<WKNavigationDelegate,WKUIDelegate,UIWebViewDelegate>

@property (nonatomic,readonly) double estimatedProgress NS_AVAILABLE_IOS(8_0);//加载进度
@property (nonatomic,readonly) BOOL isUsingWKWebView;//是否正在使用 WKWebView

@end


@implementation TYGWebViewController{
    UIActivityIndicatorView *loadingView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        self.webShowStatus = WebShowSVProgressHUD;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    Class wkWebView = NSClassFromString(@"WKWebView");
    if (wkWebView) {
        //iOS SDK >= 8.0
        _isUsingWKWebView = YES;
        
        WKWebView *webView = [[NSClassFromString(@"WKWebView") alloc] initWithFrame:self.view.bounds];
        webView.navigationDelegate = self;
        webView.UIDelegate = self;
        webView.allowsBackForwardNavigationGestures = YES;//打开左划回退功能
        webView.backgroundColor = [UIColor clearColor];
        webView.opaque = NO;
        
        [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        [webView addObserver:self forKeyPath:@"changeTitle" options:NSKeyValueObservingOptionNew context:nil];
        
        [self.view addSubview:webView];
        
        if (self.url && ![[NSNull null] isEqual:self.url]) {
            NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
            [webView loadRequest:request];
        }
        else{
            [webView loadHTMLString:self.htmlString baseURL:nil];
        }
        
        _mainWebView = webView;
    }
    else{
        UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        webView.delegate = self;
        webView.backgroundColor = [UIColor clearColor];
        webView.opaque = NO;
        [self.view addSubview:webView];
        
        if (self.url && ![[NSNull null] isEqual:self.url]) {
            NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
            [webView loadRequest:request];
        }
        else{
            [webView loadHTMLString:self.htmlString baseURL:nil];
        }
        
        _mainWebView = webView;
    }

}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    if (_isUsingWKWebView) {
        WKWebView* webView = _mainWebView;
        webView.navigationDelegate = nil;
        [webView removeObserver:self forKeyPath:@"estimatedProgress"];
        [webView removeObserver:self forKeyPath:@"changeTitle"];
    }
    else{
        UIWebView* webView = _mainWebView;
        webView.delegate = nil;
    }
    
    [_mainWebView scrollView].delegate = nil;
    [_mainWebView stopLoading];
    [(UIWebView*)_mainWebView loadHTMLString:@"" baseURL:nil];
    [_mainWebView stopLoading];
    [_mainWebView removeFromSuperview];
    _mainWebView = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//MVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if([keyPath isEqualToString:@"estimatedProgress"]) {
        
        _estimatedProgress = [change[NSKeyValueChangeNewKey] doubleValue];
        if (self.webShowStatus == WebShowSVProgressHUD) {
            if (_estimatedProgress < 1.0) {
                [SVProgressHUD showProgress:_estimatedProgress];
            }
            else{
                [SVProgressHUD dismiss];
            }
        }
    }
    else if([keyPath isEqualToString:@"changeTitle"]) {
        
        self.title = change[NSKeyValueChangeNewKey];
    }
}

#pragma mark - 工具
//开始HUD
- (void)starStatus{
    switch (self.webShowStatus) {
        case WebShowSVProgressHUD: {
            if (_isUsingWKWebView == NO) {
                [SVProgressHUD showWithStatus:@"数据加载中…" maskType:SVProgressHUDMaskTypeNone];
            }
            break;
        }
        case WebShowActivityIndicatorView: {
            if (nil == loadingView) {
                loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                loadingView.center=CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
                [self.view addSubview:loadingView];
            }
            
            [loadingView startAnimating];
            break;
        }
        case WebShowNetworkActivityIndicatorVisible: {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            break;
        }
        default: {
            break;
        }
    }
}

//结束HUD
- (void)endStatus{
    switch (self.webShowStatus) {
        case WebShowSVProgressHUD: {
            [SVProgressHUD dismiss];
            break;
        }
        case WebShowActivityIndicatorView: {
            [loadingView stopAnimating];
            break;
        }
        case WebShowNetworkActivityIndicatorVisible: {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            break;
        }
        default: {
            break;
        }
    }
}


#pragma mark - UIWebViewDelegate 方法
// 开始请求前，执行该方法。
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    //    NSLog(@"请求前的检查，返回YES，将请求；返回NO：将不在请求。");
    return YES;
    
}

// 当网页视图开始加载内容时将调用这个方法
- (void)webViewDidStartLoad:(UIWebView *)webView{
    // 显示加载状态
    [self starStatus];
    
}

// 当网页视图完成加载时将调用这个方法
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    // 隐藏加载状态
    [self endStatus];

}

// 当因加载出错(例如:因网络问题而断开可连接)而导致停止加载时将调用这方法
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    [TSMessage showNotificationWithTitle:@"页面加载失败！" type:TSMessageNotificationTypeError];
    
    [self endStatus];
}


#pragma mark - WKUIDelegate
//web界面中有弹出警告框时调用
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    NSString * hostString = webView.URL.host;
    [UIAlertView bk_showAlertViewWithTitle:hostString message:message cancelButtonTitle:@"OK" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        completionHandler();
    }];
}

//web界面中有弹出确定框时调用
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    
    NSString * hostString = webView.URL.host;
    [UIAlertView bk_showAlertViewWithTitle:hostString message:message cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            completionHandler(YES);
        }
        else{
            completionHandler(NO);
        }
        
    }];
}

//web界面中有弹出输入框时调用
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString *))completionHandler{
    
    NSString * hostString = webView.URL.host;
    
    UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:prompt message:hostString];
    [alertView bk_setCancelButtonWithTitle:@"取消" handler:^{
        completionHandler(nil);
    }];
    
    [alertView bk_addButtonWithTitle:@"确定" handler:^{
        NSString * input = [alertView textFieldAtIndex:0].text;
        completionHandler(input);
    }];
    
    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    
    UITextField *textField = [alertView textFieldAtIndex:0];
    textField.placeholder = defaultText;
    
    [alertView show];
}

#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    // 显示加载状态
    [self starStatus];
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    // 隐藏加载状态
    [self endStatus];
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    
    //[TSMessage showNotificationWithTitle:@"页面加载失败！" type:TSMessageNotificationTypeError];
    [TSMessage showNotificationWithTitle:@"页面加载失败！" subtitle:error.domain type:TSMessageNotificationTypeError];
    
    // 隐藏加载状态
    [self endStatus];
}

//鉴权HTTPS请求
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler{
    //鉴权HTTPS请求
    if ([challenge.protectionSpace.authenticationMethod isEqualToString: NSURLAuthenticationMethodServerTrust]) {
        
        if ([challenge previousFailureCount] == 0) {
            
            NSURLCredential * credential = [NSURLCredential credentialForTrust: challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        }
        else {
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        }
    }
    else {
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
    }
}

@end
