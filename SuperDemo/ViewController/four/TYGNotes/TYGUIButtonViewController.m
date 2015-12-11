//
//  TYGUIButtonViewController.m
//  SuperDemo
//
//  Created by 谈宇刚 on 15/9/2.
//  Copyright (c) 2015年 TYG. All rights reserved.
//

#import "TYGUIButtonViewController.h"
#import "TYG_allHeadFiles.h"

@interface TYGUIButtonViewController ()

@end

@implementation TYGUIButtonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //设置圆角
    self.button1.layer.masksToBounds = YES;
    
//    self.button1.layer.cornerRadius = CGRectGetWidth(self.button1.frame)/2.0;
    self.button1.layer.cornerRadius = 100;
    
    
    UIView *lineView = [TYG_UIItems drawDashLineWithLineFrame:CGRectMake(0, 0, SCREEN_WIDTH, 4) lineLength:10 lineSpacing:4 lineColor:[UIColor redColor]];//虚线
    
    [self.view addSubview:lineView];
                        
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)switchValueChanged:(UISwitch *)sender {
    if (sender.isOn) {
        self.button1.tygButtonType = TYGUIButtonTypeDefalut;
    }
    else{
        self.button1.tygButtonType = TYGUIButtonTypeRound;
    }
}

- (IBAction)buttonClick:(UIButton *)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"按钮点击事件" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}
@end
