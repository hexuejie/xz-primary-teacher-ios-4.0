//
//  CheckDetialHeaderView.m
//  TeacherPro
//
//  Created by 何学杰 on 2018/12/21.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "CheckDetialHeaderView.h"
#import "ZZCircleProgress.h"
#import "PublicDocuments.h"
#import "ProUtils.h"
#import "CheckDetialHeaderProessView.h"

@interface CheckDetialHeaderView ()

@property (strong, nonatomic) ZZCircleProgress *progressView;
@property (strong, nonatomic) CheckDetialHeaderProessView *subProessView;

@end

@implementation CheckDetialHeaderView

- (void)awakeFromNib{
    [super  awakeFromNib];
    
    
    if (kScreenWidth == 375&&kScreenHeight>667){
       self.titleTop.constant = 31+18;
    }
    [self.customPicButton setAdjustsImageWhenHighlighted:NO];
    CGRect preessFrame = CGRectMake(6, 6, 96, 96);//108
    self.progressView = [[ZZCircleProgress alloc]initWithFrame:preessFrame pathBackColor:[UIColor clearColor] pathFillColor:[UIColor clearColor] startAngle:1.0 strokeWidth:4 textStyle:ZZCircleProgressTextStyle_custom];
    [self.headerView addSubview:self.progressView];
 
    self.subProessView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CheckDetialHeaderProessView class]) owner:nil options:nil].firstObject;
    self.subProessView.frame = CGRectMake(0, 0, 100, 100);
    [self.progressView addSubview:self.subProessView];
}

- (void)setListModel:(CHWListModel *)listModel{
    _listModel = listModel;
    
    self.starTime.text = [_listModel.info.ctime substringToIndex:16];;
    self.endTime.text = [_listModel.info.endTime substringToIndex:16];
    
    self.customTitle.text = _listModel.info.clazzName;
    [self.customPicButton setTitle:_listModel.info.feedbackName forState:UIControlStateNormal];
     [self.customPicButton setTitle:_listModel.info.feedbackName forState:UIControlStateSelected];
    
    self.customPicButton.enabled = YES;
    if ([_listModel.info.feedbackName isEqualToString:@"无需反馈"]) {
        self.customPicButton.alpha = 0.7;
        self.customPicButton.enabled = NO;
    }if ([_listModel.info.feedbackName isEqualToString:@"不需要反馈"]) {
        self.customPicButton.alpha = 0.7;
        self.customPicButton.enabled = NO;
    }if ([_listModel.info.feedbackName isEqualToString:@"签字反馈"]) {
        self.customPicButton.alpha = 0.7;
        self.customPicButton.enabled = NO;
    }
    
    NSAttributedString * progressTextAtrDes = nil;
    UIColor * pathFillColor = project_main_blue;
    NSString * stateStr = @"";
    
    CHWInfoModel * model = _listModel.info;
    if(0<= [model.finishedCount integerValue] && [model.finishedCount integerValue]< [model.studentCount integerValue]){
        
        stateStr = @"完成人数";
        pathFillColor = project_main_blue;
    }else if([model.finishedCount integerValue]==[model.studentCount integerValue]){
        
        stateStr = @"完成人数";
        NSArray * colors = @[UIColorFromRGB(0x33AAFF),UIColorFromRGB(0x8A8F99)];
        if ([model.finishedCount integerValue] == [model.studentCount integerValue]) {
            stateStr = @"全部完成";
            colors = @[UIColorFromRGB(0x33AAFF),UIColorFromRGB(0x33AAFF)];
        }
        pathFillColor = UIColorFromRGB(0x2D8AFF);
    }
    CGFloat progress = 0;
    if ([model.studentCount floatValue] == 0) {
        progress = 0;
    }else{
        progress = [model.finishedCount floatValue]/[model.studentCount floatValue];
    }

    [self cofightProprogressViewText:progressTextAtrDes withPathFillColor:pathFillColor withProgress:progress];
    self.subProessView.finishCountLabel.text = [NSString stringWithFormat:@"%ld",[model.finishedCount integerValue]];;
    self.subProessView.allCountLabel.text = [NSString stringWithFormat:@"/%ld",[model.studentCount integerValue]];
    self.subProessView.contentLabel.text = stateStr;
    [NSString stringWithFormat:@"%ld/%ld \n %@",[model.finishedCount integerValue],[model.studentCount integerValue],stateStr];
}


- (void)cofightProprogressViewText:(NSAttributedString *)progressTextAtrDes withPathFillColor:(UIColor *)pathFillColor withProgress:(CGFloat)progress{
    self.progressView.progressTextAtr = progressTextAtrDes;
    self.progressView.showProgressText = YES;
    self.progressView.duration = 1;
    self.progressView.showPoint = YES;
    self.progressView.increaseFromLast = YES;
    self.progressView.strokeWidth = 8;
    self.progressView.progressLabel.font = systemFontSize(12);
    self.progressView.progressLabel.textColor = UIColorFromRGB(0x8A8F99);
    self.progressView.pathBackColor = UIColorFromRGB(0xF5F5F5);
    
    self.progressView.pathFillColor = pathFillColor;
    self.progressView.progress = progress;
}
@end
