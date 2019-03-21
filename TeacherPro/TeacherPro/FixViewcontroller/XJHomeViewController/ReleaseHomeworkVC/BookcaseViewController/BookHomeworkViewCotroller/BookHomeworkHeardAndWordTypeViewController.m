//
//  BookHomeworkHeardAndWordTypeViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/9/7.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BookHomeworkHeardAndWordTypeViewController.h"
#import "HeardPracticeViewController.h"
#import "WordPracticeViewController.h"
#import "HeardAndWordTypeModel.h"
#import "BookHomeworkHeardAndWordTypeBottomView.h"
#import "HomeworkConfirmationViewController.h"
@interface BookHomeworkHeardAndWordTypeViewController ()
@property(nonatomic, copy) NSString * titleStr;
@property(nonatomic, copy) NSString * unitId;
@property(nonatomic, strong) HeardAndWordTypeModel * detailTypeModel;
@property(nonatomic, strong) BookHomeworkHeardAndWordTypeBottomView * bottomView;
@property(nonatomic, strong) NSArray * workDataArray;
@property(nonatomic, strong) NSArray * heardDataArray;
@property(nonatomic, assign) NSInteger  totalTime;//总数
@property(nonatomic, assign) NSInteger  wordTotalNumber;//单词练习数
@property(nonatomic, assign) NSInteger  heardTotalNumber ;//听说练习数
@property(nonatomic, strong) NSArray *cacheData;
@end

@implementation BookHomeworkHeardAndWordTypeViewController
- (instancetype)initWithNavigationTitle:(NSString *)titleStr  withUnitId:(NSString *)unitId withCacheData:(NSArray *)cacheData {
    self = [super init];
    if (self) {
        self.titleStr = titleStr;
        self.unitId = unitId;
        self.cacheData = cacheData;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.totalTime = 0;
    self.wordTotalNumber = 0;
    self.heardTotalNumber  = 0;
    [self setNavigationItemTitle:self.titleStr];
    [self setupIndicator];
    [self requestQueryAppTypeByUnit];
    [self initBottomView];
}

- (void)setupIndicator{
    
    self.buttonBarView.shouldCellsFillAvailableWidth = YES;
    self.buttonBarView.backgroundColor = [UIColor whiteColor];
    self.isProgressiveIndicator = NO;
    self.buttonBarView.isAutoIndicatorWidth = YES;
    self.buttonBarView.leftRightMargin = 0;
    self.buttonBarView.scrollsToTop = NO;
    self.buttonBarView.scrollEnabled = NO;
    // Do any additional setup after loading the view.
    
    self.buttonBarView.selectedBar.backgroundColor =  UIColorFromRGB(0x2E8AFF);
    
    self.buttonBarView.backgroundColor = [UIColor whiteColor];
    self.bottomLineView.backgroundColor = UIColorFromRGB(0xededed);
    self.buttonBarView.bottomLineHeight = 1;
    
}
- (void)initBottomView{
    [self.view addSubview:self.bottomView];
   

    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        CGFloat bottomHeight = FITSCALE(50);
        CGFloat top = self.view.frame.size.height - bottomHeight;
        make.leading.mas_equalTo(self.view.mas_leading);
        make.trailing.mas_equalTo(self.view.mas_trailing);
        make.top.mas_equalTo(@(top));
        make.height.mas_equalTo(@(bottomHeight));
        
    }];
     
    WEAKSELF
    self.bottomView.sureBlock = ^{
        [weakSelf gotoHomeworkConfirmationVC];
    };
}

- (BookHomeworkHeardAndWordTypeBottomView *)bottomView{
   if (!_bottomView) {
        _bottomView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([BookHomeworkHeardAndWordTypeBottomView class]) owner:nil options:nil].firstObject;
    
       UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,  self.view.frame.size.width, 0.5)];
       lineView.backgroundColor = project_line_gray;
       [_bottomView addSubview:lineView];
       
    }
    return _bottomView;
}
-(NSArray *)childViewControllersForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    WordPracticeViewController * wordPracticeVC = [[WordPracticeViewController alloc]initWithCacheData:self.cacheData.firstObject[@"words"]];
    WEAKSELF
    wordPracticeVC.homeworkBlock = ^(NSArray *wordArray) {
        weakSelf.workDataArray = wordArray;
 
        [weakSelf setupBottomViewData];
    };
    HeardPracticeViewController * heardPracticeVC = [[HeardPracticeViewController alloc]initWithCacheData:self.cacheData.firstObject[@"listenAndTalk"]];
    heardPracticeVC.homeworkBlock = ^(NSArray *hearArray) {
        weakSelf.heardDataArray = hearArray;
        [weakSelf setupBottomViewData];
    };
    NSArray * childViewControllers = [NSMutableArray arrayWithObjects:wordPracticeVC,heardPracticeVC,nil];
    
    return childViewControllers;
}



- (void)setupBottomViewData{
    self.totalTime =  0;
    self.wordTotalNumber = [self  configDataArray:self.workDataArray ];
    self.heardTotalNumber  = [self configDataArray:self.heardDataArray];
    [self.bottomView setupTotalNumber:self.totalTime withWordNumber:self.wordTotalNumber withHeardNumber:self.heardTotalNumber];
  
}


- (NSInteger )configDataArray:(NSArray *)dataArray {
    
    NSMutableArray * tempArray = [NSMutableArray array];
    //每块总题数
    NSInteger sectionTotalNumber = 0;
    //每块总时间
    NSInteger sectionTotalTime = 0;

    
    for (NSDictionary * tempDic in dataArray) {
        NSString *sectionName = tempDic[@"sectionName"];
        NSString *id = tempDic[@"id"];
        [tempArray addObject:@{@"id":id,@"sectionName":sectionName}];
        
        NSArray * tempContentArray = tempDic[@"content"];
        [tempArray addObjectsFromArray:tempContentArray];
        for (NSDictionary * itemDic in tempContentArray) {
           NSInteger  tempDurationTime = [itemDic[@"durationTime"] integerValue] * [itemDic[@"count"] integerValue];
            sectionTotalTime = sectionTotalTime + tempDurationTime ;
             sectionTotalNumber ++;
        }
        
    }
    
   
    self.totalTime = self.totalTime + sectionTotalTime;
    
    return  sectionTotalNumber;
}


- (void)changeCurrentIndexUpdate:(NSInteger )toIndex  {
   
    if (toIndex == 0) {
        [self  updateWordView];
    }else if (toIndex == 1){
        [self  updateHeardView];
    }
}


#pragma mark --
- (void)requestQueryAppTypeByUnit{
    
    NSDictionary *parameterDic =nil;
    if (self.unitId) {
        parameterDic  = @{@"unitId":self.unitId};
    }
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_QueryAppTypeByUnit] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_QueryAppTypeByUnit];
}

- (void)setNetworkRequestStatusBlocks{
    
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_QueryAppTypeByUnit) {
            
            strongSelf.detailTypeModel = [[HeardAndWordTypeModel  alloc]initWithDictionary:successInfoObj error:nil];
            
            [strongSelf firstShowViewData];
            
        }
        
    }];
}
- (void)firstShowViewData{
     WordTypeModel * model = self.detailTypeModel.words.firstObject;
    
    if (model &&[model.appTypes count] ) {
        [self updateWordView];
        
        HeardPracticeViewController * heardViewController = self.pagerTabStripChildViewControllers[1] ;
        [heardViewController setupCacheHeardData:self.detailTypeModel];
    }else{
        [self moveToViewControllerAtIndex:1];
        HeardPracticeViewController * heardViewController = self.pagerTabStripChildViewControllers[1] ;
        [heardViewController setupCacheHeardData:self.detailTypeModel];
        
    }
   
}
//词汇练习
- (void)updateWordView{

    WordPracticeViewController * wordViewController = self.pagerTabStripChildViewControllers.firstObject ;
    [wordViewController updateViewData:self.detailTypeModel];
    
}

//听说练习
- (void)updateHeardView{
    HeardPracticeViewController * heardViewController = self.pagerTabStripChildViewControllers[1];
    
    [heardViewController updateViewData:self.detailTypeModel];
}

- (void)gotoHomeworkConfirmationVC{
 
    if (((!self.workDataArray)||[self.workDataArray count]==0) &&( (!self.heardDataArray)||[self.heardDataArray count] == 0)) {
        [self showAlert:TNOperationState_Unknow content:@"请选择作业布置"];
 
    }else{
       HomeworkConfirmationViewController * hwcVC = [[HomeworkConfirmationViewController alloc]initWithWorkData:self.workDataArray withHeardData:self.heardDataArray withUnityID:self.unitId];
        [self pushViewController:hwcVC];
    }
}

#pragma mark --
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIColor *)getTabTitleColorNor{
    
    return UIColorFromRGB(0x9f9f9f);
}
- (UIColor *)getTabTitleColorSelected{
    
    return UIColorFromRGB(0x4C6B9A);
}

@end
