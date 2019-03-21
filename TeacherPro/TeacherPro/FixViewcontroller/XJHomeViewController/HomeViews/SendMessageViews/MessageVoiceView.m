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
//  MessageVoiceView.m
//  TeacherPro
//
//  Created by DCQ on 2017/6/29.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "MessageVoiceView.h"
#import "UIView+SDAutoLayout.h"
#import "PublicDocuments.h"
#import "UIView+CustomControlView.h"
@interface MessageVoiceView ()


@end
@implementation MessageVoiceView

- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{

    self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playButton setBackgroundImage: [UIImage imageNamed:@"homework_voice_normal"] forState:UIControlStateNormal];
    [self.playButton setBackgroundImage:[UIImage imageNamed:@"homework_voice_selected"] forState:UIControlStateSelected];
    [self.playButton addTarget:self action:@selector(playButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.playButton.selected = NO;
    [self addSubview:self.playButton];
    
    
 
    
    self.progressView = [[UIProgressView alloc]init];
    self.progressView.progress =  0;
    self.progressView.trackImage = [UIImage imageNamed:@"progress_backgrounp"];
    self.progressView.progressTintColor = project_main_blue;
    
    [self addSubview:self.progressView];
    
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.font = fontSize_11;
    self.timeLabel.textColor = project_main_blue;
    self.timeLabel.text = @"00:00";
    self.timeLabel.backgroundColor = [UIColor clearColor];
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.timeLabel];
    self.timeLabel.hidden = YES;
    
    UIView *contentView = self;
    CGFloat margin = 10;
    
    self.playButton.sd_layout
    .leftSpaceToView(contentView, margin)
    .centerYEqualToView(contentView)
    .widthIs(FITSCALE(25))
    .heightIs(FITSCALE(25));


    
    self.progressView.sd_layout
    .leftSpaceToView(self.playButton,margin)
    .centerYEqualToView(self.playButton)
    .rightSpaceToView(self, margin*3)
    .heightIs(4);
    
    
    self.timeLabel.sd_layout
    .rightEqualToView(self.progressView)
    .topSpaceToView(self.progressView, 0)
    .bottomEqualToView(self)
    .widthIs(FITSCALE(50));
  
}
- (void)setupVoiceDuration:(NSNumber *)voiceDuration{
    self.totalVoiceDuration = [voiceDuration integerValue];
    NSInteger  duration = [voiceDuration integerValue];
    self.timeLabel.text = [NSString stringWithFormat:@"00:%02zd",duration];
}
- (void)playButtonClicked:(UIButton *)button{

    button.selected =!button.selected;
    if ( self.playBlock) {
        self.playBlock(button.selected);
    }
    
}
- (void)zf_playerCurrentTime:(NSInteger)currentTime totalTime:(NSInteger)totalTime sliderValue:(CGFloat)value {
    // 当前时长进度progress
    NSInteger proMin = currentTime / 60;//当前分钟
    NSInteger proSec = currentTime % 60;//当前秒
    // duration 总时长
    NSInteger durMin = totalTime / 60;//总分钟
    NSInteger durSec = totalTime % 60;//总秒
    self.progressView.progress = value;
    self.timeLabel.hidden = NO;
    NSInteger spacing = durSec-proSec;
    
    if (spacing <= 0) {
        spacing =  0;
    }
    self.timeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", durMin, spacing];
//    NSLog(@"%zd===proSec==%zd==self.totalVoiceDuration=%zd",self.totalVoiceDuration - proSec,proSec,self.totalVoiceDuration);
}

/** 播放完了 */
- (void)zf_playerPlayEnd {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self resetVoiceView];
    });
}

/**  加载失败 */
- (void)zf_playerItemStatusFailed:(NSError *)error {
   self.playButton.selected = NO;
    self.progressView.progress = 0;
}
- (void)resetVoiceView{

    self.playButton.selected = NO;
    self.progressView.progress = 0;
    self.timeLabel.text = [NSString stringWithFormat:@"00:00"];
    self.timeLabel.hidden = YES;
}
@end
