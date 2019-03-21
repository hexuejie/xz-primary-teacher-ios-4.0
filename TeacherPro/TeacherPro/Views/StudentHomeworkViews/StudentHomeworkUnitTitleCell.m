//
//  StudentHomeworkUnitTitleCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/7/31.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "StudentHomeworkUnitTitleCell.h"
#import "PublicDocuments.h"
@interface StudentHomeworkUnitTitleCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
@implementation StudentHomeworkUnitTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubview];
}
- (void)setupSubview{

    self.titleLabel.textColor = UIColorFromRGB(0x434343);
    self.titleLabel.font = fontSize_14;
}
- (void)setupUnitTitle:(NSString *)title{

    self.titleLabel.text = title;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
