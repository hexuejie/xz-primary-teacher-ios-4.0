//
//  GFMallChooseAreaViewController.h
//  TeacherPro
//
//  Created by DCQ on 2017/12/7.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//
//选择地区
#import "BaseTableViewController.h"

typedef void(^GFMallChooseAreaVCBlock)(NSString * area,NSString * province , NSString *city);
@interface GFMallChooseAreaViewController : BaseTableViewController
@property(nonatomic, copy) GFMallChooseAreaVCBlock chooseAreaBlock;
@end
