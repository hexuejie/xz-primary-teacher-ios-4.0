//
//  HWReportVoiceCell.m
//  TeacherPro
//
//  Created by DCQ on 2018/8/1.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "HWReportVoiceCell.h"
#import "PublicDocuments.h"
@interface HWReportVoiceCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UILabel *playTitleLabel;

@end
@implementation HWReportVoiceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLabel.text = @"有一条作业语音";
    self.titleLabel.font = fontSize_13;
    self.titleLabel.textColor = UIColorFromRGB(0x6b6b6b);
    self.playTitleLabel.font = fontSize_13;
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)playVoice:(UIButton *)sender {
    if (self.playblock) {
        self.playblock(sender,self.playTitleLabel);
    }

}
- (UIButton *)getPlayBtn{
    
    return self.playBtn;
}

- (UILabel *)getPlayTitleLabel{
    
    return self.playTitleLabel;
}
@end
