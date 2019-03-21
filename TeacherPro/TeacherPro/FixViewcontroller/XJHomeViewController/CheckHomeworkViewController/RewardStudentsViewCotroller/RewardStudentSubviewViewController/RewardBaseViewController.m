//
//  RewardBaseViewController.m
//  AplusKidsMasterPro
//
//  Created by DCQ on 2017/3/9.
//  Copyright © 2017年 neon. All rights reserved.
//

#import "RewardBaseViewController.h"
#import "StudentHomeworkDetailViewController.h"

NSString * const  RewardCellIndentifier = @"RewardCellIndentifier";
NSString * const  AllRewardCellIndentifier= @"AllRewardCellIndentifier";


@interface RewardBaseViewController ()<XLPagerTabStripChildItem,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, copy) NSString * coinNubmer;
@property (nonatomic, copy) NSString * adjustCoinNubmer;

@end

@implementation RewardBaseViewController

- (void)registerCell{
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AllRewardCell class]) bundle:nil] forCellReuseIdentifier:AllRewardCellIndentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RewardCell class]) bundle:nil] forCellReuseIdentifier:RewardCellIndentifier];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isNetReqeustEmptyData = YES;
    self.coinNubmer = @"0";

    [self resetData];
   
    [self updateTableView];
  
    self.view.backgroundColor = project_background_gray;
    self.tableView.backgroundColor = [UIColor clearColor];
    
   
    // Do any additional setup after loading the view.
}

- (CGRect)getTableViewFrame{
    CGRect tableViewFrame = [self getChangeTableView];
    return tableViewFrame;
}

- (CGRect)getChangeTableView{

    CGRect tableViewFrame = CGRectZero;
    CGFloat bottomHeight = FITSCALE(60);
    CGFloat viewHeight = self.view.frame.size.height - FITSCALE(44);
    if ([self adjustRewardViewHidden]) {
        tableViewFrame = CGRectMake(0,0, self.view.frame.size.width, viewHeight - bottomHeight   );
    }else{
        CGFloat adjustRewardHeight = FITSCALE(60);
        if (self.formType == RewardBaseViewControllerType_lookUnonlineHomework||self.formType == RewardBaseViewControllerType_lookOnlineHomework) {
            adjustRewardHeight = 0;
        }else if (self.formType == RewardBaseViewControllerType_checkOnlineHomework){
            adjustRewardHeight = FITSCALE(60)  ;
        }else if (self.formType == RewardBaseViewControllerType_checkUnonlineHomework){
            adjustRewardHeight = FITSCALE(0)  ;
        }
        tableViewFrame = CGRectMake(0, 0, self.view.frame.size.width, viewHeight - adjustRewardHeight  );
    }

    return tableViewFrame;
}
-  (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
  
//    //初始化当前操作的列表
//    if (!self.rewardList) {
//        self.rewardList = [[NSMutableArray alloc]init];
//       
//    }
////    self.coinNubmer = @"0";
//    //重新筛选数据
//     [self resetData];
// 
//      [self updateTableView];

}


- (void)resetData{
    [self.rewardList removeAllObjects];
    //获取全部列表数据
    self.listData = [[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"allRewardDataList"]];
    
    for (NSDictionary * dic in self.listData) {
        if ([dic[[self getTypeState]] isEqualToString:@"YES"]) {
            NSMutableDictionary * tempDic = [NSMutableDictionary dictionaryWithDictionary:dic];
            [self.rewardList addObject:tempDic];
        }
       
    }
    
    if ([self.listData count] < MinSendCoinStudentsNumber) {
        self.isSendCoin = NO;
    }else{
        self.isSendCoin = YES;
    }
}

- (NSString *)getTypeState{

    return @"";
}
- (BOOL)adjustRewardViewHidden{
    if (self.rewardList.count >= MinSendCoinStudentsNumber) {
        
        return NO;
    }else{
        return YES;
    }
}

- (void)changeTableViewFrame{

    self.tableView.frame = [self getChangeTableView];
    
}
- (BOOL)allSelectedBtnHidden{
   
    
    BOOL hidden = YES;
    if (self.formType == RewardBaseViewControllerType_lookOnlineHomework||self.formType == RewardBaseViewControllerType_lookUnonlineHomework||self.formType == RewardBaseViewControllerType_checkUnonlineHomework) {
        hidden = YES;
    }else{
        if (!self.isSendCoin) {
            hidden = YES;
        }else{
            hidden = NO;
        }
    }
    return hidden;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSString *)titleForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    return @"";
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.rewardList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return FITSCALE(70);
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.rewardList.count == 0) {
        return 0;
    }else
        return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat headerHeight =  0.000001;
    if (section == 0 &&self.formType == RewardBaseViewControllerType_checkOnlineHomework) {
        headerHeight = FITSCALE(7);
    }else  if (section == 0 &&self.formType == RewardBaseViewControllerType_checkUnonlineHomework) {
        headerHeight = FITSCALE(7);
    }
    return headerHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.000001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView * headerView = [[UIView alloc]init];
    if ( section == 0&&self.formType == RewardBaseViewControllerType_checkOnlineHomework) {
        headerView.frame = CGRectMake(0, 0, IPHONE_WIDTH, FITSCALE(7));
        headerView.backgroundColor = [UIColor clearColor];
    }else  if ( section == 0&&self.formType == RewardBaseViewControllerType_checkUnonlineHomework) {
        headerView.frame = CGRectMake(0, 0, IPHONE_WIDTH, FITSCALE(7));
        headerView.backgroundColor = [UIColor clearColor];
    }
    
    return headerView;
}


- (BOOL)getUnfinished{

    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ( self.formType == RewardBaseViewControllerType_lookOnlineHomework  ) {
        
         [self gotoStudentDetail:self.rewardList[indexPath.section]];
        
    }else{
        if(self.isSendCoin){
            [self setupSelectedState:indexPath];
        }
    }
}

- (void)setupSelectedState:(NSIndexPath *)indexPath{
    
    BOOL yesOrNo ;
    if ([self.statusArray[indexPath.section] intValue] == 0) {
        yesOrNo = YES;
    }else {
        yesOrNo = NO;
    }
    [self.statusArray replaceObjectAtIndex:indexPath.section withObject:[NSNumber numberWithInteger:yesOrNo]];
    
    //选中
    if (yesOrNo) {
        [self addItmeData:self.rewardList[indexPath.section] isAdjustCoinNubmer:YES];
        
    }else{
        //取消
        [self cancelItemData:self.rewardList[indexPath.section]];
        
    }
    [self resetData];
    [self updateTableView];
    
    //改变全选按钮状态
    [self.statusArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSNumber * state = obj;
        if (![state boolValue]) {
            if (self.changeStateBlock) {
                self.changeStateBlock([state boolValue]);
            }
            *stop = YES; // Stop enumerating
            return ;
        }
        if (idx == self.statusArray.count -1) {
            if (self.changeStateBlock) {
                self.changeStateBlock(YES);
            }
            
            *stop = YES; // Stop enumerating
            return ;
        }
    }];

}
- (void)cancelItemData:(NSDictionary *)dic{

    NSMutableArray * tempList =  [[NSMutableArray alloc]init];
     NSArray * tempListData = [[NSUserDefaults standardUserDefaults] objectForKey:@"allRewardDataList"];
    for (int i = 0; i< tempListData.count ; i++) {
        NSMutableDictionary * tempDic = [NSMutableDictionary dictionaryWithDictionary:tempListData[i]];
        if ([[NSString stringWithFormat:@"%@",tempDic[@"studentId"]] isEqualToString: [NSString stringWithFormat:@"%@",dic[@"studentId"]]]) {
            
            NSInteger  coin = [dic[@"coin"] integerValue] - [self.adjustCoinNubmer integerValue] ;
            
            [tempDic setObject:[NSString stringWithFormat:@"%zd",coin] forKey:@"coin"];
            
        }
        [tempList  addObject:tempDic];
    }
    [[NSUserDefaults standardUserDefaults] setObject:tempList forKey:@"allRewardDataList"];


}

//折叠状态
-(NSMutableArray *)statusArray
{
    if (!_statusArray) {
        _statusArray = [NSMutableArray array];
    }
    if (_statusArray.count) {
        if (_statusArray.count > self.tableView.numberOfSections) {
            [_statusArray removeObjectsInRange:NSMakeRange(self.tableView.numberOfSections - 1, _statusArray.count - self.tableView.numberOfSections)];
            
        }else if (_statusArray.count < self.tableView.numberOfSections) {
            for (NSInteger i = self.tableView.numberOfSections - _statusArray.count; i < self.tableView.numberOfSections; i++) {
                [_statusArray addObject:[NSNumber numberWithInteger:YES]];
            }
        }
    }else{
        for (NSInteger i = 0; i < self.tableView.numberOfSections; i++) {
            [_statusArray addObject:[NSNumber numberWithInteger:YES]];
        }
    }
    return _statusArray;
}

- (NSMutableArray *)rewardList{

    if (!_rewardList) {
        _rewardList = [[NSMutableArray alloc] init];
    }
    return _rewardList;
}
//全选 全取消
- (void)setupAllStateArrayNumber:(BOOL)YesOrNo{
 
    for(int index = 0 ; index < self.rewardList.count;index++) {
        //选中的取消的豆
        if ([self.statusArray[index] intValue] == 1 ) {
            
            NSDictionary * dic = self.rewardList[index];
            
            [self cancelItemData:dic];
            
        }else{
            //没选中的增加
            NSDictionary * dic = self.rewardList[index];
            [self addItmeData:dic isAdjustCoinNubmer:YES];
            
        }
        
    }
    
    for (int i = 0; i< self.statusArray.count; i++) {
            [self.statusArray replaceObjectAtIndex:i withObject:[NSNumber numberWithInteger:YesOrNo]];
    }
     [self updateTableView];
    
}



- (void)updateTVCoin:(NSString *)coinNubmer withAdjustCoinNubmer:(NSString *)adjustCoinNubmer{
 
    self.coinNubmer = coinNubmer;
    self.adjustCoinNubmer = adjustCoinNubmer;
    [self changeAllData];
     [self resetData];
    [self updateTableView];
}

- (void)changeAllData{
    
    for(int index = 0 ; index < self.rewardList.count;index++) {
        //选中的修改的豆
        if ([self.statusArray[index] intValue] == 1 ) {
            
            NSDictionary * dic = self.rewardList[index];
            [self addItmeData:dic isAdjustCoinNubmer:NO];
            
        }
        
    }
    
 
    
}

- (void)addItmeData:(NSDictionary *)dic isAdjustCoinNubmer:(BOOL )yesOrNo{
    NSMutableArray * tempList =  [[NSMutableArray alloc]init];
    NSArray * tempListData = [[NSUserDefaults standardUserDefaults] objectForKey:@"allRewardDataList"];
   
    for (int i = 0; i< tempListData.count ; i++) {
        
        NSMutableDictionary * tempDic = [NSMutableDictionary dictionaryWithDictionary:tempListData[i]];
        if ([[NSString stringWithFormat:@"%@",tempDic[@"studentId"]] isEqualToString:[NSString stringWithFormat:@"%@",dic[@"studentId"] ]]) {
            
            NSInteger  coin = [dic[@"coin"] integerValue] + [ (yesOrNo?self.adjustCoinNubmer: self.coinNubmer) integerValue];
            
            [tempDic setObject:[NSString stringWithFormat:@"%zd",coin] forKey:@"coin"];
            
        }
        [tempList  addObject:tempDic];
    }
    [[NSUserDefaults standardUserDefaults] setObject:tempList forKey:@"allRewardDataList"];
}


- (void)gotoStudentDetail:(NSDictionary *)studentInfo{
    
    NSAssert(studentInfo[@"studentId"], @"学生id 为空");
    [self gotoStudentHomeworkDetailVC:studentInfo[@"studentId"] studnetName:studentInfo[@"studentName"]];
    
}
- (void)gotoStudentHomeworkDetailVC:(NSString *)studentId studnetName:(NSString *)studentName{
    
    StudentHomeworkDetailViewController * detail = [[StudentHomeworkDetailViewController alloc]initWithStudent:studentId withStudentName:studentName   withHomeworkId:self.homeworkId withHomeworkState:self.isCheck];
    NSMutableArray * studentList = [[NSMutableArray alloc]init];
    NSInteger  currentPage = 0;

        for (int i=0;i<[self.rewardList count] ;i++) {
            NSDictionary * dic = self.rewardList[i];
            [studentList addObject:dic];
            if ([dic[@"studentId"] isEqualToString:studentId]) {
                currentPage = i;
            }
        }
        
    detail.studentList = studentList;
    detail.currenntIndex = currentPage;
    [self pushViewController:detail];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    
    return 0;
}

@end
