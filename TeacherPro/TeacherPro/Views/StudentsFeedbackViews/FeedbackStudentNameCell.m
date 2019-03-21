//
//  FeedbackStudentNameCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/7/9.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "FeedbackStudentNameCell.h"
#import "PublicDocuments.h"
@interface FeedbackStudentNameCell()
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *studentNameLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@end
@implementation FeedbackStudentNameCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubview];
}

- (void)setupSubview{

//    self.imgV.backgroundColor = project_main_blue;
//    self.studentNameLabel.textColor = UIColorFromRGB(0x6b6b6b);
//    self.studentNameLabel.font = fontSize_14;
//    
//    self.bgView.backgroundColor = UIColorFromRGB(0xD1E4FD);
    self.lineView.backgroundColor = project_line_gray;
    
}
- (void)setupStudentName:(NSString *)studentName{

    self.studentNameLabel.text = studentName;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
