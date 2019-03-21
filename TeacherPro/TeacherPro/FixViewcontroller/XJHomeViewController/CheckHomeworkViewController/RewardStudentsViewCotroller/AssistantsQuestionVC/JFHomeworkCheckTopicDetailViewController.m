//
//  JFHomeworkCheckTopicDetailViewController.m
//  TeacherPro
//
//  Created by DCQ on 2018/1/3.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "JFHomeworkCheckTopicDetailViewController.h"
#import "JFHomeworkQuestionModel.h"
#import "JFTopicOtherTeacherParseViewController.h"

@interface JFHomeworkCheckTopicDetailViewController ()
@property(nonatomic, copy)NSString * bookHomeworkId;
@property(nonatomic, copy)NSString * homeworkId;
@property(nonatomic, copy)NSString * questionNum;
@property(nonatomic, copy)NSString * unitId;
@property(nonatomic, copy)NSString * analysisType;
@property(nonatomic, copy)NSString *analysisProviderId;

@end

@implementation JFHomeworkCheckTopicDetailViewController
- (instancetype)initWithBookId:(NSString *)bookId  withBookHomeworkId:(NSString *)bookHomeworkId withHomeworkId:(NSString *)homeworkId withBookName: (NSString *)bookName withModel:(QuestionModel *)model{
    if (self == [super init]) {
        self.bookId = bookId;
//        self.model = model;
        self.unitId = model.unitId;
        self.questionNum = model.questionNum;
        self.analysisType = model.analysisType;
        self.bookHomeworkId = bookHomeworkId;
        self.analysisProviderId = model.analysisProviderId;
        self.homeworkId = homeworkId;
        self.bookName = bookName;
    }
    return  self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //bookAnalysis=原书解析,myAnalysis=我的解析,otherAnalysis=其它解析
    if ([self.analysisType isEqualToString:@"bookAnalysis"]) {
        self.selectedIndex = 1;
    }else if ([self.analysisType isEqualToString:@"myAnalysis"]) {
         self.selectedIndex = 2;
    }else if ([self.analysisType isEqualToString:@"otherAnalysis"]) {
        self.selectedIndex = 3;
    }
    [self requestTeacherQueryJFQuestion];
}
- (void)sureBtnAction:(id)sender{
    [self requestUpdateHomeworkJFQuestionAnalysis];
}
- (void)requestUpdateHomeworkJFQuestionAnalysis{
    NSString * analysisProviderId = @"";
    NSString *  analysisType = @"otherAnalysis";// 解析类型 bookAnalysis=原书解析,myAnalysis=我的解析,otherAnalysis=其它老师解析
    NSDictionary * analysisProviderIdDic = nil;
    if (self.selectedIndex ==  1) {
        analysisType = @"bookAnalysis";
    }else if (self.selectedIndex == 2){
         analysisType = @"myAnalysis";
    }else if (self.selectedIndex == 3){
         analysisType = @"otherAnalysis";
        if (self.analysisProviderId) {
            analysisProviderIdDic = @{@"analysisProviderId":self.analysisProviderId};
        }
        
    }
    NSMutableDictionary * parameterDic = [NSMutableDictionary dictionary];
    NSDictionary * tempDic = @{@"homeworkId":self.homeworkId,@"bookHomeworkId":self.bookHomeworkId,@"unitId":self.unitId,@"questionNum":self.questionNum,@"analysisType":analysisType};
    

    [parameterDic addEntriesFromDictionary: tempDic];
    if (analysisProviderIdDic) {
        [parameterDic addEntriesFromDictionary:analysisProviderIdDic];
    }
    if (analysisProviderId.length > 0) {
        [parameterDic addEntriesFromDictionary:@{@"analysisProviderId":analysisProviderId}];
    }
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_UpdateHomeworkJFQuestionAnalysis] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_UpdateHomeworkJFQuestionAnalysis];
}

- (void)setNetworkRequestStatusBlocks{
    WEAKSELF
    [self setSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_UpdateHomeworkJFQuestionAnalysis) {
            [super updatePopTopicListData];
            [strongSelf backViewController];
        }else  if (request.tag == NetRequestType_TeacherQueryJFQuestion) {
          
            AssistantsQuestionModel * questionModel =  [[AssistantsQuestionModel alloc]initWithDictionary:successInfoObj error:nil];
            strongSelf.model = questionModel.question;
            [strongSelf updateTableView];
            [strongSelf updateBottomView];
        }
    }];
}


- (void)requestTeacherQueryJFQuestion{
    
    NSDictionary * parameterDic = nil;
    if (self.unitId && self.questionNum) {
        parameterDic = @{@"unitId":self.unitId,@"questionNum":self.questionNum,@"containsChilds":@(false)};
    }else{
        return ;
    }
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_TeacherQueryJFQuestion] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag: NetRequestType_TeacherQueryJFQuestion];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)gotoOtherParseVC{
     NSDictionary* homeworkQuestionAnalysisDic = @{@"homeworkId":self.homeworkId,@"bookHomeworkId":self.bookHomeworkId,@"unitId":self.unitId,@"questionNum":self.questionNum,@"analysisType":@"otherAnalysis"};
    JFTopicOtherTeacherParseViewController * otherVC = [[JFTopicOtherTeacherParseViewController alloc]initWithHomework:self.model.unitId withQuestionNum:self.model.questionNum withHomeworkQuestionAnalysisDic:homeworkQuestionAnalysisDic];
    otherVC.seletedChangePareTopicIndexPath = self.seletedChangePareTopicIndexPath;
    [self pushViewController:otherVC];
}
@end
