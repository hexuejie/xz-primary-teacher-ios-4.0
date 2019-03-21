//
//  AddressSchoolsModel.h
//  TeacherPro
//
//  Created by DCQ on 2017/5/8.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "Model.h"

@class  AddressSchoolModel;
@protocol  AddressSchoolModel;
@interface AddressSchoolsModel : Model
@property (nonatomic,strong) NSArray <AddressSchoolModel >*schools;
@end

@interface AddressSchoolModel : Model
/**
 * 地区编码
 */
@property (nonatomic,copy) NSString * area;

/**
 * 书店联系人
 */
@property (nonatomic,copy) NSString * bookshopContact;

/**
 * 书店联系人电话
 */
@property (nonatomic,copy) NSString * bookshopContactPhone;

/**
 * 市编码
 */
@property (nonatomic,copy) NSString * city;

/**
 * 班级数量
 */
@property (nonatomic,strong) NSNumber * clazzCount;

/**
 * 创建时间
 */
@property (nonatomic,copy) NSString * ctime;

/**
 * 学校全称
 */
@property (nonatomic,copy) NSString * fullName;

/**
 * 学校名称
 */
@property (nonatomic,copy) NSString * schoolName;

/**
 * 省编码
 */
@property (nonatomic,copy) NSString * province;

/**
 * 学校联系人姓名
 */
@property (nonatomic,copy) NSString * schoolContact;

/**
 * 学校联系人电话
 */
@property (nonatomic,copy) NSString * schoolContactPhone;

/**
 * 学校id
 */
@property (nonatomic,copy) NSString * schoolId;

/**
 * 学校阶段(1->小学；2->初中；3->高中；12->小初；23->初高；123->小初高)
 */
@property (nonatomic,copy) NSString * schoolStage;

/**
 * 学校类型(1->培训学校；2->公立学校；3->私立学校)
 */
@property (nonatomic,copy) NSString * schoolType;

/**
 * 学生数量
 */
@property (nonatomic,strong) NSNumber * studentCount;

/**
 * 教师数量
 */
@property (nonatomic,strong) NSNumber * teacherCount;

// getters and setters...

@end
