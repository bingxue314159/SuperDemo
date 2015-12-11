//
//  BlocksKitViewController.m
//  SuperDemo
//
//  Created by tanyugang on 15/7/1.
//  Copyright © 2015年 TYG. All rights reserved.
//

#import "BlocksKitViewController.h"
#import "TYG_allHeadFiles.h"
#import <BlocksKit.h>
#import <BlocksKit+UIKit.h>
#import <BlocksKit+MessageUI.h>

@interface BlocksKitViewController ()

@end

@implementation BlocksKitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//UIAlertView
- (IBAction)buttonClickForUIAlertView:(UIButton *)sender {
    
    switch (sender.tag) {
        case 10:{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"UIAlertView" message:@"测试" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            
            [alertView bk_setHandler:^{
                [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"取消"]];
            } forButtonAtIndex:0];
            
            [alertView bk_setHandler:^{
                [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"确定"]];
            } forButtonAtIndex:1];
            
            [alertView show];

            break;
        }
        case 11:{
            UIAlertView *alert = [UIAlertView bk_alertViewWithTitle:@"bk_alertView" message:@"bk_alertView测试"];
            [alert bk_setCancelButtonWithTitle:@"取消" handler:^{
                [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"取消"]];
            }];
            
            [alert bk_addButtonWithTitle:@"确定" handler:^{
                [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"确定"]];
            }];
            
            [alert show];
            break;
        }
        case 12:{
            
            [UIAlertView bk_showAlertViewWithTitle:@"bk_alertView show" message:@"" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                
                NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
                
                [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%ld,%@",(long)buttonIndex,title]];
            }];
            
            break;
        }
        case 13:{
            UIAlertView *alert = [UIAlertView bk_alertViewWithTitle:@"bk_alertView" message:@"bk_alertView测试"];
            [alert bk_setCancelButtonWithTitle:@"取消" handler:^{
                [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"取消"]];
            }];
            
            [alert bk_addButtonWithTitle:@"确定" handler:^{
                [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"确定"]];
            }];
            
            [alert show];
         
            break;
        }
        default:
            break;
    }
    
}

//UIActionSheetView
- (IBAction)buttonClickForUIActionSheetView:(UIButton *)sender{
    switch (sender.tag) {
        case 20:{
            
            /**
             *  IOS8抛弃了UIActionSheet
             
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"UIAlertController" message:@"UIAlertController" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * __nonnull action) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }]];
        
            [self presentViewController:alertController animated:YES completion:nil];
            
            */

            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"按钮0" otherButtonTitles:@"按钮1",@"按钮2",@"按钮3", nil];
            
            
            [sheet bk_setDidDismissBlock:^(UIActionSheet *sheet, NSInteger buttonIndex) {
                NSString *title = [sheet buttonTitleAtIndex:buttonIndex];
                
                [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%ld,%@",(long)buttonIndex,title]];
            }];
            
            [sheet showInView:self.view];
            
            
            break;
        }
        case 21:{
            /**
             *  IOS8抛弃了UIActionSheet
             
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"UIAlertController" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * __nonnull action) {
                [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"好的"]];
            }];
            [alertController addAction:okAction];
            
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"other" style:UIAlertActionStyleDestructive handler:nil];
            [alertController addAction:otherAction];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:cancelAction];
  
            [self presentViewController:alertController animated:YES completion:nil];
             */
            
            UIActionSheet *sheet = [UIActionSheet bk_actionSheetWithTitle:@"UIActionSheet"];
            [sheet bk_setCancelButtonWithTitle:@"取消" handler:^{
                [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"取消"]];
            }];
            
            [sheet showInView:self.view];
            
            break;
        }
        case 22:{

            
            break;
        }
        case 23:{

            
            break;
        }
        default:
            break;
    }
}

//UIMessage
- (IBAction)buttonClickForUIMessage:(UIButton *)sender{
    switch (sender.tag) {
        case 30:{
            
            
            break;
        }
        case 31:{
            
            break;
        }
        case 32:{
            
            
            break;
        }
        case 33:{
            
            
            break;
        }
        default:
            break;
    }
}


@end
