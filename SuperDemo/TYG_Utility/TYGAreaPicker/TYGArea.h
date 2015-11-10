//
//  TYGArea.h
//  TYGAreaPicker
//
//  Created by 谈宇刚 on 15/11/9.
//  Copyright © 2015年 tanyugang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYGArea : NSObject

@property (nonatomic, assign) NSInteger AREA_ID;/**< 行政区划 */
@property (nonatomic, strong) NSString *AREA_NAME;/**< 区域名称 */
@property (nonatomic, assign) NSInteger PARENT_ID;/**< 上级区域 */
@property (nonatomic, assign) NSInteger AREA_LEVEL;/**< 区域级别 */

@property (nonatomic, strong) NSMutableArray *childObjArray;

@end
