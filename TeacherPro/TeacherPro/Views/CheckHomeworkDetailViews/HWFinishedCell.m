
//
//  HWFinishedCell.m
//  TeacherPro
//
//  Created by DCQ on 2018/7/12.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "HWFinishedCell.h"
#import "PublicDocuments.h"
#import "ProUtils.h"
#import "UIImageView+WebCache.h"
@interface HWFinishedCell()

@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
@property (weak, nonatomic) IBOutlet UILabel *studentName;
@property (weak, nonatomic) IBOutlet UILabel *hwState;
@property (weak, nonatomic) IBOutlet UIImageView *jfWarnImgV;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImgV;

@end
@implementation HWFinishedCell

 
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubView];
}

- (void)setupSubView{
    
    self.studentName.textColor = UIColorFromRGB(0x6b6b6b);
    self.studentName.font = fontSize_13;
    self.hwState.font = fontSize_13;
}
- (void)setupStudentDic:(NSDictionary *)studentDic withJF:(BOOL)isJF{
    NSString * avatar = studentDic[@"avatar"];
    NSString * placeholderImgName = @"";
    if ([studentDic[@"sex"] isEqualToString:@"female"]) {
        placeholderImgName =  @"student_wuman";
    }else if ([studentDic[@"sex"] isEqualToString:@"male"]){
        placeholderImgName =  @"student_man";
    }else{
        placeholderImgName =  @"student_wuman";
    }
    [self.imgIcon  sd_setImageWithURL:[NSURL URLWithString:avatar]placeholderImage:  [UIImage imageNamed:placeholderImgName]];
    self.studentName.text = studentDic[@"studentName"];
   
    if (isJF) {
        if (studentDic[@"unknowQuestions"] && [studentDic[@"unknowQuestions"] count] > 0) {
            //有题不会做
            self.hwState.text = @"有题不会做";
            self.hwState.textColor = UIColorFromRGB(0xFAA947);
             [self hiddenArrow:NO];
        }else{
            self.hwState.text = @"已完成";
            self.hwState.textColor = UIColorFromRGB(0x9b9b9b);
            self.jfWarnImgV.hidden = YES;
            [self hiddenArrow:YES];
        }
    }else{
        if (studentDic[@"scoreLevel"]) {
            NSString * textStr = [NSString stringWithFormat:@"作业评分: %@",studentDic[@"scoreLevel"]];
            NSRange range = NSRangeFromString(studentDic[@"scoreLevel"]);
            NSAttributedString * hwStateAttr = [ProUtils  setAttributedText:textStr withColor:UIColorFromRGB(0xF66A67) withRange:range withFont:fontSize_13];
            self.hwState.attributedText = hwStateAttr;
        }else{
            self.hwState.text = @"已完成";
        }
        
        self.hwState.textColor = UIColorFromRGB(0x9b9b9b);
        self.jfWarnImgV.hidden = YES;
    }

 
}

- (void)hiddenArrow:(BOOL)hidden{
    
    self.arrowImgV.hidden = hidden;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
