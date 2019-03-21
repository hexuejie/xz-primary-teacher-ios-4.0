

//
//  CheckHomeworkDetailHeaderView.m
//  TeacherPro
//
//  Created by DCQ on 2018/7/11.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "CheckHomeworkDetailHeaderView.h"
#import "PublicDocuments.h"
#import "CHWListModel.h"
@interface CheckHomeworkDetailHeaderView()
@property (weak, nonatomic) IBOutlet ZZCircleProgress *circleProgress;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;
@property (weak, nonatomic) IBOutlet UIImageView *circleView;
@property (weak, nonatomic) IBOutlet UIImageView *subjectsIconV;
@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UIButton *feedBackBtn;
@property (weak, nonatomic) IBOutlet UILabel *endTimerLabel;
@property (assign, nonatomic)BOOL   isFeedBack;
@end
@implementation CheckHomeworkDetailHeaderView
- (void)awakeFromNib{
    [super awakeFromNib];
    [self setupSubViews];
}

- (void)setupSubViews{

    if (iPhoneX) {
        self.topLayout.constant = 84+20;
    }else{
        self.topLayout.constant = 64+20 ;
    }
  
    self.circleView.layer.masksToBounds = YES;
    self.circleView.layer.borderColor = [UIColor clearColor].CGColor;
    self.circleView.layer.cornerRadius = 30;
    
    self.gradeLabel.font = fontSize_13;
    self.stateLabel.font = fontSize_13;
    self.timerLabel.font = fontSize_13;
    self.feedBackBtn.titleLabel.font = fontSize_13;
    self.endTimerLabel.font = fontSize_13;
}


- (void)setupHeaderData:(CHWInfoModel *)data withCheckState:(BOOL)state{
    CHWInfoModel * infoModel = data;
    [self confightProgressView:infoModel];
    self.gradeLabel.text = [[infoModel.gradeName stringByAppendingString:@" "] stringByAppendingString:infoModel.clazzName];
    NSString * startTime = @"";
    NSString * endTime = @"";
    if (infoModel.ctime && infoModel.ctime.length >=16) {
        startTime = [infoModel.ctime substringToIndex:16];
    }
    if (infoModel.endTime && infoModel.endTime.length >=16) {
       endTime = [infoModel.endTime substringToIndex:16];
    }
    self.timerLabel.text = [NSString stringWithFormat:@"布置：%@",startTime];
    self.endTimerLabel.text = [NSString stringWithFormat:@"截止：%@",endTime];
    //~~~~~~作业状态~~///
    NSString * stateStr = @"";
    UIColor * bgColor ;
    if (state) {
        stateStr = @"已检查";
        bgColor = UIColorFromRGB(0x6FB85A);
    }else{
        stateStr = @"未检查";
        bgColor = UIColorFromRGB(0xF4726F);
    }
    self.stateLabel.text =stateStr;
    self.stateLabel.backgroundColor = bgColor;
    
      //~~~~~~科目~~///
    NSString * imgName = @"";
    if ([infoModel.subjectId isEqualToString:@"001"]) {
        //语文
        imgName = @"chineseSubject_homework_icon.png";
    }else if ([infoModel.subjectId isEqualToString:@"002"]){
        //数学
         imgName = @"numberSubject_homework_icon.png";
    }else if ([infoModel.subjectId isEqualToString:@"003"]){
        //英语
         imgName = @"englishSubject_homework_icon.png";
    }else{
        //其它科目
         imgName = @"otherSubject_homework_icon.png";
    }
    self.subjectsIconV.image = [UIImage imageNamed:imgName];
    
    
   //~~~~~~反馈按钮~~///
    BOOL feedbackBtnHidden = YES;
    NSString * feedBackTitleStr = @"";
    if ([infoModel.feedback isEqualToString:@"none"]) {
        //@"反馈";
        feedbackBtnHidden = NO;
        feedBackTitleStr = @"无需反馈";
        self.isFeedBack = NO;
        //@"不需要反馈";
    }else if ([infoModel.feedback isEqualToString:@"signature"]) {
        //@"签字反馈";
        feedbackBtnHidden = NO;
        feedBackTitleStr = @"签字反馈";
        self.isFeedBack = NO;
    }else if ([infoModel.feedback isEqualToString:@"sound"]) {
       // @"语音反馈";
        feedbackBtnHidden = NO;
        feedBackTitleStr = @"查看录音反馈";
        self.isFeedBack = YES;
    }else if ([infoModel.feedback isEqualToString:@"photo"]) {
        //@"拍照反馈";
        feedbackBtnHidden = NO;
        feedBackTitleStr = @"查看图片反馈";
        self.isFeedBack = YES;
    }
    [self.feedBackBtn setTitle:feedBackTitleStr forState:UIControlStateNormal];
    self.feedBackBtn.hidden = feedbackBtnHidden;
}

- (void)confightProgressView:(CHWInfoModel * )infoModel{
    CGFloat progress = 0.0;
    NSString * stateStr = @"已完成";
    NSString * progressTextDes = @"";
    if ([infoModel.studentCount floatValue] == 0) {
        stateStr = @"班级\n无学生";
        progressTextDes =  stateStr;
    }else{
        if ([infoModel.finishedCount floatValue] == 0) {
            stateStr = @"未完成";
        }else if ([infoModel.finishedCount floatValue] < [infoModel.studentCount floatValue]){
            stateStr = @"进行中";
        }else if ([infoModel.finishedCount floatValue] == [infoModel.studentCount floatValue]){
            stateStr = @"已完成";
            
        }
        progress =  [infoModel.finishedCount floatValue]/[infoModel.studentCount floatValue];
        
        progressTextDes = [NSString stringWithFormat:@"%@\n %ld/%ld  ",stateStr,[infoModel.finishedCount integerValue],[infoModel.studentCount integerValue]];
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
      self.circleProgress.pathFillColor  = [UIColor clearColor];
    self.circleProgress.progress = progress;
    
}

- (IBAction)gotoFeedbackAction:(id)sender {
    
    if (self.feedbackBlock && self.isFeedBack ) {
        self.feedbackBlock();
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
