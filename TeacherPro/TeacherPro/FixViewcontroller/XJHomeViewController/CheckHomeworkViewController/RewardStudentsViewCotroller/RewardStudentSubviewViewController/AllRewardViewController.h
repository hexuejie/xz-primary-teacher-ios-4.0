//
//  AllRewardViewController.h
//  AplusKidsMasterPro
//
//  Created by DCQ on 2017/3/8.
//  Copyright © 2017年 neon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RewardBaseViewController.h"

typedef NS_ENUM(NSInteger, AllRewardStudentGroupType) {

    AllRewardStudentGroupType_normal  = 0,//无分组
    AllRewardStudentGroupType_Results    ,//成绩分组
    AllRewardStudentGroupType_Feedback   ,//反馈分组
    AllRewardStudentGroupType_Complete    ,//完成分组
   
};
typedef void(^SelectedNotItemBlock)(NSString * studentId);
typedef void(^SelectedOnlineNotItemBlock)(NSString * studentId, NSString *studentName);
@interface AllRewardViewController : RewardBaseViewController
@property(nonatomic, copy) SelectedOnlineNotItemBlock selectedOnlineNotItemBlock;
@property(nonatomic, copy) SelectedNotItemBlock selectedUnOnlineNotItemBlock;
- (void)setupAllRewardViewControllerGroupType:(AllRewardStudentGroupType) groupType;

- (AllRewardStudentGroupType)getGroupType;
@end
