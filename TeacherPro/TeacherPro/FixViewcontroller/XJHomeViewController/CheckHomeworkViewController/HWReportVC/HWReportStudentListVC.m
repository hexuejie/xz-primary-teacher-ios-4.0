

//
//  HWReportStudentListVC.m
//  TeacherPro
//
//  Created by DCQ on 2018/7/25.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "HWReportStudentListVC.h"
#import "HWReportStudentCell.h"
#import "HWReportStudentSectionView.h"
#import "HWReportCartoonVC.h"

NSString * const HWReportStudentCellIdentifier = @"HWReportStudentCellIdentifier";
NSString * const HWReportStudentSectionViewIdentifier = @"HWReportStudentSectionViewIdentifier";
@interface HWReportStudentListVC ()
@property (nonatomic, copy)NSString * homeworkId;
@property (nonatomic, copy)NSString * homeworkTypeId;
@property (nonatomic, strong) NSArray *  studentsList;
@property (nonatomic, assign) HWReportStudentListVCStyle  style;
@property (nonatomic, copy)NSString * bookId;
@end

@implementation HWReportStudentListVC
- (instancetype)initWithHomeworkId:(NSString * )homeworkId withHomeworkTypeId:(NSString *)homeworkTypeId withStyle:(HWReportStudentListVCStyle) style withBookId:(NSString *)bookId{
    self = [super init];
    if (self) {
        self.homeworkId = homeworkId;
        self.homeworkTypeId = homeworkTypeId;
        self.style = style;
        self.bookId = bookId;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)getNetworkData{
    
    NSDictionary * parameterDic = @{@"homeworkId":self.homeworkId,@"homeworkTypeId":self.homeworkTypeId};
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_ListStudentScoreByHomeworkTypeId] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_ListStudentScoreByHomeworkTypeId];
    
}

- (void)setNetworkRequestStatusBlocks{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_ListStudentScoreByHomeworkTypeId) {
            NSLog(@"%@===",successInfoObj);
           strongSelf.studentsList = successInfoObj[@"list"];
        }
        [strongSelf updateTableView];
    } failedBlock:^(NetRequest *request, NSError *error) {
        [super  setDefaultNetFailedBlockImplementationWithNetRequest: request error: error otherExecuteBlock:nil];
        [weakSelf updateTableView];
    }];
  
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)registerCell{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HWReportStudentCell class]) bundle:nil] forCellReuseIdentifier:HWReportStudentCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HWReportStudentSectionView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:HWReportStudentSectionViewIdentifier];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  [self.studentsList count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rows =  0;
    NSDictionary * sectionDic = self.studentsList[section];
    rows = [sectionDic[@"students"] count];
    return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = nil;
    HWReportStudentCell * tempCell = [tableView dequeueReusableCellWithIdentifier:HWReportStudentCellIdentifier];
    NSDictionary * sectionDic = self.studentsList[indexPath.section];
    NSArray *studentsList =  sectionDic[@"students"]  ;
    
    if ([sectionDic[@"title"] isEqualToString:@"未完成"]) {
        [tempCell setupStudentName:studentsList[indexPath.row][@"studentName"] withResults:@"" withCompleteState:NO];
    }else{
        NSString * results = @"";
        if (studentsList[indexPath.row][@"scoreLevel"]) {
            results = studentsList[indexPath.row][@"scoreLevel"];
        }else if(studentsList[indexPath.row][@"score"]){
            results = [NSString stringWithFormat:@"%@",studentsList[indexPath.row][@"score"]];
        }
        BOOL state = NO;
        if (self.style == HWReportStudentListVCStyle_cartoon && studentsList[indexPath.row][@"score"]) {
            state = YES;
        }
        [tempCell setupStudentName:studentsList[indexPath.row][@"studentName"] withResults:results withCompleteState:state];
    }
    cell = tempCell;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * sectionView = nil;
    NSDictionary * sectionDic = self.studentsList[section];
    NSArray *studentsList =  sectionDic[@"students"];
    if (!studentsList || [studentsList count] == 0) {
        sectionView = [UIView new];
    }else{
        HWReportStudentSectionView  * tempView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HWReportStudentSectionViewIdentifier];
        [tempView setupSection:sectionDic[@"title"]];
        sectionView = tempView;
    }
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = 0;
    NSDictionary * sectionDic = self.studentsList[section];
    NSArray *studentsList =  sectionDic[@"students"];
   if (!studentsList || [studentsList count] == 0) {
        height = 0;
    }else{
        height = FITSCALE(24);
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * sectionDic = self.studentsList[indexPath.section];
    NSArray *studentsList =  sectionDic[@"students"];
    if (![sectionDic[@"title"] isEqualToString:@"未完成"]) {
        
        if (self.style == HWReportStudentListVCStyle_cartoon && studentsList[indexPath.row][@"score"] ) {
            //绘本有成绩 跳转h5
            [self gotoCartoonDetailVC:studentsList[indexPath.row][@"studentId"]];
        }
        
    }
    
 
}

- (void)gotoCartoonDetailVC:(NSString *)studentId{
    HWReportCartoonVC * cartoonVC = [[HWReportCartoonVC alloc]initWithStudentId:studentId withBookId:self.bookId];
    [self pushViewController:cartoonVC];
    
}

@end
