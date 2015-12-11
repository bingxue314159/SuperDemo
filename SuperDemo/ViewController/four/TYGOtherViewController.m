//
//  TYGOtherViewController.m
//  SuperDemo
//
//  Created by tanyugang on 15/6/10.
//  Copyright (c) 2015年 TYG. All rights reserved.
//

#import "TYGOtherViewController.h"
#import "TYGWebViewController.h"

@interface TYGOtherViewController ()

@end

@implementation TYGOtherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)buttonClick:(UIButton *)sender {
    
    NSString *urlStr = @"";
    
    switch (sender.tag) {
        case 0:{
            urlStr = @"http://mp.weixin.qq.com/s?__biz=MjM5OTM0MzIwMQ==&mid=207458207&idx=3&sn=40187683266b369f679f3facf858a6ee&scene=5#rd";
            break;
        }
        case 1:{
            urlStr = @"https://github.com/vsouza/awesome-ios";
            break;
        }
        case 2:{
            urlStr = @"https://github.com/matteocrippa/awesome-swift";
            break;
        }
        case 3:{
            urlStr = @"https://github.com/cjwirth/awesome-ios-ui";
            break;
        }
        case 4:{
            urlStr = @"https://github.com/futurice/ios-good-practices";
            break;
        }
        case 5:{
            urlStr = @"http://mp.weixin.qq.com/s?__biz=MjM5OTM0MzIwMQ==&mid=207594239&idx=3&sn=4cf71f62db7385a3e404a04176987caa&scene=5#rd";
            break;
        }
        case 6:{
            urlStr = @"https://github.com/CoderMJLee/MJExtension";
            break;
        }
        default:
            break;
    }
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    TYGWebViewController *webView = [[TYGWebViewController alloc] init];
    webView.title = [sender titleForState:UIControlStateNormal];
    webView.url = url;
    
    [self.navigationController pushViewController:webView animated:YES];
}
@end
