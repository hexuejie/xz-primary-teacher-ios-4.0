//
//  HomeworkReviewViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/7/17.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "HomeworkReviewViewController.h"
#import "HomeworkReviewCell.h"
#import "HomeworkReviewFooterView.h"
#import "HomeworkReviewHeaderView.h"
#import "HomeworkReviewModel.h"
#import "CheckHomeworkReviewListViewController.h"
#define headerViewCurrentlabelTag  10003
#define headerViewRightBtnTag  10005
#define HeaderHeight  FITSCALE(50)
#define ClassDetailHeight   FITSCALE(50)
NSString * const HomeworkReviewCellIdentifier = @"HomeworkReviewCellIdentifier";
NSString * const HomeworkReviewFooterViewIdentifier  = @"HomeworkReviewFooterViewIdentifier";
NSString * const HomeworkReviewHeaderViewIdentifier  = @"HomeworkReviewHeaderViewIdentifier";
@interface HomeworkReviewViewController ()<CheckHomewrokListViewControllerDelegate>
@property (nonatomic, copy)   NSString * currentDate;
@property (nonatomic, assign) NSInteger  currentMonthIndex;
@property (nonatomic, strong) HomeworkReviewListModel * models;
@end

@implementation HomeworkReviewViewController
- (instancetype)init{

    self = [super init];
    if (self) {
          self.currentDate  = [self getYearMonth:[NSDate date]];
    }
    
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationItemTitle:@"作业回顾"];
    [self setupTableViewHeaderView];
    self.tableView.backgroundColor = [UIColor clearColor];
    // 隐藏UITableViewStyleGrouped上边多余的间隔
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
   
    self.view.backgroundColor = project_background_gray;
}
- (UITableViewStyle)getTableViewStyle{

    return UITableViewStyleGrouped;
}

- (CGRect)getTableViewFrame{
    CGRect tableFrame = CGRectMake(0, HeaderHeight, self.view.frame.size.width, self.view.frame.size.height- HeaderHeight);
    return tableFrame;
}
- (void)setupTableViewHeaderView{
    
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH,HeaderHeight )];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel * contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, FITSCALE(50))];
    contentLabel.text = self.currentDate;
    contentLabel.textColor =  project_main_blue;
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.tag = headerViewCurrentlabelTag;
    [headerView addSubview:contentLabel];
    
    UIButton * leftBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    
    [leftBtn addTarget:self action:@selector(leftAction:) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setFrame:CGRectMake(10, 0, FITSCALE(50), FITSCALE(50))];
    [leftBtn setImage: [UIImage imageNamed:@"preMoth"] forState: UIControlStateNormal];
    
    [headerView addSubview:leftBtn];
    
    UIButton * rightBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    
    [rightBtn addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.tag = headerViewRightBtnTag;
    [rightBtn setFrame:CGRectMake(IPHONE_WIDTH - FITSCALE(50), 0,  FITSCALE(50), FITSCALE(50))];
    [rightBtn setImage: [UIImage imageNamed:@"nextMoth"] forState: UIControlStateNormal];
    rightBtn.hidden =  YES;
    [headerView addSubview:rightBtn];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, FITSCALE(50)-FITSCALE(0.5), IPHONE_WIDTH, FITSCALE(0.5))];
    [lineView setBackgroundColor:project_line_gray];
    [headerView addSubview:lineView];
    [self.view addSubview:headerView];
    
}

- (void)registerCell{
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeworkReviewCell class]) bundle:nil] forCellReuseIdentifier:HomeworkReviewCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeworkReviewFooterView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:HomeworkReviewFooterViewIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeworkReviewHeaderView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:HomeworkReviewHeaderViewIdentifier];
}
- (void)getNormalTableViewNetworkData{
    
    [self  requestQueryTeacherHomeworkMonthReview];
}


- (NSString *)getYearMonth:(NSDate *)date{
    
    NSDateFormatter * dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yyyy-MM";
    NSString * yearMonth = [dateFormatter stringFromDate: date];
    
    return yearMonth;
}


- (void)leftAction:(id)sender{
    
    //上月
    _currentMonthIndex --;
    [self senderPreOrNewMonth];
}

- (void)rightAction:(id)sender{
    //下月
    
    _currentMonthIndex ++;
    [self senderPreOrNewMonth];
    
}
- (void )senderPreOrNewMonth{
    
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *comps = nil;
    
    comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
    
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    
    [adcomps setYear: 0];
    
    [adcomps setMonth:_currentMonthIndex];
    
    [adcomps setDay:0];
    
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:[NSDate date] options:0];
    
    
    self.currentDate =  [self getYearMonth: newdate];
    
    UILabel * currentLabel = [self.view viewWithTag:headerViewCurrentlabelTag];
    currentLabel.text =  self.currentDate;
    
    [self requestQueryTeacherHomeworkMonthReview];
    UIButton * rightBtn = [self.view viewWithTag:headerViewRightBtnTag];
    if([self.currentDate isEqualToString:[self getYearMonth:[NSDate date]]]){
         rightBtn.hidden =  YES;
     }else{
         rightBtn.hidden = NO;
    }
    
}

#pragma mark --
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [self.models.homeworkDays count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0.01;
    HomeworkReviewModel * model = self.models.homeworkDays[indexPath.row];
    
     height = ClassDetailHeight * [ model.homeworkDetials count] + 20 ;
     return height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat headerHeight = 0;
    if ([self.models.homeworkDays count] >0) {
        headerHeight = FITSCALE(36);
    }
    return headerHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    CGFloat footerHeight = 0;
    if ([self.models.homeworkDays count] >0) {
        footerHeight = FITSCALE(120);
    }
    return  footerHeight;
}
- ( UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headerView = [[UIView alloc]init];
    if ([self.models.homeworkDays count] >0) {
        HomeworkReviewHeaderView * tempView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HomeworkReviewHeaderViewIdentifier];
        headerView = tempView;
    }

    return headerView;
}
- ( UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footerView = [[UIView alloc]init];
    if ([self.models.homeworkDays count] >0) {
        HomeworkReviewFooterView * tempView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HomeworkReviewFooterViewIdentifier];
         footerView = tempView;
    }
    return footerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = nil;
    HomeworkReviewCell * tempCell = [tableView dequeueReusableCellWithIdentifier:HomeworkReviewCellIdentifier];
    [tempCell setupHomeworkReviewInfo:self.models.homeworkDays[indexPath.row]];
    tempCell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell = tempCell;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     HomeworkReviewModel * model = self.models.homeworkDays[indexPath.row];
    
    NSString * day = @"";
    if ([model.day length] >0 && [model.day length] <2) {
        day = [NSString stringWithFormat:@"0%@",model.day];
    }else{
       day = model.day;
    }
    
    NSString * date =  [[self.currentDate stringByReplacingOccurrencesOfString:@"-" withString:@""] stringByAppendingString:day];
    [self gotoCheckHomeworkList: date];
}

- (void)gotoCheckHomeworkList:(NSString *)day{

    CheckHomeworkReviewListViewController * checkHomewrokVC = [[CheckHomeworkReviewListViewController alloc]initWithType:CheckHomewrokListViewControllerFromType_review withDay:day];
    checkHomewrokVC.delegate = self;
    [self pushViewController:checkHomewrokVC];
}
#pragma mark ---

- (void)requestQueryTeacherHomeworkMonthReview{
    
    NSDictionary * parameterDic = @{@"months":[self.currentDate stringByReplacingOccurrencesOfString:@"-" withString:@""]};
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_QueryTeacherHomeworkMonthReview] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_QueryTeacherHomeworkMonthReview];
    
}


- (void)setNetworkRequestStatusBlocks{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_QueryTeacherHomeworkMonthReview) {
            NSDictionary * homeworksDic = successInfoObj[@"homeworks"];
           NSArray * tempArray  =  [homeworksDic allValues][0];
            NSDictionary * homeworkDaysDic = @{@"homeworkDays":tempArray};
            
           strongSelf.models  = [[HomeworkReviewListModel alloc]initWithDictionary:homeworkDaysDic error:nil] ;
            
            [strongSelf updateTableView];
        }
    }];
    
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    
    return [UIImage imageNamed:@"homework_review_nodata"];
}
- (NSString *)getDescriptionText{
    
    return @"该月暂无作业！";
}

- (void)updateHomeworkDate{

    [self getNormalTableViewNetworkData];
}
#pragma mark --
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
