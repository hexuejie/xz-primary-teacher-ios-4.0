
//
//  SubjectsNewTitleCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/8/2.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "SubjectsNewTitleCell.h"
#import "PublicDocuments.h"
@interface SubjectsNewTitleCell()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;

@end
@implementation SubjectsNewTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.title.text = @"选择科目";
    self.title.font = fontSize_14;
    self.title.textColor = UIColorFromRGB(0x6b6b6b);
    self.bottomLine.backgroundColor = project_line_gray;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
