//
//  JFTopicOtherTeacherParseViewController.h
//  TeacherPro
//
//  Created by DCQ on 2017/12/22.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BaseTableViewController.h"

@interface JFTopicOtherTeacherParseViewController : BaseTableViewController
- (instancetype)initWithHomework:(NSString *)unitId withQuestionNum:(NSString *)questionNum;
- (instancetype)initWithHomework:(NSString *)unitId withQuestionNum:(NSString *)questionNum withHomeworkQuestionAnalysisDic:(NSDictionary *)homeworkQuestionAnalysisDic;
@property(nonatomic, strong) NSIndexPath *seletedChangePareTopicIndexPath;//记录选择要修改的题目位置
@end
