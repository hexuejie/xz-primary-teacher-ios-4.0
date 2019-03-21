

//
//  CheckHomeworkTypeVC.m
//  TeacherPro
//
//  Created by DCQ on 2018/7/6.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "CheckHomeworkTypeVC.h"
#import "TeacherPro-Swift.h"
#import "HWCompleteStateHeaderV.h"
#import "HWUnfinishedCell.h"
#import "HWFinishedCell.h"
#import "HWKHLXFinishedCell.h"
#import "StudentHomeworkDetailViewController.h"

#import "StudentKHLXHomeworkDetailVC.h"
#import "JFHomeItemViewController.h"

NSString * const  HWCompleteStateHeaderVIdentifier = @"HWCompleteStateHeaderVIdentifier";
NSString * const  HWUnfinishedCellIdentifier = @"HWUnfinishedCellIdentifier";
NSString * const  HWFinishedCellIdentifier = @"HWFinishedCellIdentifier";
NSString * const  HWKHLXFinishedCellIdentifier = @"HWKHLXFinishedCellIdentifier";
@interface CheckHomeworkTypeVC ()<UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic) UITableView *tableView;
@property(copy, nonatomic) NSString * titleStr;
@property(copy, nonatomic) NSString * practiceType;
@property(strong, nonatomic) NSArray  * studentList;
@property(copy, nonatomic) NSString * homeworkId;
@property (nonatomic, assign) BOOL isCheck;//是否检查状态
@property(strong, nonatomic) NSNumber *onlineHomework;
@end

@implementation CheckHomeworkTypeVC
- (instancetype)initWithTitle:(NSString *)titleStr withHomeworkId:(NSString *)homeworkId withPracticeType:(NSString *)practiceType withHWStudentList:(NSArray *)studentList withCheck:(BOOL) isCheck withOnlineHomework:(NSNumber *)onlineHomework{
    if (self == [super init]) {
        self.titleStr = titleStr;
        self.practiceType = practiceType;
        self.studentList = studentList;
        self.homeworkId = homeworkId;
        self.isCheck = isCheck;
        self.onlineHomework = onlineHomework;
    }
    return self;
}

- (UITableView *)tableView {
    if (!_tableView) {
//        CGFloat statusBarH = [UIApplication sharedApplication].statusBarFrame.size.height;
       
        _tableView = [[UITableView alloc] initWithFrame:[self getTableViewFrame]  style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:self.tableView];
    
    [self registerCell];
    // Do any additional setup after loading the view.
    self.tableView.backgroundColor = project_background_gray;
 
#warning 重要 必须赋值
     self.glt_scrollView = self.tableView;
    
    [self setNavigationItemTitle:self.titleStr];
    
    if (!self.studentList && self.practiceType) {
        [self  requestHomework:self.homeworkId withPracticeType:self.practiceType];
    }
    
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, FITSCALE(20))];
    footerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView =footerView;
}

- (void)requestHomework:(NSString *)homeworkId  withPracticeType:(NSString *)practiceType{
    NSDictionary * parameterDic = @{@"homeworkId":homeworkId,@"practiceType":practiceType};
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_QueryHomeworkTypeStudents] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_QueryHomeworkTypeStudents];
}

- (void)setNetworkRequestStatusBlocks{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_QueryHomeworkTypeStudents) {
            strongSelf.studentList = successInfoObj[@"list"];
        }
        [strongSelf.tableView reloadData];
    }];
}
-(void)registerCell{
     [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HWUnfinishedCell class]) bundle:nil] forCellReuseIdentifier:HWUnfinishedCellIdentifier];
     [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HWFinishedCell class]) bundle:nil] forCellReuseIdentifier:HWFinishedCellIdentifier];
     [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HWKHLXFinishedCell  class]) bundle:nil] forCellReuseIdentifier:HWKHLXFinishedCellIdentifier];
     [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HWCompleteStateHeaderV class]) bundle:nil] forHeaderFooterViewReuseIdentifier:HWCompleteStateHeaderVIdentifier];
}
- (UIColor *)getNavBarBgColor{
    return project_main_blue;
}
- (BOOL)getNavBarBgHidden{
    return YES;
}
- (CGRect)getTableViewFrame{
    CGFloat bottomHeight = self.isCheck? 0 :FITSCALE(50);
    CGFloat H =  self.view.bounds.size.height - bottomHeight;
    return  CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, H);
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger section = [self.studentList count];
    return section;
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 0;
    NSDictionary * sectionDic  = self.studentList[section];
    rows = [sectionDic[@"students"] count];
    return rows;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = nil;
    NSDictionary * sectionDic  = self.studentList[indexPath.section];
    if ([sectionDic[@"title"] isEqualToString:@"未完成"]) {
        HWUnfinishedCell * tempCell = [tableView dequeueReusableCellWithIdentifier:HWUnfinishedCellIdentifier];
        [tempCell setupStudentDic:sectionDic[@"students"][indexPath.row]];
        tempCell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell = tempCell;
    }else{
        if ([self.practiceType isEqualToString:@"khlx"]) {
            //@"课后练习"
            HWKHLXFinishedCell * tempCell = [tableView dequeueReusableCellWithIdentifier:HWKHLXFinishedCellIdentifier];
            tempCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [tempCell setupStudentDic:sectionDic[@"students"][indexPath.row]];
            cell = tempCell;
        }else{
            
           //作业总览  - 教辅   语文点读 在线练习 绘本
            HWFinishedCell * tempCell = [tableView dequeueReusableCellWithIdentifier:HWFinishedCellIdentifier];
            BOOL isJF = NO;
            if ([self.practiceType isEqualToString:@"jfHomework"]){
                //教辅
                isJF = YES;
            }
            [tempCell setupStudentDic:sectionDic[@"students"][indexPath.row] withJF:isJF];
            tempCell.selectionStyle = UITableViewCellSelectionStyleNone;
          
             if (self.practiceType && ([self.practiceType isEqualToString:@"ywdd"])) {
                    tempCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    [tempCell hiddenArrow:YES];
                }else{
                    tempCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    [tempCell hiddenArrow:NO];
                }
            
            if ([self.practiceType isEqualToString:@"dctx"]||[self.practiceType isEqualToString:@"ldkw"]||[self.practiceType isEqualToString:@"tkwly"]){
                [tempCell hiddenArrow:YES];
            }

            cell = tempCell;
            
        }
    }
   
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 60;
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height =  0;
     NSDictionary * sectionDic  = self.studentList[section];
    if ([sectionDic[@"students"] count] > 0) {
        height = FITSCALE(24);
    }
    return  height;
}

- ( UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headerView = nil;
    NSDictionary * sectionDic  = self.studentList[section];
    if ( !sectionDic[@"students"] || [sectionDic[@"students"] count] == 0) {
           headerView = [UIView new];
    }else{
        HWCompleteStateHeaderV * tempView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:HWCompleteStateHeaderVIdentifier];
        NSString * sectionStr = @"";
        NSInteger number = 0;
        sectionStr = sectionDic[@"title"] ;
        number =[sectionDic[@"students"] count];
        [tempView setupTitleStr:sectionStr withNumber:number];
        tempView.frame = CGRectMake(0, 0, IPHONE_WIDTH,  FITSCALE(30));
        headerView = tempView;
    }

    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return FITSCALE(0.000001);
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView * footerView = [UIView new];
    return footerView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
    if (self.practiceType && self.practiceType.length >0  ) {
        NSDictionary * sectionDic  = self.studentList[indexPath.section];
        NSDictionary * studentInfo = sectionDic[@"students"][indexPath.row];
        if ([sectionDic[@"title"] isEqualToString:@"未完成"]) {
            return;
        }
        
            //作业详情
            if ([self.practiceType isEqualToString:@"zxlx"]){
                //教辅 课后练习 在线练习
                NSAssert(studentInfo[@"studentId"], @"学生id 为空");
                [self gotoStudentHomeworkDetailVC:studentInfo[@"studentId"] studnetName:studentInfo[@"studentName"]];
//                if ([self.practiceType isEqualToString:@"dctx"]||[self.practiceType isEqualToString:@"ldkw"]||[self.practiceType isEqualToString:@"tkwly"]){
//
//                }
            }else if ([self.practiceType isEqualToString:@"jfHomework"] && studentInfo[@"unknowQuestions"] ){
                
                [self gotoUnOnlineAssistantsQuestionVC:studentInfo[@"studentId"]];
            }
            
            else if ([self.practiceType isEqualToString:@"khlx"]){
                
                [self gotoStudentKHLXHomeworkDetailVC:studentInfo[@"studentId"] studnetName:studentInfo[@"studentName"]];
            }else if ([self.practiceType isEqualToString:@"cartoonHomework"]){
                NSAssert(studentInfo[@"studentId"], @"学生id 为空");
                [self gotoStudentHomeworkDetailVC:studentInfo[@"studentId"] studnetName:studentInfo[@"studentName"]];
            }else{
                //        NSDictionary * sectionDic  = self.studentList[indexPath.section];
                //        NSDictionary * studentInfo = sectionDic[@"students"][indexPath.row];
                //        if ([sectionDic[@"title"] isEqualToString:@"未完成"]) {
                //            return;
                //        }
                //         NSAssert(studentInfo[@"studentId"], @"学生id 为空");
                //        [self gotoStudentHomeworkDetailVC:studentInfo[@"studentId"] studnetName:studentInfo[@"studentName"]];
            }
            
        }
        
  
  
    
}
- (void)gotoUnOnlineAssistantsQuestionVC:(NSString *)studentId {
    
    JFHomeItemViewController * vc = [[JFHomeItemViewController alloc]initWithHomeworkId:self.homeworkId withStudentId:studentId];
    [self pushViewController:vc];
}

- (void)gotoStudentHomeworkDetailVC:(NSString *)studentId studnetName:(NSString *)studentName{
    NSMutableArray * studentList = [[NSMutableArray alloc]init];
    NSInteger  currentPage = 0;
    NSArray *tempArray = self.studentList ;
    NSInteger studentCount = 0;
    for (NSDictionary * tempDic in tempArray) {
        if (![tempDic[@"title"] isEqualToString:@"未完成"]){
            for (int i = 0; i < [tempDic[@"students"] count] ;i++) {
                NSDictionary * dic = tempDic[@"students"][i];
               
                [studentList addObject: dic ];
                if ([dic[@"studentId"] isEqualToString:studentId]) {
                    currentPage = studentCount;
                }
                studentCount ++;
            }
        }
    }
 
  
    StudentHomeworkDetailViewController * detail = [[StudentHomeworkDetailViewController alloc]initWithStudent:studentId withStudentName:studentName   withHomeworkId:self.homeworkId withHomeworkState:self.isCheck withStudentList:studentList withCurrenntIndex:currentPage];
  
    [self pushViewController:detail];
}

- (void)gotoStudentKHLXHomeworkDetailVC:(NSString *)studentId studnetName:(NSString *)studentName{
    
    StudentKHLXHomeworkDetailVC * detail = [[StudentKHLXHomeworkDetailVC alloc]initWithStudentName:studentName withStudentId:studentId withHomeworkId:self.homeworkId];
    
    [self pushViewController:detail];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
