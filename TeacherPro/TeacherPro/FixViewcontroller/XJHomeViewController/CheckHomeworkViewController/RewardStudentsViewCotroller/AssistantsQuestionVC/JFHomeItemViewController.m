


//
//  JFHomeItemViewController.m
//  TeacherPro
//
//  Created by DCQ on 2018/8/16.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "JFHomeItemViewController.h"
#import "JFHomeworkQuestionModel.h"
#import "JFHomeworkDoubtStudentListViewController.h"

@interface JFHomeItemViewController ()
@property(nonatomic, copy)  NSString *studentId;
@property(nonatomic, copy)  NSString *studentName;
@property(nonatomic, copy)  NSString *bookId;
@end

@implementation JFHomeItemViewController
- (instancetype)initWithHomeworkId:(NSString *)homeworkId withStudentId:(NSString *)studentId{
    self =  [super init];
    if (self) {
        self.homeworkId = homeworkId;
        self.studentId = studentId;
 
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationItemTitle:@"教辅练习"];
    [self requestListQueryStudentHomeworkJfQuestions];
}
- (void)requestListQueryStudentHomeworkJfQuestions{
    NSDictionary *parameterDic = @{@"homeworkId":self.homeworkId,@"studentId":self.studentId};
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_QueryStudentHomeworkJfQuestions] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_QueryStudentHomeworkJfQuestions];
    
}

- (void)setNetworkRequestStatusBlocks{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        NSMutableArray *questions = [NSMutableArray array];
        for (NSDictionary * dic in successInfoObj[@"questions"]) {
            if (dic[@"children"] &&[dic[@"children"] count]>0 ) {
                //子题
                for (NSDictionary * tempDic in dic[@"children"]) {
                    [questions addObject:tempDic];
                }
            }else{
                //父题
                 [questions addObject:dic];
            }
        }
        
        NSSortDescriptor *ageSD = [NSSortDescriptor sortDescriptorWithKey:@"unKnowQuestion" ascending:NO];//ascending:YES 代表升序 如果为NO 代表降序
 
       NSArray * tempQuestions = [questions sortedArrayUsingDescriptors:@[ageSD]];
        if (request.tag == NetRequestType_QueryStudentHomeworkJfQuestions) {
            strongSelf.questionModel = [[JFHomeworkQuestionModel alloc]initWithDictionary:@{@"questions":tempQuestions} error:nil];
            [strongSelf updateTableView];
        }
    }];
}



//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    QuestionModel * tempModel = [super getQuesionModel:indexPath.section];
//    [super gotoJFHomeworkTopicDetailVC:tempModel withIndexPath:indexPath];
//}
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
