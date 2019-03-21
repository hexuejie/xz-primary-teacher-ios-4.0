//
//  GFMallAddAddressViewController.h
//  TeacherPro
//
//  Created by DCQ on 2017/12/7.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//
//添加地址

#import "BaseTableViewController.h"
@class GFMallAddressModel;
typedef void(^GFMallAddAddressBlock)();
@interface GFMallAddAddressViewController : BaseTableViewController
@property(nonatomic, copy) GFMallAddAddressBlock updateAddressBlock;
- (instancetype)initWithModel:(GFMallAddressModel*) model;
@end
