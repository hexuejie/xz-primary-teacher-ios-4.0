//
//  FeedbackViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/6/2.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "FeedbackViewController.h"
#import "FeedbackCell.h"
#import "FeedbackModel.h"


@interface FeedbackViewController ()
@property (nonatomic, strong) FeedbackModels * feedbackModels;
@property (nonatomic, assign) NSInteger  selectedIndex;
@property (nonatomic, strong) NSArray * backModels;
@end

@implementation FeedbackViewController
- (instancetype)initWithIndex:(NSInteger )index{

    if (self == [super init]) {
        self.selectedIndex = index;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationItemTitle:@"反馈方式"];
 
//    [self requestFeedback];
    FeedbackModel * backModelOne = [[FeedbackModel alloc]init];
    backModelOne.des = @"书写、预习等作业要家长拍照";
    backModelOne.name = @"图片反馈";
    backModelOne.logo = @"feedback_photo";
    backModelOne.id = @"photo";
    
    FeedbackModel * backModelTow = [[FeedbackModel alloc]init];
    backModelTow.des = @"朗读、背诵等作业要家长录音";
    backModelTow.name = @"录音反馈";
    backModelTow.logo = @"feedback_sound";
    backModelTow.id = @"sound";
    
    FeedbackModel * backModelThreed = [[FeedbackModel alloc]init];
    backModelThreed.des = @"学校、班级通知等要家长签字";
    backModelThreed.name = @"签字反馈";
    backModelThreed.logo = @"feedback_signature";
    backModelThreed.id = @"signature";
    
    
    FeedbackModel * backModelFour = [[FeedbackModel alloc]init];
    backModelFour.des = @"仅告知家长，不需要家长反馈";
    backModelFour.name = @"无需反馈";
    backModelFour.logo = @"feedback_none";
    backModelFour.id = @"none"; 
    self.backModels = @[backModelOne,backModelTow,backModelThreed,backModelFour];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self navUIBarBackground:0];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self navUIBarBackground:0];
}

- (void)registerCell{

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FeedbackCell class]) bundle:nil] forCellReuseIdentifier:@"FeedbackCellIdentifier"];
}
- (void)requestFeedback{

    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_QueryHomeworkFeedback] parameterDic:nil requestMethodType:RequestMethodType_POST requestTag:NetRequestType_QueryHomeworkFeedback];
}

- (void)setNetworkRequestStatusBlocks{

    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_QueryHomeworkFeedback) {
            
            strongSelf.feedbackModels = [[FeedbackModels  alloc]initWithDictionary:successInfoObj error:nil];
            [strongSelf updateTableView];
        }
        
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.backModels count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FeedbackCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FeedbackCellIdentifier"];
    BOOL selected = NO;
//    if (self.selectedIndex == indexPath.row) {
//        selected = YES;
//    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setupCellInfo:self.backModels[indexPath.row] withSelected:selected];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectedIndex = indexPath.row;

    if (self.feedbackBlock) {
        self.feedbackBlock(self.backModels[indexPath.row], self.selectedIndex);
    }
    [self backViewController];
}

@end
