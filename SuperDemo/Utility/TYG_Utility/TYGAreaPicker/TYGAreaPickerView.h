//
//  TYGAreaPickerView.h
//  areapicker
//
//  Created by 谈宇刚 on 15/11/9.
//  Copyright © 2015年 tanyugang. All rights reserved.
//
/**
 * 功能：省、市、县（区）选取器
 * 作者：谈宇刚
 * 版本：V1.0.1
 **/

#import <UIKit/UIKit.h>
#import "TYGLocation.h"

typedef enum {
    TYGAreaPickerWithStateAndCity,
    TYGAreaPickerWithStateAndCityAndDistrict
} TYGAreaPickerStyle;

@interface TYGAreaPickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>{
    void (^_callBack)(TYGAreaPickerView *);/**< 回调 */
}

@property (strong, nonatomic) IBOutlet UIPickerView *locatePicker;
@property (strong, nonatomic) TYGLocation *locate;
@property (nonatomic) TYGAreaPickerStyle pickerStyle;/**< 选取器样式 */


+ (TYGAreaPickerView *)sharedInstance;

/**
 *  装载view
 *  @param view 父级视图
 */
- (void)showInView:(UIView *)view;

/**
 *  取消显示
 */
- (void)dissmiss;

/**
 *  选定值后的回调
 *  @param callBack block回调
 */
- (void)didselectedArea:(void(^)(TYGAreaPickerView *areaPickerView))callBack;

/**
 * 设置选取器的值
 * array -- @[标题的值]
 */
- (void)setValueWithArray:(NSArray *)array animated:(BOOL)animated;

@end
