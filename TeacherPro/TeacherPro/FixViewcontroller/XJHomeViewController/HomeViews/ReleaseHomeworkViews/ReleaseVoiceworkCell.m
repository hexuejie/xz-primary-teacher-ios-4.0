//
//  ReleaseVoiceworkCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/6/13.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "ReleaseVoiceworkCell.h"
#import <AVFoundation/AVFoundation.h>
#import "PublicDocuments.h"

@interface ReleaseVoiceworkCell()<AVAudioPlayerDelegate>
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (nonatomic,strong) AVAudioPlayer *audioPlayer;//音频播放器，用于播放录音文件

@property (nonatomic,strong) NSTimer *timer;//
@property (nonatomic,assign) NSInteger playDuration;
@property (nonatomic,assign) NSInteger currentProgress;
@property (nonatomic,strong) NSDateFormatter*formatter;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (nonatomic, strong) NSURL * playUrl;
@end
@implementation ReleaseVoiceworkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupSubview];
    
    UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory);
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,sizeof (audioRouteOverride),&audioRouteOverride);
    
    AudioSessionSetProperty (kAudioSessionProperty_OverrideCategoryDefaultToSpeaker,sizeof (audioRouteOverride),&audioRouteOverride);
    
}

- (void)setupSubview{

//    self.progressView.trackTintColor = UIColorFromRGB(0xeeeeee);
    self.progressView.layer.cornerRadius = 4.0;
    self.progressView.layer.masksToBounds = YES;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)clear{
    _progressView.progress = 0;
    self.currentProgress = 0;
    self.audioPlayer = nil;
}
- (void)updateVoice:(NSURL *)url{
    [self clear];
    self.playUrl = url;
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:self.audioPlayer.duration];
    NSString* dateString = [[self formatter] stringFromDate:date];
    NSLog(@"录音!,时长%@秒",dateString);
    
    self.timerLabel.text = [NSString stringWithFormat:@"00:%@",dateString];
    self.playDuration = [dateString integerValue];
    self.currentProgress = 0;
}

- (NSDateFormatter *)formatter{
    
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc] init];
        [_formatter setDateFormat:@"ss"];
    }
    
    
    return _formatter;
}
/**
 *
 */
-(void)audioPowerChange{
    //    [self.audioRecorder updateMeters];//更新测量值
    //    float power= [self.audioRecorder averagePowerForChannel:0];//取得第一个通道的音频，注意音频强度范围时-160到0
    //    CGFloat progress=(1.0/160.0)*(power+160.0);
    CGFloat tempProgress =   (1/( self.playDuration*10.0 )  );
    self.progressView.progress += tempProgress;
    if (self.progressView.progress >=1) {
        [self playComplete];
    }
    self.currentProgress ++;
    if (self.currentProgress > self.playDuration*10.0) {
        [self playComplete];
    }
    NSInteger tempPlayDuration = self.playDuration - (int)self.currentProgress/10;
    NSString * tempStr =@"";
    if (tempPlayDuration<10) {
        tempStr = [NSString stringWithFormat:@"0%zd",tempPlayDuration];
    }else{
        tempStr = [NSString stringWithFormat:@"%zd",tempPlayDuration];
    }
    self.timerLabel.text = [NSString stringWithFormat:@"00:%@",tempStr];
}
//一次播放完成
- (void)playComplete
{
    
    [self.audioPlayer stop];
    [self  playFinished];
    self.audioPlayer = nil;
    self.playButton.selected = NO;
    self.timer.fireDate=[NSDate distantFuture];
    
}
- (IBAction)playAction:(UIButton *)sender {
 
    if (![self.audioPlayer isPlaying]) {
        //建议播放之前设置yes，播放结束设置no，这个功能是开启红外感应
        [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
        [self.audioPlayer play];

        sender.selected = YES;
        self.timer.fireDate=[NSDate distantPast];
    }else{
        
        //建议播放之前设置yes，播放结束设置no，这个功能是开启红外感应
        [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
      [self.audioPlayer pause];
       self.timer.fireDate=[NSDate distantFuture];//暂停定时器，注意不能调用invalidate方法，此方法会取消，之后无法恢复
      sender.selected = NO;
        
    }
    
    
    
}
- (IBAction)deleteAction:(id)sender {
    
    if ([self.audioPlayer isPlaying]) {
        [self.audioPlayer stop];
        
        [self stopAudioPlayer];
        self.audioPlayer =  nil;
    }
    if (self.deleteBlock) {
        self.deleteBlock();
    }
    
}

/**
 *  创建播放器
 *
 *  @return 播放器
 */
-(AVAudioPlayer *)audioPlayer{
    if (!_audioPlayer) {
        NSURL *url=[self getSavePath];
        NSError *error=nil;
        _audioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
//        _audioPlayer.numberOfLoops=0;
        _audioPlayer.delegate = self;
        [_audioPlayer prepareToPlay];
        _audioPlayer.volume = 1.0;
        //添加监听
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(sensorStateChange:)
                                                     name:@"UIDeviceProximityStateDidChangeNotification"
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playFinished) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        
        if (error) {
            NSLog(@"创建播放器过程中发生错误，错误信息：%@",error.localizedDescription);
            return nil;
        }
    }
    return _audioPlayer;
}
/**
 *  录音声波监控定制器
 *
 *  @return 定时器
 */
-(NSTimer *)timer{
    if (!_timer) {
        _timer=[NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(audioPowerChange) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

-(void)sensorStateChange:(NSNotificationCenter *)notification;
{
    //如果此时手机靠近面部放在耳朵旁，那么声音将通过听筒输出，并将屏幕变暗（省电啊）
    if ([[UIDevice currentDevice] proximityState] == YES)
    {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }
    else
    {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}
/**
 *  取得录音文件保存路径
 *
 *  @return 录音文件路径
 */
-(NSURL *)getSavePath{
 
//       return [NSURL URLWithString:[NSTemporaryDirectory() stringByAppendingString:kRecordAudioFile]];
    return self.playUrl;
}

- (void)stopAudioPlayer{
    
    //关闭红外感应
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    
    
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
 
    [self playFinished];
    
}
- (void)dealloc{
    [self.timer invalidate];
    self.timer = nil;
    self.audioPlayer = nil;
}
- (void)playFinished{
    self.progressView.progress = 0;
    self.currentProgress = 0;
    self.audioPlayer = nil;
    [self stopAudioPlayer];
}

- (void)stopPlayer{

    [self.audioPlayer stop];
    
}

#pragma mark - tool

//时间转换
- (NSString *)timeFormatted:(int)totalSeconds {
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60);
    return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}

@end
