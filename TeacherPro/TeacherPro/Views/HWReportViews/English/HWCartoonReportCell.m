


//
//  HWCartoonReportCell.m
//  TeacherPro
//
//  Created by DCQ on 2018/7/16.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//
///// 绘本报告
#import "HWCartoonReportCell.h"
#import "PublicDocuments.h"
#import "ProUtils.h"
@interface HWCartoonReportCell()
@property (weak, nonatomic) IBOutlet   TYMProgressBarView *progressView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *completeNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *completeTitle;

@end
@implementation HWCartoonReportCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubViews];
}
- (void)setupSubViews{
    self.titleLabel.font = fontSize_13;
    self.titleLabel.textColor = UIColorFromRGB(0x3b3b3b);
    
    self.completeNumberLabel.textColor = UIColorFromRGB(0x6b6b6b);
    self.completeNumberLabel.font = fontSize_12;
    
    self.completeTitle.textColor = UIColorFromRGB(0x6b6b6b);
    self.completeTitle.font = fontSize_12;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setupInfo:(NSDictionary *)dic{
    
    [self setupCompleteNumber:dic];
    CGFloat finishStudentF = [dic[@"finishStudentCount"] floatValue];
    CGFloat studentCountF = [dic[@"studentCount"] floatValue];
    CGFloat progress = 0.0f;
    if (studentCountF > 0) {
        progress =  finishStudentF/studentCountF;
    }
    [self setupProgressView:progress];
    [self setupIconAndTitle:dic];
}
- (void)setupCompleteNumber:(NSDictionary *)dic{
    NSString * completeTextDes =  [NSString stringWithFormat:@"%@/%@人",dic[@"finishStudentCount"],dic[@"studentCount"]];
    NSArray * colors = @[UIColorFromRGB(0x30B9B8)];
    NSRange range1 = [completeTextDes rangeOfString:[NSString stringWithFormat:@"%ld",[dic[@"finishStudentCount"] integerValue]]];
    
    NSArray * ranges = @[NSStringFromRange(range1)  ];
    NSArray * fonts = @[fontSize_13];
    
    NSAttributedString * completeTextAtrDes = [ProUtils confightAttributedText:completeTextDes withColors:colors withRanges:ranges withFonts:fonts];
    
    self.completeNumberLabel.attributedText = completeTextAtrDes;
}
- (void)setupProgressView:(CGFloat)progress{
    
    self.progressView.barBorderWidth = 1.0f;
//    self.progressView.barBorderColor = UIColorFromRGB(0x30B9B8);
    self.progressView.barBorderColor = [UIColor clearColor];
    self.progressView.barBackgroundColor = UIColorFromRGB(0xEFEFEF);
    self.progressView.barInnerPadding = 0.0f;
    self.progressView.progress = progress;
    if (progress == 0.0f) {
        self.progressView.barFillColor =  UIColorFromRGB(0xEFEFEF);
    }else{
        self.progressView.barFillColor = UIColorFromRGB(0x30B9B8);
        
    }
    
}
- (void)setupIconAndTitle:(NSDictionary *)dic{
     NSString * titleStr  = dic[@"typeName"];
    NSString * iconImgName = @"";
 
    if ([dic[@"type"] isEqualToString:@"hbxt"]) {
        iconImgName = @"cartoon_practice_icon.png";//绘本习题
        
    }else if ([dic[@"type"] isEqualToString:@"yyyd"]) {
        iconImgName = @"cartoon_reading_icon";//原音阅读
     
    }else if ([dic[@"type"] isEqualToString:@"chxx"]) {
        iconImgName = @"cartoon_vocabulary_icon";//词汇练习
  
    }else if ([dic[@"type"] isEqualToString:@"hbpy"]) {
        iconImgName = @"cartoon_voice_icon";//绘本配音
        
    }
 
    self.iconImgV.image = [UIImage imageNamed:iconImgName];
    self.titleLabel.text = titleStr;
}
@end
