//
//  TeachingAssistantsListItemAudioCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/11/7.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "TeachingAssistantsListItemAudioCell.h"

@interface TeachingAssistantsListItemAudioCell()
@property (weak, nonatomic) IBOutlet UIImageView *playImgV;

@end

@implementation TeachingAssistantsListItemAudioCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setupPlayState:(BOOL)state{
    NSString * imageName = @"";
    if (state) {
        imageName = @"play_left_icon_1.png";
    }else{
        imageName = @"play_left_icon.png";
    }
    self.playImgV.image = [UIImage imageNamed:imageName];
    
}
@end
