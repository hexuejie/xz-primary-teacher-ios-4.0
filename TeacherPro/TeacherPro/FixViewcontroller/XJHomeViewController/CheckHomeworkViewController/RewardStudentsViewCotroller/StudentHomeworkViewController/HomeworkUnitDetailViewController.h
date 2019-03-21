//
//  HomeworkUnitDetailViewController.h
//  TeacherPro
//
//  Created by DCQ on 2017/7/9.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BaseTableViewController.h"

@interface HomeworkUnitDetailViewController : BaseTableViewController
- (instancetype)initWithStudentId:(NSString *)studentId withHomeworkId:(NSString *)homeworkId withHomeworkTypeId:(NSString *)homeworkTypeId withUnitName:(NSString *)unitName withType:(NSString *) typeTitle;
@end
