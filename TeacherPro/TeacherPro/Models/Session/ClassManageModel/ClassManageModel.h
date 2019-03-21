//
//  ClassManageModel.h
//  TeacherPro
//
//  Created by DCQ on 2017/5/11.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "Model.h"

@class ClassManageModel;
@protocol  ClassManageModel;

@interface ClassListGruopModel : Model
@property(nonatomic, strong) NSArray< ClassManageModel >* clazzes;
@property(nonatomic, assign) NSInteger  grade;
@property(nonatomic, strong) NSString * gradeName;
@end

@interface ClassManageListModel : Model
@property(nonatomic, strong) NSArray< ClassManageModel >* clazzList;
@end


@interface ClassManageListGroupModel : Model
@property(nonatomic, strong) NSArray< ClassManageModel >* clazzMap;
@end



@interface ClassManageModel : Model

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
@property(nonatomic, copy) NSString     *clazzLogo;//班级图标

@property(nonatomic, assign) BOOL     isSelected ; // 学校id
@end
