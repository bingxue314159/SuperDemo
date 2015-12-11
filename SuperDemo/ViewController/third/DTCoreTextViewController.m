//
//  DTCoreTextViewController.m
//  SuperDemo
//
//  Created by tanyugang on 15/7/1.
//  Copyright © 2015年 TYG. All rights reserved.
//

#import "DTCoreTextViewController.h"
#import "TYG_allHeadFiles.h"
#import <DTCoreText.h>

@interface DTCoreTextViewController ()

@end

@implementation DTCoreTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self drawMainView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawMainView{
    DTAttributedLabel *label = [[DTAttributedLabel alloc] init];
    label.frame = CGRectMake(8, 20, 100, 30);
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 1;
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.view addSubview:label];
    
    UIFont *font = [UIFont systemFontOfSize:16];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font
                                                                forKey:NSFontAttributeName];
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:@"this is test!" attributes:attrsDictionary];
    //把this的字体颜色变为红色
    [attriString addAttribute:(NSString *)kCTForegroundColorAttributeName
                        value:(id)[UIColor redColor].CGColor
                        range:NSMakeRange(0, 4)];
    //把is变为黄色
    [attriString addAttribute:(NSString *)kCTForegroundColorAttributeName
                        value:(id)[UIColor yellowColor].CGColor
                        range:NSMakeRange(5, 2)];
    //改变this的字体，value必须是一个CTFontRef
    [attriString addAttribute:(NSString *)kCTFontAttributeName
                        value:(id)[UIFont boldSystemFontOfSize:22]
                        range:NSMakeRange(0, 4)];
    //给this加上下划线，value可以在指定的枚举中选择
    [attriString addAttribute:(NSString *)kCTUnderlineStyleAttributeName
                        value:(id)[NSNumber numberWithInt:kCTUnderlineStyleDouble]
                        range:NSMakeRange(0, 4)];
    
    label.attributedString = attriString;
}


@end
