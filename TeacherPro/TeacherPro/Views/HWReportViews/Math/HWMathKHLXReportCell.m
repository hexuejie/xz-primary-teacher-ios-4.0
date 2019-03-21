
//
//  HWMathKHLXReportCellCell.m
//  TeacherPro
//
//  Created by DCQ on 2018/7/30.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "HWMathKHLXReportCell.h"
#import "TYMProgressBarView.h"
#import "PublicDocuments.h"
#import "ProUtils.h"
@interface HWMathKHLXReportCell()
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet TYMProgressBarView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *completeLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *completeTitleLabel;

@end
@implementation HWMathKHLXReportCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubView];
}

- (void)setupSubView{
    
    self.completeLabel.font = fontSize_13;
    self.itemCountLabel.font = fontSize_14;
    self.unitLabel.font = fontSize_14;
    self.completeTitleLabel.font = fontSize_13;
    
    self.unitLabel.textColor = UIColorFromRGB(0x3b3b3b);
    self.completeLabel.textColor = UIColorFromRGB(0x6b6b6b);
    self.itemCountLabel.textColor = UIColorFromRGB(0x6b6b6b);
    self.completeTitleLabel.textColor = UIColorFromRGB(0x6b6b6b);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setupInfo:(NSDictionary *)dic{
    self.unitLabel.text = dic[@"unitName"];
 
    self.itemCountLabel.text = [NSString stringWithFormat:@"共%@题",dic[@"questionCount"]];
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
    
    self.completeLabel.attributedText = completeTextAtrDes;
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

