//
//  UnfinishedViewController.m
//  AplusKidsMasterPro
//
//  Created by DCQ on 2017/3/9.
//  Copyright © 2017年 neon. All rights reserved.
//

#import "UnfinishedViewController.h"
#import "OnlineUnfinishedAdjustCell.h"
#import "OnlineUnfinishedLookCell.h"
#import "UnOnlineUnfinishedCell.h"

NSString * const UnOnlineUnfinishedCellIdentifier = @"UnOnlineUnfinishedCellIdentifier";
NSString * const CheckOnlineUnfinishedAdjustCellIdentifier = @"CheckOnlineUnfinishedAdjustCellIdentifier";
NSString * const OnlineUnfinishedLookCellIdentifier = @"OnlineUnfinishedLookCellIdentifier";
@interface UnfinishedViewController ()

@end

@implementation UnfinishedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)registerCell{

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([OnlineUnfinishedAdjustCell class]) bundle:nil] forCellReuseIdentifier:CheckOnlineUnfinishedAdjustCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UnOnlineUnfinishedCell class]) bundle:nil] forCellReuseIdentifier:UnOnlineUnfinishedCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([OnlineUnfinishedLookCell class]) bundle:nil] forCellReuseIdentifier:OnlineUnfinishedLookCellIdentifier];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSString *)titleForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    return @"未完成";
    
}

- (NSString *)getTypeState{
    
    return @"unfinishedStudents";
}
- (NSString *)getDescriptionText{
    
    NSString * description = @"本次作业没有“未完成”!";
    
    return description;
}

- (BOOL)getUnfinished{
    
    return YES;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = nil;
    if (self.formType == RewardBaseViewControllerType_checkUnonlineHomework||self.formType == RewardBaseViewControllerType_lookUnonlineHomework) {
        UnOnlineUnfinishedCell * allRewardCell = [tableView dequeueReusableCellWithIdentifier:UnOnlineUnfinishedCellIdentifier];
        NSDictionary * studentInfo =self.rewardList[indexPath.section];
        [allRewardCell setupStudentInfo:studentInfo ];
        cell = allRewardCell;
        
    }else if(self.formType == RewardBaseViewControllerType_checkOnlineHomework){
        OnlineUnfinishedAdjustCell * tempCell = [tableView dequeueReusableCellWithIdentifier:CheckOnlineUnfinishedAdjustCellIdentifier];
        NSDictionary *  studentInfo = self.rewardList[indexPath.section];
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
    }else if (self.formType == RewardBaseViewControllerType_lookOnlineHomework){
    
        OnlineUnfinishedLookCell * tempCell = [tableView dequeueReusableCellWithIdentifier:OnlineUnfinishedLookCellIdentifier];
        NSDictionary * studentInfo;
        studentInfo = self.rewardList[indexPath.section];
        [tempCell setupStudentInfo:studentInfo];
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
