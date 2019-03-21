
//
//  HomeworkProblemsUnitSectionCell.m
//  TeacherPro
//
//  Created by DCQ on 2018/1/19.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "HomeworkProblemsUnitSectionCell.h"
#import "PublicDocuments.h"

@interface HomeworkProblemsUnitSectionCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *isChooseImgV;
@property (weak, nonatomic) IBOutlet UIView *lineV;
@end
@implementation HomeworkProblemsUnitSectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubview];
}

- (void)setupSubview{
    
    self.titleLabel.textColor =  project_main_blue;
    self.titleLabel.font = fontSize_14;
    self.isChooseImgV.hidden = NO;
    [self setupShowChooseImgVSate:NO];
    
     self.lineV.backgroundColor = project_line_gray;
}

- (void)setupTitle:(NSString *)titleStr withIsSelected:(BOOL)selected{
    
    self.titleLabel.text = titleStr;
    NSString * imgName  = @"";
    if (selected) {
        imgName = @"problems_selected.png";
    }else{
        imgName = @"problems_no_selected.png";
    }
     self.isChooseImgV.hidden = NO;
    self.isChooseImgV.image = [UIImage imageNamed:imgName];
}

- (void)setupShowChooseImgVSate:(BOOL)yesOrNo{
    
    if (yesOrNo) {
//        self.isChooseImgV.hidden = NO;
           self.titleLabel.textColor =  project_main_blue;
    }else{
//        self.isChooseImgV.hidden = YES;
           self.titleLabel.textColor =  UIColorFromRGB(0xC1C1C1);
    }
}
- (void)setupDefaultUnitTitle{
    self.isChooseImgV.hidden = YES;
    self.titleLabel.textColor =  project_main_blue;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
