//
//  RewardViewController.h
//  AplusKidsMasterPro
//
//  Created by DCQ on 2017/3/8.
//  Copyright © 2017年 neon. All rights reserved.
//

#import "XLButtonBarPagerTabStripViewController.h"

typedef NS_ENUM(NSInteger, RewardStudentViewControlleType){

    RewardStudentViewControlleType_normal =  0,
    RewardStudentViewControlleType_checkOnlineHomework ,//检查在线作业
    RewardStudentViewControlleType_checkUnonlineHomework ,//检查 非在线作业
    
    RewardStudentViewControlleType_lookOnlineHomework ,//查看 在线
    RewardStudentViewControlleType_lookUnonlineHomework ,//查看 非在线作业
};

typedef NS_ENUM(NSInteger,HomeworkBackfeedType){
    
    HomeworkBackfeedType_normal =  0,
    HomeworkBackfeedType_nono ,   // 不需要反馈
    HomeworkBackfeedType_backfeed ,//需要反馈
};

typedef void(^HomeworkCheckSuccessBlock)();
@interface RewardStudentViewController : XLButtonBarPagerTabStripViewController
- (instancetype)initWithRewardType:(RewardStudentViewControlleType) type  withTitle:(NSString *)title withHomeworkId:(NSString *)homeworkId withHomeworkBackfeedType:(HomeworkBackfeedType)backfeedType;
@property(nonatomic, copy) HomeworkCheckSuccessBlock  checkSuccessBlock;
@end
