

//
//  HWVoiceReportCell.m
//  TeacherPro
//
//  Created by DCQ on 2018/7/16.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//
//英语 语音报告
#import "HWZXLXVoiceReportCell.h"
#import "PublicDocuments.h"
#import "ProUtils.h"

@interface HWZXLXVoiceReportCell()
 
@property (weak, nonatomic) IBOutlet   TYMProgressBarView *progressView;
@property (weak, nonatomic) IBOutlet   UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet   UILabel *completeNumberLabel;
@property (weak, nonatomic) IBOutlet   UILabel *unitTitle;
@property (weak, nonatomic) IBOutlet UILabel *completeDesLabel;

@end

@implementation HWZXLXVoiceReportCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubViews];
}
- (void)setupSubViews{
    
    self.unitTitle.font = fontSize_13;
    self.unitTitle.textColor = UIColorFromRGB(0x3b3b3b);
    self.completeNumberLabel.font = fontSize_12;
    self.completeNumberLabel.textColor = UIColorFromRGB(0x6b6b6b);
    self.numberLabel.font = fontSize_13;
    self.numberLabel.textColor = UIColorFromRGB(0x6b6b6b);
    self.completeDesLabel.font = fontSize_12;
    self.completeDesLabel.textColor = UIColorFromRGB(0x6b6b6b);
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setupInfo:(NSDictionary *)dic{
    NSString * tempStr = @"";
    NSString * number = @"";
    if ([dic[@"practiceType"] isEqualToString:@"dctx"] ) {
        tempStr = @"个词";
        number = [NSString stringWithFormat:@"%@",dic[@"wordCount"]];
    }else{
        tempStr = @"遍";
        number =  [NSString stringWithFormat:@"%@",dic[@"nameNo"]];
    }
    self.numberLabel.text = [NSString stringWithFormat:@"%@ %@",number,tempStr];
    self.unitTitle.text = dic[@"unitName"];
    [self setupCompleteNumber:dic];
    CGFloat finishStudentF = [dic[@"finishStudentCount"] floatValue];
    CGFloat studentCountF = [dic[@"studentCount"] floatValue];
    
    CGFloat progress = 0.0f;
    if (studentCountF > 0) {
        progress =  finishStudentF/studentCountF;
    }
    [self setupProgressView:progress];
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
@end
