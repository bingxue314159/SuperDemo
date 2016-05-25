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
#import <BlocksKit+UIKit.h>

@interface DTCoreTextViewController ()<DTAttributedTextContentViewDelegate>

@end

@implementation DTCoreTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self drawMainView];
    [self drawLineLabel];
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

- (void)drawLineLabel{
    
    DTAttributedLabel *bottomLabel = [[DTAttributedLabel alloc]initWithFrame:CGRectMake(8, 60, 300, 20)];
    bottomLabel.backgroundColor = [UIColor clearColor];

    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:@"注册即视为同意我们的《用户服务协议》"];
    
    NSRange linkRang = NSMakeRange(10,8);

    //设置字体颜色
    [attributeStr addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColor redColor].CGColor range:linkRang];

    //下划线
    [attributeStr addAttribute:NSUnderlineStyleAttributeName value:@1 range:linkRang];
    
    // 设置链接属性，链接的文字范围
    //    [attributeStr addAttribute:DTLinkAttribute value:[NSURL URLWithString:@"http://www.baidu.com"] range:linkRang];
    [attributeStr addAttribute:NSLinkAttributeName value:[NSURL URLWithString:@"http://www.baidu.com"]  range:linkRang];
    
    
    [bottomLabel setAttributedString:attributeStr];
    bottomLabel.delegate = self; // 设置DTAttributedTextContentViewDelegate代理
    
    [self.view addSubview:bottomLabel];
}

// 返回将相应的链接所转换成的DTLinkButton对象
- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForLink:(NSURL *)url identifier:(NSString *)identifier frame:(CGRect)frame{
    
    DTLinkButton *button = [[DTLinkButton alloc] initWithFrame:frame];
    button.URL = url;
    button.GUID = identifier;
    [button addTarget:self action:@selector(linkButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    button.minimumHitSize = CGSizeMake(10, 10); // adjusts it's bounds so that button is always large enough
    return button;
}

- (void)linkButtonClick:(DTLinkButton *)sender{
    
    [UIAlertView bk_showAlertViewWithTitle:@"用户服务协议" message:[NSString stringWithFormat:@"%@",sender.URL] cancelButtonTitle:@"好的" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        
    }];
}


@end
