//
//  CreateClassViewController.h
//  TeacherPro
//
//  Created by DCQ on 2017/5/10.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BaseTableViewController.h"

@class ClassManageModel;
@class ChooseClassViewController;

typedef NS_ENUM(NSInteger, ViewControllerFromeType) {
    ViewControllerFromeType_Normal  = 0,

    ViewControllerFromeType_Choose     ,//布置作业选择班级
    ViewControllerFromeType_checkChoose     ,//检查作业选择班级
};

@protocol ChooseClassViewDelegate <NSObject>

@optional
- (void)chooseClassInfo:(NSDictionary *)info;
- (void)checkChooseClassInfo:(ClassManageModel *)classInfo;


////新数据
- (void)ChooseClassViewController:(ChooseClassViewController *)classViewController data:(NSArray *)dataArray gradeStr:(NSString*)grade;


@end

 
@interface ChooseClassViewController : BaseTableViewController

@property (nonatomic, strong) NSString * classIds;//班级数据
- (instancetype)initWithViewControllerFromeType:(ViewControllerFromeType )type ;
@property(nonatomic, assign) id<ChooseClassViewDelegate> chooseDelegate;

@end
