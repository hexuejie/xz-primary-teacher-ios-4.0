//
//  SessionModel.h
//  TeacherPro
//
//  Created by DCQ on 2017/5/2.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "Model.h"

@interface SessionModel : Model

/**
 * 感恩币
 */
@property (nonatomic,strong) NSNumber   * coin;

/**
 * 创建时间
 */
@property (nonatomic,copy) NSString  * ctime;

/**
 * 经验值
 */
@property (nonatomic,strong) NSNumber   * exp;

/**
 * 历史感恩币
 */
@property (nonatomic,strong) NSNumber  * historicalCoin;

/**
 * 邀请码
 */
@property (nonatomic,copy) NSString * inviteCode;

/**
 * 等级ID
 */
@property (nonatomic,strong) NSNumber * levelId;

/**
 * 教师姓名
 */
@property (nonatomic,copy) NSString *name;
/**
 * 教师性别  判断是否填写个人用户信息
 */
@property (nonatomic,copy) NSString *sex;

/**
 * 手机号码
 */
@property (nonatomic,copy) NSString * phone;

/**
 * 学校id
 */
@property (nonatomic,copy) NSString *schoolId;

/**
 * 学校名称
 */
@property (nonatomic,copy) NSString * schoolName;

/**
 * 状态
 */
@property (nonatomic,strong) NSNumber * status;
//
///**
// * 教师id
// */
@property (nonatomic,copy) NSString * teacherId;

/**
  是不会有班级
 */
@property (nonatomic,strong)NSNumber * hasClazz;

/**
 * token
 */
@property (nonatomic,copy) NSString * token;


///**
 /** 图像缩略图
 */
@property (nonatomic,copy) NSString  * thumbnail;

/**
 * 教师密码
 */
@property (nonatomic,copy) NSString <Ignore>* password;
@end
