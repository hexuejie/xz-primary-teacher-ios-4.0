 
//  GratitudeCurrencyListModel.h
//  TeacherPro
//
//  Created by DCQ on 2017/7/6.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "Model.h"

@class GratitudeCurrencyModel;
@protocol GratitudeCurrencyModel @end
@interface GratitudeCurrencyListModel : Model
@property(nonatomic, strong) NSMutableArray <GratitudeCurrencyModel> *changeLogs;
@end

@interface GratitudeCurrencyModel : Model
/**
 * 文本记录
 */
@property(nonatomic, copy)NSString *  comment;

/**
 * 正数为获取， 负数为消耗
 */
@property(nonatomic, strong) NSNumber * count;

/**
 * 发生时间
 */
@property(nonatomic, copy) NSString * ctime;

/**
 * 发生的事件,比如 reg：代表注册
 */
@property(nonatomic, copy)NSString *   event;

/**
 * 该事件相关的ID号
 */
@property(nonatomic, copy)NSString *   eventId;

/**
 * 流水号
 */
@property(nonatomic, strong) NSNumber * id;

/**
 * 月份
 */
@property(nonatomic, copy)NSString *   month;

/**
 * 角色 teacher, parent, student
 */
@property(nonatomic, copy)NSString *   role;

/**
 * 角色id teacherId, parentId, studentId
 */
@property(nonatomic, copy)NSString *   roleId;

/**
 * 学期
 */
@property(nonatomic, copy)NSString *   term;

/**
 * coin: 金币 exp: 经验
 */
@property(nonatomic, copy)NSString *   type;
@end
