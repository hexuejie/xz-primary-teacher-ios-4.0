//
//  CheckJobViewController.h
//  TeacherPro
//
//  Created by DCQ on 2017/6/20.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BaseTableViewController.h"

typedef NS_ENUM(NSInteger, CheckHomewrokListViewControllerFromType){

    CheckHomewrokListViewControllerFromType_normal = 0,
    CheckHomewrokListViewControllerFromType_review    ,//回顾
    CheckHomewrokListViewControllerFromType_check     ,//检查
};

@protocol CheckHomewrokListViewControllerDelegate <NSObject>


- (void)updateHomeworkDate;
@end
@interface CheckHomeworkReviewListViewController : BaseTableViewController
@property(nonatomic, weak) id<CheckHomewrokListViewControllerDelegate> delegate;
- (instancetype)initWithType:(CheckHomewrokListViewControllerFromType)type;
- (instancetype)initWithType:(CheckHomewrokListViewControllerFromType)type withDay:(NSString *)day;
@end
