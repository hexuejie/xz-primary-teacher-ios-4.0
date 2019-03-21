//
//  CheckHomeworkBookUnitSectionCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/7/31.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//
// 单元标题
#import "CheckHomeworkDetailBookUnitSectionCell.h"
#import "PublicDocuments.h"

@interface CheckHomeworkDetailBookUnitSectionCell()
@property (weak, nonatomic) IBOutlet UILabel *unitTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;

@end
@implementation CheckHomeworkDetailBookUnitSectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.unitTitleLabel.textColor = UIColorFromRGB(0x434343);
//    self.unitTitleLabel.font = fontSize_14;
    self.bottomLine.backgroundColor = HexRGB(0xF5F5F5);
}

- (void)setupUnitTitle:(NSString *)title{

    self.unitTitleLabel.text = title;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
