//
//      ┏┛ ┻━━━━━┛ ┻┓
//      ┃　　　　　　 ┃
//      ┃　　　━　　　┃
//      ┃　┳┛　  ┗┳　┃
//      ┃　　　　　　 ┃
//      ┃　　　┻　　　┃
//      ┃　　　　　　 ┃
//      ┗━┓　　　┏━━━┛
//        ┃　　　┃   神兽保佑
//        ┃　　　┃   代码无BUG！
//        ┃　　　┗━━━━━━━━━┓
//        ┃　　　　　　　    ┣┓
//        ┃　　　　         ┏┛
//        ┗━┓ ┓ ┏━━━┳ ┓ ┏━┛
//          ┃ ┫ ┫   ┃ ┫ ┫
//          ┗━┻━┛   ┗━┻━┛
//
//  RecordingCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/6/8.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "RecordingView.h"
#import "MMPopupCategory.h"
#import "PublicDocuments.h"
#import <AVFoundation/AVFoundation.h>
#import "PublicDocuments.h"
#import "ProUtils.h"
#import "AlertView.h"
#import "lame.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define NAVBAR_HEIGHT 40

#define TITLE_X (SCREEN_WIDTH/2-SCREEN_WIDTH/10)
#define TITLE_Y (1.5*NAVBAR_HEIGHT)
#define TITLE_WIDTH (SCREEN_WIDTH/5)
#define TITLE_HEIGHT NAVBAR_HEIGHT

#define RECORDBAR_X (SCREEN_WIDTH/2-SCREEN_WIDTH/4)
#define RECORDBAR_Y (TITLE_Y+TITLE_HEIGHT+NAVBAR_HEIGHT/2)
#define RECORDBAR_WIDTH (SCREEN_WIDTH/2)

#define TIME_X (SCREEN_WIDTH/2-SCREEN_WIDTH/8)
#define TIME_Y (RECORDBAR_Y+NAVBAR_HEIGHT)
#define TIME_WIDTH (SCREEN_WIDTH/4)
#define TIME_HEIGHT NAVBAR_HEIGHT

#define RECORDBUTTON_X (SCREEN_WIDTH/2-SCREEN_WIDTH/6)
#define RECORDBUTTON_Y (TIME_Y+TIME_HEIGHT+NAVBAR_HEIGHT/2)
#define RECORDBUTTON_WIDTH (SCREEN_WIDTH/3)
#define RECORDBUTTON_HEIGHT RECORDBUTTON_WIDTH

#define PLAYBUTTON_X (SCREEN_WIDTH/2-SCREEN_WIDTH/8)
#define PLAYBUTTON_Y (TIME_Y+2*TIME_HEIGHT)
#define PLAYBUTTON_WIDTH SCREEN_WIDTH/4
#define PLAYBUTTON_HEIGHT PLAYBUTTON_WIDTH

#define RECORE_BUTTON_TAG 1010
#define NEW_PLAY_BUTTON_TAG 1011
#define PAUSE_PLAY_BUTTON_TAG 1012
#define FINISH_BUTTON_TAG 1013
#define RECORDAGAIN_BUTTON_TAG 1014
#define PAUSE_BUTTON_TAG 1015

#define COUNTDOWN 60*10.0f
@interface RecordingView()<AVAudioRecorderDelegate>{

   
    
    UIButton * recordingButton;
    
    UILabel * content;
    UILabel * title;
}
@property (nonatomic,strong) AVAudioRecorder *audioRecorder;//音频录音机
@property (nonatomic,strong) NSTimer *timer;//
@property (nonatomic,strong) CircleView *circleView;
@property (nonatomic,assign) NSInteger  vocieTime;
@property (nonatomic,assign) BOOL isCancel;
@property (nonatomic,strong) UIView *countdownBgView;//倒计时背景
@property (nonatomic,strong) UILabel *countdownLabel;//倒计时
@property (nonatomic,strong) UIImageView *countdownImg;//
@property (nonatomic,strong) UILabel *countdownDetail;
@end
@implementation RecordingView

-(instancetype)initWithFrame:(CGRect)frame{

    if (self == [super initWithFrame:frame]) {
        [self setupSubViews];
//        [self initializeUI];
    }
    return self;
}

- (void)setupSubViews{
    self.isCancel = NO;
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8] ;
      CGFloat bottomHeight = 224;
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height- bottomHeight)];
    topView.backgroundColor = [UIColor clearColor];
    [self addSubview:topView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [topView addGestureRecognizer:tap];
    

    UIView * recordingBgView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height- bottomHeight, self.frame.size.width, bottomHeight)];
    recordingBgView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:recordingBgView];
    

    CGFloat recordingWidth = 100;
    CGRect recordingRect = CGRectMake(
                                      recordingBgView.frame.size.width/2-recordingWidth/2 +5,
                                      recordingBgView.frame.size.height/2-recordingWidth/2 +5,
                                      recordingWidth-10, recordingWidth-10);
    
    
    //圆圈
     self.circleView = [[CircleView alloc] initWithFrame:CGRectMake(recordingRect.origin.x, recordingRect.origin.y, recordingRect.size.width , recordingRect.size.height ) ];
    [recordingBgView addSubview:self.circleView];
    

    
  
    
    recordingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [recordingButton setImage:[UIImage imageNamed:@"homework_bottom_voice"] forState:UIControlStateNormal];
//    [recordingButton setImage:[UIImage imageNamed:@"homework_recording"] forState:UIControlStateHighlighted];
    [recordingButton setImage:[UIImage imageNamed:@"homework_recording"] forState:UIControlStateSelected];
    [recordingButton setFrame:recordingRect];
    
    [recordingButton addTarget:self action:@selector(recordClick:) forControlEvents:UIControlEventTouchDown];
//    [recordingButton addTarget:self action:@selector(stopClick:) forControlEvents:UIControlEventTouchUpInside];
//    [recordingButton addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpOutside];
    [recordingBgView addSubview:recordingButton];
//    [recordingButton addTarget:self action:@selector(remindDragExit:) forControlEvents:UIControlEventTouchDragExit];
//    [recordingButton addTarget:self action:@selector(remindDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
    
    content = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth,30)];
    content.text = @"录音时长不要超过60秒哦";
    content.textAlignment = NSTextAlignmentCenter;
    content.font = systemFontSize(14);
    content.textColor = HexRGB(0x999999);
    [recordingBgView addSubview:content];
    
    title = [[UILabel alloc]initWithFrame:CGRectMake(0, 12 +CGRectGetMaxY(recordingButton.frame), kScreenWidth,30)];
    title.text = @"点击开始录音";
    title.textAlignment = NSTextAlignmentCenter;
    title.font = systemFontSize(16);;
    title.textColor = HexRGB(0x666666);
    
    [recordingBgView addSubview:title];
    
    [self.audioRecorder pause];
  
    CGFloat countdownImgHeight = FITSCALE(38);
    self.countdownImg = [[UIImageView alloc]initWithFrame:CGRectMake(self.countdownBgView.frame.size.width/2 - countdownImgHeight/2, self.countdownBgView.frame.size.height - CGRectGetMinY(self.countdownLabel.frame)- countdownImgHeight, countdownImgHeight, countdownImgHeight)];
    self.countdownImg.image = [UIImage imageNamed:@"audio_icon_normal"];
    
    self.countdownImg.backgroundColor = [UIColor clearColor];
    [self.countdownBgView addSubview:self.countdownImg];
    
    self.circleView.hidden = YES;
}

- (void)remindDragExit:(id)sender{
  self.countdownDetail.text = @"松开手指,取消发送";
    NSLog(@"退出1------");
}

- (void)remindDragEnter:(id)sender{

    self.countdownDetail.text = @"手指上滑,取消发送";
    NSLog(@"结束----");
}
- (void)showAudioView {

    self.countdownBgView.hidden = NO;
    
}

- (void)hiddenAudioView {
    
    self.countdownBgView.hidden = YES;
    
    
    
}
- (void)tapAction:(id)tap{

    [self removeFromSuperview];
    
}
- (void)cancelClick:(id)sender{
    [self hiddenAudioView];
    
    //取消录音
    self.isCancel = YES;
    [self.audioRecorder stop];
    self.timer.fireDate=[NSDate distantFuture];
    self.vocieTime = 0;
    self.circleView.progress = 0;
    self.countdownLabel.text = @"00:00";
    
    content.text = @"录音时长不要超过60秒哦";
    title.text = @"点击开始录音";
    
}
#pragma mark - 私有方法
/**
 *  设置音频会话
 */
-(void)setAudioSession{
    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    //设置为播放和录音状态，以便可以在录制完之后播放录音
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];//启动音频会话管理,此时会阻断后台音乐的播放.
}

/**
 *  取得录音文件保存路径
 *
 *  @return 录音文件路径
 */
-(NSURL *)getSavePath{
//    NSString *urlStr=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    urlStr=[urlStr stringByAppendingPathComponent:kRecordAudioFile];
//    recordUrl = [NSURL URLWithString:[NSTemporaryDirectory() stringByAppendingString:@"selfRecord.caf"]];
//    
//    NSString *urlStr = [NSTemporaryDirectory() stringByAppendingString:kRecordAudioFile];
//    NSLog(@"file path:%@",urlStr);
//    NSURL *url=[NSURL fileURLWithPath:urlStr];
    return [NSURL URLWithString:[NSTemporaryDirectory() stringByAppendingString:kRecordAudioFile]];
}
//
///**
// *  取得录音文件设置
// *
// *  @return 录音设置
// */
-(NSDictionary *)getAudioSetting{
 
    //录音设置
    NSMutableDictionary *recordSetting = [NSMutableDictionary dictionary];
    //设置录音格式  AVFormatIDKey==kAudioFormatLinearPCM
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    //设置录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）, 采样率必须要设为11025才能使转化成mp3格式后不会失真
    [recordSetting setValue:[NSNumber numberWithFloat:11025.0] forKey:AVSampleRateKey];
    //录音通道数  1 或 2 ，要转换成mp3格式必须为双通道
    [recordSetting setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    //线性采样位数  8、16、24、32
    [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    //录音的质量
    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
    //....其他设置等
    return recordSetting;
}

/**
 *  获得录音机对象
 *
 *  @return 录音机对象
 */
-(AVAudioRecorder *)audioRecorder{
    if (!_audioRecorder) {
        //创建录音文件保存路径
        NSURL *url=[self getSavePath];
        //创建录音格式设置
        NSDictionary *setting=[self getAudioSetting];
        //创建录音机
        NSError *error=nil;
        _audioRecorder=[[AVAudioRecorder alloc]initWithURL:url settings:setting error:&error];
        _audioRecorder.delegate=self;
        _audioRecorder.meteringEnabled=YES;//如果要监控声波则必须设置为YES
        if (error) {
            NSLog(@"创建录音机对象时发生错误，错误信息：%@",error.localizedDescription);
            return nil;
        }
        

        
    }
    return _audioRecorder;
}

/**
 *  录音声波监控定制器
 *
 *  @return 定时器
 */
-(NSTimer *)timer{
    if (!_timer) {
        _timer=[NSTimer scheduledTimerWithTimeInterval:(1/10.0f) target:self selector:@selector(audioPowerChange) userInfo:nil repeats:YES];
         [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

/**
 *  录音
 */
-(void)audioPowerChange{
//    [self.audioRecorder updateMeters];//更新测量值
//    float power= [self.audioRecorder averagePowerForChannel:0];//取得第一个通道的音频，注意音频强度范围时-160到0
//    CGFloat progress=(1.0/160.0)*(power+160.0);
    CGFloat progress =   (1/(COUNTDOWN )  );
    self.circleView.progress += progress;
    if (self.circleView.progress >1) {
        
        [self recordClick:recordingButton];
        [self removeTimer];
    }
    self.vocieTime ++;
//    NSLog(@"%f===%zd==vocieTime", self.circleView.progress,self.vocieTime);
    
    NSString * minutes = @"";
    if (self.vocieTime/10 <10) {
        minutes = [NSString stringWithFormat:@"0%zd",self.vocieTime/10];
    }else{
    
        minutes = [NSString stringWithFormat:@"%zd",self.vocieTime/10];
    }
    content.text = [NSString stringWithFormat:@"00:%@",minutes];
//    content.text = @"录音时长不要超过60秒哦";
    title.text = @"录音中";
    
}

- (void)removeTimer
{
    [_timer invalidate];
    _timer = nil;
    self.vocieTime = 0;
    
}
#pragma mark - UI事件
/**
 *  点击录音按钮
 *
 *  @param sender 录音按钮
 */
- (void)recordClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected == NO) {
        
//        [self cancelClick:sender];
        self.circleView.hidden = YES;
        
        if ( self.vocieTime  < 2*10 ) {
            [self cancelClick:nil];
            [SVProgressHelper dismissWithMsg:@"录音时间为2-60秒,请重新录音"];
            return ;
            
        }
        if (self.saveRecordingBlock) {
            NSURL* mp3FilePath = [NSURL URLWithString:[NSTemporaryDirectory() stringByAppendingString:kMyselfRecordFile]];
            self.saveRecordingBlock([self getSavePath],mp3FilePath,(int)roundf(self.vocieTime/10.0));
        }
        
        [super removeFromSuperview];
        NSLog(@"录音完成!");
        return;
    }
    self.circleView.hidden = NO;
    //    [recordingButton addTarget:self action:@selector(stopClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [recordingButton addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpOutside];
//    [recordingBgView addSubview:recordingButton];
    //    [recordingButton addTarget:self action:@selector(remindDragExit:) forControlEvents:UIControlEventTouchDragExit];
    //    [recordingButton addTarget:self action:@selector(remindDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
    
    if (![self.audioRecorder isRecording]) {
        [self showAudioView];
        [self setAudioSession];
        [self.audioRecorder prepareToRecord];
        [self.audioRecorder peakPowerForChannel:0.0];
        self.isCancel = NO;
        self.vocieTime = 0;
        [self.audioRecorder record];//首次使用应用时如果调用record方法会询问用户是否允许使用麦克风
        self.timer.fireDate=[NSDate distantPast];
        
    }
}

/**
 *  点击暂定按钮
 *
 *  @param sender 暂停按钮
 */
- (void)pauseClick:(UIButton *)sender {
    if ([self.audioRecorder isRecording]) {
        [self.audioRecorder pause];
        
        self.timer.fireDate=[NSDate distantFuture];
    }
}

/**
 *  点击恢复按钮
 *  恢复录音只需要再次调用record，AVAudioSession会帮助你记录上次录音位置并追加录音
 *
 *  @param sender 恢复按钮
 */
- (void)resumeClick:(UIButton *)sender {
    [self recordClick:sender];
}

/**
 *  点击停止按钮
 *
 *  @param sender 停止按钮
 */
- (void)stopClick:(UIButton *)sender {
    
    [self performSelector:@selector(stopRecording) withObject:nil afterDelay:0.5];
  

    
}

- (void)stopRecording{

    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];  // //此处需要恢复设置回放标志，否则会导致其它播放声音也会变小
    [self.audioRecorder stop];
    
    
    
    self.timer.fireDate=[NSDate distantFuture];
}

#pragma mark - 录音机代理方法
/**
 *  录音完成，录音完成后播放录音
 *
 *  @param recorder 录音机对象
 *  @param flag     是否成功
 */
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
//    if (![self.audioPlayer isPlaying]) {
//        
////        [self.audioPlayer play];
//    }
    
    // 格式化时间
//    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
// 
//    [formatter setDateFormat:@"ss"];
//    NSDate* date = [NSDate dateWithTimeIntervalSince1970:self.audioPlayer.duration];
//    NSString* dateString = [formatter stringFromDate:date];
   
    
   
    if (!self.isCancel) {
        if ( self.vocieTime  < 2*10 ) {
            AlertView * alert = [[AlertView alloc]initWithOperationState:TNOperationState_Unknow detail:@"录音时间为2-60秒,请重新录音" items:nil];
            [alert show];
            [self cancelClick:nil];
            return ;
            
        }
        
        if (self.saveRecordingBlock) {
            NSURL* mp3FilePath = [NSURL URLWithString:[NSTemporaryDirectory() stringByAppendingString:kMyselfRecordFile]];
            self.saveRecordingBlock([self getSavePath],mp3FilePath,(int)self.vocieTime/10);
        }
    
        [super removeFromSuperview];
         NSLog(@"录音完成!");
//        [self transformCAFToMP3];
    }else{
        NSLog(@"取消本次录音");
    }
 
}

- (void)stopAudioPlayer{
    
    //关闭红外感应
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    
}

@end

#pragma mark  ----CircleView

#define KHWCircleLineWidth 4.0f
#define KHWCircleFont [UIFont boldSystemFontOfSize:26.0f]
#define KHWCircleColor project_main_blue

@interface CircleView ()

@property (nonatomic, weak) UILabel *cLabel;

@end

@implementation CircleView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        
     
    }
    
    return self;
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    _cLabel.text = [NSString stringWithFormat:@"%d%%", (int)floor(progress * 100)];
    
    [self setNeedsDisplay];
}


- (void)setupBackgroudPath{

    
        UIBezierPath *backgroudPath = [UIBezierPath bezierPath];
        //线宽
        backgroudPath.lineWidth = KHWCircleLineWidth;
        
        
        //设置颜色（颜色设置也可以放在最上面，只要在绘制前都可以）
        
        [UIColorFromRGB(0xE6E6E6) setStroke];
        //填充
        [[UIColor clearColor] setFill];
        
        //半径
        CGFloat backgroudradius = (MIN(self.frame.size.width, self.frame.size.height) - KHWCircleLineWidth) * 0.5;
        //画弧（参数：中心、半径、起始角度(3点钟方向为0)、结束角度、是否顺时针）
        
        [backgroudPath addArcWithCenter:(CGPoint){self.frame.size.width * 0.5, self.frame.size.height * 0.5} radius:backgroudradius startAngle:M_PI * 1.5 endAngle:M_PI * 1.5 + M_PI * 2 clockwise:YES];
        [backgroudPath stroke];
      
  
 }
- (void)drawRect:(CGRect)rect
{
    
    
    [self setupBackgroudPath];
    
    
    //路径
    UIBezierPath *path = [UIBezierPath bezierPath];
    //线宽
    path.lineWidth = KHWCircleLineWidth;
    //颜色
    [HexRGB(0x41A2FF) set];
    //拐角
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;
    //半径
    CGFloat radius = (MIN(rect.size.width, rect.size.height) - KHWCircleLineWidth) * 0.5;
    //画弧（参数：中心、半径、起始角度(3点钟方向为0)、结束角度、是否顺时针）
    [path addArcWithCenter:(CGPoint){rect.size.width * 0.5, rect.size.height * 0.5} radius:radius startAngle:M_PI * 1.5 endAngle:M_PI * 1.5 + M_PI * 2 * _progress clockwise:YES];
    //连线
    [path stroke];
}

@end
