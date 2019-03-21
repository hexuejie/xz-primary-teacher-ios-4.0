
//
//  HWVocabularyReportCell.m
//  TeacherPro
//
//  Created by DCQ on 2018/7/16.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//
/////英语 词汇报告
#import "HWZXLXVocabularyReportCell.h"
#import "PublicDocuments.h"
#import "UIView+WZLBadge.h"


@interface HWZXLXVocabularyReportCell()
@property (weak, nonatomic) IBOutlet ZZCircleProgress *circleProgress;
@property (weak, nonatomic) IBOutlet UIImageView *circleView;
@property (weak, nonatomic) IBOutlet UIView *peripheralCircle;
@property (weak, nonatomic) IBOutlet UIImageView *perfectImgV;
@property (weak, nonatomic) IBOutlet UIImageView *goodImgV;
@property (weak, nonatomic) IBOutlet UIImageView *basicImgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *perfectLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodLabel;
@property (weak, nonatomic) IBOutlet UILabel *basicLabel;

@end
@implementation HWZXLXVocabularyReportCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
       [self setupSubViews];
}
- (void)setupSubViews{
    
    self.titleLabel.textColor = UIColorFromRGB(0x3b3b3b);
    self.titleLabel.font = fontSize_13;
    
    self.perfectLabel.font = fontSize_13;
     self.perfectLabel.textColor = UIColorFromRGB(0x6b6b6b);
    
    self.goodLabel.font = fontSize_13;
     self.goodLabel.textColor = UIColorFromRGB(0x6b6b6b);
    
    self.basicLabel.font = fontSize_13;
     self.basicLabel.textColor = UIColorFromRGB(0x6b6b6b);
    
    self.circleView.layer.masksToBounds = YES;
    self.circleView.layer.borderColor = [UIColor clearColor].CGColor;
    self.circleView.layer.cornerRadius = (54-6)/2;
    self.circleView.layer.borderWidth = 1;
    
    self.peripheralCircle.layer.masksToBounds = YES;
    self.peripheralCircle.layer.borderColor = UIColorFromRGB(0x30B9B8).CGColor;
    self.peripheralCircle.layer.cornerRadius = (54+4)/2;
    self.peripheralCircle.layer.borderWidth = 1;
    
    
}

- (void)setupInfo:(NSDictionary *)dic{
    
    //        "typeEn" //类型简写
    //        "homeworkTypeId"://类型id
    //        "typeCn"//类型名称
    //        "logo"://类型icon
    //        "hasScoreLevel"//是否有成绩 用于区分是否 听写
    //        "correctRate": //完成比例
    //        "masteLevel"://掌握程度
    //        "finishStudentCount" //完成学生数
   
    
    NSString * typeCn = dic[@"typeCn"];
    NSString * correctRate = dic[@"correctRate"];
    NSString * masteLevel = dic[@"masteLevel"];
    
    
    
    CGFloat progress = 0.0;
    if ([correctRate containsString:@"%"]) {
       NSString *correctRateStr  =  [correctRate stringByReplacingOccurrencesOfString:@"%" withString:@""];
        progress = [correctRateStr integerValue]/100;
    }
   
    NSString * stateStr = @"正确率";
    NSString * progressTextDes = [NSString stringWithFormat:@"%@\n %@",correctRate,stateStr];
    
    UIColor  * pathFillColor = UIColorFromRGB(0x30B9B8);
    
    [self cofightProprogressViewText:progressTextDes withPathFillColor:pathFillColor withProgress:progress];
    [self masterDegree:masteLevel];
    self.titleLabel.text = typeCn;
}
//掌握程度
- (void)masterDegree:(NSString *)masteLevel{
    if ([masteLevel isEqualToString:@"Perfect"]) {
         self.perfectImgV.image = [UIImage imageNamed:@"master_perfect_icon.png"];
         self.goodImgV.image = [UIImage imageNamed:@"master_master_icon.png"];
         self.basicImgV.image = [UIImage imageNamed:@"master_master_icon.png"];
    }else if ([masteLevel isEqualToString:@"Good"]){
         self.perfectImgV.image = [UIImage imageNamed:@"master_master_icon.png"];
         self.goodImgV.image = [UIImage imageNamed:@"master_good_icon.png"];
         self.basicImgV.image = [UIImage imageNamed:@"master_master_icon.png"];
    }else if ([masteLevel isEqualToString:@"Fail"]){
         self.perfectImgV.image = [UIImage imageNamed:@"master_master_icon.png"];
         self.goodImgV.image = [UIImage imageNamed:@"master_master_icon.png"];
         self.basicImgV.image = [UIImage imageNamed:@"master_basic_icon.png"];
       
    }
     
}
- (void)cofightProprogressViewText:(NSString *)progressTextDes withPathFillColor:(UIColor *)pathFillColor withProgress:(CGFloat)progress{
    self.circleProgress.progressText = progressTextDes;
    self.circleProgress.showProgressText = YES;
    self.circleProgress.duration = 1;
    self.circleProgress.showPoint = NO;
    self.circleProgress.increaseFromLast = YES;
    self.circleProgress.strokeWidth = 3;
    self.circleProgress.progressLabel.font = fontSize_11;
    self.circleProgress.progressLabel.textColor = UIColorFromRGB(0x30B9B8);
    self.circleProgress.pathBackColor = [UIColor clearColor];
    self.circleProgress.pathFillColor = pathFillColor;
    self.circleProgress.progress = progress;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated]; 
    // Configure the view for the selected state
}

@end
