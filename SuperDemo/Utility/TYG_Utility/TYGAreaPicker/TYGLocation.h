//
//  TYGLocation.h
//  areapicker
//
//  Created by 谈宇刚 on 15/11/9.
//  Copyright © 2015年 tanyugang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYGArea.h"

@interface TYGLocation : NSObject

@property (strong, nonatomic) NSString *country;/**< 国 */
@property (strong, nonatomic) TYGArea *province;/**< 省 */
@property (strong, nonatomic) TYGArea *city;/**< 市 */
@property (strong, nonatomic) TYGArea *district;/**< 区、县 */
@property (assign, nonatomic) NSString *steet;/**< 街道 */
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;

@end
