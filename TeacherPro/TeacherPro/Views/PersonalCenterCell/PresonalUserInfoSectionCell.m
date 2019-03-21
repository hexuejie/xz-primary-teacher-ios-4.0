//
//  PresonalUserInfoSectionCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/7/20.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "PresonalUserInfoSectionCell.h"
#import "PublicDocuments.h"
@interface PresonalUserInfoSectionCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
@implementation PresonalUserInfoSectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLabel.text = @"基本信息";
    self.titleLabel.font = fontSize_14;
    self.titleLabel.textColor = UIColorFromRGB(0x6b6b6b);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
