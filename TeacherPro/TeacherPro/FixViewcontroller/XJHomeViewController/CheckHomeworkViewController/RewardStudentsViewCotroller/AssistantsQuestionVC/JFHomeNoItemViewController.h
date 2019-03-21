//
//  JFHomeNoItemViewController.h
//  TeacherPro
//
//  Created by DCQ on 2018/1/3.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "JFHomeworkQuestionViewController.h"

@interface JFHomeNoItemViewController : JFHomeworkQuestionViewController
- (instancetype)initWithBookId:(NSString *)bookId withHomeworkId:(NSString *)homeworkId withStudentId:(NSString *)studentId;
- (instancetype)initWithBookId:(NSString *)bookId withHomeworkId:(NSString *)homeworkId withStudentId:(NSString *)studentId withIsOnlineHomework:(BOOL)isOnline withOnlyKhlxOnline: (BOOL)onlyKhlxOnline withStudentName:(NSString *) studentName withHomeworkState:(BOOL)isCheck;
@end
