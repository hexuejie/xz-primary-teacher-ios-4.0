
//
//  JoinSearchNewClassListCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/8/3.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "JoinSearchNewClassListCell.h"
#import "QueryTeacherClass.h"
#import "PublicDocuments.h"
#import "UIImageView+WebCache.h"
@interface JoinSearchNewClassListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *classImgIcon;
@property (weak, nonatomic) IBOutlet UILabel *className;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *adminIconImgV;
@property (weak, nonatomic) IBOutlet UIView *bottomLineV;

@property (weak, nonatomic) IBOutlet UIImageView *stateImgV;
@end
@implementation JoinSearchNewClassListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubview];
}

- (void)setupSubview{
    self.className.textColor = UIColorFromRGB(0x6b6b6b);
    self.className.font = fontSize_14;
    
    self.detailLabel.textColor = UIColorFromRGB(0x9f9f9f);
    self.detailLabel.font = fontSize_14;
    
    self.bottomLineV.backgroundColor = project_line_gray;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setupClassInfo:(QueryTeacherClass *)model{

    [self.classImgIcon sd_setImageWithURL:[NSURL URLWithString:model.clazzLogo] placeholderImage:[UIImage imageNamed:@"student_img"]];
    self.className.text = [NSString stringWithFormat:@"%@%@",model.gradeName,model.clazzName];
    self.detailLabel.text = @"任教老师";
    if ([model.adminTeacher integerValue] == 1) {
        self.adminIconImgV.hidden = NO;
        self.detailLabel.hidden = YES;
    }else{
        self.adminIconImgV.hidden = YES;
        self.detailLabel.hidden = NO;
    }
    if ([model.isJoin integerValue] == 1) {
        self.stateImgV.image = [UIImage imageNamed:@"join_search_new_class"];
    }else{
    
        if ([model.isApply integerValue] == 1) {
            self.stateImgV.image = [UIImage imageNamed:@"join_search_new_Apply_class"];
        }else{
        
            self.stateImgV.image = [UIImage imageNamed:@"join_search_new_noApply_class"];
        }
    }

}
@end
