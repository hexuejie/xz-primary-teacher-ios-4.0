//
//  NewClassDetailTeacherViewController.h
//  TeacherPro
//
//  Created by DCQ on 2017/8/3.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BaseNewClassDetailChildrenViewController.h"
#import "XLPagerTabStripViewController.h"
@class ClassDetailTeachersModel;
@interface NewClassDetailTeacherViewController : BaseNewClassDetailChildrenViewController
@property(nonatomic, strong) ClassDetailTeachersModel * teachersModel;
- (instancetype)initWithClassId:(NSString *)classId withClassName:(NSString *)className isTeacherIdentity:(BOOL)isAdmin;
@end
