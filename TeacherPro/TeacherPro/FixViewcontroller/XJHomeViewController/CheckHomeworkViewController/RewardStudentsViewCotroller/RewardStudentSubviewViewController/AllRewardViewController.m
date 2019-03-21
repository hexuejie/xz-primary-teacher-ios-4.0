//
//  AllRewardViewController.m
//  AplusKidsMasterPro
//
//  Created by DCQ on 2017/3/8.
//  Copyright © 2017年 neon. All rights reserved.
//

#import "AllRewardViewController.h"
#import "RewardGroupSectionHeaderView.h"
#import "StudentHomeworkDetailViewController.h"
#import "StudentKHLXHomeworkDetailVC.h"

#import "OnlineAllRewardCell.h"
#import "UnOnlineRewardCell.h"

NSString *const OnlineAllRewardCellIdentifier = @"OnlineAllRewardCellIdentifier";
NSString *const UnOnlineRewardCellIdentifier = @"UnOnlineRewardCellIdentifier";



@interface AllRewardViewController ()
@property(nonatomic, assign) AllRewardStudentGroupType groupType;

@end

@implementation AllRewardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.groupType = AllRewardStudentGroupType_normal;
    // Do any additional setup after loading the view.
}

- (void)registerCell{

    [super registerCell];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([OnlineAllRewardCell class]) bundle:nil] forCellReuseIdentifier:OnlineAllRewardCellIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UnOnlineRewardCell class]) bundle:nil] forCellReuseIdentifier:UnOnlineRewardCellIdentifier];
    
    
}
- (AllRewardStudentGroupType)getGroupType{

    return self.groupType;
}
#pragma mark ---
- (void)setupAllRewardViewControllerGroupType:(AllRewardStudentGroupType) groupType{

    self.groupType = groupType;
    if (self.groupType == AllRewardStudentGroupType_normal) {
        [self resetNormalData];
    }else if (self.groupType == AllRewardStudentGroupType_Results){
        [self resetResultsData];
        
    }else if (self.groupType == AllRewardStudentGroupType_Complete){
    
        [self resetCompleteData];
    }else if (self.groupType == AllRewardStudentGroupType_Feedback){
    
        [self resetFeedbackData];
    }
    
}

- (void)resetNormalData{

    [self resetData];
}

- (void)resetResultsData{
    if (self.rewardList) {
         [self.rewardList removeAllObjects];
    }else{
    
        self.rewardList = [[NSMutableArray alloc]init];
    }
   
    
    NSArray * allStudentArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"allRewardDataList"];
    
     NSMutableArray * scoreLevelA = [[NSMutableArray alloc]init];
     NSMutableArray * scoreLevelB = [[NSMutableArray alloc]init];
     NSMutableArray * scoreLevelC = [[NSMutableArray alloc]init];
     NSMutableArray * scoreLevelD = [[NSMutableArray alloc]init];
    for (NSDictionary * studentInfo in allStudentArray) {
  
        //
        if (studentInfo[@"scoreLevel"]) {
            if ([studentInfo[@"scoreLevel"] isEqualToString:@"A"]) {
                [scoreLevelA addObject:studentInfo];
            }else  if ([studentInfo[@"scoreLevel"] isEqualToString:@"B"]) {
                 [scoreLevelB addObject:studentInfo];
            }else  if ([studentInfo[@"scoreLevel"] isEqualToString:@"C"]) {
                 [scoreLevelC addObject:studentInfo];
            }
        }
        //未完成
        else{
            [scoreLevelD addObject:studentInfo];
        }
  
    }
    
    if ([scoreLevelA count] > 0) {
        [self.rewardList addObject:@{@"title":@"A",@"content":scoreLevelA}];
    }
    if ([scoreLevelB count] > 0) {
        [self.rewardList addObject:@{@"title":@"B",@"content":scoreLevelB}];
    }
    if ([scoreLevelC count] > 0) {
        [self.rewardList addObject:@{@"title":@"C",@"content":scoreLevelC}];
    }
    if ([scoreLevelD count] > 0) {
        [self.rewardList addObject:@{@"title":@"未完成",@"content":scoreLevelD}];
    }
    scoreLevelA = nil;
    scoreLevelB = nil;
    scoreLevelC = nil;
    scoreLevelD = nil;
}

- (void)resetCompleteData{

    if (self.rewardList) {
        [self.rewardList removeAllObjects];
    }else{
        
        self.rewardList = [[NSMutableArray alloc]init];
    }
    
    NSArray * allStudentArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"allRewardDataList"];
    
    NSMutableArray * completeArray = [[NSMutableArray alloc]init];
    NSMutableArray * uncompleteArray = [[NSMutableArray alloc]init];
 
    for (NSDictionary * studentInfo in allStudentArray) {
        
        //完成
        if (studentInfo[@"finishTime"]) {
            [completeArray addObject:studentInfo];
        }
        //未完成
        else{
            [uncompleteArray addObject:studentInfo];
        }
        
    }
    
    if ([completeArray count] > 0) {
        [self.rewardList addObject:@{@"title":@"完成",@"content":completeArray}];
    }
    if ([uncompleteArray count] > 0) {
        [self.rewardList addObject:@{@"title":@"未完成",@"content":uncompleteArray}];
    }
   
    completeArray = nil;
    uncompleteArray = nil;
 
    
    
}

- (void)resetFeedbackData{
    if (self.rewardList) {
        [self.rewardList removeAllObjects];
    }else{
        
        self.rewardList = [[NSMutableArray alloc]init];
    }
    NSArray * allStudentArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"allRewardDataList"];
    
    NSMutableArray * feedbackArray = [[NSMutableArray alloc]init];
    NSMutableArray * unFeedbackArray = [[NSMutableArray alloc]init];
    
    for (NSDictionary * studentInfo in allStudentArray) {
        
        //完成
        if (studentInfo[@"finishTime"]) {
            [feedbackArray addObject:studentInfo];
        }
        //未完成
        else{
            [unFeedbackArray addObject:studentInfo];
        }
        
    }
    
    if ([feedbackArray count] > 0) {
        [self.rewardList addObject:@{@"title":@"已反馈",@"content":feedbackArray}];
    }
    if ([unFeedbackArray count] > 0) {
        [self.rewardList addObject:@{@"title":@"未反馈",@"content":unFeedbackArray}];
    }
    
    feedbackArray = nil;
    unFeedbackArray = nil;
    
}
#pragma mark ---
- (BOOL)adjustRewardViewHidden{
    
    return YES;
}
 
- (BOOL)allSelectedBtnHidden{
    if (self.rewardList.count > 0) {
        return NO;
    }else
        return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)getDescriptionText{
    
    NSString * description = @"暂无学生!";
   
    return description;
}
-(NSString *)titleForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    return @"全部";
    
}



- (NSString *)getTypeState{
    
    return @"aLLStudents";
}

#pragma mark ---
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = nil;
    if (self.formType == RewardBaseViewControllerType_lookOnlineHomework||self.formType == RewardBaseViewControllerType_checkOnlineHomework) {
        
        OnlineAllRewardCell * tempCell = [tableView dequeueReusableCellWithIdentifier:OnlineAllRewardCellIdentifier];
        NSDictionary * studentInfo;
        if (self.groupType == AllRewardStudentGroupType_normal) {
              studentInfo = self.rewardList[indexPath.section]; 
        }else{
            NSDictionary * tempInfo  = self.rewardList[indexPath.section];
            studentInfo = tempInfo[@"content"][indexPath.row];
        }
        tempCell.indexPath = indexPath;
        WEAKSELF
        tempCell.selectedBlock = ^(NSIndexPath *index) {
            NSString * studentId = weakSelf.rewardList[index.section][@"studentId"];
            NSString * studentName = weakSelf.rewardList[index.section][@"studentName"];
            if (self.selectedOnlineNotItemBlock) {
                self.selectedOnlineNotItemBlock(studentId,studentName);
            }
        };
        
        [tempCell setupStudentInfo:studentInfo withIsShow:self.isSendCoin];
        
        cell = tempCell;
    }else if (self.formType == RewardBaseViewControllerType_lookUnonlineHomework||self.formType == RewardBaseViewControllerType_checkUnonlineHomework){
    
        UnOnlineRewardCell * tempCell = [tableView dequeueReusableCellWithIdentifier:UnOnlineRewardCellIdentifier];
         NSDictionary * studentInfo;
        if (self.groupType == AllRewardStudentGroupType_normal) {
            studentInfo = self.rewardList[indexPath.section];
            
        }else{
            NSDictionary * tempInfo  = self.rewardList[indexPath.section];
            studentInfo = tempInfo[@"content"][indexPath.row];
        }
        tempCell.indexPath = indexPath;
        WEAKSELF
        tempCell.selectedBlock = ^(NSIndexPath *index) {
            NSString * studentId = weakSelf.rewardList[index.section][@"studentId"];
            if (self.selectedUnOnlineNotItemBlock) {
                self.selectedUnOnlineNotItemBlock(studentId);
            }
        };
        [tempCell setupStudentInfo:studentInfo];
        cell =tempCell;
    } else{
        AllRewardCell * tempCell = [tableView dequeueReusableCellWithIdentifier:@"AllRewardCellIndentifier"];
        
        tempCell.indexPath = indexPath;
        if (!self.isShowResultsGroup) {
            [tempCell hiddenDetailButton];
        }
        if (self.groupType == AllRewardStudentGroupType_normal) {
            
            WEAKSELF
            tempCell.detailBlock = ^(NSIndexPath *index) {
                STRONGSELF
                [strongSelf gotoStudentDetail:strongSelf.rewardList[index.section]];
            };
            
            NSDictionary * studentInfo = self.rewardList[indexPath.section];
            cell.backgroundColor = [UIColor whiteColor];
            BOOL  isShow = YES ;
            if (self.formType == RewardBaseViewControllerType_lookUnonlineHomework||self.formType == RewardBaseViewControllerType_checkUnonlineHomework){
                isShow = NO;
            }
            [tempCell setupStudentInfo:studentInfo withShowReward:isShow];
            
        }else   {
            
            WEAKSELF
            tempCell.detailBlock = ^(NSIndexPath *index) {
                STRONGSELF
                NSDictionary * tempInfo  = strongSelf.rewardList[index.section];
                NSDictionary * studentInfo = tempInfo[@"content"][index.row];
                
                [strongSelf gotoStudentDetail:studentInfo];
            };
            cell.backgroundColor = UIColorFromRGB(0xfbfbfb);
            NSDictionary * tempInfo  = self.rewardList[indexPath.section];
            NSDictionary * studentInfo = tempInfo[@"content"][indexPath.row];
            BOOL  isShow = YES ;
            if (self.formType == RewardBaseViewControllerType_checkUnonlineHomework){
                isShow = NO;
            }
            [tempCell setupStudentInfo:studentInfo withShowReward:isShow ];
            
            
        }

        cell = tempCell;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger sections = 0;
    
     sections =  self.rewardList.count;
    
    return sections;
}
 
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat headerHeight = 0.000001;
    if (self.groupType == AllRewardStudentGroupType_normal) {
        headerHeight = 0.00000001;
    }else {
        headerHeight = FITSCALE(44);
    }
    
    return headerHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    NSInteger row = 0;
    if (self.groupType == AllRewardStudentGroupType_normal) {
        row = 1;
    }else {
        NSDictionary * sectionInfo = self.rewardList[section];
        
        row = [sectionInfo[@"content"] count];
    }
    return row;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headerView  = [UIView new];
    if (self.groupType != AllRewardStudentGroupType_normal) {
        CGFloat headerHeight =  FITSCALE(44);
 
      RewardGroupSectionHeaderView * sectionView  =   [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([RewardGroupSectionHeaderView class]) owner:nil options:nil].firstObject;
        sectionView.frame = CGRectMake(0, 0, self.view.frame.size.width, headerHeight);
        NSDictionary * sectionDic = self.rewardList[section];
        NSString * title = sectionDic[@"title"];
        NSString * number = [NSString stringWithFormat:@"%zd",[sectionDic[@"content"] count]];
        
        BOOL  isOpen = NO;
        [sectionView setupTitle:title withNumber:number withOpenState:isOpen];
        
        headerView = sectionView;
    }
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    CGFloat footerHeight = 0.000001;
    if (self.groupType != AllRewardStudentGroupType_normal) {
        footerHeight =  FITSCALE(9);
      
    }
    return footerHeight;
}

- (  UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    UIView * footerView = [[UIView alloc]init];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}
#pragma mark ---
- (void)gotoStudentDetail:(NSDictionary *)studentInfo{

    NSAssert(studentInfo[@"studentId"], @"学生id 为空");
 
    if (self.onlyKhlxOnline) {
        [self gotoStudentKHLXHomeworkDetailVC:studentInfo[@"studentId"] studnetName:studentInfo[@"studentName"]];
      
    }else{
        [self gotoStudentHomeworkDetailVC:studentInfo[@"studentId"] studnetName:studentInfo[@"studentName"]];
    }
    
}
- (void)gotoStudentKHLXHomeworkDetailVC:(NSString *)studentId studnetName:(NSString *)studentName{
    
    StudentKHLXHomeworkDetailVC * detail = [[StudentKHLXHomeworkDetailVC alloc]initWithStudentName:studentName withStudentId:studentId withHomeworkId:self.homeworkId];
    
    [self pushViewController:detail];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //学生必须要有成绩才能查看作业详情
    if ( self.isShowResultsGroup) {
        
      
        NSDictionary * studentInfo = nil;
        if (self.groupType == AllRewardStudentGroupType_normal) {
            studentInfo = self.rewardList[indexPath.section];
        }else {
            NSDictionary * tempInfo  = self.rewardList[indexPath.section];
           studentInfo = tempInfo[@"content"][indexPath.row];
        }
        
        if ([self hasUnknowQuestions:studentInfo]) {
            NSString * studentId = self.rewardList[indexPath.section][@"studentId"];
            NSString * studentName = self.rewardList[indexPath.section][@"studentName"];
            if (self.selectedOnlineNotItemBlock) {
                self.selectedOnlineNotItemBlock(studentId,studentName);
            }
        }else{
           [self gotoStudentDetail:studentInfo];
        }
       
    }else{
        //离线作业 
        NSDictionary * studentInfo;
        if (self.groupType == AllRewardStudentGroupType_normal) {
            studentInfo = self.rewardList[indexPath.section];
            
        }else{
            NSDictionary * tempInfo  = self.rewardList[indexPath.section];
            studentInfo = tempInfo[@"content"][indexPath.row];
        }
        
        if ([studentInfo objectForKey:@"unknowQuestions"] && [[studentInfo objectForKey:@"unknowQuestions"] count] >0) {
            NSString * studentId = self.rewardList[indexPath.section][@"studentId"];
            if (self.selectedUnOnlineNotItemBlock) {
                self.selectedUnOnlineNotItemBlock(studentId);
            }

        }
        
    }
    
}

- (BOOL)hasUnknowQuestions:(NSDictionary *)studentInfo{
    BOOL isUnknowQuestion =  NO;
    if ([studentInfo objectForKey:@"unknowQuestions"] && [[studentInfo objectForKey:@"unknowQuestions"] count] >0) {
        isUnknowQuestion = YES;
        
    }
    
    return isUnknowQuestion;
}
- (void)gotoStudentHomeworkDetailVC:(NSString *)studentId studnetName:(NSString *)studentName{
    
    StudentHomeworkDetailViewController * detail = [[StudentHomeworkDetailViewController alloc]initWithStudent:studentId withStudentName:studentName   withHomeworkId:self.homeworkId withHomeworkState:self.isCheck];
    NSMutableArray * studentList = [[NSMutableArray alloc]init];
    NSInteger  currentPage = 0;
    if (self.groupType == AllRewardStudentGroupType_normal) {
        for (int i=0;i<[self.rewardList count] ;i++) {
            NSDictionary * dic = self.rewardList[i];
            [studentList addObject:dic];
            if ([dic[@"studentId"] isEqualToString:studentId]) {
                currentPage = i;
            }
        }
        
    }else {
        for (int i=0;i<[self.rewardList count] ;i++) {
            
            NSDictionary * dic = self.rewardList[i];
            for (NSDictionary * tempDic in dic[@"content"]) {
                 [studentList addObject:tempDic ];
            }
            
        }
        
        for (int i=0;i<[studentList count] ;i++) {
            NSDictionary * dic = studentList[i];
           if ([dic[@"studentId"] isEqualToString:studentId]) {
                currentPage = i;
            }
        }
    
    }
   
    detail.studentList = studentList;
    detail.currenntIndex = currentPage;
    [self pushViewController:detail];
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
