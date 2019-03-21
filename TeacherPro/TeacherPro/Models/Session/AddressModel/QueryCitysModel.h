//
//  QueryCitysModel.h
//  TeacherPro
//
//  Created by DCQ on 2017/5/9.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "Model.h"

@class CityModel;
@protocol CityModel;

@interface QueryCitysModel : Model
@property (nonatomic,strong) NSArray <CityModel>*items;
@end
@interface  CityModel : Model

/**
 * 编号
 */
@property (nonatomic,strong) NSNumber * id;

/**
 * 叶子节点(true/false)
 */
@property (nonatomic,strong) NSNumber * leaf;

/**
 * 名称
 */
@property (nonatomic,strong) NSString * name;

/**
 * 排序值，值越小越靠前
 */
@property (nonatomic,strong) NSNumber * orderNum;

/**
 * 上级编号
 */
@property (nonatomic,strong) NSString * parentId;

/**
 * 是否可选择(true/false)
 */
@property (nonatomic,strong) NSString * selectable;

// getters and setters...

@end
