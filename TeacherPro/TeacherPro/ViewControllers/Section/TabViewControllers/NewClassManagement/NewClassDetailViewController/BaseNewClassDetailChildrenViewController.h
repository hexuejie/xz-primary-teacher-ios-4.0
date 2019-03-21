//
//  BaseNewClassDetailChildrenViewController.h
//  TeacherPro
//
//  Created by DCQ on 2017/10/19.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseNewClassDetailChildrenViewController : BaseTableViewController
//页面是否加载过数据
@property(nonatomic, assign) BOOL  hasLoadData;
//更新本页数据
- (void)updateRequestData;
@end
