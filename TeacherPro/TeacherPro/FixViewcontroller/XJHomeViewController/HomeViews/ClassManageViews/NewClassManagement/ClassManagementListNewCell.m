

//
//  ClassManagementListNewCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/8/2.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "ClassManagementListNewCell.h"
#import "ClassManageModel.h"
#import "PublicDocuments.h"
#import "UIImageView+WebCache.h"
@interface   ClassManagementListNewCell()
@property (weak, nonatomic) IBOutlet UIImageView *classImgIcon;
@property (weak, nonatomic) IBOutlet UILabel *className;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *adminIconImgV;
@property (weak, nonatomic) IBOutlet UIView *bottomLineV;

@end

@implementation ClassManagementListNewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubview];
}

- (void)setupSubview{

    
    self.bottomLineV.backgroundColor = project_line_gray;
    
    
}

- (void)setupClassInfo:(ClassManageModel *)model{

    self.className.text = [NSString stringWithFormat:@"%@%@",model.gradeName,model.clazzName];
    self.detailLabel.text = @"";
    self.detailLabel.hidden = YES;
    self.adminIconImgV.hidden = NO;
    if ([model.adminTeacher integerValue] == 1) {//管理员
        self.adminIconImgV.image = [UIImage imageNamed:@"class_management_admin"];
        
    }else{
        self.adminIconImgV.image = [UIImage imageNamed:@"class_management_teach"];
    }
    [self.classImgIcon sd_setImageWithURL:[NSURL URLWithString:model.clazzLogo] placeholderImage:[UIImage imageNamed:@"student_img"]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
