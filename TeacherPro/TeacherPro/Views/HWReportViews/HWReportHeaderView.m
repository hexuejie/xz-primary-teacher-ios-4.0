
//
//  HWReportHeaderView.m
//  TeacherPro
//
//  Created by DCQ on 2018/7/19.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "HWReportHeaderView.h"
#import "PublicDocuments.h"
#import "UIImageView+WebCache.h"
@interface HWReportHeaderView()
@property (weak, nonatomic) IBOutlet ZZCircleProgress *circleProgress;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;
@property (weak, nonatomic) IBOutlet UIImageView *circleView;
@property (weak, nonatomic) IBOutlet UIImageView *subjectsIconV;
@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;
@property (weak, nonatomic) IBOutlet UILabel *fackbookLabel;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentText;
@property (weak, nonatomic) IBOutlet UIImageView *ImgVType;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@end

@implementation HWReportHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setupSubViews];
}

- (void)setupSubViews{
    
    self.circleProgress.pathFillColor = [UIColor clearColor];
    self.circleView.layer.masksToBounds = YES;
    self.circleView.layer.borderColor = [UIColor clearColor].CGColor;
    self.circleView.layer.cornerRadius = 35;
    
    self.gradeLabel.font = fontSize_13;
    self.timerLabel.font = fontSize_13;
   
}


- (void)setupHeaderData:(NSDictionary *)dic{
    
    NSString * text = dic[@"text"];
    NSInteger studentCount = [dic[@"studentCount"] integerValue];
    NSInteger finishedCount = [dic[@"finishedCount"] integerValue];
    NSString * gradeName = dic[@"gradeName"];
    NSString * endTime = dic[@"endTime"];
    NSString * clazzName = dic[@"clazzName"];
    
 
    NSString * subjectId = dic[@"subjectId"];

    NSString * feedbackName = dic[@"feedbackName"];
 
   
    
    [self setupProgressStudentCount:studentCount withFinishedCount:finishedCount];
    self.gradeLabel.text = [gradeName stringByAppendingString:clazzName];
    self.timerLabel.text = [@"截止：" stringByAppendingString:endTime];
    self.fackbookLabel.text = feedbackName;
    
    //~~~~~~科目~~///
    NSString * imgName = @"";
    if ([subjectId isEqualToString:@"001"]) {
        //语文
        imgName = @"chineseSubject_homework_icon.png";
    }else if ([subjectId isEqualToString:@"002"]){
        //数学
        imgName = @"numberSubject_homework_icon.png";
    }else if ([subjectId isEqualToString:@"003"]){
        //英语
        imgName = @"englishSubject_homework_icon.png";
    }else{
        //其它科目
        imgName = @"otherSubject_homework_icon.png";
    }
    self.subjectsIconV.image = [UIImage imageNamed:imgName];
    self.contentText.text = text;
    
    
  
}

- (void)setupProgressStudentCount:(NSInteger )studentCount withFinishedCount:(NSInteger)finishedCount{
    
    CGFloat progress = 0.0;
    NSString * stateStr = @"已完成";
    NSString * progressTextDes = @"";
    if (studentCount == 0) {
        stateStr = @"班级\n无学生";
        progressTextDes = stateStr;
    }else{
        CGFloat finishedCountF =  [@(finishedCount)  floatValue];
        CGFloat studentCountF =  [@(studentCount)  floatValue];
        progress = finishedCountF/ studentCountF;
        progressTextDes = [NSString stringWithFormat:@"%@\n%ld/%ld",stateStr,finishedCount,studentCount];
    }
    
    UIColor  * pathFillColor = UIColorFromRGB(0x49E3B4);
    
    [self cofightProprogressViewText:progressTextDes withPathFillColor:pathFillColor withProgress:progress];
}
- (void)cofightProprogressViewText:(NSString *)progressTextDes withPathFillColor:(UIColor *)pathFillColor withProgress:(CGFloat)progress{
    self.circleProgress.progressText = progressTextDes;
    self.circleProgress.showProgressText = YES;
    self.circleProgress.duration = 1;
    self.circleProgress.showPoint = NO;
    self.circleProgress.increaseFromLast = YES;
    self.circleProgress.strokeWidth = 3;
    self.circleProgress.progressLabel.font = fontSize_13;
    self.circleProgress.progressLabel.textColor = [UIColor whiteColor];
    self.circleProgress.pathBackColor = [UIColor clearColor];
//    self.circleProgress.pathFillColor = pathFillColor;
     self.circleProgress.pathFillColor = [UIColor clearColor];
    self.circleProgress.progress = progress;
    
}

@end
