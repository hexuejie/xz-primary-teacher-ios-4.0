
//
//  HWReportDetailSpellingCell.m
//  TeacherPro
//
//  Created by DCQ on 2018/7/25.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "HWReportDetailSpellingCell.h"
#import "TYMProgressBarView.h"
#import "PublicDocuments.h"
#import "ProUtils.h"

@interface HWReportDetailSpellingCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet TYMProgressBarView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *completeLabel;

@end
@implementation HWReportDetailSpellingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubViews];
}
// Initialization code
- (void)setupSubViews{
    self.titleLabel.textColor = UIColorFromRGB(0x3b3b3b);
    self.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    self.numberLabel.font = fontSize_13;
    self.numberLabel.textColor = UIColorFromRGB(0x6b6b6b);
    self.completeLabel.font = fontSize_13;
    self.completeLabel.textColor = UIColorFromRGB(0x6b6b6b);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setupInfo:(NSDictionary *)dic{
    self.titleLabel.text = dic[@"typeCn"];
    
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
    
    self.numberLabel.attributedText = completeTextAtrDes;
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
