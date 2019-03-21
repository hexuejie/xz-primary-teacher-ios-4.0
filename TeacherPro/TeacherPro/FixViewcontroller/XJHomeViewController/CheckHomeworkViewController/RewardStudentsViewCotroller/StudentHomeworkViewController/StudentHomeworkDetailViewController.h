//
//  StudentHomeworkDetailViewController.h
//  TeacherPro
//
//  Created by DCQ on 2017/7/9.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BaseTableViewController.h"

@interface StudentHomeworkDetailViewController : BaseTableViewController
- (instancetype)initWithStudent:(NSString *)studentId withStudentName:(NSString *)studentName withHomeworkId:(NSString *)homeworkId withHomeworkState:(BOOL)isCheck;

- (instancetype)initWithStudent:(NSString *)studentId withStudentName:(NSString *)studentName withHomeworkId:(NSString *)homeworkId withHomeworkState:(BOOL)isCheck withStudentList:(NSArray *)studentList withCurrenntIndex:(NSInteger )currenntIndex;
@property(nonatomic,strong) NSArray * studentList;//列表所有数据
@property(nonatomic,assign) NSInteger currenntIndex;//当前页面标

@end
