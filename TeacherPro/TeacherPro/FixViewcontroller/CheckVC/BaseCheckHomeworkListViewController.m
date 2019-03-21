


//
//  BaseCheckHomeworkListViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/8/12.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BaseCheckHomeworkListViewController.h"
#import "CheckHomeworkListModel.h"
#import "CheckHomeworkCell.h"
#import "NewCheckHomeworkDetailVC.h"

#import "CheckNewListPageViewController.h"
#import "RewardStudentViewController.h"
#import "CheckHomeworkDetailVC.h"
#import "UIViewController+HBD.h"

#import "NewCheeckPictureReportVC.h"
#import "HWReportViewController.h"
#import "InvitationStudentViewController.h"
//#import "XJWorkGeneralTableVC.h"
#import "JFHomeworkQuestionViewController.h"
#import "HomeworkDetailViewController.h"

NSString * const BaseCheckHomeworkCellIdentifier = @"BaseCheckHomeworkCellIdentifier";
@interface BaseCheckHomeworkListViewController ()


@end

@implementation BaseCheckHomeworkListViewController

- (void)viewDidLoad {
    
    self.currentPageNo = 0;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector( reloadListViewData) name:@"UPDATA_HOMEWORK_LIST_DATA" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationCenterClassChoose:) name:@"ClassChoose" object:nil];
    self.tableView.separatorColor = [UIColor clearColor];
    
    
    CheckNewListPageViewController *superVC;
    for (UIViewController *tempVC in self.navigationController.viewControllers) {
        if ([tempVC isKindOfClass:[CheckNewListPageViewController class]]) {
            superVC = (CheckNewListPageViewController *)tempVC;
        }
    }
    if (superVC.clazzId.length>0&&self.clazzId.length==0) {
        self.clazzId = superVC.clazzId;
    }
    
    [self drogDownRefresh];
}
- (BOOL)isBeginRefreshing{
    
    return NO;
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self navUIBarBackground:0];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self navUIBarBackground:0];
    if (self.isRefersh&&self.tableView) {
        [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
            });
        });
    }
    self.isRefersh = NO;
}

- (void)notificationCenterClassChoose:(NSNotification *)notification{
    
    self.isRefersh = YES;
    if ([[notification userInfo][@"classId"] length]>0) {
        self.clazzId = [notification userInfo][@"classId"];
        CheckNewListPageViewController *superVC;
        for (UIViewController *tempVC in self.navigationController.viewControllers) {
            if ([tempVC isKindOfClass:[CheckNewListPageViewController class]]) {
                superVC = (CheckNewListPageViewController *)tempVC;
            }
        }
        superVC.clazzId = self.clazzId;
        if ([notification userInfo][@"className"]) {
            UIButton * releaseBtn  = self.superVC.navigationItem.rightBarButtonItem.customView;
            [releaseBtn setTitle:[notification userInfo][@"className"] forState:UIControlStateNormal];
        }
    }else{
        
    }
    
    [self drogDownRefresh];
    //userInfo:@{@"strGrade":strGrade,@"classId":classId}];
}

- (void)reloadListViewData{
    if (self.checkSuccessBlock) {
        self.checkSuccessBlock();
    }
    [self beginRefresh];
}

- (void)drogDownRefresh{
    self.currentPageNo = 0;
    self.pageCount = 10;
    [self requestHomework];;
}
- (void)getLoadMoreTableViewNetworkData{
    
    [self requestHomework];
}

- (NSInteger)getNetworkTableViewDataCount{
    NSInteger  count = 0;
    count = self.checkModels.homeworks.count;
    return  count;
}

- (void)requestCallHomework:(NSString *)homeworkId{
    NSDictionary *parameterDic = @{@"homeworkId":homeworkId};
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_TeacherCallHomework] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_TeacherCallHomework];
}

- (void)requestHomework{
    
    NSString *pageIndex = [NSString stringWithFormat:@"%zd",self.currentPageNo];
    NSString *pageSize = [NSString stringWithFormat:@"%zd",self.pageCount];
    NSString * remarked = @"false";
    if ([self getCheckHomeworkType] == 0) {
        remarked = @"false";
    }else if ([self getCheckHomeworkType] == 1){
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
            strongSelf.hasLoadData = YES;
            if (strongSelf.currentPageNo == 0) {
                strongSelf.checkModels = nil;
                strongSelf.sectionDataArray = [NSMutableArray new];
            }
            NSMutableArray *tempDataArr = [NSMutableArray array];
            NSMutableArray *subArr = [NSMutableArray array];
            NSString *strTime = nil;
            
            NSArray *object = successInfoObj[@"homeworks"];
            for (int i = 0; i<[(NSArray *)object count]; i++) {
                NSDictionary *tempDic = object[i];
                NSString *dateString = [tempDic[@"ctime"] substringToIndex:11];//天
                if ([strTime isEqualToString:dateString]) {
                    //hasCallHomework == 1  已催缴
                    //onlineHomework == 1有勋章
                    [subArr addObject:[[CheckHomeworkModel alloc]initWithDictionary:tempDic error:nil]];
                }else{
                    strTime = dateString;
                    
                    if (subArr.count > 0) {
                        [tempDataArr addObject:subArr];
                    }
                    subArr = [NSMutableArray array];
                    [subArr addObject:[[CheckHomeworkModel alloc]initWithDictionary:tempDic error:nil]];
                }
                if (i == [(NSArray *)object count]-1) {
                    [tempDataArr addObject:subArr];
                }
            }
            [weakSelf.sectionDataArray addObjectsFromArray:tempDataArr];
            
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
            [strongSelf updateTableView];
            
        } else if (request.tag == NetRequestType_TeacherCallHomework){
            if ( successInfoObj[@"studentCount"]) {
                NSString * content = [NSString stringWithFormat:@"成功向%@名学生发送催缴消息",successInfoObj[@"studentCount"]];
                [strongSelf showAlert:TNOperationState_OK content:content];
            }
            
//            [strongSelf.tableView reloadData];
        }
        
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.tableView;
}
- (BOOL)isAddRefreshHeader{
    BOOL yesOrNo = YES;
    
    return yesOrNo;
}

- (BOOL)isAddRefreshFooter{
    BOOL yesOrNo = YES;
    
    return yesOrNo;
}

- (UITableViewStyle )getTableViewStyle{
    return UITableViewStylePlain;
}
- (CGRect)getTableViewFrame{
    CGRect tableViewFrame = CGRectZero;
    CGFloat SegmentedViewHeight  =  44;
    CGFloat spacing = 8;
    tableViewFrame = CGRectMake(0, spacing,self.view.frame.size.width, self.view.frame.size.height - SegmentedViewHeight- spacing);
    return tableViewFrame;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionDataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *rowArray = self.sectionDataArray[section];
    return rowArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *rowArray = self.sectionDataArray[indexPath.section];
    CheckHomeworkModel * model = rowArray[indexPath.row];
    NSString *booksName = [NSString stringWithFormat:@"%@",[model.books componentsJoinedByString:@"\n"]];
    
    return
    170+  [self getHeightLineWithString:booksName withWidth:kScreenWidth-(145+16+32) withFont:[UIFont systemFontOfSize:14]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell =nil;
    CheckHomeworkCell * tempCell = [tableView dequeueReusableCellWithIdentifier:BaseCheckHomeworkCellIdentifier];
    BOOL isRemarked = NO;
    CheckHomeworkModel * model = nil;
    
    if ([self getCheckHomeworkType] == 0) {
        isRemarked = NO;
        
    }else if ([self getCheckHomeworkType] == 1){
        isRemarked = YES;
        
    }
    NSArray *rowArray = self.sectionDataArray[indexPath.section];
    model = rowArray[indexPath.row];
    [tempCell setupHomeworkInfo:model isRemarked:isRemarked];
    tempCell.checkeBlock = ^(CheckHomeworkModel *model, NSInteger type) {
        switch (type) {
            case CheckHomeworkCellButtonType_worth:
                model.hasCallHomework = @"1";
      
                [self worthHomework:model.homeworkId];
                break;
            case CheckHomeworkCellButtonType_look:
                //                [self gotoLookHomeworkVC:model ];
                [self gotoCheckOrLookHomeworkVC0:type withHomeworkId:model withOnlineHomework:model.onlineHomework];
                break;
                
            case CheckHomeworkCellButtonType_check:
                //                [self gotoCheckeHomeworkVC:model ];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  30;
}

- ( UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSArray *rowArray = self.sectionDataArray[section];
    CheckHomeworkModel * model = [rowArray firstObject];
    
    ////时间里面的r日期
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH,  30)];
    view.backgroundColor = HexRGB(0xF6F6F8);
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    titleLabel.textColor = HexRGB(0x8A8F99);
    titleLabel.font = systemFontSize(13);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    titleLabel.text = [NSString stringWithFormat:@"%@ 布置",[model.ctime substringToIndex:11]] ;
    [view addSubview:titleLabel];
    return view;
}

#pragma mark --- click
//催缴作业
- (void)worthHomework:(NSString *)homeworkId{
    [self requestCallHomework:homeworkId];
}
//作业详情
- (void)gotoHomeworkDetailVC:(CheckHomeworkModel *)model{
    
     HomeworkDetailViewController * detailVC = [[HomeworkDetailViewController alloc]initWithHomeworkId:model.homeworkId];
     [self pushViewController:detailVC];
    
//    JFHomeworkQuestionViewController * questionVC = [[JFHomeworkQuestionViewController alloc]initWithHomeworkId:model.homeworkId withBookId:model.homeworkId withBookHomeworkId:bookHomeworkId];
//    [self pushViewController:questionVC];
    
}
//作业报告
- (void)gotoReportVC:(CheckHomeworkModel *)model{
//    if ([model.isphonicsHomework boolValue]) {//
//        NewCheeckPictureReportVC *detailVC = [[NewCheeckPictureReportVC alloc]initWithHomeworkId:model.homeworkId];
//        [self pushViewController:detailVC];
//    }else{
        //原来的报告
        HWReportViewController * detailVC = [[HWReportViewController alloc]initWithHomeworkId:model.homeworkId];
        [self pushViewController:detailVC];
//    }
}

- (void)gotoInviteStudents:(CheckHomeworkModel *)model{
    InvitationStudentViewController * studentVC = [[InvitationStudentViewController alloc]initWithClazzName:model.clazzName withClazzId:model.clazzId];
    [self pushViewController:studentVC];
    
}
//查看作业
//- (void)gotoLookHomeworkVC:(CheckHomeworkModel *)model{
//    HomeworkBackfeedType  type;
//    if ([model.feedbackName isEqualToString:@"不需要反馈"]) {
//        type = HomeworkBackfeedType_nono;
//    }else{
//        type = HomeworkBackfeedType_backfeed;
//    }
//
//    RewardStudentViewControlleType homeworkType = RewardStudentViewControlleType_normal ;
//    if ([model.onlineHomework boolValue]) {
//        homeworkType = RewardStudentViewControlleType_lookOnlineHomework;
//    }else{
//
//        homeworkType = RewardStudentViewControlleType_lookUnonlineHomework;
//    }
//    RewardStudentViewController * rewardVC = [[RewardStudentViewController alloc]initWithRewardType:homeworkType withTitle:model.clazzName withHomeworkId:model.homeworkId  withHomeworkBackfeedType:type];
//
//
//    [self.navigationController pushViewController:rewardVC animated:YES];
//}
//检查作业
//- (void)gotoCheckeHomeworkVC:(CheckHomeworkModel *)model{
//    HomeworkBackfeedType  type;
//    if ([model.feedbackName isEqualToString:@"不需要反馈"]) {
//        type = HomeworkBackfeedType_nono;
//    }else{
//        type = HomeworkBackfeedType_backfeed;
//    }
//
//    RewardStudentViewControlleType homeworkType = RewardStudentViewControlleType_normal ;
//    if ([model.onlineHomework boolValue]) {
//        homeworkType = RewardStudentViewControlleType_checkOnlineHomework;
//    }else{
//
//        homeworkType = RewardStudentViewControlleType_checkUnonlineHomework;
//    }
//    RewardStudentViewController * rewardVC =  [[RewardStudentViewController alloc]initWithRewardType:homeworkType  withTitle:model.clazzName withHomeworkId:model.homeworkId  withHomeworkBackfeedType:type];
//    WEAKSELF
//    rewardVC.checkSuccessBlock = ^{
//        if (weakSelf.checkSuccessBlock) {
//            weakSelf.checkSuccessBlock();
//        }
//         [weakSelf beginRefresh];
//    };
//    [self.navigationController pushViewController:rewardVC animated:YES];
//
//}


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

- (void)registerCell{
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CheckHomeworkCell class]) bundle:nil] forCellReuseIdentifier:BaseCheckHomeworkCellIdentifier];
    
}

- (CGFloat)getHeightLineWithString:(NSString *)string withWidth:(CGFloat)width withFont:(UIFont *)font {
    
    //1.1最大允许绘制的文本范围
    CGSize size = CGSizeMake(width, 2000);
    //1.2配置计算时的行截取方法,和contentLabel对应
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:5];
    //1.3配置计算时的字体的大小
    //1.4配置属性字典
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:style};
    //2.计算
    //如果想保留多个枚举值,则枚举值中间加按位或|即可,并不是所有的枚举类型都可以按位或,只有枚举值的赋值中有左移运算符时才可以
    CGFloat height = [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size.height;
    return height;
}

- (NSInteger )getCheckHomeworkType{
    return 0;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];//ClassChoose
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

