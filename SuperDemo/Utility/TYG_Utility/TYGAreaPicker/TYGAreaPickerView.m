//
//  TYGAreaPickerView.m
//  areapicker
//
//  Created by 谈宇刚 on 15/11/9.
//  Copyright © 2015年 tanyugang. All rights reserved.
//

#import "TYGAreaPickerView.h"
#import <QuartzCore/QuartzCore.h>
#import "MJExtension.h"
#import "TYGArea.h"

#define kDuration 0.3

@interface TYGAreaPickerView (){
    NSArray *provinces;
    NSArray *cities;
    NSArray *districts;
    
    NSArray *defineValueArray;
}

@end

@implementation TYGAreaPickerView

static TYGAreaPickerView *sharedObject = nil;
+ (TYGAreaPickerView *)sharedInstance{
    static dispatch_once_t _singletonPredicate;
    dispatch_once(&_singletonPredicate, ^{
        sharedObject = [[self alloc] init];
    });
    return sharedObject;
}

//初始化
- (id)init{
    
    self = [[[NSBundle mainBundle] loadNibNamed:@"TYGAreaPickerView" owner:self options:nil] objectAtIndex:0];
    if (self) {

        self.pickerStyle = TYGAreaPickerWithStateAndCityAndDistrict;
        self.locatePicker.delegate = self;
        self.locatePicker.dataSource = self;
        
        CGRect frame = self.frame;
        frame.size.width = [[UIScreen mainScreen] bounds].size.width;
        self.frame = frame;
        
        self.locate.country = @"中国";
        provinces = [self readCityData];
        self.locate.province = [provinces firstObject];
        
        cities = [TYGArea mj_objectArrayWithKeyValuesArray:self.locate.province.childObjArray];
        self.locate.city = [cities firstObject];
        
        districts = [TYGArea mj_objectArrayWithKeyValuesArray:self.locate.city.childObjArray];
        self.locate.district = [districts firstObject];
        
        defineValueArray = @[self.locate.province.AREA_NAME,self.locate.city.AREA_NAME,self.locate.district.AREA_NAME];

    }
    
    return self;
    
}

- (void)setPickerStyle:(TYGAreaPickerStyle)pickerStyle{
    _pickerStyle = pickerStyle;
    
    [self.locatePicker reloadAllComponents];
    
}

-(TYGLocation *)locate{
    if (_locate == nil) {
        _locate = [[TYGLocation alloc] init];
    }
    
    return _locate;
}

//获取数据
- (NSArray *)readCityData{
    NSDictionary *dicData = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tygCity.plist" ofType:nil]];
    NSArray *proArray = [dicData objectForKey:@"中国"];
    
    NSArray *objArray = [TYGArea mj_objectArrayWithKeyValuesArray:proArray];
    
    return objArray;
}

/**
 *  选定值后的回调
 *  @param callBack block回调
 */
- (void)didselectedArea:(void(^)(TYGAreaPickerView *areaPickerView))callBack{
    _callBack = callBack;
}

//设置选取的默认值
- (void)setValueWithArray:(NSArray *)array animated:(BOOL)animated{
    
    NSInteger maxLeng = 2;
    if (self.pickerStyle == TYGAreaPickerWithStateAndCityAndDistrict) {
        maxLeng = 3;
    }
    
    if (array.count < maxLeng) {
        
        array = [NSArray arrayWithArray:defineValueArray];
    }
    
    for (int i = 0; i < array.count; i++) {
        if (i<maxLeng) {
            NSString *title1 = [array objectAtIndex:i];
            if (title1.length == 0) {
                [self.locatePicker selectRow:0 inComponent:i animated:animated];
            }
            else{
                NSInteger lastCow = [self getTitleIndexWithTitle:title1 component:i];
                [self.locatePicker selectRow:lastCow inComponent:i animated:animated];
                
            }
            
        }
        else{
            break;
        }
    }
    
    
}

- (NSInteger)getTitleIndexWithTitle:(NSString *)title component:(NSInteger)component{
    
    NSInteger index = 0;
    
    
    if (self.pickerStyle == TYGAreaPickerWithStateAndCityAndDistrict) {
        switch (component) {
            case 0:{
                
                for (int i=0; i<provinces.count; i++) {
                    NSString *newTitle = [[provinces objectAtIndex:i] AREA_NAME];
                    if ([title isEqualToString:newTitle]) {
                        index = i;
                        break;
                    }
                }
                
                TYGArea *province = [provinces objectAtIndex:index];
                self.locate.province = province;
                
                cities = [TYGArea mj_objectArrayWithKeyValuesArray:province.childObjArray];
                [self.locatePicker selectRow:0 inComponent:1 animated:YES];
                [self.locatePicker reloadComponent:1];
                
                TYGArea *city = [cities firstObject];
                districts = [TYGArea mj_objectArrayWithKeyValuesArray:city.childObjArray];
                [self.locatePicker selectRow:0 inComponent:2 animated:YES];
                [self.locatePicker reloadComponent:2];
                
                self.locate.city = [cities firstObject];
                self.locate.district = [districts firstObject];
                
                
                break;
            }
            case 1:{
                
                for (int i=0; i<cities.count; i++) {
                    NSString *newTitle = [[cities objectAtIndex:i] AREA_NAME];
                    if ([title isEqualToString:newTitle]) {
                        index = i;
                        break;
                    }
                }
                
                TYGArea *city = [cities objectAtIndex:index];
                
                districts = [TYGArea mj_objectArrayWithKeyValuesArray:city.childObjArray];
                [self.locatePicker selectRow:0 inComponent:2 animated:YES];
                [self.locatePicker reloadComponent:2];
                
                self.locate.city = city;
                self.locate.district = [districts firstObject];
                
                break;
            }
            case 2:{
                
                for (int i=0; i<districts.count; i++) {
                    NSString *newTitle = [[districts objectAtIndex:i] AREA_NAME];
                    if ([title isEqualToString:newTitle]) {
                        index = i;
                        break;
                    }
                }
                self.locate.district = [districts objectAtIndex:index];
                
                break;
            }
            default:
                index = 0;
                break;
        }
    } else{
        switch (component) {
            case 0:{
                
                for (int i=0; i<provinces.count; i++) {
                    NSString *newTitle = [[provinces objectAtIndex:i] AREA_NAME];
                    if ([title isEqualToString:newTitle]) {
                        index = i;
                        break;
                    }
                }
                
                TYGArea *province = [provinces objectAtIndex:index];
                self.locate.province = province;
                
                cities = [TYGArea mj_objectArrayWithKeyValuesArray:province.childObjArray];
                [self.locatePicker selectRow:0 inComponent:1 animated:YES];
                [self.locatePicker reloadComponent:1];
                
                self.locate.city = [cities firstObject];

                break;
            }
            case 1:{
                
                for (int i=0; i<cities.count; i++) {
                    NSString *newTitle = [[cities objectAtIndex:i] AREA_NAME];
                    if ([title isEqualToString:newTitle]) {
                        index = i;
                        break;
                    }
                }
                
                self.locate.city = [cities objectAtIndex:index];
                break;
            }
            default:
                index = 0;
                break;
        }
    }
    
    return index;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (self.pickerStyle == TYGAreaPickerWithStateAndCityAndDistrict) {
        return 3;
    } else{
        return 2;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (component) {
        case 0:
            return [provinces count];
            break;
        case 1:
            return [cities count];
            break;
        case 2:
            return [districts count];
        default:
            return 0;
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch (component) {
        case 0:
            return [[provinces objectAtIndex:row] AREA_NAME];
            break;
        case 1:
            return [[cities objectAtIndex:row] AREA_NAME];
            break;
        case 2:
            if ([districts count] > 0) {
                return [[districts objectAtIndex:row] AREA_NAME];
                break;
            }
        default:
            return  @"";
            break;
    }
}

#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (self.pickerStyle == TYGAreaPickerWithStateAndCityAndDistrict) {
        switch (component) {
            case 0:{

                TYGArea *province = [provinces objectAtIndex:row];
                self.locate.province = province;
                
                cities = [TYGArea mj_objectArrayWithKeyValuesArray:province.childObjArray];
                [self.locatePicker selectRow:0 inComponent:1 animated:YES];
                [self.locatePicker reloadComponent:1];
                
                TYGArea *city = [cities firstObject];
                districts = [TYGArea mj_objectArrayWithKeyValuesArray:city.childObjArray];
                [self.locatePicker selectRow:0 inComponent:2 animated:YES];
                [self.locatePicker reloadComponent:2];
                
                self.locate.city = [cities firstObject];
                self.locate.district = [districts firstObject];
                
                break;
            }
            case 1:{
                
                TYGArea *city = [cities objectAtIndex:row];
                
                districts = [TYGArea mj_objectArrayWithKeyValuesArray:city.childObjArray];
                [self.locatePicker selectRow:0 inComponent:2 animated:YES];
                [self.locatePicker reloadComponent:2];
                
                self.locate.city = [cities objectAtIndex:row];
                self.locate.district = [districts firstObject];
                
                break;
            }
            case 2:{
                self.locate.district = [districts objectAtIndex:row];
                
                break;
            }
            default:
                break;
        }
    } else{
        switch (component) {
            case 0:{
                TYGArea *province = [provinces objectAtIndex:row];
                self.locate.province = province;
                
                cities = [TYGArea mj_objectArrayWithKeyValuesArray:province.childObjArray];
                
                [self.locatePicker selectRow:0 inComponent:1 animated:YES];
                [self.locatePicker reloadComponent:1];

                self.locate.city = [cities objectAtIndex:0];
                break;
            }
            case 1:{
                self.locate.city = [cities objectAtIndex:row];
                break;
            }
            default:
                break;
        }
    }
    
}

#pragma mark - animation

- (void)showInView:(UIView *)view{
    
    self.frame = CGRectMake(0, view.frame.size.height, self.frame.size.width, self.frame.size.height);
    [view addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, view.frame.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    }];
    
}

- (void)dissmiss{
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.frame = CGRectMake(0, self.frame.origin.y+self.frame.size.height, self.frame.size.width, self.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                         
                     }];
    
}

- (IBAction)cancelButtonClick:(UIBarButtonItem *)sender {
    [self dissmiss];
}

- (IBAction)submitButtonClick:(UIBarButtonItem *)sender {

    _callBack(self);
    [self dissmiss];
}

@end
