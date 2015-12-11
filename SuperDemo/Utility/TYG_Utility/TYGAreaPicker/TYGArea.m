//
//  TYGArea.m
//  TYGAreaPicker
//
//  Created by 谈宇刚 on 15/11/9.
//  Copyright © 2015年 tanyugang. All rights reserved.
//

#import "TYGArea.h"
#import <MJExtension.h>

@implementation TYGArea

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.childObjArray = [NSMutableArray arrayWithCapacity:100];
    }
    return self;
}

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property{
    
    if ([oldValue isKindOfClass:[NSString class]]) {
        oldValue = [oldValue length] ? (oldValue) : @"";
    }

    return oldValue;
}

@end
