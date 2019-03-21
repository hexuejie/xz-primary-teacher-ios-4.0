//
//  HomeworkDetailKHLXListViewController.h
//  TeacherPro
//
//  Created by DCQ on 2018/1/31.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "BaseTableViewController.h"

typedef NS_ENUM(NSInteger, HomeworkDetailKHLXListVCStyle){
    
    HomeworkDetailKHLXListVCStyle_normal = 0,
    HomeworkDetailKHLXListVCStyle_report //报告
};
@interface HomeworkDetailKHLXListViewController : BaseTableViewController
- (instancetype) initWithUnitName:(NSString *)unitName withQuestions:(NSArray *)questions withFinishStudentCount:(NSNumber *)finishStudentCount withHomeworkStudents:(NSArray *)homeworkStudents withExpectTime:(NSNumber *) expectTime;

- (instancetype)initWithHomeworkId:(NSString *)homeworkId withHomeworkTypeId:(NSString *)homeworkTypeId withStyle:(HomeworkDetailKHLXListVCStyle)style;
@end
