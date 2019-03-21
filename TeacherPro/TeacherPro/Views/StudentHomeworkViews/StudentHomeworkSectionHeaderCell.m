
//
//  StudentHomeworkSectionHeaderCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/7/9.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "StudentHomeworkSectionHeaderCell.h"
#import "PublicDocuments.h"

@interface StudentHomeworkSectionHeaderCell()

@end

@implementation StudentHomeworkSectionHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupSubview];
}

- (void)setupSubview{
    
    self.imgV.backgroundColor = [UIColor whiteColor];
//    self.nameLabel.textColor = UIColorFromRGB(0x434343);
    self.nameLabel.textColor = UIColorFromRGB(0x6b6b6b);
    self.nameLabel.font = fontSize_14;
//    self.bgView.backgroundColor = UIColorFromRGB(0xD1E4FD);
    self.bgView.backgroundColor = [UIColor whiteColor];
    
}
- (void)setupName:(NSString *)name{
    
    self.nameLabel.text = name;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
