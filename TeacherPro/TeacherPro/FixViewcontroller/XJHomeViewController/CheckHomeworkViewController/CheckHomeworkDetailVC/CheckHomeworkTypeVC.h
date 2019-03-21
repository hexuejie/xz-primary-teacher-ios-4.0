//
//  CheckHomeworkTypeVC.h
//  TeacherPro
//
//  Created by DCQ on 2018/7/6.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "BaseNetworkViewController.h"

@interface CheckHomeworkTypeVC : BaseNetworkViewController
- (instancetype)initWithTitle:(NSString *)titleStr withHomeworkId:(NSString *)homeworkId withPracticeType:(NSString *)practiceType withHWStudentList:(NSArray *)studentList withCheck:(BOOL) isCheck withOnlineHomework:(NSNumber *)onlineHomework;

@end
