
//
//  GradeListNewCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/8/2.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "GradeListNewCell.h"
#import "PublicDocuments.h"

@interface GradeListNewCell()
@property (weak, nonatomic) IBOutlet UILabel *gradeName;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;

@end
@implementation GradeListNewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.gradeName.textColor = UIColorFromRGB(0x6b6b6b);
//    self.gradeName.font = fontSize_14;
    self.bottomLine.backgroundColor = HexRGB(0xF7F7F7);
}

- (void)setupGrade:(NSString *)gradeName{

    self.gradeName.text = gradeName;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
