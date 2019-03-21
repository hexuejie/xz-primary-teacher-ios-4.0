//
//  ProvinceListViewController.h
//  TeacherPro
//
//  Created by DCQ on 2017/5/6.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BaseNetworkViewController.h"

typedef void(^ProvinceListChangeProvinceBlock)(NSString * provinceName,NSNumber * provinceID);
typedef NS_ENUM(NSInteger ,ProvinceListViewFromType){
    
   ProvinceListViewFromType_nomarl         =  0,
    //市区
    ProvinceListViewFromType_City       ,
    //学校
    ProvinceListViewFromType_School         ,
} ;
@interface ProvinceListViewController : BaseNetworkViewController
@property(nonatomic, copy) ProvinceListChangeProvinceBlock  selectedProvinceBlock;
- (instancetype)initWithType:(ProvinceListViewFromType) type ;
@end
