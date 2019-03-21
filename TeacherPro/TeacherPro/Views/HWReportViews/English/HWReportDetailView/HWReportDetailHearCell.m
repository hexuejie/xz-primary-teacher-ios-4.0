//
//  HWReportDetailHearCell.m
//  TeacherPro
//
//  Created by DCQ on 2018/7/25.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "HWReportDetailHearCell.h"
#import "TYMProgressBarView.h"
#import "PublicDocuments.h"
@interface HWReportDetailHearCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet TYMProgressBarView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *ALabel;
@property (weak, nonatomic) IBOutlet UILabel *BLabel;
@property (weak, nonatomic) IBOutlet UILabel *CLabel;
@property (weak, nonatomic) IBOutlet UILabel *ADesLabel;
@property (weak, nonatomic) IBOutlet UILabel *BDesLabel;
@property (weak, nonatomic) IBOutlet UILabel *CDesLabel;
@property (weak, nonatomic) IBOutlet UILabel *completeLabel;

@end
@implementation HWReportDetailHearCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupSubViews];
}
    // Initialization code
- (void)setupSubViews{
    
    self.titleLabel.textColor = UIColorFromRGB(0x3b3b3b);
    self.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    self.ADesLabel.font = fontSize_13;
    self.ADesLabel.textColor = UIColorFromRGB(0xEF2D80);
    
    self.BDesLabel.font = fontSize_13;
    self.BDesLabel.textColor = UIColorFromRGB(0x30B9B8);
    
    self.CDesLabel.font = fontSize_13;
    self.CDesLabel.textColor = UIColorFromRGB(0x0060FE);
    
    self.ALabel.font = fontSize_13;
     self.ALabel.textColor = UIColorFromRGB(0x3b3b3b);
    
    self.BLabel.font = fontSize_13;
     self.BLabel.textColor = UIColorFromRGB(0x3b3b3b);
    
    self.CLabel.font = fontSize_13;
     self.CLabel.textColor = UIColorFromRGB(0x3b3b3b);
    
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
  
//                      dic[@"typeCn"],
//
//                       @"levels":dic[@"levels"],
//                       @"finishStudentCount":tempDic[@"finishStudentCount"],
//
//                       @"studentCount":self.studentCount
//                       };
    
    self.titleLabel.text = dic[@"typeCn"];
    self.numberLabel.text = [NSString stringWithFormat:@"%@/%@人",dic[@"finishStudentCount"],dic[@"studentCount"]];
    
    CGFloat finishStudentF = [dic[@"finishStudentCount"] floatValue];
    CGFloat studentCountF = [dic[@"studentCount"] floatValue];
    CGFloat progress = 0.0f;
    if (studentCountF > 0) {
        progress =  finishStudentF/studentCountF;
    }
    
    [self setupProgressView:progress];
     NSDictionary * levels = dic[@"levels"];
    NSNumber *studentCountA = levels[@"A"][@"studentCount"];
    NSNumber *studentCountB = levels[@"B"][@"studentCount"];
    NSNumber *studentCountC = levels[@"C"][@"studentCount"];
    self.ALabel.text = [NSString  stringWithFormat:@"%@人",studentCountA];
    self.BLabel.text = [NSString  stringWithFormat:@"%@人",studentCountB];
    self.CLabel.text = [NSString  stringWithFormat:@"%@人",studentCountC];
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
