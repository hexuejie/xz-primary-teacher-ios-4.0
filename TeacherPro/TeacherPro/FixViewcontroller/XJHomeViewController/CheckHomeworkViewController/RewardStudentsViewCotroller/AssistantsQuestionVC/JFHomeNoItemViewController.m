//
//  JFHomeNoItemViewController.m
//  TeacherPro
//
//  Created by DCQ on 2018/1/3.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "JFHomeNoItemViewController.h"
#import "JFHomeworkQuestionModel.h"
#import "StudentHomeworkDetailViewController.h"
#import "StudentKHLXHomeworkDetailVC.h"
@interface JFHomeNoItemViewController ()

@property(nonatomic, copy)  NSString *studentId;
@property(nonatomic, copy)  NSString *studentName;
@property(nonatomic, copy)  NSString *bookId;
@property(nonatomic, assign)  BOOL onlyKhlxOnline;
@property(nonatomic, assign)  BOOL isOnline;
@property(nonatomic, assign)  BOOL isCheck;
@end

@implementation JFHomeNoItemViewController
- (instancetype)initWithBookId:(NSString *)bookId withHomeworkId:(NSString *)homeworkId withStudentId:(NSString *)studentId{
    if (self == [super init]) {
        self.homeworkId = homeworkId;
        self.studentId = studentId;
        self.bookId = bookId;
    }
    return self;
}
- (instancetype)initWithBookId:(NSString *)bookId withHomeworkId:(NSString *)homeworkId withStudentId:(NSString *)studentId withIsOnlineHomework:(BOOL)isOnline withOnlyKhlxOnline:(BOOL)onlyKhlxOnline withStudentName:(NSString *) studentName withHomeworkState:(BOOL)isCheck{
    if (self == [super init]) {
        self.homeworkId = homeworkId;
        self.studentId = studentId;
        self.bookId = bookId;
        self.isOnline = isOnline;
        self.onlyKhlxOnline = onlyKhlxOnline;
        self.studentName = studentName;
        self.isCheck = isCheck;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"不会做的题"];
    [self requestListStudentUnKnowHomeworkJfQuestions];
    if (self.isOnline) {
        UIButton * onlineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [onlineBtn setTitle:@"查看作业详情" forState:UIControlStateNormal];
        [onlineBtn setTitleColor:UIColorFromRGB(0x6b6b6b) forState:UIControlStateNormal];
        [onlineBtn setBackgroundColor:project_main_blue];
        [onlineBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.view addSubview:onlineBtn];
        onlineBtn.layer.masksToBounds = YES;
        onlineBtn.layer.cornerRadius = 44/2;
        onlineBtn.layer.borderWidth = 1;
        onlineBtn.layer.borderColor = [UIColor clearColor].CGColor;
        [onlineBtn addTarget:self action:@selector(gotoStudentInfo:) forControlEvents:UIControlEventTouchUpInside];
        [onlineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.tableView.mas_bottom );
            make.left.mas_equalTo(self.view.mas_left).offset(20);
            make.right.mas_equalTo(self.view.mas_right).offset(-20);
            make.height.mas_equalTo(@(44));
        }];
    }
}

- (CGRect)getTableViewFrame{
    CGFloat onlineHomeworkH = 0;
    if (self.isOnline) {
        onlineHomeworkH = 44;
    }
    return CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height -onlineHomeworkH);
}

- (void)requestListStudentUnKnowHomeworkJfQuestions{
    NSDictionary *parameterDic = @{@"homeworkId":self.homeworkId,@"studentId":self.studentId};
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_ListStudentUnKnowHomeworkJfQuestions] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_ListStudentUnKnowHomeworkJfQuestions];
    
}

- (void)setNetworkRequestStatusBlocks{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_ListStudentUnKnowHomeworkJfQuestions) {
               strongSelf.questionModel = [[JFHomeworkQuestionModel alloc]initWithDictionary:successInfoObj error:nil];
            [strongSelf updateTableView];
        }
    }];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    QuestionModel * tempModel = [super getQuesionModel:indexPath.section];
    [super gotoJFHomeworkTopicDetailVC:tempModel withIndexPath:indexPath];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)gotoStudentInfo:(id)sender{
    
    if (self.onlyKhlxOnline) {
        [self gotoStudentKHLXHomeworkDetailVC:self.studentId  studnetName:self.studentName ];
        
    }else{
        [self gotoStudentHomeworkDetailVC:self.studentId  studnetName:self.studentName ];
    }
    
}


- (void)gotoStudentKHLXHomeworkDetailVC:(NSString *)studentId studnetName:(NSString *)studentName{
    
    StudentKHLXHomeworkDetailVC * detail = [[StudentKHLXHomeworkDetailVC alloc]initWithStudentName:studentName withStudentId:studentId withHomeworkId:self.homeworkId];
    
    [self pushViewController:detail];
}

- (void)gotoStudentHomeworkDetailVC:(NSString *)studentId studnetName:(NSString *)studentName{
    
    StudentHomeworkDetailViewController * detail = [[StudentHomeworkDetailViewController alloc]initWithStudent:studentId withStudentName:studentName   withHomeworkId:self.homeworkId withHomeworkState:self.isCheck]; 
 
    [self pushViewController:detail];
}

@end
