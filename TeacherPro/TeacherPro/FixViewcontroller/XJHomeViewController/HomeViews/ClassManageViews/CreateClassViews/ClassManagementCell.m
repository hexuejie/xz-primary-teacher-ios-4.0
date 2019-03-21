//
//  ClassManagementCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/5/11.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "ClassManagementCell.h"
#import "PublicDocuments.h"

@interface ClassManagementCell()
@property (nonatomic, weak)IBOutlet  UILabel * classLabel;
@property (nonatomic, weak)IBOutlet  UILabel * classManageImgV;
@property (weak, nonatomic) IBOutlet UIImageView *chooseImgV;

@end
@implementation ClassManagementCell
- (void)setupCellType:(CellType) type{

    if (type == CellType_create) {
        self.chooseImgV.hidden = YES;
    }else if (type == CellType_choose){
    
        self.chooseImgV.hidden = NO;
    }else if(type ==CellType_checkChoose){
    
        self.chooseImgV.hidden = YES;
    }
}
- (void)setupChooseCellSelected:(BOOL )yesOrNo{

    if (yesOrNo) {
        self.classLabel.textColor = project_main_blue;
        self.chooseImgV.highlighted =  YES;
    }else{
        self.chooseImgV.highlighted =  NO;
        self.classLabel.textColor = UIColorFromRGB(0x6b6b6b);
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UIView *backGroundView = [[UIView alloc]init];
    backGroundView.backgroundColor = [UIColor clearColor];
    self.selectedBackgroundView = backGroundView;
    self.classLabel.font = fontSize_15;
    self.classLabel.textColor = project_textgray_gray;
    self.classManageImgV.font = fontSize_13;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setupClassInfo:(ClassManageModel *)model{

    self.classLabel.text = model.clazzName;
    if ([model.adminTeacher integerValue] == 0) {
        self.classManageImgV.hidden = YES;
    }
    else  if ([model.adminTeacher integerValue] == 1) {
        self.classManageImgV.hidden = NO;
    }
}
@end
