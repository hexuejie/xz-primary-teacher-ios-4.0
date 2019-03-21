//
//  StudentsFeedbackViewController.h
//  TeacherPro
//
//  Created by DCQ on 2017/7/9.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BaseTableViewController.h"

typedef NS_ENUM(NSInteger, StudentFeedbackType) {
    StudentFeedbackType_normal = 0,
    StudentFeedbackType_feedback  ,
    StudentFeedbackType_unFeedback  ,
};
@interface StudentsFeedbackViewController : BaseTableViewController
- (instancetype)initWithHomeworkId:(NSString *)homeworkId withStudentFeedbackType:(StudentFeedbackType)type;
@end
