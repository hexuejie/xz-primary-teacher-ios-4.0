

//
//  HomeworkDetailKHLXListViewController.m
//  TeacherPro
//
//  Created by DCQ on 2018/1/31.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "HomeworkDetailKHLXListViewController.h"
#import "HomeworkDetailKHLXTopicDetailViewController.h"
#import "CheckHomeworkDetailKHLXHeaderSectionView.h"
#import "CheckHomeworkDetailKHLXTopicContentCell.h"
#import "HomeworkDetailKHLXListModel.h"
#import "ProUtils.h"

NSString * const CheckHomeworkDetailKHLXHeaderSectionViewIdentifier = @"CheckHomeworkDetailKHLXHeaderSectionViewIdentifier";
NSString * const CheckHomeworkDetailKHLXTopicContentCellIdentifier = @"CheckHomeworkDetailKHLXTopicContentCellIdentifier";

@interface HomeworkDetailKHLXListViewController ()
@property(nonatomic, copy) NSString * unitName;
@property(nonatomic, strong) NSArray *questions;
//@property(nonatomic, strong) HomeworkDetailKHLXListModel* model;
@property(nonatomic, strong) NSArray* listModel;
@property(nonatomic, strong) NSNumber * finishStudentCount;//完成作业的对象
@property(nonatomic, strong) NSArray * homeworkStudents;//做作业的所有学生对象
@property(nonatomic, strong) NSNumber * expectTime;//总时间

////////

@property(nonatomic, copy) NSString * homeworkId;
@property(nonatomic, copy) NSString * homeworkTypeId;
@property(nonatomic, assign) HomeworkDetailKHLXListVCStyle style;
@end

@implementation HomeworkDetailKHLXListViewController
- (instancetype) initWithUnitName:(NSString *)unitName withQuestions:(NSArray *)questions withFinishStudentCount:(NSNumber *)finishStudentCount withHomeworkStudents:(NSArray *)homeworkStudents withExpectTime:(NSNumber *) expectTime{
    self = [super init];
    if (self) {
        self.unitName = unitName ;
        self.questions = questions;
        self.finishStudentCount = finishStudentCount;
        self.homeworkStudents = homeworkStudents;
        self.expectTime = expectTime;
    }
    return self;
}

- (instancetype) initWithHomeworkId:(NSString *)homeworkId withHomeworkTypeId:(NSString *)homeworkTypeId withStyle:(HomeworkDetailKHLXListVCStyle)style{
    self = [super init];
    if (self) {

        self.homeworkId = homeworkId;
        self.homeworkTypeId = homeworkTypeId;
        self.style = style;
    }
    return self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationItemTitle:@"课后练习"];
    [self showHUDInfoByType:HUDInfoType_Loading];
    if (self.style != HomeworkDetailKHLXListVCStyle_report) {
         [self resetData];
    }
    
}

- (void)getNetworkData{
    if (self.style == HomeworkDetailKHLXListVCStyle_report) {
        NSDictionary * parameterDic = @{
                                        @"homeworkId":self.homeworkId,
                                        @"homeworkTypeId":self.homeworkTypeId,
                                            };
        [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_TeacherQueryHomeworkKhlxQuestions] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_TeacherQueryHomeworkKhlxQuestions];
    }
}

- (void)setNetworkRequestStatusBlocks{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_TeacherQueryHomeworkKhlxQuestions) {
            NSLog(@"%@",successInfoObj);
            strongSelf.homeworkStudents = successInfoObj[@"homeworkStudents"];
            strongSelf.unitName = successInfoObj[@"unitName"];
            strongSelf.questions = successInfoObj[@"questions"];
            strongSelf.finishStudentCount = successInfoObj[@"finishStudentCount"];
            strongSelf.expectTime = successInfoObj[@"expectTime"];
            [strongSelf resetData];
        }
       
    } failedBlock:^(NetRequest *request, NSError *error) {
        [super  setDefaultNetFailedBlockImplementationWithNetRequest: request error: error otherExecuteBlock:nil];
        
        [weakSelf updateTableView];
    }];
}
- (UITableViewStyle)getTableViewStyle{
    return UITableViewStylePlain;
}
- (void)resetData{
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSArray *newQuestions = [self resetData:self.questions];
 
        self.listModel = newQuestions;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideHUD];
            [self.tableView reloadData];
        });
    });
}
- (NSMutableArray *)resetData:(NSArray *)unitQuestions{
    
        NSArray * questions = unitQuestions;
        NSMutableArray * newQuestions =[NSMutableArray array];
        for (NSDictionary * questionsDic in questions) {
            NSMutableDictionary * newQuestionsDic = [NSMutableDictionary dictionary];
            [newQuestionsDic addEntriesFromDictionary:questionsDic];
            NSArray *questionStemArray =  [self cellTopHtmlLayoutHeight:questionsDic[@"questionStem"] withTextFontSize:fontSize_14];
            CGFloat htmlH = [questionStemArray[1] floatValue];
            id questionStem = questionStemArray[0] ;
          
            NSArray *optionsArray =  [self cellOptionsHeight:questionsDic[@"options"] withTextFOntSize:fontSize_14];
            CGFloat optionsH = [optionsArray[1] floatValue];
           id options = optionsArray[0];
            CGFloat bottomH =  50;
            CGFloat spacing =  10+10+4+16;
            CGFloat height =  htmlH+ optionsH+ bottomH +spacing ;
            [newQuestionsDic setObject:@(height) forKey:@"cellHeight"];
            [newQuestionsDic setObject:options forKey:@"options"];
            [newQuestionsDic setObject:questionStem forKey:@"questionStem"];
            [newQuestions addObject:newQuestionsDic];
        }
    
    return newQuestions;
}


NSInteger khlxSortedCompare(id obj1, id obj2, void *context)
{
    
    return  [obj1 localizedCompare:obj2];
}

- (NSArray *)cellOptionsHeight:(NSDictionary *)contentDic withTextFOntSize:(UIFont *)font{
    CGFloat height = 0;
    CGFloat spacing = (26+10)*2;
    NSArray * allkeys = contentDic.allKeys;
    NSArray *sortedArray = [allkeys sortedArrayUsingFunction:khlxSortedCompare context:NULL];
    __block NSString * options =@"";
    [sortedArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        options = [options stringByAppendingString:[NSString stringWithFormat:@"%@.%@<br><br>",obj,contentDic[obj]]];
    }];
    //    height = [options boundingRectWithSize:CGSizeMake(self.view.frame.size.width - spacing , MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil].size.height;
    NSMutableAttributedString *attributes = [[NSMutableAttributedString alloc] init];
    [attributes appendAttributedString: [ProUtils strToAttriWithStr: options]];
    
    [attributes addAttribute:NSFontAttributeName value:font  range:NSMakeRange(0, attributes.length)];
    
    CGSize attSize = [attributes boundingRectWithSize:CGSizeMake(IPHONE_WIDTH - spacing , MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin  context:nil].size;
    height = attSize.height;
    return@[attributes,@(height)];
}

- (NSArray * )cellTopHtmlLayoutHeight:(NSString *)content withTextFontSize:(UIFont *)font
{
    
    CGFloat spacing = 26*2;
    NSMutableAttributedString *attributes = [[NSMutableAttributedString alloc] initWithAttributedString:[ProUtils strToAttriWithStr: content]];
    
    [attributes addAttribute:NSFontAttributeName value:font  range:NSMakeRange(0, attributes.length)];
    
    CGSize attSize = [attributes boundingRectWithSize:CGSizeMake(IPHONE_WIDTH - spacing , MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    
    return @[attributes,@(attSize.height)];
}
- (void)registerCell{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CheckHomeworkDetailKHLXTopicContentCell class]) bundle:nil] forCellReuseIdentifier:CheckHomeworkDetailKHLXTopicContentCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CheckHomeworkDetailKHLXHeaderSectionView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:CheckHomeworkDetailKHLXHeaderSectionViewIdentifier];
}
#pragma mark ---
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger section = 0;
    if (self.listModel) {
        section = 1;
    }
    return section;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.listModel count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    HomeworkDetailKHLXQuestionsModel *questionModel = self.model.questions[indexPath.row];
    NSDictionary *questionModel = self.listModel[indexPath.row];
    return [questionModel[@"cellHeight"] floatValue];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = nil;
    CheckHomeworkDetailKHLXTopicContentCell * tempCell = [tableView dequeueReusableCellWithIdentifier:CheckHomeworkDetailKHLXTopicContentCellIdentifier];
    [self configureCell:tempCell atIndexPath:indexPath];
    cell = tempCell;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)configureCell:(CheckHomeworkDetailKHLXTopicContentCell *)cell atIndexPath:(NSIndexPath *)indexPath{
//    HomeworkDetailKHLXQuestionsModel * questionModel  = self.model.questions[indexPath.row];
//    [cell setupTopicModel:questionModel];
    NSDictionary *questionModel = self.listModel[indexPath.row];
    [cell setupTopicDic:questionModel];
    cell.indexPath = indexPath;
    cell.buttonBlock = ^( NSIndexPath * indexPath) {
        //对错
        [self gotoRightAndWrongTopicDetailVC:indexPath];
    };
   
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headerView = nil;
 
    CheckHomeworkDetailKHLXHeaderSectionView*  tempView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:CheckHomeworkDetailKHLXHeaderSectionViewIdentifier];
    [tempView setupUnitName:self.unitName withTopicNumber:[self.questions count] withExpectTime:self.expectTime];
    [tempView setupCompleteNumber:self.finishStudentCount ];
    tempView.btnBlock = ^(NSInteger section) {
       //完成 情况
        if (self.finishStudentCount && [self.finishStudentCount integerValue] > 0) {
             [self  gotoCompleteTopicDetailVC];
        }
       
    };
   
    headerView = tempView;
    return headerView;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footerView = [UIView new];
    return footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = 0.0001;
    height = 80;
    return height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
}


- (void)gotoCompleteTopicDetailVC{
    HomeworkDetailKHLXTopicType type  = HomeworkDetailKHLXTopicType_Normal;
      type  = HomeworkDetailKHLXTopicType_Complete;
    NSArray * completeAndNoCompleteStudentArray = [self getCompleteAndNoCompleteStudentArray];
    HomeworkDetailKHLXTopicDetailViewController * topicVC = [[HomeworkDetailKHLXTopicDetailViewController alloc]initWithType:type withArray:completeAndNoCompleteStudentArray ];
    [self pushViewController:topicVC];
}

- (NSArray *)getCompleteAndNoCompleteStudentArray {
    NSMutableArray * array = [NSMutableArray array];
    NSMutableArray * completeArray = [NSMutableArray array];
    NSMutableArray * noCompleteArray = [NSMutableArray array];
 
    for (NSDictionary * studentDic in self.homeworkStudents) {
        
        bool finish = [studentDic[@"finish"] boolValue];
        if (finish) {
            [completeArray addObject:studentDic[@"studentName"]];
        }else{
            [noCompleteArray addObject:studentDic[@"studentName"]];
        }
    }
    [array addObject:noCompleteArray];
    [array addObject:completeArray];
    return array;
}
- (void)gotoRightAndWrongTopicDetailVC:(NSIndexPath * )indexPath{
    HomeworkDetailKHLXTopicType type  = HomeworkDetailKHLXTopicType_Normal;
    type = HomeworkDetailKHLXTopicType_RightAndWrong;
//    HomeworkDetailKHLXQuestionsModel *questionModel = self.model.questions[indexPath.row];
      NSDictionary *questionModel = self.listModel[indexPath.row];
     NSArray * rightAndWrongArray = [self getRightAndWrongStudent:questionModel];
    //错题人数大于0 查看错题人
    if ([rightAndWrongArray.firstObject count] > 0) {
        HomeworkDetailKHLXTopicDetailViewController * topicVC = [[HomeworkDetailKHLXTopicDetailViewController alloc]initWithType:type withArray:rightAndWrongArray];
        [self pushViewController:topicVC];
    }

}
//- (NSArray *)getRightAndWrongStudent:(HomeworkDetailKHLXQuestionsModel *)questionModel{
//    NSMutableArray * array = [NSMutableArray array];
//    NSMutableArray * rightArray = [NSMutableArray array];
//    NSMutableArray * wrongArray = [NSMutableArray array];
//    for (AnswerStudentsModel *tempModel in questionModel.answerStudents) {
//
//        bool correct = [tempModel.correct boolValue];
//        if (correct) {
//            [rightArray addObject:tempModel.studentName];
//        }else{
//            [wrongArray addObject:tempModel.studentName];
//        }
//    }
//    [array addObject:wrongArray];
//    [array addObject:rightArray];
//    return array;
//}

- (NSArray *)getRightAndWrongStudent:(NSDictionary *)questionModel{
    NSMutableArray * array = [NSMutableArray array];
    NSMutableArray * rightArray = [NSMutableArray array];
    NSMutableArray * wrongArray = [NSMutableArray array];
    for (NSDictionary *tempModel in questionModel[@"answerStudents"]) {
        
        bool correct = [tempModel[@"correct"] boolValue];
        if (correct) {
            [rightArray addObject:tempModel[@"studentName"]];
        }else{
            [wrongArray addObject:tempModel[@"studentName"]];
        }
    }
    [array addObject:wrongArray];
    [array addObject:rightArray];
    return array;
}
#pragma mark ---
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
