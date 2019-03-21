//
//  HomeworkUnitDetailVoiceCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/7/12.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "HomeworkUnitDetailVoiceCell.h"
#import "PublicDocuments.h"
#import "HomeworkUnitDetailsModel.h"
@interface HomeworkUnitDetailVoiceCell()
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;


@end
@implementation HomeworkUnitDetailVoiceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubview];
}

- (void)setupSubview{

    self.titleLabel.textColor = UIColorFromRGB(0x6b6b6b);
    self.timerLabel.textColor = project_main_blue;
    self.scoreLabel.textColor = UIColorFromRGB(0x6b6b6b);
    self.bottomLineView.backgroundColor = project_background_gray;
    self.timerLabel.font = fontSize_14;
    self.scoreLabel.font = fontSize_14;
    self.titleLabel.font = fontSize_14;
    self.timerLabel.hidden = YES;
    self.progress.progress =  0;
    self.timerLabel.text = @"00:00";
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setupDetailModel:(HomeworkUnitDetailModel *)model{

    self.titleLabel.text = model.en;
    self.scoreLabel.text = [NSString stringWithFormat:@"%@分",model.score];
}


//- (CGSize)sizeThatFits:(CGSize)size {
//    CGFloat totalHeight = 0;
//    
//    totalHeight += [self.titleLabel sizeThatFits:size].height;
//    
//    totalHeight += FITSCALE(60); // margins
//    totalHeight += FITSCALE(20); // margins
//    return CGSizeMake(size.width, totalHeight);
//}
- (IBAction)playButton:(UIButton *)sender {
    sender.selected =!sender.selected;
    if (self.playIndexPathBlock) {
        self.playIndexPathBlock(sender.selected, self, self.indexPath);
    }
    
}


- (void)zf_playerCurrentTime:(NSInteger)currentTime totalTime:(NSInteger)totalTime sliderValue:(CGFloat)value {
    // 当前时长进度progress
    NSInteger proMin = currentTime / 60;//当前分
    NSInteger proSec = currentTime % 60;//当前秒
    // duration 总时长
    NSInteger durMin = totalTime / 60;//总分
    NSInteger durSec = totalTime % 60;//总秒
    
    self.progress.progress = value;
    //        // 更新当前播放时间
    //    self.currentTimeLabel.text       = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];
    
    // 更新总时间
    
    NSInteger spacing = durSec-proSec;
    
    if (spacing <= 0) {
        spacing =  0;
    }
    self.timerLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", durMin, spacing];
    self.timerLabel.hidden = NO;
    
}

/** 播放完了 */
- (void)zf_playerPlayEnd {
    
    self.playBtn.selected = NO;
    self.progress.progress = 0;
    
}

/**  加载失败 */
- (void)zf_playerItemStatusFailed:(NSError *)error {
    self.playBtn.selected = NO;
    self.progress.progress = 0;
}
- (void)resetVoiceView{
    
    self.playBtn.selected = NO;
    self.progress.progress = 0;
    self.timerLabel.text = [NSString stringWithFormat:@"00:00"];
    self.timerLabel.hidden = YES;
}
@end
