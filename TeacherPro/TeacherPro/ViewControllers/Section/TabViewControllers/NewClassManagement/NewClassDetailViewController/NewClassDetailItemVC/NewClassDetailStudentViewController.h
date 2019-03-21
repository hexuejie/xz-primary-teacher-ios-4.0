//
//  NewClassDetailStudentViewController.h
//  TeacherPro
//
//  Created by DCQ on 2017/8/3.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BaseNewClassDetailChildrenViewController.h"
#import "XLPagerTabStripViewController.h"
@class ClassDetailStudentsModel;
@interface NewClassDetailStudentViewController : BaseNewClassDetailChildrenViewController
@property(nonatomic, strong)  ClassDetailStudentsModel *studentsModel;
- (instancetype)initWithClassId:(NSString *)classId withClassName:(NSString *)className;
- (void)requestStudents;
@end
