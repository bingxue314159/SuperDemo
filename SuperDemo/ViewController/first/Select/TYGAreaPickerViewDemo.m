//
//  ViewController.m
//  areapicker
//
//  Created by tanyugang on 15/4/20.
//  Copyright (c) 2015年 TYG. All rights reserved.
//

#import "TYGAreaPickerViewDemo.h"
#import "TYGAreaPickerView.h"
#import "TYG_allHeadFiles.h"

@interface TYGAreaPickerViewDemo () <UITextFieldDelegate>{
    TYGAreaPickerView *locatePicker;
}

@property (retain, nonatomic) IBOutlet UITextField *areaText;
@property (retain, nonatomic) IBOutlet UITextField *cityText;

@end

@implementation TYGAreaPickerViewDemo


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showPick:(TYGAreaPickerStyle)pickerStyle{
    
    locatePicker = [TYGAreaPickerView sharedInstance];
    locatePicker.pickerStyle = pickerStyle;
    
    switch (pickerStyle) {
        case TYGAreaPickerWithStateAndCity:{
            NSArray *array = [self.cityText.text componentsSeparatedByString:@" "];
            [locatePicker setValueWithArray:array animated:NO];
            break;
        }
        case TYGAreaPickerWithStateAndCityAndDistrict:{
            NSArray *array = [self.areaText.text componentsSeparatedByString:@" "];
            [locatePicker setValueWithArray:array animated:NO];
            break;
        }
        default:
            break;
    }
    
    [locatePicker showInView:self.view];

    WeekSelf(weakSelf);
    [locatePicker didselectedArea:^(TYGAreaPickerView *pickview) {
        switch (pickerStyle) {
            case TYGAreaPickerWithStateAndCity:{
                weakSelf.cityText.text = [NSString stringWithFormat:@"%@ %@",pickview.locate.province.AREA_NAME,pickview.locate.city.AREA_NAME];
                break;
            }
            case TYGAreaPickerWithStateAndCityAndDistrict:{
                weakSelf.areaText.text = [NSString stringWithFormat:@"%@ %@ %@",pickview.locate.province.AREA_NAME,pickview.locate.city.AREA_NAME,pickview.locate.district.AREA_NAME];
                break;
            }
            default:
                break;
        }
        
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [locatePicker dissmiss];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if ([textField isEqual:self.cityText]) {
        [self showPick:TYGAreaPickerWithStateAndCity];
    }
    else if ([textField isEqual:self.areaText]){
        [self showPick:TYGAreaPickerWithStateAndCityAndDistrict];
    }

    return NO;
}


@end
