
//
//  JFHomeworkQuestionViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/12/25.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "JFHomeworkQuestionViewController.h"
#import "TeachingAssistantsListItemImageContentCell.h"
#import "AssistantsQuestionModel.h"
#import "ZFPlayerView.h"
#import "TeachingAssistantsListItemTitleCell.h"

#import "JFHomeworkTopicDetailViewController.h"
#import "JFHomeworkListItemQuestionCell.h"
#import "JFHomeworkListItemNoQuestionCell.h"
#import "JFHomeworkQuestionModel.h"
#import "JFHomeworkDoubtStudentListViewController.h"
#import "JFHomeworkCheckTopicDetailViewController.h"


NSString * const JFHomeworkListItemTitleCellIdentifer = @"JFHomeworkListItemTitleCellIdentifer";

NSString * const JFHomeworkListListItemImageContentCellIdentifer = @"JFHomeworkListListItemImageContentCellIdentifer";

NSString * const JFHomeworkListItemQuestionCellIdentifer = @"JFHomeworkListItemQuestionCellIdentifer";
NSString * const JFHomeworkListItemNoQuestionCellIdentifer = @"JFHomeworkListItemNoQuestionCellIdentifer";

#define KJFDefaultImageHeight  120
@interface JFHomeworkQuestionViewController ()<ZFPlayerDelegate,JFHomeworkTopicParseDelegate>


@property (nonatomic, strong) ZFPlayerView        *playerView;
@property (nonatomic, assign)  NSInteger      playerCurrentIndex;
@property (nonatomic, copy)  NSString * bookId;
@property (nonatomic, copy)  NSString * bookHomeworkId;
@property (nonatomic, copy)  NSString * homeworkTypeId;
@end

@implementation JFHomeworkQuestionViewController
- (instancetype)initWithHomeworkId:(NSString *)homeworkId withBookId:(NSString *)bookId withBookHomeworkId:(NSString *)bookHomeworkId {
    if (self = [super init]) {
        self.homeworkId = homeworkId; 
        self.bookId = bookId;
        self.bookHomeworkId = bookHomeworkId;
        
    }
    return self;
}
- (instancetype)initWithHomeworkId:(NSString *)homeworkId withBookId:(NSString *)bookId withBookHomeworkId:(NSString *)bookHomeworkId withHomeworkTypeId:(NSString *)homeworkTypeId{
    
    if (self = [super init]) {
        self.homeworkId = homeworkId;
        self.bookId = bookId;
        self.bookHomeworkId = bookHomeworkId;
        self.homeworkTypeId = homeworkTypeId;
    }
    return self;
}
- (void)registerNotification{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:@"UPDATE_OTHER_PARSE" object:nil];
}
- (void)notificationAction:(NSNotification *)notifi{
    
    if (notifi.userInfo) {
        NSIndexPath * indexPath = notifi.userInfo[@"indexPath"];
        NSNumber *number = notifi.userInfo[@"selectedParseIndex"];
        NSString * analysisProviderId = notifi.userInfo[@"analysisProviderId"];
        [self chooseItmeIndex:indexPath withParsingIndex:[number integerValue] withAnalysisProviderId:analysisProviderId];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"作业概况"];
    [self configTableView];
    [self registerNotification];
   
//    NSArray   * questionArray = self.jfHomework.firstObject[@"questions"];
//    NSMutableArray * listQuestions = [NSMutableArray array];
//    for (NSDictionary *questionDic  in questionArray) {
//        NSArray * children = questionDic[@"children"];
//        if (children) {
//            for (NSDictionary * dic in children) {
//                [listQuestions addObject:dic];
//            }
//        }else {
//            [listQuestions addObject:questionDic];
//        }
//    }
//    NSDictionary * questionsDic = @{@"questions":listQuestions};
//    self.questionModel = [[JFHomeworkQuestionModel alloc]initWithDictionary:questionsDic error:nil];
//
//    [self updateTableView];
    [self requestQueryHomeworkJfQuestions];
}
- (void)requestQueryHomeworkJfQuestions{
    NSMutableDictionary *parameterDic = [NSMutableDictionary dictionary];
   [parameterDic addEntriesFromDictionary: @{@"homeworkId":self.homeworkId}];
    if (self.homeworkTypeId) {
        [parameterDic addEntriesFromDictionary:@{@"homeworkTypeId":self.homeworkTypeId}];
    }
   
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_QueryHomeworkJfQuestions] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_QueryHomeworkJfQuestions];
    
}

- (void)setNetworkRequestStatusBlocks{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_QueryHomeworkJfQuestions) {
            NSArray   * questionArray = successInfoObj[@"questions"];
            NSMutableArray * listQuestions = [NSMutableArray array];
            for (NSDictionary *questionDic  in questionArray) {
                NSArray * children = questionDic[@"children"];
                if (children) {
                    for (NSDictionary * dic in children) {
                        [listQuestions addObject:dic];
                    }
                }else {
                    [listQuestions addObject:questionDic];
                }
            }
            NSDictionary * questionsDic = @{@"questions":listQuestions};
            strongSelf.questionModel = [[JFHomeworkQuestionModel alloc]initWithDictionary:questionsDic error:nil];
            [strongSelf updateTableView];
        }
    }];
    
}
- (void)configTableView{
    self.tableView.backgroundColor = [UIColor clearColor];
    // 隐藏UITableViewStyleGrouped上边多余的间隔
    self.view.backgroundColor = project_background_gray;
}
#pragma mark ---
- (BOOL)validationIsAudio:(QuestionModel *)model{
    BOOL yesOrNo = NO;
    if (model.continuousAudios && [model.continuousAudios count]) {
        yesOrNo = YES;
    }else{
        if (model.singleAudios && [model.singleAudios count]) {
            yesOrNo = YES;
        }
    }
    return yesOrNo;
}
- (QuestionModel *)getQuesionModel:(NSInteger)section{
    
    QuestionModel * model = nil;
 
    model = self.questionModel.questions[section];
    return model;
}
//   优先选择我解析  次 原书解析  再其它老师
- (NSInteger)getParingIndex:(QuestionModel *)model{
    NSInteger selectedParingIndex =  -1;
    if (model.myAnalysis){
        selectedParingIndex = 2;
    }else if (model.analysis) {
        selectedParingIndex = 1;
    }else  if (model.otherAnalysis && [model.otherAnalysis count] > 0){
        selectedParingIndex = 3;
    }else{
        selectedParingIndex = -1;
    }
    return selectedParingIndex;
}

#pragma mark ---
- (UITableViewStyle)getTableViewStyle{
    
    return UITableViewStyleGrouped;
}
- (void)registerCell{
 
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TeachingAssistantsListItemTitleCell  class]) bundle:nil] forCellReuseIdentifier:JFHomeworkListItemTitleCellIdentifer];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TeachingAssistantsListItemImageContentCell  class]) bundle:nil] forCellReuseIdentifier:JFHomeworkListListItemImageContentCellIdentifer];
    
 
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JFHomeworkListItemQuestionCell   class]) bundle:nil] forCellReuseIdentifier:JFHomeworkListItemQuestionCellIdentifer];
     [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JFHomeworkListItemNoQuestionCell   class]) bundle:nil] forCellReuseIdentifier:JFHomeworkListItemNoQuestionCellIdentifer];
    
}

#pragma mark ----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger  section = 0;
    section = [self getSections];
    return section ;
}

- (NSInteger)getSections{
    NSInteger section = 0;
    if (self.questionModel) {
        section = [self.questionModel.questions count];
    }
    return section;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger row = 0;
    QuestionModel * model = [self getQuesionModel:section];
    row = 2 + [model.imgs count];
    return row;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height =  0;
    
    QuestionModel * tempModel = [self getQuesionModel:indexPath.section];
    if (indexPath.row == 0) {
        height = FITSCALE(40);
    }else if (indexPath.row >=1 &&indexPath.row < 1 + [tempModel.imgs count]){
        //            height =  [self getImgVHeight:tempModel atIndex:indexPath.row-1];
        height =  KJFDefaultImageHeight;
    }else{
        height =  FITSCALE(40);
    }
   
    return height;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    CGFloat height = 0.00001;
     height = FITSCALE(15);
    return height;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, 15)];
    footerView.backgroundColor = [UIColor clearColor];
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 2)];
    imageView.backgroundColor = [UIColor clearColor];
    [footerView addSubview:imageView];
    imageView.image = [UIImage imageNamed:@"edge_shadow_img"];
    
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = FITSCALE(0.00001);
    if (section == 0) {
        height = [self validationIsAudio:self.questionModel.questions[section]]?height:FITSCALE(8);
    }
    return height;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headerView = [UIView new];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell =  nil;
    
    QuestionModel * tempModel = [self getQuesionModel:indexPath.section];
    //标题
    if (indexPath.row == 0) {
        
        cell = [self confightItemSectionTableView:tableView cellForRowAtIndexPath:indexPath];
    }
    //图片
    else if ( indexPath.row >=1 &&indexPath.row <  1 + [ tempModel.imgs count]){
        cell = [self confightItemImageContentTableView:tableView cellForRowAtIndexPath:indexPath];
    }else  {
        cell = [self confightItemFooterTableView:tableView cellForRowAtIndexPath:indexPath];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark custom
 
- (UITableViewCell *)confightItemSectionTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TeachingAssistantsListItemTitleCell  * tempCell = [tableView dequeueReusableCellWithIdentifier:JFHomeworkListItemTitleCellIdentifer];
    QuestionModel * tempModel = [self getQuesionModel:indexPath.section];
    
    [tempCell setupModel:tempModel];
    return  tempCell;
    
}


- (UITableViewCell *)confightItemImageContentTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TeachingAssistantsListItemImageContentCell * tempCell = [tableView dequeueReusableCellWithIdentifier:JFHomeworkListListItemImageContentCellIdentifer];
    QuestionModel * tempModel = [self getQuesionModel:indexPath.section];
//    CGFloat height =   [self getImgVHeight:tempModel atIndex:indexPath.row-1];
    CGFloat height = KJFDefaultImageHeight ;
 
    tempCell.defaultHeight = height;
    tempCell.indexPath = indexPath;
 
    [tempCell setupModel:tempModel withImgHeight:height withIndex:indexPath.row - 1];
 
    return  tempCell;
    
}
- (UITableViewCell *)confightItemFooterTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QuestionModel * tempModel = [self getQuesionModel:indexPath.section];
    UITableViewCell * cell = nil;
    if ( tempModel.doubtStudents &&[tempModel.doubtStudents count] > 0) {
        JFHomeworkListItemQuestionCell * tempCell = [tableView dequeueReusableCellWithIdentifier:JFHomeworkListItemQuestionCellIdentifer];
        NSInteger num = [tempModel.doubtStudents count];
        [tempCell setupNum:num];
         cell = tempCell;
    
    }else{
        JFHomeworkListItemNoQuestionCell * tempCell = [tableView dequeueReusableCellWithIdentifier:JFHomeworkListItemNoQuestionCellIdentifer];
        
        [tempCell setupModel:tempModel ];
        cell = tempCell;
    }
   
    return  cell;

    
 
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    QuestionModel * tempModel = [self getQuesionModel:indexPath.section];
  
    if ((indexPath.row ==  [tempModel.imgs count] +1 )&& tempModel.doubtStudents && tempModel.doubtStudents.count > 0) {
        [self gotoDoubtStudentsVC:tempModel];
    }else{
    
        [self  gotoJFHomeworkTopicDetailVC:tempModel withIndexPath:indexPath];
    }
}

- (void)gotoDoubtStudentsVC:(QuestionModel *)model{
 
    JFHomeworkDoubtStudentListViewController * doubtStudentsVC = [[JFHomeworkDoubtStudentListViewController alloc]initWithData:model.doubtStudents];
    [self pushViewController:doubtStudentsVC];
}

- (void)gotoJFHomeworkTopicDetailVC:(QuestionModel * )tempModel withIndexPath:(NSIndexPath *)indexPath{
    
    JFHomeworkCheckTopicDetailViewController * detailVC = [[JFHomeworkCheckTopicDetailViewController alloc]initWithBookId:[self getBookId:tempModel] withBookHomeworkId: [self getBookHomeworkId:tempModel] withHomeworkId:self.homeworkId  withBookName:@"作业概况" withModel:tempModel ];
    detailVC.delegate = self;
    detailVC.seletedChangePareTopicIndexPath = indexPath;
    [self pushViewController:detailVC];
}

- (NSString *)getBookId:(QuestionModel * )tempModel{
    return  tempModel.bookId ?tempModel.bookId :self.bookId;
}
- (NSString *)getBookHomeworkId:(QuestionModel *)tempModel{
      return  tempModel.bookHomeworkId ?tempModel.bookHomeworkId :self.bookHomeworkId;
}
- (void)chooseItmeIndex:(NSIndexPath *)indexPath withParsingIndex:(NSInteger)selectedIndex withAnalysisProviderId:(NSString *)analysisProviderId{
    
    QuestionModel *model = self.questionModel.questions[indexPath.section];
    NSString * analysisType = @"";
    if (selectedIndex == 1) {
        analysisType = @"bookAnalysis";
    }else if (selectedIndex == 2){
        analysisType = @"myAnalysis";
    }else if (selectedIndex == 3){
        analysisType = @"otherAnalysis";
     
    }
    model.analysisType = analysisType;
    model.analysisProviderId = analysisProviderId;
    [self updateTableView];
}
- (void)chooseItmeIndex:(NSIndexPath *)indexPath withParsingIndex:(NSInteger)selectedIndex{
    
    QuestionModel *model = self.questionModel.questions[indexPath.section];
    NSString * analysisType = @"";
    NSString * analysisProviderId = @"";
    if (selectedIndex == 1) {
        analysisType = @"bookAnalysis";
    }else if (selectedIndex == 2){
        analysisType = @"myAnalysis";
    }else if (selectedIndex == 3){
        analysisType = @"otherAnalysis";
        QuestionAnalysisModel * analys = model.otherAnalysis[selectedIndex -3];
        analysisProviderId  = analys.teacherId;
    }
    model.analysisType = analysisType;
    model.analysisProviderId = analysisProviderId;
    [self updateTableView];
}
- (void)updateListData{
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
