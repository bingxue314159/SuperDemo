//
//  TYGAudioUtil.h
//  youjiaba
//
//  Created by 谈宇刚 on 15-1-25.
//  Copyright (c) 2015年 uvct. All rights reserved.
//
/**
 *
 * 需要播放的音频文件不能超过30秒
 * 必须是IMA/ADPCM格式[in linear PCM or IMA4(IMA/ADPCM) format]
 * 必须是.caf  .aif .wav文件
 */

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@interface TYGAudioUtil : UIView

/**
 * 播放声音(如：videoRing.caf)
 * @param fileNmae 资源名称
 * @param fileType 资源后缀名
 */
-(void)playAduio:(NSString*)fileNmae ext:(NSString*)fileType;

/**
 * 震动
 */
-(void)playVibrate;

@end
