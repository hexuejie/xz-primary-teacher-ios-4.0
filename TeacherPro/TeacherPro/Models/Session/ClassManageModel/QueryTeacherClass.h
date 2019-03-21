 
//  QueryTeacherClass.h
//  TeacherPro
//
//  Created by DCQ on 2017/6/12.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "Model.h"

@class QueryTeacherClasss;
@protocol  QueryTeacherClass;
@interface QueryTeacherClasss : Model

@property(nonatomic, strong) NSArray< QueryTeacherClass >* clazzList;
@end
@interface QueryTeacherClass : Model
@property(nonatomic, copy) NSString     *clazzId ; //班级id
@property(nonatomic, copy) NSString     *clazzName; // 班级名称
@property(nonatomic, strong) NSNumber   *adminTeacher ; // 是否是班级管理员 0=不是 1=是
@property(nonatomic, copy) NSString     *subjectId ; // 教师所教科目id
@property(nonatomic, copy) NSString     *subjectName ; // 教师所教科目名称
@property(nonatomic, copy) NSString     *schoolId ; // 学校id
@property(nonatomic, strong) NSNumber   *studentCount ; // 学生数量
@property(nonatomic, strong) NSNumber   *grade ; // 年级
@property(nonatomic, copy) NSString     *gradeName; // 年级名称
@property(nonatomic, strong) NSNumber   *teacherCount ; // 教师数量
@property(nonatomic, strong) NSString   *adminPhone ; //  管理员号码
@property(nonatomic, strong) NSString   *adminName ;//管理员姓名
@property(nonatomic, copy) NSString * clazzLogo;    //班级logo
@property(nonatomic, strong )NSNumber *isJoin ;
@property(nonatomic, strong) NSNumber *isApply;
@end
