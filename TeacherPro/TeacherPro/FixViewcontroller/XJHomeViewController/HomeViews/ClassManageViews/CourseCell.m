//
//  CourseCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/5/11.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "CourseCell.h"
#import "PublicDocuments.h"
@interface CourseCell ()
@property(nonatomic, weak) IBOutlet UILabel * courseLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImgV;
@end
@implementation CourseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.courseLabel.font = fontSize_15;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setupCourseInfo:(CourseModel *)model{

    self.courseLabel.text = model.dicValue;
    
}
- (void)setupCellState:(BOOL )state{

    if (!state) {
        self.selectedImgV.image = [UIImage imageNamed:@"class_btn_no_selected"];
    }else{
         self.selectedImgV.image = [UIImage imageNamed:@"class_btn_selected"];
    }
    
}
@end
