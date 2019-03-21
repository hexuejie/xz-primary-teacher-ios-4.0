//
//  LeftGradeCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/5/11.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "LeftGradeCell.h"
#import "PublicDocuments.h"

@interface LeftGradeCell()
@property (weak, nonatomic) IBOutlet UILabel *gradeNameLabel;
@property (weak, nonatomic) IBOutlet UIView *gradeBgView;

@end
@implementation LeftGradeCell

- (void)setupBackgroundView:(UIColor *)color textColor:(UIColor *)textColor layerColor:(UIColor *)layerColor{

    self.gradeBgView.backgroundColor = color;
    self.gradeNameLabel.textColor = textColor;
    self.gradeBgView.layer.borderColor = layerColor.CGColor;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    UIView *backGroundView = [[UIView alloc]init];
//    backGroundView.backgroundColor = UIColorFromRGB(0xD1E5FF);
//    self.selectedBackgroundView = backGroundView;
     self.gradeNameLabel.font = fontSize_15;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
   
      
        //以下自定义控件
    }
    return self;
}

- (void)setupCellInfo:(NSString *)grade withManagerClass:(NSString *)managerName withJoinClass:(NSString *)joinName{
    NSString * gradeStr;
    gradeStr =  grade;
    
    NSUInteger allClass = 0;
    if (managerName) {
        allClass =  allClass + [managerName integerValue];
//        gradeStr = [NSString stringWithFormat:@"%@\n管理%@个班",gradeStr,managerName];
    }
    
    if (joinName) {
//        gradeStr = [NSString stringWithFormat:@"%@\n加入%@个班",gradeStr,joinName];
        allClass =  allClass + [joinName integerValue];
    }
    
    if (allClass > 0) {
          gradeStr = [NSString stringWithFormat:@"%@\n共%zd个班",gradeStr,allClass];
    }
    NSString * tempStr =[gradeStr stringByReplacingOccurrencesOfString:grade withString:@""];
    
      NSRange range= [gradeStr  rangeOfString:[NSString stringWithFormat:@"%@",tempStr ]];
    self.gradeNameLabel.attributedText = [self setAttributedText:gradeStr withRange:range];

    self.gradeNameLabel.numberOfLines = 0;
}

- (NSAttributedString *)setAttributedText:(NSString *)text   withRange:(NSRange )range{
    
    NSMutableAttributedString *Attributed  = [[NSMutableAttributedString alloc]initWithString:text];
    
    
    
    
    [Attributed addAttribute:NSFontAttributeName
     
                       value: fontSize_12
     
                       range:range];
    return Attributed;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
