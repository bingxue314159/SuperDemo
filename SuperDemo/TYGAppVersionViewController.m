//
//  TYGAppVersionViewController.m
//  SuperDemo
//
//  Created by 谈宇刚 on 15/8/18.
//  Copyright (c) 2015年 TYG. All rights reserved.
//

#import "TYGAppVersionViewController.h"
#import "TYGAPPVersion.h"
#import "TYG_allHeadFiles.h"

@interface TYGAppVersionViewController (){
    TYGAPPVersion *appVersion;
}

@end

@implementation TYGAppVersionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.appVersionTextField.text = AppVersion;
    self.appVersionTextField.enabled = NO;
    
     appVersion = [[TYGAPPVersion alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)updateAction:(id)sender {
    
    //itms-services://?action=download-manifest&url=https://dn-bingxue.qbox.me/youxing.plist
    
    appVersion.appUrl = [NSURL URLWithString:self.urlTextField.text];
    appVersion.version = self.versionTextField.text;
    appVersion.describe = self.licTextField.text;
    appVersion.isUpdate = self.updateSwitch.isOn;
    
    [appVersion updateApp];
    
}
@end
