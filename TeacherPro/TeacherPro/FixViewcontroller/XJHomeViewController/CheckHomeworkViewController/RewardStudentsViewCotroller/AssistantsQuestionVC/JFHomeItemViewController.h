//
//  JFHomeItemViewController.h
//  TeacherPro
//
//  Created by DCQ on 2018/8/16.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "JFHomeworkQuestionViewController.h"

@interface JFHomeItemViewController : JFHomeworkQuestionViewController
- (instancetype)initWithHomeworkId:(NSString *)homeworkId withStudentId:(NSString *)studentId;
@end
