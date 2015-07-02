//
//  TYGAudioUtil.h
//  youjiaba
//
//  Created by 谈宇刚 on 15-1-25.
//  Copyright (c) 2015年 uvct. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYGAudioUtil : UIView

/**
 * 播放声音
 * @param fileNmae 资源名称
 * @param fileType 资源后缀名
 */
-(void)playAduio:(NSString*)fileNmae ext:(NSString*)fileType;

/**
 * 震动
 */
-(void)playVibrate;

@end
