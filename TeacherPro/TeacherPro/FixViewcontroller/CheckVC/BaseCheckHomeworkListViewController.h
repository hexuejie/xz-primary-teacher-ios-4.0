//
//  BaseCheckHomeworkListViewController.h
//  TeacherPro
//
//  Created by DCQ on 2017/8/12.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BaseTableViewController.h"
@class CheckHomeworkListModel;
typedef void(^HomeworkCheckSuccessBlock)();

@interface BaseCheckHomeworkListViewController : BaseTableViewController

@property(nonatomic, strong)  UIViewController  *superVC;
@property(nonatomic, copy) HomeworkCheckSuccessBlock  checkSuccessBlock;
@property(nonatomic, strong) CheckHomeworkListModel * checkModels;
@property(nonatomic, strong) NSMutableArray * sectionDataArray;
@property(nonatomic, copy) NSString * clazzId;

//页面是否加载过数据
@property(nonatomic, assign) BOOL  hasLoadData;

@property(nonatomic, assign) BOOL  isRefersh;
@end
