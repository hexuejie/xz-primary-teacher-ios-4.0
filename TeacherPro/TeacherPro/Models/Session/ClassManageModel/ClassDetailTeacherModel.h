//
//  ClassDetailTeacherModel.h
//  TeacherPro
//
//  Created by DCQ on 2017/5/16.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "Model.h"

@class ClassDetailTeacherModel;
@protocol ClassDetailTeacherModel;

@interface ClassDetailTeachersModel :Model
@property(nonatomic, strong)NSArray <ClassDetailTeacherModel>*  teachers;
@end

@interface ClassDetailTeacherModel : Model
@property(nonatomic, copy) NSString  *teacherName;//教师名字
@property(nonatomic, copy) NSString   *teacherId;//教师id
@property(nonatomic, copy) NSString    *subjectNames;//科目
@property(nonatomic, copy) NSString  * sex ;//性别
@property(nonatomic, copy) NSString  * avatar;//图像地址
@property(nonatomic, copy) NSString  * teacherPhone;
@property(nonatomic, strong) NSNumber  *adminTeacher;//是否管理员 1为是 0为不是
@property(nonatomic, strong) NSArray   *subjectIds ;//科目ID


//用于选择科目提交后台服务字段
@property(nonatomic, strong) NSNumber  * registerNumber;//是否注册用户
@property(nonatomic, copy) NSString*  phone;//电话号码
@property(nonatomic, copy) NSString * classId;//班级id
@property(nonatomic, copy) NSString * className;//班级名称申请的
@end
