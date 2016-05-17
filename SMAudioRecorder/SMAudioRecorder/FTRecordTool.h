//
//  FTRecordTool.h
//  master
//
//  Created by 宋明 on 16/5/11.
//  Copyright © 2016年 灵猫. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@class FTRecordTool;

@protocol FTRecordToolDelegate <NSObject>

@optional
- (void)recordTool:(FTRecordTool *)recordTool didstartRecoring:(CGFloat)timer AndPow:(NSString *)pow;

@end
@interface FTRecordTool : NSObject

/** 录音文件地址 */
@property (nonatomic, strong) NSURL *recordFileUrl;

/** 录音工具的单例 */
+ (instancetype)sharedRecordTool;

/** 开始录音 */
- (void)startRecording;

/** 停止录音 */
- (void)stopRecording;

/** 播放录音文件 */
- (void)playRecordingFile;

/** 停止播放录音文件 */
- (void)stopPlaying;

/** 销毁录音文件 */
- (void)destructionRecordingFile;

/** 录音MP3文件 */
- (NSString *)transformCAFToMP3;

@property (nonatomic , assign)CGFloat recordTime;

/** 录音对象 */
@property (nonatomic, strong) AVAudioRecorder *recorder;
/** 播放器对象 */
@property (nonatomic, strong) AVAudioPlayer *player;

/** 更新当前播放时间以及音频波 */
@property (nonatomic, assign) id<FTRecordToolDelegate> delegate;
@end
