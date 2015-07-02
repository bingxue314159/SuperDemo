//
//  HZAreaPickerView.h
//  areapicker
//
//  Created by Cloud Dai on 12-9-9.
//  Copyright (c) 2012年 clouddai.com. All rights reserved.
//
/**
 * 功能：省、市、县（区）选取器
 * 作者：在网上下载的代码，后改造于谈宇刚
 * 版本：V1.0
 **/

#import <UIKit/UIKit.h>
#import "HZLocation.h"

typedef enum {
    HZAreaPickerWithStateAndCity,
    HZAreaPickerWithStateAndCityAndDistrict
} HZAreaPickerStyle;

@class HZAreaPickerView;

@protocol HZAreaPickerDatasource <NSObject>

- (NSArray *)areaPickerData:(HZAreaPickerView *)picker;

@end

@protocol HZAreaPickerDelegate <NSObject>

@optional
- (void)pickerDidChaneStatus:(HZAreaPickerView *)picker;

@end

@interface HZAreaPickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (assign, nonatomic) id <HZAreaPickerDelegate> delegate;
@property (assign, nonatomic) id <HZAreaPickerDatasource> datasource;
@property (strong, nonatomic) IBOutlet UIPickerView *locatePicker;
@property (strong, nonatomic) HZLocation *locate;
@property (nonatomic) HZAreaPickerStyle pickerStyle;

- (id)initWithStyle:(HZAreaPickerStyle)pickerStyle withDelegate:(id <HZAreaPickerDelegate>)delegate andDatasource:(id <HZAreaPickerDatasource>)datasource;
- (void)showInView:(UIView *)view;
- (void)cancelPicker;
- (IBAction)cancelButtonClick:(UIBarButtonItem *)sender;
- (IBAction)submitButtonClick:(UIBarButtonItem *)sender;

/**
 * 设置选取器的值
 * array -- 标题的值
 */
- (void)setValueWithArray:(NSArray *)array animated:(BOOL)animated;

@end
