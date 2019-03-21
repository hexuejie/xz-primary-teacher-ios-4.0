//
//  JFTopicOtherTeacherParseViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/12/22.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "JFTopicOtherTeacherParseViewController.h"
#import "JFTopicOtherParseBottomCell.h"
#import "JFTopicOtherParseContentCell.h"
#import "JFTopicOtherTeacherParseModel.h"
#import "UITableView+SDAutoTableViewCellHeight.h"

NSString * const  JFTopicOtherParseBottomCellIdentifier = @"JFTopicOtherParseBottomCellIdentifier";
NSString * const  JFTopicOtherParseContentCellIdentifier = @"JFTopicOtherParseContentCellIdentifier";

@interface JFTopicOtherTeacherParseViewController ()
@property(nonatomic, copy) NSString *unitId;
@property(nonatomic, copy) NSString *questionNum;
@property(nonatomic, strong) JFTopicOtherTeacherParseModel * models;
@property(nonatomic, strong) NSDictionary * homeworkQuestionAnalysisDic;//作业题目 解析对应的信息
@property(nonatomic, copy) NSString *analysisProviderId;//提供者id
@property(nonatomic, strong)NSIndexPath *selectedIndex;//选择的index
@end

@implementation JFTopicOtherTeacherParseViewController

- (instancetype)initWithHomework:(NSString *)unitId withQuestionNum:(NSString *)questionNum withHomeworkQuestionAnalysisDic:(NSDictionary *)homeworkQuestionAnalysisDic{
    
    if (self == [super init]) {
        self.unitId = unitId;
        self.questionNum = questionNum;
        self.homeworkQuestionAnalysisDic = homeworkQuestionAnalysisDic;
    }
    return self;
}
- (instancetype)initWithHomework:(NSString *)unitId withQuestionNum:(NSString *)questionNum{
    if (self == [super init]) {
        self.unitId = unitId;
        self.questionNum = questionNum;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"老师解析";
    [self reqeustOtherTeacherParse];
    [self configTableView];
}

- (void)configTableView{
    self.tableView.backgroundColor = [UIColor clearColor];
    // 隐藏UITableViewStyleGrouped上边多余的间隔
    self.view.backgroundColor = project_background_gray;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UITableViewStyle)getTableViewStyle{
    
    return UITableViewStyleGrouped;
}
- (void)registerCell{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JFTopicOtherParseBottomCell class]) bundle:nil] forCellReuseIdentifier:JFTopicOtherParseBottomCellIdentifier];
    [self.tableView registerClass: [JFTopicOtherParseContentCell class] forCellReuseIdentifier: JFTopicOtherParseContentCellIdentifier];
}
- (void)reqeustOtherTeacherParse{
    if (!self.unitId || !self.questionNum) {
        NSLog(@"空数据");
        return;
    }
    NSDictionary * dic = @{@"unitId":self.unitId,@"questionNum":self.questionNum};
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_ListJFQuestCustomAnalysis] parameterDic:dic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_ListJFQuestCustomAnalysis];
}
- (void)reqeustPraiseOtherTeacherParse:(NSString *)analysisId{
    if (!analysisId) {
        NSLog(@"空数据");
        return;
    }
    NSDictionary * dic = @{@"analysisId":analysisId};
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_PraiseTeacherCustomAnalysis] parameterDic:dic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_PraiseTeacherCustomAnalysis];
}

- (void)setNetworkRequestStatusBlocks{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_ListJFQuestCustomAnalysis) {
            strongSelf.models = [[JFTopicOtherTeacherParseModel alloc]initWithDictionary:successInfoObj error:nil];
            [strongSelf updateTableView];
        }else if (request.tag == NetRequestType_PraiseTeacherCustomAnalysis ){
            NSLog(@"点赞成功");
            [strongSelf reqeustOtherTeacherParse];
        }else if (request.tag == NetRequestType_UpdateHomeworkJFQuestionAnalysis){
            [strongSelf gobackVC];
        }
    }];
}

- (void)gobackVC{
    NSDictionary * dic = @{@"indexPath":self.seletedChangePareTopicIndexPath,@"selectedParseIndex":@(self.selectedIndex.section+3),@"analysisProviderId":self.analysisProviderId};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_OTHER_PARSE" object:nil userInfo:dic];
    NSInteger count =  [self.navigationController.viewControllers count];
    UIViewController * vc = self.navigationController.viewControllers[count -3];
    [self.navigationController  popToViewController:vc animated:YES];
}
#pragma mark ---
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger  section =  0;
    if (self.models) {
        section = [self.models.analysis count];
    }
    return section;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    if (indexPath.row== 0) {
        JFTopicTeacherParseModel * model =  self.models.analysis[indexPath.section];
        height =  [self.tableView  cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[JFTopicOtherParseContentCell class] contentViewWidth:[self cellContentViewWith]];
 
    }else if(indexPath.row == 1){
        height = 50;
    }
    return height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell =  nil;
    if (indexPath.row == 0) {
        cell =  [self configContentCell:tableView atIndexPath:indexPath];
     
    }else if (indexPath.row == 1){
        cell = [self configBottomCell:tableView atIndexPath:indexPath];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 15)];
    headerView.backgroundColor = UIColorFromRGB(0xE2E2E2);
    return headerView;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footerView = [UIView new];
    footerView.backgroundColor = [UIColor clearColor];
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(6, 0, self.view.frame.size.width-12, 2)];
    imageView.backgroundColor = [UIColor clearColor];
    [footerView addSubview:imageView];
    imageView.image = [UIImage imageNamed:@"edge_shadow_img"];
    
    return footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = 0.0001;
    if (section == 0) {
        height = 12;
    }
    return height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    CGFloat height = 0.0001;
    height = 15;
    return height;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
#pragma mark --- configth cell
- (UITableViewCell *)configBottomCell:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath{
    JFTopicOtherParseBottomCell * tempCell = [tableView dequeueReusableCellWithIdentifier:JFTopicOtherParseBottomCellIdentifier];
    JFTopicTeacherParseModel * model =  self.models.analysis[indexPath.section];
    [tempCell setupPraiseNumber:model.praiseTeacherCount withHasPraiseState:model.hasPraise];
    tempCell.indexPath = indexPath;
    WEAKSELF
    tempCell.praiseBlock = ^(NSIndexPath *indexPath) {
        STRONGSELF
       JFTopicTeacherParseModel * tempModel =  strongSelf.models.analysis[indexPath.section];
        [weakSelf reqeustPraiseOtherTeacherParse:tempModel.analysisId];
    };
    tempCell.selectedBlock = ^(NSIndexPath *indexPath) {
        [weakSelf selectedParse:indexPath];
    };
    return tempCell;
}
- (UITableViewCell *)configContentCell:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath{
    
    JFTopicOtherParseContentCell * tempCell = [tableView dequeueReusableCellWithIdentifier:JFTopicOtherParseContentCellIdentifier];
    JFTopicTeacherParseModel * model =  self.models.analysis[indexPath.section];
    tempCell.model = model;
    return tempCell;
}
#pragma mark ---
#pragma mark --- sd  cell 自动适配height
- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}
#pragma mark --

- (void)selectedParse:(NSIndexPath *)index{
    JFTopicTeacherParseModel *model = self.models.analysis[index.section];
    if (model.teacherId) {
        self.analysisProviderId =  model.teacherId;
//        NSDictionary * dic = @{@"indexPath":self.seletedChangePareTopicIndexPath,@"selectedParseIndex":@(index.section+3),@"analysisProviderId":model.teacherId};
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_OTHER_PARSE" object:nil userInfo:dic];
//        NSInteger count =  [self.navigationController.viewControllers count];
//        UIViewController * vc = self.navigationController.viewControllers[count -3];
//        [self.navigationController  popToViewController:vc animated:YES];
    }
    self.selectedIndex = index;
    if (self.homeworkQuestionAnalysisDic) {
         [self requestUpdateHomeworkJFQuestionAnalysis];
    }else{
        [self gobackVC];
    }
   
}

- (void)requestUpdateHomeworkJFQuestionAnalysis{
    NSString * analysisProviderId = @"";
 
    NSDictionary * analysisProviderIdDic = nil;
  
     if (self.analysisProviderId) {
            analysisProviderIdDic = @{@"analysisProviderId":self.analysisProviderId};
      }
    
    NSMutableDictionary * parameterDic = [NSMutableDictionary dictionary];
    if (self.homeworkQuestionAnalysisDic ) {
         [parameterDic addEntriesFromDictionary: self.homeworkQuestionAnalysisDic];
    }
   
    if (analysisProviderIdDic) {
        [parameterDic addEntriesFromDictionary:analysisProviderIdDic];
    }
    if (analysisProviderId.length > 0) {
        [parameterDic addEntriesFromDictionary:@{@"analysisProviderId":analysisProviderId}];
    }
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_UpdateHomeworkJFQuestionAnalysis] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_UpdateHomeworkJFQuestionAnalysis];
}

@end
