 
//  ReceuvedMessageModel.h
//  TeacherPro
//
//  Created by DCQ on 2017/6/29.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "Model.h"
@class ReceuvedTeacherContacts;
@class ReceuvedStudentContacts;
@protocol ReceuvedTeacherContacts
@end

@protocol ReceuvedStudentContacts
@end
@interface ReceuvedMessageModel : Model
@property (nonatomic, strong)NSArray <ReceuvedTeacherContacts>* teacherContacts;
@property (nonatomic, strong)NSArray <ReceuvedStudentContacts>* studentContacts;
@end

@interface ReceuvedTeacherContacts :Model
/**
 * 老师ID
 */
@property (nonatomic, copy)NSString * teacherId;

/**
 * 老师姓名
 */
@property (nonatomic, copy)NSString * teacherName;

/**
 * 老师联系方式
 */
@property (nonatomic, copy)NSString * teacherPhone;

@property (nonatomic, copy) NSString * avatar;

@property(nonatomic, copy) NSString * sex;

@end


@class StudentsModel;
@protocol StudentsModel <NSObject>
@end
@interface ReceuvedStudentContacts :Model
/**
 * 班级ID
 */
@property (nonatomic, copy)NSString * clazzId;

/**
 * 所属班级名称
 */
@property (nonatomic, copy)NSString * clazzName;

/**
 * 所属年级
 */
@property (nonatomic, copy)NSString * grade;

/**
 * 所属年级名称
 */
@property (nonatomic, copy)NSString * gradeName;

/**
 * 学生信息集合({"studentId":"888","studentName":"Coder.Java"})
 */
@property (nonatomic, strong)NSArray <StudentsModel> * students;

// getters and setters...
@end

@interface  StudentsModel: Model
@property (nonatomic, copy)NSString * studentId;

/**
 * 所属年级名称
 */
@property (nonatomic, copy)NSString * studentName;

@property (nonatomic, copy) NSString * avatar;

@property(nonatomic, copy) NSString * sex;
@end
