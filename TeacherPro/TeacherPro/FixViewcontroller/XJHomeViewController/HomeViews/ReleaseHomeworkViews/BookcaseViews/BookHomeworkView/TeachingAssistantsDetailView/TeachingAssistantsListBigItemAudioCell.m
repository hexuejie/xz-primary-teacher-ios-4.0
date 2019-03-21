//
//  TeachingAssistantsListBigItemAudioCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/12/18.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "TeachingAssistantsListBigItemAudioCell.h"
#import "PublicDocuments.h"
#import "AssistantsQuestionModel.h"
#import "ZFPlayer.h"
#import "UIView+CustomControlView.h"
@interface TeachingAssistantsListBigItemAudioCell ()
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (nonatomic, copy) NSString * urlAudio;
@property (weak, nonatomic) IBOutlet UIButton *playBtn; 

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property(weak, nonatomic) IBOutlet UIView * lineView;
@end
@implementation TeachingAssistantsListBigItemAudioCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubview];
     [self zf_playerPlayEnd];
}

- (void)setupSubview{
    self.timerLabel.textColor = UIColorFromRGB(0x747474);
    self.lineView.backgroundColor = project_line_gray;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

//- (void)setupModel:(QuestionAnalysisAudioModel *)model{
//    NSInteger timer = 0;
//    if (model) {
//        self.urlAudio = model.voice;
//         timer = timer  + [model.playTime integerValue];
//    }
//    
//    NSInteger second = timer/1000;
//    NSString * timerStr = [self getMMSSFromSS:second];
//
//    self.timerLabel.text = timerStr;
//}

-(NSString *)getMMSSFromSS:(NSInteger )totalTime{
    
    NSInteger seconds = totalTime  ;
    
    //format of hour
    //    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    
    return format_time;
}


- (void)setupVoiceDuration:(NSString *)voiceDuration{
    NSInteger second = [voiceDuration integerValue]/1000;
    NSString * timerStr = [self getMMSSFromSS:second];

    self.timerLabel.text = timerStr;
}
- (IBAction)playAction:(UIButton *)sender {
 
    sender.selected = !sender.selected;
    
    if (self.playIndexPathBlock) {
        self.playIndexPathBlock(sender.selected,self,self.indexPath);
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
    self.timerLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", durMin, spacing];
    self.timerLabel.hidden = NO;
    //    NSLog(@"%zd===proSec==%zd==self.totalVoiceDuration=%zd",self.totalVoiceDuration - proSec,proSec,self.totalVoiceDuration);
}

/** 播放完了 */
- (void)zf_playerPlayEnd {
    
    self.playBtn.selected = NO;
    self.progressView.progress = 0;
    
}

/**  加载失败 */
- (void)zf_playerItemStatusFailed:(NSError *)error {
    
    self.playBtn.selected = NO;
    self.progressView.progress = 0;
}

- (void)zf_playerItemPause{
     self.playBtn.selected = NO;
}
- (void)zf_playerItemStartPlayer{
    self.playBtn.selected = YES;
}
- (void)resetVoiceView{
    
    self.playBtn.selected = NO;
    self.progressView.progress = 0;
    self.timerLabel.text = [NSString stringWithFormat:@"00:00"];
    self.timerLabel.hidden = YES;
}
@end
