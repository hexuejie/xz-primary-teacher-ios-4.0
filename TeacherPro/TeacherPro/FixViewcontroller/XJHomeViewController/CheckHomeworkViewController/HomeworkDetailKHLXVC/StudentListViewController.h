//
//  StudentListViewController.h
//  TeacherPro
//
//  Created by DCQ on 2018/1/31.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "BaseTableViewController.h"

typedef NS_ENUM(NSInteger,StudentListType) {
    StudentListType_Normal      = 0,
    StudentListType_Complete       ,//已完成
    StudentListType_NoComplete     ,//未完成
    StudentListType_Wrong           ,//错
    StudentListType_Right           //对
};

@interface StudentListViewController : BaseTableViewController
- (instancetype)initWithType:(StudentListType)type withArray:(NSArray *)studentArray;
@end
