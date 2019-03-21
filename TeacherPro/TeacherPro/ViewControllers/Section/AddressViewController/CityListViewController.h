//
//  CityListViewController.h
//  TeacherPro
//
//  Created by DCQ on 2017/5/6.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BaseNetworkViewController.h"

typedef void(^CityListViewControllerBlock)(NSString * name);

typedef NS_ENUM(NSInteger ,CityListViewFromType){

    CityListViewFromType_nomarl         =  0,
    //省
    CityListViewFromType_Province       ,
    //学校
    CityListViewFromType_School         ,
} ;

@interface CityListViewController : BaseNetworkViewController
@property(nonatomic, copy) CityListViewControllerBlock selectedCityBlock;
- (instancetype)initWithType:(CityListViewFromType)type withCityName:(NSString *)cityName withProvinceName:(NSString *)provinceName withProvinceID:(NSNumber *)provinceID;
@end
