
//
//  HomeworkProblemsChapterSectionCell.m
//  TeacherPro
//
//  Created by DCQ on 2018/1/19.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "HomeworkProblemsChapterSectionCell.h"
#import "PublicDocuments.h"

@interface HomeworkProblemsChapterSectionCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *isChooseImgV;
@property (weak, nonatomic) IBOutlet UIView *lineV;

@end
@implementation HomeworkProblemsChapterSectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubview];
}

- (void)setupSubview{
    
    self.titleLabel.textColor =  UIColorFromRGB(0x6b6b6b);
    self.titleLabel.font = fontSize_14;
    self.lineV.backgroundColor = project_line_gray;
    self.isChooseImgV.hidden = NO;
}

- (void)setupTitle:(NSString *)titleStr withIsSelected:(BOOL)selected{
    
    self.titleLabel.text = titleStr;
    NSString * imgName  = @"";
    if (selected) {
        imgName = @"problems_selected.png";
    }else{
        imgName = @"problems_no_selected.png";
    }
    self.isChooseImgV.image = [UIImage imageNamed:imgName];
}
- (void)setupShowChooseImgVSate:(BOOL)YesOrNo{
    if (YesOrNo) {
 
        self.titleLabel.textColor =  UIColorFromRGB(0x6b6b6b);
    }else{
 
        self.titleLabel.textColor =  UIColorFromRGB(0xC1C1C1);
    }
//    self.isChooseImgV.hidden = !YesOrNo;
}
 
@end
