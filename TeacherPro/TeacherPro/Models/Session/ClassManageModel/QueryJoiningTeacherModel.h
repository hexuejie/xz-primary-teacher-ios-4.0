 
//  QueryJoiningTeacherModel.h
//  TeacherPro
//
//  Created by DCQ on 2017/8/4.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "Model.h"

@class JoiningTeacherModel;
@protocol  JoiningTeacherModel<NSObject>

@end
@interface QueryJoiningTeacherModel : Model
@property(nonatomic, strong) NSArray <JoiningTeacherModel> * teachers;
@end

@interface JoiningTeacherModel : Model
@property(nonatomic, copy)NSString * teacherName ; // 教师姓名
@property(nonatomic, copy)NSString * teacherPhone ;// 教师手机号码
@property(nonatomic, copy)NSString *thumbnail;// 教师头像
@property(nonatomic, strong)NSNumber *isRegister;  // 是否已注册
@property(nonatomic, copy) NSString *subjectNames  ;// - 科目名称列表
@property(nonatomic, copy) NSString *sex  ;//  性别
@end
