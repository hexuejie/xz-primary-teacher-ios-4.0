//
//  RewardBaseViewController.h
//  AplusKidsMasterPro
//
//  Created by DCQ on 2017/3/9.
//  Copyright © 2017年 neon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLPagerTabStripViewController.h"
#import "RewardCell.h"
#import "AllRewardCell.h"
#import "BaseTableViewController.h"

typedef NS_ENUM(NSInteger, RewardBaseViewControllerType){
    RewardBaseViewControllerType_Normal = 0,
    RewardBaseViewControllerType_checkOnlineHomework ,//检查在线作业
    RewardBaseViewControllerType_checkUnonlineHomework,//检查非在线作业
    RewardBaseViewControllerType_lookOnlineHomework ,//查看 在线作业
    RewardBaseViewControllerType_lookUnonlineHomework,//查看 非在线作业
};
typedef void(^RewardBaseChangeStateBlock)(BOOL state);
@interface RewardBaseViewController : BaseTableViewController
@property(nonatomic, copy) RewardBaseChangeStateBlock  changeStateBlock;
@property(nonatomic, strong) NSMutableArray * listData;//唯一的所有学生数据
@property (nonatomic, strong) NSMutableArray * rewardList;//更具每个模块显示的数据
@property (nonatomic, strong) NSMutableArray *statusArray;
@property (nonatomic, assign) BOOL isShowResultsGroup;//是否显示成绩分组
@property (nonatomic, assign) BOOL isCheck;//是否检查状态
@property (nonatomic, copy) NSString * homeworkId;//作业id
@property (nonatomic, assign) BOOL isSendCoin;//是否允许发送学豆
@property (nonatomic, assign) BOOL onlyKhlxOnline;//作业是否包含仅课后练习的在线练习
@property(nonatomic, assign)RewardBaseViewControllerType formType;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)setupAllStateArrayNumber:(BOOL)YesOrNo;
- (void)updateTVCoin:(NSString *)coinNubmer withAdjustCoinNubmer:(NSString *)adjustCoinNubmer;
- (BOOL)adjustRewardViewHidden;
- (BOOL)allSelectedBtnHidden;
- (void)resetData;
- (void)changeTableViewFrame;

@end
