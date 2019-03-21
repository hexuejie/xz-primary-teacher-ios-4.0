

//
//  HWJFBookReportCell.m
//  TeacherPro
//
//  Created by DCQ on 2018/7/31.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "HWJFBookReportCell.h"
#import "TYMProgressBarView.h"
#import "PublicDocuments.h"
#import "ProUtils.h"
@interface HWJFBookReportCell ()
@property (weak, nonatomic) IBOutlet UILabel *itemName;
@property (weak, nonatomic) IBOutlet TYMProgressBarView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *doubtCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *doubtTitlelabel;

@end
@implementation HWJFBookReportCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubView];
}

- (void)setupSubView{
    self.doubtTitlelabel.textColor = UIColorFromRGB(0xF65A5F);
    self.doubtCountLabel.font = fontSize_13;
    self.doubtTitlelabel.font = fontSize_13;
    self.itemName.font = fontSize_13;
    self.itemName.textColor = UIColorFromRGB(0x3b3b3b);
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setupInfo:(NSDictionary *)dic{
    self.itemName.text = dic[@"questionNum"];
    [self setupDoubtCountLabelNumber:dic];
  
    CGFloat finishStudentF = [dic[@"doubtStudentCount"] floatValue];
    CGFloat studentCountF = [dic[@"studentCount"] floatValue];
    CGFloat progress = 0.0f;
    if (studentCountF > 0) {
        progress =  finishStudentF/studentCountF;
    }
    [self setupProgressView:progress];
}

- (void)setupDoubtCountLabelNumber:(NSDictionary *)dic{
    NSString * completeTextDes =  [NSString stringWithFormat:@"%@/%@人",dic[@"doubtStudentCount"],dic[@"studentCount"]];
    NSArray * colors = @[UIColorFromRGB(0x30B9B8)];
    NSRange range1 = [completeTextDes rangeOfString:[NSString stringWithFormat:@"%ld",[dic[@"doubtStudentCount"] integerValue]]];
    
    NSArray * ranges = @[NSStringFromRange(range1)  ];
    NSArray * fonts = @[fontSize_13];
    
    NSAttributedString * completeTextAtrDes = [ProUtils confightAttributedText:completeTextDes withColors:colors withRanges:ranges withFonts:fonts];
    
    self.doubtCountLabel.attributedText = completeTextAtrDes;
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
        self.progressView.barFillColor = UIColorFromRGB(0xF65A5F);
        
    }
    
}
@end
