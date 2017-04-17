//
//  TYGValidViewController.m
//  SuperDemo
//
//  Created by 谈宇刚 on 15/9/11.
//  Copyright (c) 2015年 TYG. All rights reserved.
//

#import "TYGValidViewController.h"
#import "TYG_allHeadFiles.h"
#import <AMPopTip.h>

@interface TYGValidViewController ()<UITextFieldDelegate>{
    AMPopTip *popTip;
}

@end

@implementation TYGValidViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    popTip = [AMPopTip popTip];
    popTip.shouldDismissOnTapOutside = YES;
    popTip.shouldDismissOnTap = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
//    [popTip hide];
    
    textField.backgroundColor = [UIColor whiteColor];
    
    NSString *content = @"";
    switch (textField.tag) {
        case 0:{
            content = @"手机号码验证\n如：13812345678";
            break;
        }
        case 1:{
            content = @"座机号码验证\n如：010-12345678、0912-1234567、(010)-12345678、(0912)1234567、(010)12345678、(0912)-1234567、01012345678、09121234567";
            break;
        }
        case 2:{
            content = @"e-mail验证\n如：zhangsan@163.com、li-si@236.net、wan_gwu999@SEED.NET.TW";
            break;
        }
        case 3:{
            content = @"e-mail验证\n如：zhangsan@163.com、li-si@236.net、wan_gwu999@SEED.NET.TW";
            break;
        }
        case 4:{
            content = @"纯数字验证\n如：102，5.88，0.88，.88";
            break;
        }
        case 5:{
            content = @"字母+数字\n如：a123,a,123,a1b2c3";
            break;
        }
        case 6:{
            content = @"纯汉字\n如：程序员";
            break;
        }
        case 7:{
            content = @"身份证\n一定要输入正确的身份证，验证较严格";
            break;
        }
        case 8:{
            content = @"银行卡号(16位或者19位)";
            break;
        }
        case 9:{
            content = @"";
            break;
        }
        case 10:{
            content = @"";
            break;
        }
        default:
            break;
    }
    
    
    if (content.length > 0) {
        //PopTip的BUG，不能连续调用
        [popTip showText:content direction:AMPopTipDirectionUp maxWidth:(SCREEN_WIDTH - 60) inView:self.view fromFrame:textField.frame];
        
    }
    else {
        [popTip hide];
    }

}

- (void)textFieldDidEndEditing:(UITextField *)textField{

    NSString *text = [Utility trimString:textField.text];
    if (text.length == 0) {
        textField.backgroundColor = [UIColor whiteColor];
        return;
    }
    
    BOOL flag = NO;
    switch (textField.tag) {
        case 0:{
            flag = [TYGValid isTelphoneNumber:text];
            break;
        }
        case 1:{
            flag = [TYGValid isHomePhoneNumber:text];
            break;
        }
        case 2:{
            flag = [TYGValid isEmail:text];
            break;
        }
        case 3:{
            flag = [TYGValid isValidateEmail:text];
            break;
        }
        case 4:{
            flag = [TYGValid isNumber:text];
            break;
        }
        case 5:{
            flag = [TYGValid isNumberAndChar:text];
            break;
        }
        case 6:{
            flag = [TYGValid isChinese:text];
            break;
        }
        case 7:{
            flag = [TYGValid isIDCard:text];
            break;
        }
        case 8:{
            flag = YES;
            flag = [TYGValid isBankCardNum:text];
            break;
        }
        case 9:{
            flag = YES;
            break;
        }
        case 10:{
            flag = YES;
            break;
        }
        default:
            break;
    }
    
    if (flag) {
        textField.backgroundColor = [UIColor greenColor];
    }
    else{
        textField.backgroundColor = [UIColor redColor];
    }
}


@end
