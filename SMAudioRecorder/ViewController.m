//
//  ViewController.m
//  SMAudioRecorder
//
//  Created by 宋明 on 16/5/16.
//  Copyright © 2016年 apolla. All rights reserved.
//

#import "ViewController.h"
#import "FTRecordTool.h"

@interface ViewController ()<FTRecordToolDelegate,UIGestureRecognizerDelegate,AVAudioPlayerDelegate>
//播放录音条
@property (weak, nonatomic) IBOutlet UIView *palyView;

/**  录音播放进度条 */
@property (weak, nonatomic) IBOutlet UIProgressView *recordProgress;

/**  音频的删除 */
@property (weak, nonatomic) IBOutlet UIButton *delete;


/**  录音长按钮 */
@property (weak, nonatomic) IBOutlet UILabel *recordLong;

/**  当前录音时间展示 */
@property (weak, nonatomic) IBOutlet UILabel *timmerLable;

/**  左侧圆点 */
@property (weak, nonatomic) IBOutlet UILabel *powLable1;

/**  右侧远点 */
@property (weak, nonatomic) IBOutlet UILabel *powLable2;

/** 定时器 */
@property (nonatomic, strong) NSTimer *timer;

/** 录音工具 */
@property (nonatomic, strong) FTRecordTool *recordTool;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILongPressGestureRecognizer *LongP = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longClick:)];
    LongP.delegate = self;
    
    [self.recordLong addGestureRecognizer:LongP];
    
    //初始化录音工具类
    self.recordTool = [FTRecordTool sharedRecordTool];
    self.recordTool.recordTime = 0;
    self.recordTool.delegate = self;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/** 播放音乐 */
- (IBAction)playRecord:(id)sender {
    
    
    [self.recordTool playRecordingFile];
    
    //获取播放器的代理
    self.recordTool.player.delegate = self;
    
    //用于更新进度条
    NSTimer *timer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(changeProgress) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    [timer fire];
    self.timer = timer;
}

/**
 *  删除音频
 *
 *  @param sender <#sender description#>
 */
- (IBAction)deleteRecord:(id)sender {
    
    if(self.recordTool.player.playing)[self.recordTool stopPlaying];
    [self.recordTool destructionRecordingFile];

}

/**
 *  点击录音按钮
 *
 *  @param sender 录音按钮
 */
- (void)longClick:(UILongPressGestureRecognizer *)gesture
{
    //开始录音
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        [self.recordTool startRecording];
        
    }
    //结束录音
    if (gesture.state == UIGestureRecognizerStateEnded)
    {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            [self.recordTool stopRecording];
            //[self destructionRecordingFile];
            
        });
        self.recordTool.recordTime = 0;

        self.timmerLable.text = @"00 秒";

    }
    
}

#pragma mark - LVRecordToolDelegate
- (void)recordTool:(FTRecordTool *)recordTool didstartRecoring:(CGFloat)timer AndPow:(NSString *)pow{
    
    //限制为60s 自动停止
    if (timer >= 60) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            [self.recordTool stopRecording];
            
        });
        self.recordTool.recordTime = 0;
        self.timmerLable.text = @"00 秒";
    }else{
        
        self.timmerLable.text = [NSString stringWithFormat:@"%02.1f 秒",timer];
        self.powLable1.text = pow;
        self.powLable2.text = pow;
        [self.powLable2 sizeToFit];
        [self.powLable1 sizeToFit];
        
    }
    
}

//修改进度条
- (void)changeProgress
{
    
    CGFloat progress =self.recordTool.player.currentTime / self.recordTool.player.duration ;
    self.recordProgress.progress = progress;
}

#pragma mark - AVAudioPlayerDelegate
// 音频播放完成时
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [self.recordProgress setProgress:0.0];
    [self.timer invalidate];
    
}


@end
