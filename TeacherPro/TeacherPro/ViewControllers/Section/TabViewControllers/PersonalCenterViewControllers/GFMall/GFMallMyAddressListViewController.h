//
//  GFMallMyAddressListViewController.h
//  TeacherPro
//
//  Created by DCQ on 2017/12/7.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//
//地址管理
#import "BaseTableViewController.h"
@class GFMallAddressListModel;
@class GFMallAddressModel;
typedef void(^GFMallMyAddressBlock)(NSInteger index, GFMallAddressModel * model);
typedef void(^ClearOrderAddressBlock)();
@interface GFMallMyAddressListViewController : BaseTableViewController
@property(nonatomic,copy) GFMallMyAddressBlock chooseblock;
@property(nonatomic,copy) ClearOrderAddressBlock  emptyBlock;
- (instancetype)initWithModel:(GFMallAddressListModel *) model withSelectedIndex:(NSInteger)selectedIndex;
@end
