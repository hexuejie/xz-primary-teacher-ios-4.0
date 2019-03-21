//
//  StudentKHLXHomeworkDetailVC.m
//  TeacherPro
//
//  Created by DCQ on 2018/7/5.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "StudentKHLXHomeworkDetailVC.h"
#import "StudentKHLXHomeworkDetailListModel.h"
#import "StudentKHLXHomeworkTopicContentCell.h"
#import "StudentKHLXHomeworkDetailHeaderSectionView.h"
#import "ProUtils.h"
#import "PublicDocuments.h"

NSString * const StudentKHLXHomeworkTopicContentCellIdentifier = @"StudentKHLXHomeworkTopicContentCellIdentifier";
NSString * const StudentKHLXHomeworkDetailHeaderSectionViewIdentifier = @"StudentKHLXHomeworkDetailHeaderSectionViewIdentifier";
@interface StudentKHLXHomeworkDetailVC ()
@property(nonatomic, copy)NSString * studentName;
@property(nonatomic, copy)NSString * studentId;
@property(nonatomic, copy)NSString * homeworkId;
@property(nonatomic, strong)  NSMutableArray *  listModel;
@end

@implementation StudentKHLXHomeworkDetailVC
- (instancetype)initWithStudentName:(NSString *)studentName withStudentId:(NSString *)studentId withHomeworkId:(NSString *)homeworkId{
    self = [super init];
    if (self) {
        self.studentName = studentName;
        self.studentId = studentId;
        self.homeworkId = homeworkId;
    }
    return self;
}
- (NSMutableArray *)listModel{
    if (!_listModel) {
        _listModel = [NSMutableArray array];
    }
    return _listModel;
}
- (UITableViewStyle)getTableViewStyle{
    return UITableViewStylePlain;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationItemTitle: self.studentName];
}
- (void)registerCell{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([StudentKHLXHomeworkTopicContentCell class]) bundle:nil] forCellReuseIdentifier:StudentKHLXHomeworkTopicContentCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([StudentKHLXHomeworkDetailHeaderSectionView class]) bundle:nil] forHeaderFooterViewReuseIdentifier: StudentKHLXHomeworkDetailHeaderSectionViewIdentifier];
}
- (void)getNetworkData{
    
    NSDictionary * parameterDic = @{@"studentId":self.studentId,@"homeworkId":self.homeworkId};
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_QueryStudentKhlxHomework] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_QueryStudentKhlxHomework];
}

- (void)setNetworkRequestStatusBlocks{
    
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
       STRONGSELF
        if (request.tag == NetRequestType_QueryStudentKhlxHomework) {
//            strongSelf.listModel = [[StudentKHLXHomeworkDetailListModel alloc]initWithDictionary:successInfoObj error:nil];
 
           NSArray * unitQuestions = successInfoObj[@"khlxHomeworks"] ;
            
            for (NSDictionary * unitDic in unitQuestions) {
               NSMutableDictionary * newQuestionsDic = [NSMutableDictionary dictionary];
                [newQuestionsDic addEntriesFromDictionary:unitDic];
                [newQuestionsDic setObject:[strongSelf resetData:unitDic[@"questions"]] forKey:@"questions"];
                [strongSelf.listModel addObject:newQuestionsDic];
            }
            [strongSelf updateTableView];
        }
                                      
    }];
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


NSInteger khlxStudentSortedCompare(id obj1, id obj2, void *context)
{
    
    return  [obj1 localizedCompare:obj2];
}

- (NSArray *)cellOptionsHeight:(NSDictionary *)contentDic withTextFOntSize:(UIFont *)font{
    CGFloat height = 0;
    CGFloat spacing = (26+10)*2;
    NSArray * allkeys = contentDic.allKeys;
    NSArray *sortedArray = [allkeys sortedArrayUsingFunction:khlxStudentSortedCompare context:NULL];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger sections = [self.listModel count];
    return sections;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray * questions  = self.listModel[section][@"questions"] ;
    NSInteger rows = [questions count];
    return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    HomeworkDetailKHLXQuestionsModel *questionModel = self.model.questions[indexPath.row];
    NSArray * questions  = self.listModel[indexPath.section][@"questions"] ;
    NSDictionary *questionModel = questions[indexPath.row];
    return [questionModel[@"cellHeight"] floatValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell =nil;
    
    StudentKHLXHomeworkTopicContentCell * tempCell =  [tableView dequeueReusableCellWithIdentifier:StudentKHLXHomeworkTopicContentCellIdentifier];
     NSArray * questions  = self.listModel[indexPath.section][@"questions"] ;
    NSDictionary * topicDic = questions[indexPath.row];
    [tempCell setupTopicDic:topicDic];
    cell = tempCell;
    return cell;
    
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headerView = nil;
    
    StudentKHLXHomeworkDetailHeaderSectionView*  tempView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:StudentKHLXHomeworkDetailHeaderSectionViewIdentifier];
    NSDictionary * unitDic = self.listModel[section];
    [tempView setupUnitDic:unitDic];
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
