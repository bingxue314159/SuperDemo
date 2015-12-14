//
//  TYGWebViewProgressDemo.m
//  SuperDemo
//
//  Created by 谈宇刚 on 15/12/14.
//  Copyright © 2015年 TYG. All rights reserved.
//

#import "TYGWebViewProgressDemo.h"
#import "TYG_allHeadFiles.h"
#import <Masonry.h>
#import <UIWebView+AFNetworking.h>  //进度回调
#import <UINavigationController+M13ProgressViewBar.h>   //进度显示

@interface TYGWebViewProgressDemo (){
    UIWebView *mainWebView;
}

@end

@implementation TYGWebViewProgressDemo

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = Color_mainviewBackground;
    [self drawMainView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawMainView{
    mainWebView = [[UIWebView alloc] init];
    [self.view addSubview:mainWebView];
    [mainWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    if ([self.navigationController isShowingProgressBar]) {
        [self.navigationController cancelProgress];
    }
    [self.navigationController showProgress];
    [self primaryColorChanged];
    [self secondaryColorChanged];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.taobao.com"]];
    [mainWebView loadRequest:request progress:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        CGFloat pro = (totalBytesExpectedToWrite*1.0)/(bytesWritten*1.0);
        [self.navigationController setProgress:pro animated:YES];
        
    } success:^NSString *(NSHTTPURLResponse *response, NSString *HTML) {
        [self.navigationController finishProgress];
        return HTML;
    } failure:^(NSError *error) {
        [self.navigationController cancelProgress];
    }];
    
}

- (void)primaryColorChanged
{
    UIColor *color = [Utility RandomColor];
//    color = [UIColor blueColor];
    [self.navigationController setPrimaryColor:color];
}

- (void)secondaryColorChanged
{
    UIColor *color = [Utility RandomColor];
//    color = [UIColor yellowColor];
    [self.navigationController setSecondaryColor:color];
}

@end
