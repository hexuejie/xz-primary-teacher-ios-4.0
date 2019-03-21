//
//  RightClassView.h
//  TeacherPro
//
//  Created by DCQ on 2017/5/11.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ClassManageModel;
typedef NS_ENUM(NSInteger, RightClassViewType) {

    RightClassViewType_normal = 0,
    RightClassViewType_create    ,//创建
    RightClassViewType_choose    ,//选择
    RightClassViewType_checkChoose,//检查作业选班
    
};

@protocol RightClassViewDelegate  <NSObject>

- (void)chooseClassInfo:(NSDictionary *)info;
- (void)checkChooseClassInfo:(ClassManageModel *)model;
@end
@interface RightClassView : UIView
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style withType:(RightClassViewType)type;
- (void)setupTableViewData:(NSArray *)array withGradName:(NSString *)gradeName;
@property(assign, nonatomic) id<RightClassViewDelegate> rightDelegate;
@end
