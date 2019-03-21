//
//  JoinClassListCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/5/10.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "JoinClassListCell.h"
#import "ClassManageModel.h"
@interface JoinClassListCell()
@property (weak, nonatomic) IBOutlet UILabel *className;
@property (weak, nonatomic) IBOutlet UILabel *classAdministrator;

@property (weak, nonatomic) IBOutlet UILabel *classNumber;
@property (weak, nonatomic) IBOutlet UIImageView *applyImgV;

@end
@implementation JoinClassListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.applyImgV.hidden = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setupCellInfo:(ClassManageModel *)model{

    self.className.text = [NSString stringWithFormat:@"%@ %@",model.gradeName,model.clazzName];
    self.classAdministrator.text = [NSString stringWithFormat:@"管理员: %@ (%@)",model.adminName,model.adminPhone];

    self.classNumber.text = [NSString stringWithFormat:@"教师%@名 学生%@名",model.teacherCount,model.studentCount];
}
@end
