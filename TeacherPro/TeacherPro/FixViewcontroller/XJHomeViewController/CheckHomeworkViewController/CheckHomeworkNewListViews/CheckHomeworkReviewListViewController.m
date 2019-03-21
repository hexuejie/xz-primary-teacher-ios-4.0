//
//  CheckJobViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/6/20.
//  Copyright © 2017年 ZNXZ. All rights reserved.
// 检查作业

#import "CheckHomeworkReviewListViewController.h"
#import "ProUtils.h"
#import "CheckHomeworkListModel.h"
#import "CheckHomeworkCell.h"
#import "ChooseClassViewController.h"
#import "ClassManageModel.h"

#import "HomeworkDetailViewController.h"
#import "CheckHomeworkDetailVC.h"
#import "HWReportViewController.h"
#import "InvitationStudentViewController.h"

typedef NS_ENUM(NSInteger, CheckHomewrokListType){
        CheckHomewrokListType_normal   =  0 ,
        CheckHomewrokListType_unCheck     ,//未检查
        CheckHomewrokListType_check       ,//已检查
    
};
#define  SegmentedViewHeight        44
#define  noCheckBtnTag              323434
#define  checkBtnTag                323435
#define  bottomLineIndexTag              323436
NSString * const CheckHomeworkCellIdentifier = @"CheckHomeworkCellIdentifier";
@interface CheckHomeworkReviewListViewController ()<ChooseClassViewDelegate>

@property(nonatomic, strong) CheckHomeworkListModel * unCheckModels;
@property(nonatomic, strong) CheckHomeworkListModel * checkModels;
@property(nonatomic, strong) CheckHomeworkListModel * models;
@property(nonatomic, assign) CheckHomewrokListType  stateType;
@property(nonatomic, strong) UIView * segmentedView;
@property(nonatomic, copy) NSString * clazzId;
@property(nonatomic, assign) CheckHomewrokListViewControllerFromType fromType;
@property(nonatomic, copy) NSString * day;
@property(nonatomic, assign) BOOL unCheckFirstRequest;
@property(nonatomic, assign) BOOL checkfirstRequest;
@end

@implementation CheckHomeworkReviewListViewController


- (instancetype)initWithType:(CheckHomewrokListViewControllerFromType)type{
    self = [super init];
    if (self) {
         self.stateType = CheckHomewrokListType_unCheck;
         self.fromType = type;
    }
    return self;
}
- (instancetype)initWithType:(CheckHomewrokListViewControllerFromType)type withDay:(NSString *)day{
    self = [super init];
    if (self) {
      
        self.fromType = type;
        self.day = day;
    }
    return self;
}
- (void)viewDidLoad {
    
    self.unCheckFirstRequest = YES;
    self.checkfirstRequest = YES;
    self.currentPageNo = 0;
    self.pageCount = 10;
    
    [super viewDidLoad];
 
    // Do any additional setup after loading the view.
    if (self.fromType == CheckHomewrokListViewControllerFromType_check) {
        [self setNavigationItemTitle:@"检查作业"];
        [self setupSegmentedView];
        [self setupNavigationRightItem];
    }else if (self.fromType == CheckHomewrokListViewControllerFromType_review){
        NSString * yearMonth = [self getYearMonthDay:self.day];
        [self setNavigationItemTitle:yearMonth];
    }
    
    self.view.backgroundColor = project_background_gray;
    self.tableView.backgroundColor = [UIColor clearColor];
  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestUnCheckListHomework) name:UPDATE_CHECKLIST_TEARCHER_COIN object:nil];
}

- (void)requestUnCheckListHomework{

    self.unCheckModels = nil;
    self.models = nil;
    self.currentPageNo = 0;
    if (self.fromType == CheckHomewrokListViewControllerFromType_check) {
        [self requestHomework];
    }else if (self.fromType == CheckHomewrokListViewControllerFromType_review){
        
        [self requestReview];
    }
}
- (NSString *)getYearMonthDay:(NSString *)date{
    
    NSDateFormatter * dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yyyyMMdd";
    NSDate * newDate =  [dateFormatter dateFromString: date];
    
    dateFormatter.dateFormat = @"yyyy年MM月dd日";
    NSString * yearMonth = [dateFormatter stringFromDate: newDate];
    return yearMonth;
}


- (void)registerCell{

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CheckHomeworkCell class]) bundle:nil] forCellReuseIdentifier:CheckHomeworkCellIdentifier];
    
}
- (void)getNormalTableViewNetworkData{
   
    if (self.fromType == CheckHomewrokListViewControllerFromType_check) {
        
         [self requestHomework];
    }else if (self.fromType == CheckHomewrokListViewControllerFromType_review){
    
        [self requestReview];
    }
   
}

- (void) setupNavigationRightItem{
    UIButton * releaseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [releaseBtn setTitle:@"筛选" forState:UIControlStateNormal];
    [releaseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
    [releaseBtn addTarget:self action:@selector(changeAction:) forControlEvents:UIControlEventTouchUpInside];
    [releaseBtn setFrame:CGRectMake(0, 5, 40,60)];
    
    releaseBtn.titleLabel.font = fontSize_15;
    
    
    UIBarButtonItem * rightBar = [[UIBarButtonItem alloc]initWithCustomView:releaseBtn];
    self.navigationItem.rightBarButtonItem = rightBar;
    
}

- (void)changeAction:(UIButton *)sender{

    ChooseClassViewController * createClassVC = [[ChooseClassViewController alloc]initWithViewControllerFromeType:ViewControllerFromeType_checkChoose];
    createClassVC.chooseDelegate = self;
    [self pushViewController:createClassVC];
 
}



- (void)setupSegmentedView{
 
    self.segmentedView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, SegmentedViewHeight)];
    self.segmentedView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.segmentedView];
    
    NSString * noCheckBtnTitle = @"未检查";
    UIButton * noCheckBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    [noCheckBtn setTitle:noCheckBtnTitle forState:UIControlStateNormal];
    [noCheckBtn setTitleColor: UIColorFromRGB(0x6b6b6b) forState:UIControlStateNormal];
    [noCheckBtn setTitleColor: project_main_blue forState:UIControlStateSelected];
    noCheckBtn.selected = YES;
    [noCheckBtn addTarget:self action:@selector(noCheckBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    noCheckBtn.tag = noCheckBtnTag;
    [self.segmentedView addSubview:noCheckBtn];
    
    
    NSString * checkBtnTitle = @"已检查";
    UIButton * checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [checkBtn setTitle:checkBtnTitle forState:UIControlStateNormal];
    [checkBtn setTitleColor: UIColorFromRGB(0x6b6b6b) forState:UIControlStateNormal];
    [checkBtn setTitleColor: project_main_blue forState:UIControlStateSelected];
    [checkBtn addTarget:self action:@selector(checkBtnAction:) forControlEvents:UIControlEventTouchUpInside];
     checkBtn.tag = checkBtnTag;
    [self.segmentedView addSubview:checkBtn];
    
    
    UIView *bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, self.segmentedView.frame.size.height - 1, IPHONE_WIDTH , 0)];
    bottomLine.backgroundColor = UIColorFromRGB(0xd2e6ff);
 
    [self.segmentedView addSubview:bottomLine];
    
    UIView *bottomLineIndex = [[UIView alloc]initWithFrame:CGRectMake(0, self.segmentedView.frame.size.height - FITSCALE(2), IPHONE_WIDTH/2, FITSCALE(2))];
    bottomLineIndex.backgroundColor = project_main_blue;
    bottomLineIndex.tag = bottomLineIndexTag;
    [self.segmentedView addSubview:bottomLineIndex];

    
    [noCheckBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.segmentedView.mas_left);
        make.width.mas_equalTo(self.segmentedView.frame.size.width/2);
        make.height.mas_equalTo(self.segmentedView.frame.size.height);
        
    }];
    
    [checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(noCheckBtn.mas_right);
        make.width.mas_equalTo(self.segmentedView.frame.size.width/2);
        make.height.mas_equalTo(self.segmentedView.frame.size.height);
        
    }];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
 
}
- (BOOL)isAddRefreshHeader{
    BOOL yesOrNo = NO;
    if (self.fromType == CheckHomewrokListViewControllerFromType_check) {
        yesOrNo = YES;
    }else if (self.fromType == CheckHomewrokListViewControllerFromType_review){
        yesOrNo = NO;
    }
    return yesOrNo;
}

- (BOOL)isAddRefreshFooter{
    BOOL yesOrNo = NO;
    if (self.fromType == CheckHomewrokListViewControllerFromType_check) {
        yesOrNo = YES;
    }else if (self.fromType == CheckHomewrokListViewControllerFromType_review){
        yesOrNo = NO;
    }
    return yesOrNo;
}

- (CGRect)getTableViewFrame{

    CGRect tableViewFrame = CGRectZero;
    if (self.fromType == CheckHomewrokListViewControllerFromType_check) {
        tableViewFrame = CGRectMake(0, SegmentedViewHeight,self.view.frame.size.width, self.view.frame.size.height - SegmentedViewHeight);
    }else if (self.fromType == CheckHomewrokListViewControllerFromType_review){
        tableViewFrame = CGRectMake(0, 0,self.view.frame.size.width, self.view.frame.size.height );
    }
    return tableViewFrame;
}
- (void)drogDownRefresh{
    self.currentPageNo = 0;
  
    if (self.fromType == CheckHomewrokListViewControllerFromType_check) {
        if (self.stateType == CheckHomewrokListType_unCheck) {
            self.unCheckModels = nil;
        }else if (self.stateType == CheckHomewrokListType_check){
        
            self.checkModels = nil;
        }
    }else if (self.fromType == CheckHomewrokListViewControllerFromType_review){
      self.models = nil;
    }
    [self getNormalTableViewNetworkData];
}
- (void)getLoadMoreTableViewNetworkData{

    [self getNormalTableViewNetworkData];
   
}
- (NSInteger)getNetworkTableViewDataCount{
    NSInteger  count = 0;
    if (self.fromType == CheckHomewrokListViewControllerFromType_check) {
        if (self.stateType == CheckHomewrokListType_unCheck) {
           count = self.unCheckModels.homeworks.count;
        }else if (self.stateType == CheckHomewrokListType_check){
            
           count = self.checkModels.homeworks.count;
        }
    }else if (self.fromType == CheckHomewrokListViewControllerFromType_review){
        count = self.models.homeworks.count;
    }
    return  count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger count = 0;
    if (self.fromType == CheckHomewrokListViewControllerFromType_review) {
        count = [self.models.homeworks count];
        
    }else if (self.fromType ==  CheckHomewrokListViewControllerFromType_check){
        if (self.stateType == CheckHomewrokListType_unCheck) {
            count = [self.unCheckModels.homeworks  count];
        }else if (self.stateType == CheckHomewrokListType_check){
            count = [self.checkModels.homeworks  count];
        }
        
    }
    return count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 16.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CheckHomeworkModel * model = nil;
    if (self.fromType == CheckHomewrokListViewControllerFromType_check) {
        if (self.stateType == CheckHomewrokListType_unCheck) {
            model = self.unCheckModels.homeworks[indexPath.section];
        }else if (self.stateType == CheckHomewrokListType_check){
            model = self.checkModels.homeworks[indexPath.section];
        }
    }else if (self.fromType == CheckHomewrokListViewControllerFromType_review){
        model = self.models.homeworks[indexPath.section];
    }
    NSString *booksName = [NSString stringWithFormat:@"%@",[model.books componentsJoinedByString:@"\n"]];
    return
    170+  [self getHeightLineWithString:booksName withWidth:kScreenWidth-(145+16+32) withFont:[UIFont systemFontOfSize:14]];
}
- (CGFloat)getHeightLineWithString:(NSString *)string withWidth:(CGFloat)width withFont:(UIFont *)font {
    CGSize size = CGSizeMake(width, 2000);
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:5];
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:style};
    CGFloat height = [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size.height;
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}
- ( UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIImageView * footV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, FITSCALE (7))];
    [footV setImage:[UIImage imageNamed:@"speack_line"]];
    return footV;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell =nil;
    CheckHomeworkCell * tempCell = [ tableView dequeueReusableCellWithIdentifier:CheckHomeworkCellIdentifier];
    BOOL isRemarked = NO;
    CheckHomeworkModel * model = nil;
    if (self.fromType == CheckHomewrokListViewControllerFromType_check) {
        if (self.stateType == CheckHomewrokListType_unCheck) {
            isRemarked = NO;
             model = self.unCheckModels.homeworks[indexPath.section];
        }else if (self.stateType == CheckHomewrokListType_check){
            isRemarked = YES;
            model = self.checkModels.homeworks[indexPath.section];
        }
    }else if (self.fromType == CheckHomewrokListViewControllerFromType_review){
        model = self.models.homeworks[indexPath.section];
        if ([model.status integerValue] == 9) {
              isRemarked = YES;
        }else{
             isRemarked = NO;
        }
    }
    [tempCell setupHomeworkInfo:model isRemarked:isRemarked];
    tempCell.checkeBlock = ^(CheckHomeworkModel *model, NSInteger type) {
        switch (type) {
            case CheckHomeworkCellButtonType_worth:
                [self worthHomework:model.homeworkId];
                break;
            case CheckHomeworkCellButtonType_look:
                [self gotoCheckOrLookHomeworkVC0:type withHomeworkId:model withOnlineHomework:model.onlineHomework];
                break;
            case CheckHomeworkCellButtonType_check:
                [self gotoCheckOrLookHomeworkVC0:type withHomeworkId:model withOnlineHomework:model.onlineHomework];
                break;
            case CheckHomeworkCellButtonType_detail:
                [self gotoHomeworkDetailVC:model];
                break;
            case CheckHomeworkCellButtonType_reprot:
                [self gotoReportVC:model];
                break;
            case CheckHomeworkCellButtonType_InviteStudents:
                [self gotoInviteStudents:model];
                break;
            default:
                break;
        }
    };
    tempCell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell = tempCell;
    
    return cell;
}

- (void)gotoCheckOrLookHomeworkVC0:(CheckHomeworkCellButtonType) type withHomeworkId:(CheckHomeworkModel *)model withOnlineHomework:(NSNumber *)onlineHomework{
    CheckHomeworkDetailVCType  detailType = CheckHomeworkDetailVCType_normal;
    if (type ==   CheckHomeworkCellButtonType_look){
        detailType = CheckHomeworkDetailVCType_look;
        
        NewCheckHomeworkDetailVC * detailVC = [NewCheckHomeworkDetailVC new];
        detailVC.isphonicsHomework = model.isphonicsHomework;
        detailVC.detailVCTyp = detailType;
        detailVC.onlineHomework = onlineHomework;
        detailVC.homeworkId = model.homeworkId;
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }else if (type ==   CheckHomeworkCellButtonType_check) {
        detailType = CheckHomeworkDetailVCType_check;
        
        NewCheckHomeworkDetailVC * detailVC = [NewCheckHomeworkDetailVC new];
        detailVC.detailVCTyp = detailType;
        detailVC.onlineHomework = onlineHomework;
        detailVC.homeworkId = model.homeworkId;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    
}



#pragma mark -

- (void)requestCallHomework:(NSString *)homeworkId{
    NSDictionary *parameterDic = @{@"homeworkId":homeworkId};
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_TeacherCallHomework] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_TeacherCallHomework];
}

- (void)requestReview{

    NSDictionary * parameterDic  = @{@"day":self.day
                                        };
    
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_ListTeacherHomeworkByDay] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_ListTeacherHomeworkByDay];
}

- (void)requestHomework{

    NSString *pageIndex = [NSString stringWithFormat:@"%zd",self.currentPageNo];
    NSString *pageSize = [NSString stringWithFormat:@"%zd",self.pageCount];
    NSString * remarked = @"false";
    if (self.stateType == CheckHomewrokListType_unCheck) {
        remarked = @"false";
    }else if (self.stateType == CheckHomewrokListType_check){
    
        remarked = @"true";
    }
    
    NSDictionary * parameterDicTemp = @{@"pageIndex":pageIndex,
                                        @"pageSize":pageSize,
                                        @"remarked":remarked,
                                        };
    NSMutableDictionary * parameterDic = [NSMutableDictionary dictionaryWithDictionary:parameterDicTemp];
    if (self.clazzId ) {
        [parameterDic addEntriesFromDictionary:@{@"clazzId":self.clazzId}];
    }

    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_ListTeacherHomeworks] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_ListTeacherHomeworks];
}

- (void)setNetworkRequestStatusBlocks{

    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
       STRONGSELF
        if (request.tag == NetRequestType_ListTeacherHomeworks) {
            if (strongSelf.stateType == CheckHomewrokListType_unCheck) {
                strongSelf.unCheckFirstRequest = NO;
                if (!strongSelf.unCheckModels) {
                    strongSelf.unCheckModels = [[CheckHomeworkListModel alloc]initWithDictionary:successInfoObj error:nil];
                    strongSelf.currentPageNo ++;
                }else {
                    
                    CheckHomeworkListModel * tempModel = [[CheckHomeworkListModel alloc]initWithDictionary:successInfoObj error:nil];
                    if (tempModel.homeworks.count >0) {
                        [strongSelf.unCheckModels.homeworks addObjectsFromArray:tempModel.homeworks];
                        strongSelf.currentPageNo ++;
                    }
                    
                }
            }else if (strongSelf.stateType == CheckHomewrokListType_check){
                
                strongSelf.checkfirstRequest = NO;
                if (!strongSelf.checkModels) {
                    strongSelf.checkModels = [[CheckHomeworkListModel alloc]initWithDictionary:successInfoObj error:nil];
                    strongSelf.currentPageNo ++;
                }else {
                    
                    CheckHomeworkListModel * tempModel = [[CheckHomeworkListModel alloc]initWithDictionary:successInfoObj error:nil];
                    if (tempModel.homeworks.count >0) {
                        [strongSelf.checkModels.homeworks addObjectsFromArray:tempModel.homeworks];
                        strongSelf.currentPageNo ++;
                    }
                    
                }
            }
            
            
            
        }else if (request.tag == NetRequestType_TeacherCallHomework){
            if ( successInfoObj[@"studentCount"]) {
                NSString * content = [NSString stringWithFormat:@"成功向%@名学生发送催缴消息",successInfoObj[@"studentCount"]];
                [strongSelf showAlert:TNOperationState_OK content:content];
            }
            
            
        }else if (request.tag == NetRequestType_ListTeacherHomeworkByDay){
        
             strongSelf.models = [[CheckHomeworkListModel alloc]initWithDictionary:successInfoObj error:nil];
        }
        
        [strongSelf updateTableView];
    }];
}


- (void)checkBtnAction:(UIButton *)button{
  
    if (!button.selected) {
        UIButton * otherBtn = [self.segmentedView viewWithTag:noCheckBtnTag];
        otherBtn.selected =  NO;
         button.selected = YES;
        self.stateType = CheckHomewrokListType_check;
       
        if (self.checkfirstRequest) {
            [self beginRefresh];
        }else
        {
            [self updateTableView];
        }

       UIView  *bottomLineIndex  = [self.segmentedView viewWithTag:bottomLineIndexTag];
        [UIView animateWithDuration:0.5 animations:^{
            bottomLineIndex.frame = CGRectMake(CGRectGetWidth(bottomLineIndex.frame), bottomLineIndex.frame.origin.y, CGRectGetWidth(bottomLineIndex.frame), CGRectGetHeight(bottomLineIndex.frame));
        }];
      
    }
    
}

- (void)noCheckBtnAction:(UIButton *)button{

    if (!button.selected  ) {
        UIButton * otherBtn = [self.segmentedView viewWithTag:checkBtnTag];
        otherBtn.selected =  NO;
         button.selected = YES;
        self.stateType = CheckHomewrokListType_unCheck;
        if (self.unCheckFirstRequest) {
               [self beginRefresh];
        }else
        {
            [self updateTableView];
        }
         UIView  *bottomLineIndex  = [self.segmentedView viewWithTag:bottomLineIndexTag];
        [UIView animateWithDuration:0.5 animations:^{
            bottomLineIndex.frame= CGRectMake(0, bottomLineIndex.frame.origin.y, CGRectGetWidth(bottomLineIndex.frame), CGRectGetHeight(bottomLineIndex.frame));
        }];
       
    }
    
}

#pragma mark -- chooseClassDelegate
- (void)checkChooseClassInfo:(ClassManageModel *)classInfo{

    self.clazzId = classInfo.clazzId;
    
    [self beginRefresh];
}



- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
 
    return [UIImage imageNamed:@"Recipient_no_info"];
}
- (NSString *)getDescriptionText{
    
    NSString * description = @"";
    if (self.stateType == CheckHomewrokListType_check) {
        description = @"暂无已检查作业!";
    }else if(self.stateType == CheckHomewrokListType_unCheck){
        description = @"暂无作业!";
    }
    return description;
}



#pragma mark ---
- (void)gotoInviteStudents:(CheckHomeworkModel *)model{
    InvitationStudentViewController * studentVC = [[InvitationStudentViewController alloc]initWithClazzName:model.clazzName withClazzId:model.clazzId];
    [self pushViewController:studentVC];
    
}

//催缴作业
- (void)worthHomework:(NSString *)homeworkId{
    
    [self requestCallHomework:homeworkId];
    
}

//作业详情
- (void)gotoHomeworkDetailVC:(CheckHomeworkModel *)model{
    
    HomeworkDetailViewController * detailVC = [[HomeworkDetailViewController alloc]initWithHomeworkId:model.homeworkId];
    [self pushViewController:detailVC];
    
    

}
//作业报告
- (void)gotoReportVC:(CheckHomeworkModel *)model{
    
    HWReportViewController * detailVC = [[HWReportViewController alloc]initWithHomeworkId:model.homeworkId];
    [self pushViewController:detailVC];
}
//查看作业
- (void)gotoLookHomeworkVC:(CheckHomeworkModel *)model{
//    HomeworkBackfeedType  type;
//    if ([model.feedbackName isEqualToString:@"不需要反馈"]) {
//        type = HomeworkBackfeedType_nono;
//    }else{
//        type = HomeworkBackfeedType_backfeed;
//    }
//    RewardStudentViewControlleType homeworkType = RewardStudentViewControlleType_normal ;
//    if ([model.onlineHomework boolValue]) {
//        homeworkType = RewardStudentViewControlleType_lookOnlineHomework;
//    }else{
//
//        homeworkType = RewardStudentViewControlleType_lookUnonlineHomework;
//    }
//
//    RewardStudentViewController * rewardVC = [[RewardStudentViewController alloc]initWithRewardType:homeworkType withTitle:model.clazzName withHomeworkId:model.homeworkId  withHomeworkBackfeedType:type];
//    [self.navigationController pushViewController:rewardVC animated:YES];
    
        [self gotoCheckOrLookHomeworkVC:CheckHomeworkCellButtonType_look withHomeworkId:model.homeworkId withOnlineHomework:model.onlineHomework];
}


//检查作业
- (void)gotoCheckeHomeworkVC:(CheckHomeworkModel *)model{
//    HomeworkBackfeedType  type;
//    if ([model.feedbackName isEqualToString:@"不需要反馈"]) {
//        type = HomeworkBackfeedType_nono;
//    }else{
//        type = HomeworkBackfeedType_backfeed;
//    }
//    RewardStudentViewControlleType homeworkType = RewardStudentViewControlleType_normal ;
//    if ([model.onlineHomework boolValue]) {
//        homeworkType = RewardStudentViewControlleType_checkOnlineHomework;
//    }else{
//        
//        homeworkType = RewardStudentViewControlleType_checkUnonlineHomework;
//    }
//    RewardStudentViewController * rewardVC =  [[RewardStudentViewController alloc]initWithRewardType:homeworkType  withTitle:model.clazzName withHomeworkId:model.homeworkId  withHomeworkBackfeedType:type];
//    rewardVC.checkSuccessBlock = ^{
//        if ([self.delegate respondsToSelector:@selector(updateHomeworkDate)]) {
//            [self.delegate updateHomeworkDate];
//        }
//        [self beginRefresh];
//    };
//    [self.navigationController pushViewController:rewardVC animated:YES];
//    
    [self gotoCheckOrLookHomeworkVC:CheckHomeworkCellButtonType_check withHomeworkId:model.homeworkId withOnlineHomework:model.onlineHomework];
}

- (void)gotoCheckOrLookHomeworkVC:(CheckHomeworkCellButtonType) type withHomeworkId:(NSString *)homeworkId withOnlineHomework:(NSNumber *) onlineHomework{

    CheckHomeworkDetailVCType  detailType = CheckHomeworkDetailVCType_normal;
    if (type ==   CheckHomeworkCellButtonType_look){
        detailType = CheckHomeworkDetailVCType_look;
        CheckHomeworkDetailVC  * detailVC = [[CheckHomeworkDetailVC alloc]initHomeworkID:homeworkId withType:detailType withOnlineHomework:onlineHomework];
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }else if (type ==   CheckHomeworkCellButtonType_check) {
        detailType = CheckHomeworkDetailVCType_check;
        NewCheckHomeworkDetailVC  * detailVC = [[NewCheckHomeworkDetailVC alloc]initHomeworkID:homeworkId withType:detailType withOnlineHomework:onlineHomework];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
