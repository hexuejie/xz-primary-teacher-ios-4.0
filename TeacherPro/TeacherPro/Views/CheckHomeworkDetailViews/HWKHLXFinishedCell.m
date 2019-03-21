

//
//  HWKHLXFinishedCell.m
//  TeacherPro
//
//  Created by DCQ on 2018/7/20.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "HWKHLXFinishedCell.h"
#import "PublicDocuments.h"
#import "UIImageView+WebCache.h"
@interface HWKHLXFinishedCell()
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
@property (weak, nonatomic) IBOutlet UILabel *studentName;
@property (weak, nonatomic) IBOutlet UILabel *hwState;
@property (weak, nonatomic) IBOutlet UILabel *rightNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *errorNumberLabel;

@end
@implementation HWKHLXFinishedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self  setupSubView];
}
- (void)setupSubView{
    
    self.studentName.textColor = UIColorFromRGB(0x6b6b6b);
    self.studentName.font = fontSize_13;
    self.hwState.font = fontSize_13;
    self.rightNumberLabel.font = fontSize_13;
    self.errorNumberLabel.font = fontSize_13;
    self.rightNumberLabel.textColor = UIColorFromRGB(0x6b6b6b);
    self.errorNumberLabel.textColor = UIColorFromRGB(0x6b6b6b);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setupStudentDic:(NSDictionary *)studentDic  {
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
    self.hwState.text = @"已完成";
    self.hwState.textColor = UIColorFromRGB(0x9b9b9b);
    
    self.rightNumberLabel.text =[NSString stringWithFormat:@"%@",studentDic[@"rightQuestionCount"]];
    self.errorNumberLabel.text =  [NSString stringWithFormat:@"%@",studentDic[@"errorQuestionCount"]];
    self.rightNumberLabel.textColor = UIColorFromRGB(0x3b3b3b);
    self.errorNumberLabel.textColor = UIColorFromRGB(0x3b3b3b);
}
@end
