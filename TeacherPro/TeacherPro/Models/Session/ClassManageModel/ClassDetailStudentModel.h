//
//  ClassDetailStudentModel.h
//  TeacherPro
//
//  Created by DCQ on 2017/5/16.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "Model.h"
@class ClassDetailStudentModel;
@protocol ClassDetailStudentModel ;
@interface ClassDetailStudentsModel : Model
@property(nonatomic, strong) NSArray <ClassDetailStudentModel>* students;
@end
@interface ClassDetailStudentModel : Model
/**
 * 头像
 */
@property(nonatomic, copy) NSString * avatar;



/**
 * 班级id
 */
@property(nonatomic, copy) NSString * clazzId;

/**
 * 班级名称
 */
@property(nonatomic, copy) NSString * clazzName;

/**
 * A豆数量
 */
@property(nonatomic, strong) NSNumber* coin;



/**
 * 年级名称
 */
@property(nonatomic, copy) NSString * gradeName;

/**
 * 历史A豆
 */
@property(nonatomic, strong) NSNumber* historicalCoin;



/**
 * 学生名称
 */
@property(nonatomic, copy) NSString * name;

/**
 * 家长id
 */
@property(nonatomic, copy) NSString * parentId;

/**
 * 学校名称
 */
@property(nonatomic, copy) NSString * schoolName;

/**
 * 学生性别
 */
@property(nonatomic, copy) NSString * sex;

/**
 * 学生状态 1:可用 0:删除
 */
@property(nonatomic, strong) NSNumber* status;

/**
 * 学生信息
 */
@property(nonatomic, copy) NSString * studentId;

/**
 * 速度之星次数
 */
@property(nonatomic, strong) NSNumber* speedstarCount;

/**
 * 学生作业进步达人次数
 */
@property(nonatomic, strong) NSNumber* progressiveCount;
/**
 * 学生作业top3次数
 */
@property(nonatomic, strong) NSNumber* top3Count;
@end
