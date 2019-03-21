
//
//  PlaybackControlCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/7/9.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "PlaybackControlCell.h"
#import "PublicDocuments.h"
#import "UIView+CustomControlView.h"
@interface PlaybackControlCell()


@property(nonatomic, strong)IBOutlet  UIProgressView *progressView;
@property(nonatomic, assign)  NSInteger totalVoiceDuration;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;

@end
@implementation PlaybackControlCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bottomLineView.backgroundColor = HexRGB(0xF5F5F5);
//    self.timeLabel.hidden = YES;

    [self zf_playerPlayEnd];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setupVoiceDuration:(NSNumber *)voiceDuration{
    self.totalVoiceDuration = [voiceDuration integerValue];
    self.timeLabel.text = [NSString stringWithFormat:@"00:%02zd",[voiceDuration integerValue]];
}
- (IBAction)playButtonClicked:(UIButton *)button{
    
    button.selected =!button.selected;
    if ( self.playBlock) {
        self.playBlock(button.selected,self);
    }
    
    if (self.playIndexPathBlock) {
        self.playIndexPathBlock(button.selected,self,self.indexPath);
    }
    
}
- (void)zf_playerCurrentTime:(NSInteger)currentTime totalTime:(NSInteger)totalTime sliderValue:(CGFloat)value {
    // 当前时长进度progress
    NSInteger proMin = currentTime / 60;//当前分
    NSInteger proSec = currentTime % 60;//当前秒
    // duration 总时长
    NSInteger durMin = totalTime / 60;//总分
    NSInteger durSec = totalTime % 60;//总秒
    
    self.progressView.progress = value;
    //        // 更新当前播放时间
    //    self.currentTimeLabel.text       = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];
    
    NSInteger spacing = durSec-proSec;
    
    if (spacing <= 0) {
        spacing =  0;
    }
    // 更新总时间
     self.timeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", durMin, spacing];
    self.timeLabel.hidden = NO;
//    NSLog(@"%zd===proSec==%zd==self.totalVoiceDuration=%zd",self.totalVoiceDuration - proSec,proSec,self.totalVoiceDuration);
}

/** 播放完了 */
- (void)zf_playerPlayEnd {
    
    self.playButton.selected = NO;
    self.progressView.progress = 0;
    
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
//    self.timeLabel.hidden = YES;
}
@end
