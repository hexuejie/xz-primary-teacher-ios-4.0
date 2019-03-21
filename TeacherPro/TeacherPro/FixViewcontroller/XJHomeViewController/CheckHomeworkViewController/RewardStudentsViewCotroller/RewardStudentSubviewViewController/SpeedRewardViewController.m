//
//  SpeedRewardViewController.m
//  AplusKidsMasterPro
//
//  Created by DCQ on 2017/3/9.
//  Copyright © 2017年 neon. All rights reserved.
//

#import "SpeedRewardViewController.h"
#import "OnlineRewardsAdjustCell.h"
#import "OnlineAllRewardCell.h"


NSString * const OnlineSpeedRewardsAdjustCellIdentifier = @"OnlineSpeedRewardsAdjustCellIdentifier";
NSString * const LookOnlineSpeedRewardCellIdentifier = @"LookOnlineSpeedRewardCellIdentifier";
@interface SpeedRewardViewController ()

@end

@implementation SpeedRewardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)registerCell{
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([OnlineRewardsAdjustCell class]) bundle:nil] forCellReuseIdentifier:OnlineSpeedRewardsAdjustCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([OnlineAllRewardCell class]) bundle:nil] forCellReuseIdentifier:LookOnlineSpeedRewardCellIdentifier];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSString *)titleForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    return @"速度之星";
    
}

- (NSString *)getTypeState{
    
    return @"speedStudents";
}
- (NSString *)getDescriptionText{
    
    NSString * description = @"本次作业没有产生“速度之星”!";
    
    return description;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = nil;
    if (self.formType == RewardBaseViewControllerType_checkOnlineHomework ) {
        OnlineRewardsAdjustCell * tempCell = [tableView dequeueReusableCellWithIdentifier:OnlineSpeedRewardsAdjustCellIdentifier];
        NSDictionary * studentInfo =self.rewardList[indexPath.section];
        
        if ([self.statusArray[indexPath.section] intValue] == 0) {
            [tempCell setupSelectedImgState:NO];
            [tempCell setupStudentInfo:studentInfo ];
        }else if ([self.statusArray[indexPath.section] intValue] == 1){
            [tempCell setupSelectedImgState:YES];
            NSMutableDictionary * tempDic = [[NSMutableDictionary alloc]initWithDictionary:studentInfo];
            NSInteger  coin = [studentInfo[@"coin"] integerValue] ;
            
            [tempDic setObject:[NSString stringWithFormat:@"%zd",coin] forKey:@"coin"];
            
            [tempCell setupStudentInfo:tempDic ];
            
        }
         [tempCell setupSelectedImgHidden:!self.isSendCoin]; 
        cell = tempCell;
        
        
    }else if(self.formType == RewardBaseViewControllerType_lookOnlineHomework){
        OnlineAllRewardCell * tempCell = [tableView dequeueReusableCellWithIdentifier:LookOnlineSpeedRewardCellIdentifier];
        NSDictionary * studentInfo;
        studentInfo = self.rewardList[indexPath.section];
        [tempCell setupStudentInfo:studentInfo withIsShow:self.isSendCoin];
        cell = tempCell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
