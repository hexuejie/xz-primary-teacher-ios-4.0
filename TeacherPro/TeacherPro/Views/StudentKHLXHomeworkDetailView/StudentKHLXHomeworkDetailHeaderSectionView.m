//
//  StudentKHLXHomeworkDetailHeaderSectionView.m
//  TeacherPro
//
//  Created by DCQ on 2018/2/1.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "StudentKHLXHomeworkDetailHeaderSectionView.h"
#import "StudentKHLXHomeworkDetailListModel.h"
#import "PublicDocuments.h"

@interface StudentKHLXHomeworkDetailHeaderSectionView()
@property (weak, nonatomic) IBOutlet UILabel *topicNumberLabel;//错 对
@property (weak, nonatomic) IBOutlet UILabel *unitNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomLineV;
@property (weak, nonatomic) IBOutlet UIView *centerLine;
@property (weak, nonatomic) IBOutlet UIView *topLine;

@end
@implementation StudentKHLXHomeworkDetailHeaderSectionView
- (void)awakeFromNib{
    
    [super awakeFromNib];
    [self setupSubview];
}
- (void)setupSubview{
    self.bottomLineV.backgroundColor = project_line_gray;
    self.unitNameLabel.textColor = UIColorFromRGB(0x8B8B8B);
    self.unitNameLabel.font = fontSize_13;
    self.detailLabel.textColor = UIColorFromRGB(0x8B8B8B);
    self.detailLabel.font = fontSize_13;
    self.topLine.backgroundColor = project_line_gray;
    
}
- (void)setupUnitModel:(StudentKHLXHomeworkDetailModel *) model{
    
    self.unitNameLabel.text = model.unitName;
    NSString * detail = @"";
    NSInteger questions = 0;
    if (model.questions) {
        questions = [model.questions count];
    }
  
    NSString * timer  = @"";
    if (model.expectTime) {
        timer = [self timeFormatted:model.expectTime];
    }
    detail = [NSString stringWithFormat:@"共 %ld 题  %@",questions,timer];
    
    self.detailLabel.text = detail;
    
    NSNumber * errorQuestCount = @(0);
    if ( model.errorQuestCount) {
        errorQuestCount = model.errorQuestCount;
    }
      NSNumber * rightQuestCount = @(0);
    if (model.rightQuestCount) {
        rightQuestCount = model.rightQuestCount;
    }
    self.topicNumberLabel.text = [NSString stringWithFormat:@"错%@题 对%@题",errorQuestCount,rightQuestCount];
    
}

- (NSString *)timeFormatted:(NSNumber *)time
{
    NSString * str = @"";
    //秒
    NSInteger totalSeconds  = [time integerValue];
    
    
    NSInteger minutes = (totalSeconds / 60) % 60;
    if(minutes == 0){
        str = @"";
    }else if (0 < minutes < 1) {
        str = @"预计完成时间1分钟";
    }else if (minutes>60){
        str = @"预计完成时间1个小时以上";
    }else{
        str =[NSString stringWithFormat:@"预计完成时间%ld分钟",minutes];
    }
    
    return  str;
}
- (void)setupUnitDic:(NSDictionary *) model{
    self.unitNameLabel.text = model[@"unitName"];
    NSString * detail = @"";
    NSInteger questions = 0;
    if (model[@"questions"]) {
        questions = [model[@"questions"] count];
    }
    
    NSString * timer  = @"";
    if (model[@"expectTime"]) {
        timer = [self timeFormatted:model[@"expectTime"]];
    }
    detail = [NSString stringWithFormat:@"共 %ld 题  %@",questions,timer];
    
    self.detailLabel.text = detail;
    
    NSNumber * errorQuestCount = @(0);
    if ( model[@"errorQuestCount"]) {
        errorQuestCount = model[@"errorQuestCount"];
    }
    NSNumber * rightQuestCount = @(0);
    if (model[@"rightQuestCount"]) {
        rightQuestCount = model[@"rightQuestCount"];
    }
    self.topicNumberLabel.text = [NSString stringWithFormat:@" 错%@题 对%@题 ",errorQuestCount,rightQuestCount];
   
    
}
@end
