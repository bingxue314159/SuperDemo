//
//  TYGAudioUtil.m
//  youjiaba
//
//  Created by 谈宇刚 on 15-1-25.
//  Copyright (c) 2015年 uvct. All rights reserved.
//

#import "TYGAudioUtil.h"

@implementation TYGAudioUtil

/**
 * 播放声音
 * @param fileNmae 资源名称
 * @param fileType 资源后缀名
 */
-(void)playAduio:(NSString*)fileNmae ext:(NSString*)fileType{
    NSString *path = [[NSBundle mainBundle] pathForResource:fileNmae ofType:fileType];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundID);
    //如果需要在播放完之后执行某些操作，可以调用如下方法注册一个播放完成回调函数
    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, audioPlayFinish,(__bridge void*) self);
    AudioServicesPlaySystemSound(soundID);//播放音效
    //    AudioServicesPlayAlertSound(soundID);//播放音效并震动
}

/**
 * 震动
 */
-(void)playVibrate{
    AudioServicesAddSystemSoundCompletion(kSystemSoundID_Vibrate, NULL, NULL, audioPlayFinish,NULL);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

/**
 * 播放完成之后的回调方法
 * @param soundID 播放的声音ID
 * @param clientData 传入AudioServicesAddSystemSoundCompletion最后一个参数
 */
void audioPlayFinish(SystemSoundID soundID,void* clientData){
    // 移除完成后执行的函数
    AudioServicesRemoveSystemSoundCompletion(soundID);
    // 根据ID释放自定义系统声音
    AudioServicesDisposeSystemSoundID(soundID);
}

@end
