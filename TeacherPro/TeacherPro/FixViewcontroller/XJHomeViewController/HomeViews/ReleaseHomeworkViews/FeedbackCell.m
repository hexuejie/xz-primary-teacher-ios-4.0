//
//  FeedbackCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/6/5.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "FeedbackCell.h"
#import "FeedbackModel.h"
#import "CommonConfig.h"
#import "UIImageView+WebCache.h"

@interface FeedbackCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;
@property (weak, nonatomic) IBOutlet UIImageView *stateImgV;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *lineImgV;

@end
@implementation FeedbackCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.lineImgV.backgroundColor  = HexRGB(0xF7F7F7);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setupCellInfo:(FeedbackModel *)model withSelected:(BOOL)state{

//    NSURL * iconUrl = [NSURL URLWithString:model.logo ];
//    [self.iconImgV sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageNamed:@"feedback_defult"]];
    self.iconImgV.image = [UIImage imageNamed:model.logo];
    self.detailLabel.text  = [NSString stringWithFormat:@"%@",model.des];
    self.titleLabel.text = [NSString stringWithFormat:@"%@",model.name];
    
    self.stateImgV.hidden = !state;
    
}


@end
