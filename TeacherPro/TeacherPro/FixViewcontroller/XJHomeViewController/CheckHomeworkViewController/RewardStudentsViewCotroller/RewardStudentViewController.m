//
//  RewardViewController.m
//  AplusKidsMasterPro
//
//  Created by DCQ on 2017/3/8.
//  Copyright © 2017年 neon. All rights reserved.
//

#import "RewardStudentViewController.h"
#import "AllRewardViewController.h"
#import "BeforeRewardViewController.h"
#import "ProgressViewController.h"
#import "SpeedRewardViewController.h"
#import "UnfinishedViewController.h"
#import "StudentsFeedbackViewController.h"
#import "AdjustRewardView.h"
#import "YBPopupMenu.h"

#import "DWParticleEmitter.h"
#import "ProUtils.h"
#import "JFHomeNoItemViewController.h"
#import "BaseCheckHomeworkListViewController.h"
#import "CheckHomeworkNewListViewController.h"

@interface RewardStudentViewController ()<YBPopupMenuDelegate>
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) AdjustRewardView *adjustRewardView;
@property (nonatomic, strong) NSDictionary * allRewardData;
@property (nonatomic, strong) NSMutableArray * allRewardDataList;
@property (nonatomic, strong)  NSString * titleStr;
@property (nonatomic, strong)  UIButton * allSelectedBtn;
@property (nonatomic, strong) NSMutableDictionary * btnSelectedStateDic;//存每块的全选按钮状态
@property (nonatomic, strong) NSMutableDictionary * adjustableCoinNumberDic;//存每块调整的豆数
@property (nonatomic, copy) NSString * coinNumber;
@property (nonatomic, copy) NSString * homeworkId;
@property (nonatomic, assign)RewardStudentViewControlleType type;
@property (nonatomic, copy) NSDictionary *allRewardResult;
@property (nonatomic, assign) BOOL isShowResultsGroup;//是否显示成绩分组
@property (nonatomic, assign) BOOL isAllComplete;//是否全部完成
@property (nonatomic, assign) HomeworkBackfeedType backfeedType ;
@property (nonatomic, strong) UIButton * sendRewardBtn;
@property (nonatomic, strong) UIView *assistantsQuestionView;
@property (nonatomic, strong) UIView *coinAnimationBgView;
@property (nonatomic, assign) BOOL isSendCoin;//是否允许发送学豆


@end

@implementation RewardStudentViewController

- (instancetype)initWithRewardType:(RewardStudentViewControlleType) type  withTitle:(NSString *)title withHomeworkId:(NSString *)homeworkId  withHomeworkBackfeedType:(HomeworkBackfeedType)backfeedType {
    
    if (self == [super init]) {
        [self removeAllRewardDataList];
        self.titleStr =  title;
        self.homeworkId =  homeworkId;
        self.type = type;
        self.backfeedType = backfeedType;
    }
    return self;
}

- (void)removeAllRewardDataList{
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"allRewardDataList"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.titleStr;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupIndicator];
    //    [self setupRightItem];
    
  
    [self.view addSubview:self.bottomView];
    if (self.type == RewardStudentViewControlleType_checkOnlineHomework){
        [self.view addSubview:self.adjustRewardView];
    }
    RewardBaseViewController * baseVC= self.pagerTabStripChildViewControllers[self.currentIndex];
    self.adjustRewardView.hidden = [baseVC adjustRewardViewHidden];
    self.bottomView.hidden = !self.adjustRewardView.hidden;
    self.allSelectedBtn.hidden = [baseVC allSelectedBtnHidden];
    [self configurationView];
    
 
}

- (void)configurationView{
    
    // 非在线作业
    if (self.type == RewardStudentViewControlleType_lookUnonlineHomework|| self.type == RewardBaseViewControllerType_checkUnonlineHomework) {
        self.buttonBarView.hidden = YES;
        self.bottomLineView.hidden = YES;
        self.containerView.frame = CGRectMake(self.containerView.frame.origin.x, self.containerView.frame.origin.y- self.buttonBarView.frame.size.height, self.containerView.frame.size.width, self.containerView.frame.size.height +self.buttonBarView.frame.size.height);
        
    }
}
- (UIView *)coinAnimationBgView{
    if (!_coinAnimationBgView) {
        _coinAnimationBgView = [[UIView alloc]initWithFrame:self.view.frame];
        _coinAnimationBgView.backgroundColor = [UIColor blackColor];
        _coinAnimationBgView.alpha = 0.4;
    }
    return _coinAnimationBgView;
}
-(void)showCoinAnimation:(NSString *) number{
    
    UIView * superView  = [UIApplication sharedApplication].keyWindow;
    
    UIView * bgView = [[UIView alloc]initWithFrame:superView.frame];
    bgView.backgroundColor = [UIColor clearColor];
    bgView.tag = 989898;
    [superView addSubview:bgView];
    [bgView addSubview:self.coinAnimationBgView];
    
    DWParticleEmitter *emitter = [[DWParticleEmitter alloc] init];
    emitter.emitterBirthRate = 1.5;
    emitter.cellContents = @[[UIImage imageNamed:@"GFMall_coin_icon"]];
    emitter.caEmitterMode = caOutline;
    emitter.caEmitterShape = caLine;
    emitter.cellVelocity = -200.0f;
    /** 此参数加负号即可修改为向上发射 */
    emitter.cellYAcceleration = 10.0f;
    emitter.cellScale = 0.5f;
    
    [emitter addEmitterLayerPosition:CGPointMake(self.view.frame.origin.x,0) emitterSize:CGSizeMake(self.view.frame.size.width*2, 0) view:bgView];
    
    
    UIImageView * bgImgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 240, 136 *240/154)];
    bgImgV.center = superView.center;
    bgImgV.contentMode = UIViewContentModeScaleAspectFill;
    bgImgV.image = [UIImage imageNamed:@"coin_detail_bg_img"];
    [bgView addSubview:bgImgV];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"我知道了" forState:UIControlStateNormal];
    
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIImage * btnBgImg  = [ProUtils getResizableImage:[UIImage imageNamed:@"coin_btn_image"] withEdgeInset:UIEdgeInsetsMake(4, 4, 4, 4)];
    [btn setBackgroundImage:btnBgImg forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(self.view.center.x - 40, CGRectGetMaxY(bgImgV.frame)+ 20, 80, 44)];
    [btn addTarget:self action:@selector(backCheckListVC) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:btn];
    
    
    //作业检查
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,bgImgV.frame.size.width, bgImgV.frame.size.height/2)];
    titleLabel.text = @"作业检查完成";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:22];
    titleLabel.textColor = UIColorFromRGB(0xcdab67);
    [bgImgV addSubview:titleLabel];
    
    UIImageView * coinImgV = [[UIImageView alloc]initWithFrame:CGRectMake(bgImgV.frame.size.width /2-44-10,bgImgV.frame.size.height/2 +10, 44, 44)];
    
    coinImgV.contentMode = UIViewContentModeScaleAspectFill;
    coinImgV.image = [UIImage imageNamed:@"GFMall_coin_icon"];
    [bgImgV addSubview:coinImgV];
    
    UILabel * numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(bgImgV.frame.size.width /2,coinImgV.center.y- 15 ,bgImgV.frame.size.width /2, 30)];
    numberLabel.text = [NSString stringWithFormat:@"+%@",number];
    numberLabel.textAlignment = NSTextAlignmentLeft;
    numberLabel.font = [UIFont systemFontOfSize:22];
    numberLabel.textColor = UIColorFromRGB(0xd31f1f);
    [bgImgV addSubview:numberLabel];
    
    
    UILabel * detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,bgImgV.frame.size.height-30-20,bgImgV.frame.size.width, 30)];
    detailLabel.text = @"*个人中心查看和使用";
    detailLabel.textAlignment = NSTextAlignmentCenter;
    detailLabel.font = [UIFont systemFontOfSize:15];
    detailLabel.textColor = UIColorFromRGB(0xcdab67);
    [bgImgV addSubview:detailLabel];
    
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


- (void)getNetworkData{
    [self requestHomeworkStudentScore];
}
- (void)setupRightItem{
    
    self.allSelectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    NSString * btnTitle = @"分组";
    [self.allSelectedBtn setTitle:btnTitle forState:UIControlStateNormal];
    
    self.allSelectedBtn.titleLabel.font = fontSize_14;
    
    [self.allSelectedBtn addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    [ self.allSelectedBtn setFrame:CGRectMake(0,5, 40, 44)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView: self.allSelectedBtn];
}


- (void)showMenu:(UIButton *)sender
{
    
    NSString *resultsGroupIcon = @"";
    if (self.isShowResultsGroup) {
        resultsGroupIcon = @"student_homework_screening_results";
    }else{
        resultsGroupIcon = @"student_homework_screening_nor_results";
    }
    
    NSArray * items = @[@{@"title":@"无分组",@"img":@"student_homework_screening_normal",@"action":@"normaAction"},
                        @{@"title":@"成绩分组",@"img":resultsGroupIcon,@"action":@"resultsAction"},
                        
                        @{@"title":@"完成分组",@"img":@"student_homework_screening_done",@"action":@"doneAction"}
                        ];
    
    
    NSMutableArray * menuItemTitles = [[NSMutableArray alloc]initWithCapacity:items.count];
    NSMutableArray * menuItemImgs = [[NSMutableArray alloc]initWithCapacity:items.count];
    
    for(int i =0;i< [items count]; i++)   {
        NSDictionary * dic= items[i];
        [menuItemTitles addObject: dic[@"title"]];
        [menuItemImgs    addObject: dic[@"img"]];
    }
    
    
    CGFloat menuW =  124;
    WEAKSELF
    CGFloat x = sender.center.x;
    if (IOS11) {
        x = sender.center.x + self.view.frame.size.width - sender.frame.size.width;
    }
    //    CGFloat y =  CGRectGetMaxY(sender.frame)+5;
    CGFloat y =  NavigationBar_Height;
    //推荐用这种写法
    [YBPopupMenu showAtPoint:CGPointMake(x, y) titles:menuItemTitles icons:menuItemImgs menuWidth:menuW otherSettings:^(YBPopupMenu *popupMenu) {
        STRONGSELF
        popupMenu.dismissOnSelected = NO;
        popupMenu.isShowShadow = YES;
        popupMenu.delegate = strongSelf;
        popupMenu.offset = 10;
        popupMenu.type = YBPopupMenuTypeDark;
        popupMenu.fontSize =  iPhone6Plus?  14*ip6size : FITSCALE(14) ;
        popupMenu.rectCorner = UIRectCornerBottomLeft | UIRectCornerBottomRight|UIRectCornerTopLeft|UIRectCornerTopRight;
        popupMenu.backColor = [UIColor whiteColor];
        popupMenu.textColor = UIColorFromRGB(0x6b6b6b);
        
    }];
    
    
}


- (void)resetDate{
    self.allRewardDataList = [[NSMutableArray alloc]initWithCapacity: [self.allRewardData[@"allStudents"] count]];
    
    self.isShowResultsGroup = NO;
    self.isAllComplete = YES;
    
    
    for (NSDictionary * dic in self.allRewardData[@"allStudents"]) {
        
        //判断是否显示成绩分组
        if (dic[@"scoreTotal"] && [dic[@"scoreTotal"] integerValue]>=0) {
            self.isShowResultsGroup = YES;
        }
        if (!dic[@"finishTime"] ) {
            self.isAllComplete = NO;
        }
        
        NSMutableDictionary * tempItem = [[NSMutableDictionary alloc]init];
        [tempItem addEntriesFromDictionary:dic];
        NSString * tempStudentId = [NSString stringWithFormat:@"%@",tempItem[@"studentId"]];
        //   YES 表示属于  NO 表示不属于
        NSString * progressStudentsState  =  [self isContainsStudent:self.allRewardData[@"progressStudents"] studentId:tempStudentId];
        [tempItem setObject:progressStudentsState forKey:@"progressStudents"];
        
        //   YES 表示属于  NO 表示不属于
        NSString * speedStudentsState  =  [self isContainsStudent:self.allRewardData[@"speedStudents"] studentId:tempStudentId];
        [tempItem setObject:speedStudentsState forKey:@"speedStudents"];
        
        //   YES 表示属于  NO 表示不属于
        
        NSString * top3StudentsState  =  [self isContainsStudent:self.allRewardData[@"top3Students"] studentId:tempStudentId];
        [tempItem setObject:top3StudentsState forKey:@"top3Students"];
        
        // YES 表示属于未完成 NO 表示不属于
        NSString * unfinishedStudentsState  =  [self isContainsStudent:self.allRewardData[@"unfinishedStudents"] studentId:tempStudentId];
        [tempItem setObject:unfinishedStudentsState forKey:@"unfinishedStudents"];
        
        
        //
        [tempItem setObject:@"YES" forKey:@"aLLStudents"];
        [self.allRewardDataList addObject: tempItem];
        
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:self.allRewardDataList forKey:@"allRewardDataList"];
    
}



- (NSString *)isContainsStudent:(NSArray *)list studentId:(NSString *)studentId{
    for (NSDictionary * tempItem in list) {
        NSString * tempStudentId=[NSString stringWithFormat:@"%@",[tempItem objectForKey:@"studentId"]];
        if ( [tempStudentId isEqualToString:studentId]) {
            return @"YES";
        }
    }
    
    return @"NO";
}

- (void)assignAction:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    
    RewardBaseViewController * baseVC= self.pagerTabStripChildViewControllers[self.currentIndex];
    if (sender.selected) {
        [baseVC setupAllStateArrayNumber:YES];
    }else{
        [baseVC setupAllStateArrayNumber:NO];
    }
    
    
    [self saveButtonSelectedState:sender.selected];
    
}

- (void)saveButtonSelectedState:(BOOL )selected{
    
    NSString * key = [NSString stringWithFormat:@"%zd",self.currentIndex];
    [self.btnSelectedStateDic  setObject:[NSNumber numberWithBool:selected] forKey: key];
}
- (BOOL)getButtonSelectedState:(NSString *)key{
    BOOL state = [self.btnSelectedStateDic[key] boolValue];
    return state;
}

-(NSArray *)childViewControllersForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    
    
    //全部
    //    NSMutableArray * allReardList = nil;
    //    if ([self.allRewardData[@"allStudents"] isKindOfClass:[NSArray class]]) {
    //        allReardList = [[NSUserDefaults standardUserDefaults] objectForKey:@"allRewardDataList"];
    //    }
    
    AllRewardViewController *wordVC = [[AllRewardViewController alloc]init];
    wordVC.selectedOnlineNotItemBlock = ^(NSString *studentId,NSString *studentName) {
        [self gotoOnlineHomeworkAssistantsQuestionVC:studentId withStudentName:studentName ];
    };
    wordVC.selectedUnOnlineNotItemBlock = ^(NSString *studentId) {
        [self gotoUnOnlineAssistantsQuestionVC:studentId ];
    };
    wordVC.changeStateBlock = ^(BOOL state){
        [self saveButtonSelectedState:state];
        NSString * key = [NSString stringWithFormat:@"%zd",self.currentIndex];
        self.allSelectedBtn.selected = [self getButtonSelectedState:key];
    };
    wordVC.homeworkId = self.homeworkId;
    if (self.type == RewardStudentViewControlleType_checkOnlineHomework){
        
        wordVC.formType = RewardBaseViewControllerType_checkOnlineHomework;
    }else if (self.type == RewardBaseViewControllerType_lookOnlineHomework){
        
        wordVC.formType = RewardBaseViewControllerType_lookOnlineHomework;
    }else if (self.type == RewardBaseViewControllerType_lookUnonlineHomework){
        
        wordVC.formType = RewardBaseViewControllerType_lookUnonlineHomework;
        [wordVC setupAllRewardViewControllerGroupType:  AllRewardStudentGroupType_Complete];
    }else if(self.type == RewardStudentViewControlleType_checkUnonlineHomework){
        wordVC.formType = RewardBaseViewControllerType_checkUnonlineHomework;
        [wordVC setupAllRewardViewControllerGroupType:  AllRewardStudentGroupType_Complete];
    }
    
    /////前三
    //    NSMutableArray * beforeRewardReardList = nil ;
    //    if ([self.allRewardData[@"top3Students"] isKindOfClass:[NSArray class]]) {
    //        beforeRewardReardList = [[NSUserDefaults standardUserDefaults] objectForKey:@"allRewardDataList"];
    //    }
    
    BeforeRewardViewController * beforeVC = [[BeforeRewardViewController alloc]init];
    beforeVC.changeStateBlock = ^(BOOL state){
        [self saveButtonSelectedState:state];
        NSString * key = [NSString stringWithFormat:@"%zd",self.currentIndex];
        self.allSelectedBtn.selected = [self getButtonSelectedState:key];
    };
    beforeVC.homeworkId = self.homeworkId;
    if (self.type == RewardStudentViewControlleType_checkOnlineHomework){
        beforeVC.formType = RewardBaseViewControllerType_checkOnlineHomework;
    }else if (self.type == RewardBaseViewControllerType_lookOnlineHomework){
        
        beforeVC.formType = RewardBaseViewControllerType_lookOnlineHomework;
    }else if (self.type == RewardBaseViewControllerType_lookUnonlineHomework){
        
        beforeVC.formType = RewardBaseViewControllerType_lookUnonlineHomework;
    }else if(self.type == RewardStudentViewControlleType_checkUnonlineHomework){
        beforeVC.formType = RewardBaseViewControllerType_checkUnonlineHomework;
    }
    
    ///进步达人
    //    NSMutableArray *  progressRewardReardList = nil;
    //    if ([self.allRewardData[@"progressStudents"] isKindOfClass:[NSArray class]]) {
    //        progressRewardReardList = [[NSUserDefaults standardUserDefaults] objectForKey:@"allRewardDataList"];
    //    }
    
    ProgressViewController *progressVC = [[ ProgressViewController alloc]init];
    progressVC.changeStateBlock = ^(BOOL state){
        [self saveButtonSelectedState:state];
        NSString * key = [NSString stringWithFormat:@"%zd",self.currentIndex];
        self.allSelectedBtn.selected = [self getButtonSelectedState:key];
    };
    progressVC.homeworkId = self.homeworkId;
    if (self.type == RewardStudentViewControlleType_checkOnlineHomework){
        progressVC.formType = RewardBaseViewControllerType_checkOnlineHomework;
    }else if (self.type == RewardBaseViewControllerType_lookOnlineHomework){
        
        progressVC.formType = RewardBaseViewControllerType_lookOnlineHomework;
    }else if (self.type == RewardBaseViewControllerType_lookUnonlineHomework){
        
        progressVC.formType = RewardBaseViewControllerType_lookUnonlineHomework;
    }else if(self.type == RewardStudentViewControlleType_checkUnonlineHomework){
        progressVC.formType = RewardBaseViewControllerType_checkUnonlineHomework;
    }
    ////速度之星
    //    NSMutableArray *   speedRewardReardList = nil;
    //    if ([self.allRewardData[@"speedStudents"] isKindOfClass:[NSArray class]]) {
    //        speedRewardReardList = [[NSUserDefaults standardUserDefaults] objectForKey:@"allRewardDataList"];
    //    }
    
    SpeedRewardViewController * speedVC = [[SpeedRewardViewController alloc]init];
    speedVC.changeStateBlock = ^(BOOL state){
        [self saveButtonSelectedState:state];
        NSString * key = [NSString stringWithFormat:@"%zd",self.currentIndex];
        self.allSelectedBtn.selected = [self getButtonSelectedState:key];
    };
    speedVC.homeworkId = self.homeworkId;
    if (self.type == RewardStudentViewControlleType_checkOnlineHomework){
        speedVC.formType = RewardBaseViewControllerType_checkOnlineHomework;
    }else if (self.type == RewardBaseViewControllerType_lookOnlineHomework){
        
        speedVC.formType = RewardBaseViewControllerType_lookOnlineHomework;
    }else if (self.type == RewardBaseViewControllerType_lookUnonlineHomework){
        
        speedVC.formType = RewardBaseViewControllerType_lookUnonlineHomework;
    }else if(self.type == RewardStudentViewControlleType_checkUnonlineHomework){
        speedVC.formType = RewardBaseViewControllerType_checkUnonlineHomework;
    }
    
    
    ///未完成
    //    NSMutableArray *    unfinishedReardList = nil;
    //    if ([self.allRewardData[@"unfinishedStudents"] isKindOfClass:[NSArray class]]) {
    //        unfinishedReardList = [[NSUserDefaults standardUserDefaults] objectForKey:@"allRewardDataList"];
    //    }
    
    UnfinishedViewController * unfinishedVC = [[UnfinishedViewController alloc]init];
    unfinishedVC.changeStateBlock = ^(BOOL state){
        [self saveButtonSelectedState:state];
        NSString * key = [NSString stringWithFormat:@"%zd",self.currentIndex];
        self.allSelectedBtn.selected = [self getButtonSelectedState:key];
    };
    unfinishedVC.homeworkId = self.homeworkId;
    if (self.type == RewardStudentViewControlleType_checkOnlineHomework){
        unfinishedVC.formType = RewardBaseViewControllerType_checkOnlineHomework;
    }else if (self.type == RewardBaseViewControllerType_lookOnlineHomework){
        
        unfinishedVC.formType = RewardBaseViewControllerType_lookOnlineHomework;
    }else if (self.type == RewardBaseViewControllerType_lookUnonlineHomework){
        
        unfinishedVC.formType = RewardBaseViewControllerType_lookUnonlineHomework;
    }else if(self.type == RewardStudentViewControlleType_checkUnonlineHomework){
        unfinishedVC.formType = RewardBaseViewControllerType_checkUnonlineHomework;
    }
    NSMutableArray * childViewControllers = nil;
    if (self.type == RewardStudentViewControlleType_lookUnonlineHomework|| self.type == RewardBaseViewControllerType_checkUnonlineHomework) {
        childViewControllers = [NSMutableArray arrayWithObjects:wordVC ,nil];
    }else{
        childViewControllers = [NSMutableArray arrayWithObjects:wordVC,beforeVC, progressVC, speedVC,unfinishedVC,nil];
    }
    
    
    [self setupBtnSelectedStateDic:childViewControllers.count];
    
    return  childViewControllers ;
}
//初始化全选按钮 和 加减金币
- (void)setupBtnSelectedStateDic:(NSInteger )count{
    self.btnSelectedStateDic = [[NSMutableDictionary alloc]init];
    self.adjustableCoinNumberDic = [[NSMutableDictionary alloc]init];
    for (int i =0; i<count; i++) {
        [self.btnSelectedStateDic setObject:[NSNumber numberWithBool:YES] forKey:[NSString stringWithFormat:@"%zd",i]];
        [self.adjustableCoinNumberDic setObject:@"0" forKey:[NSString stringWithFormat:@"%zd",i]];
        
    }
}

- (void)changeCurrentIndexUpdate:(NSInteger )toIndex  {
    NSString * key = [NSString stringWithFormat:@"%zd",self.currentIndex];
    
    //隐藏全部发放奖励增加扣除豆显示
    RewardBaseViewController * baseVC= self.pagerTabStripChildViewControllers[self.currentIndex];
    
    if (self.currentIndex == 0) {
        AllRewardViewController * allRewardVC=  (AllRewardViewController *)baseVC;
        [allRewardVC setupAllRewardViewControllerGroupType:[allRewardVC getGroupType]];
        
    }else{
        [baseVC resetData];
        [baseVC changeTableViewFrame];
    }
    [baseVC updateTableView];
    self.adjustRewardView.hidden = [baseVC adjustRewardViewHidden];
    self.allSelectedBtn.selected = [self.btnSelectedStateDic[key] boolValue];
    self.bottomView.hidden = !self.adjustRewardView.hidden;
    
    if ([baseVC.rewardList count] > 0) {
        self.allSelectedBtn.hidden = [baseVC allSelectedBtnHidden];
        
        if (self.currentIndex == 0) {
            self.allSelectedBtn.selected = NO;
            [ self.allSelectedBtn setTitle:@"分组" forState:UIControlStateNormal];
            [ self.allSelectedBtn setTitle:@"分组" forState:UIControlStateSelected];
            [self.allSelectedBtn removeTarget:self   action:@selector(assignAction:) forControlEvents:UIControlEventTouchUpInside];
            [ self.allSelectedBtn addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
            
        }else{
            [ self.allSelectedBtn setTitle:@"全选" forState:UIControlStateNormal];
            [ self.allSelectedBtn setTitle:@"取消" forState:UIControlStateSelected];
            [self.allSelectedBtn removeTarget:self   action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
            [ self.allSelectedBtn addTarget:self action:@selector(assignAction:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        
    }else{
        self.allSelectedBtn.hidden = YES;
    }
    
    
    //未完成
    if (self.currentIndex == 4) {
        [self.adjustRewardView  setupLimitText:[NSString stringWithFormat:@"扣罚学豆"] withImage:@"new_deduct_bean" withType:0];
        [self.adjustRewardView setupMax:0 min: min_dou];
        
    }else{
        [self.adjustRewardView  setupLimitText:[NSString stringWithFormat:@"发放奖励"]  withImage:@"adjust_icon" withType:1];
        [self.adjustRewardView setupMax:max_dou min: 0];
    }
    
    [self.adjustRewardView setupCoinNumber: [self.adjustableCoinNumberDic objectForKey:key]];
}

#pragma mark config
- (UIView *)assistantsQuestionView{
    if (!_assistantsQuestionView) {
        _assistantsQuestionView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 44- self.bottomView.frame.size.height, self.view.frame.size.width, 44)];
        _assistantsQuestionView.backgroundColor = [UIColor clearColor];
        
        UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,  44 )];
        
        
        UIImage * tempImage =  [UIImage imageNamed:@"new_bottom_button_background"]  ;
        // 指定为拉伸模式，伸缩后重新赋值
        tempImage = [tempImage resizableImageWithCapInsets:UIEdgeInsetsMake(10, 15, 15, 10) resizingMode:UIImageResizingModeStretch];
        imageV.image = tempImage;
        imageV.backgroundColor = [UIColor clearColor];
        [_assistantsQuestionView addSubview:imageV];
        
        UIImageView * arrowImgV = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 10-15,  (44-15)/2, 15, 15)];
        arrowImgV.contentMode = UIViewContentModeScaleAspectFit;
        arrowImgV.image = [UIImage imageNamed:@"change_arrow"];
        [_assistantsQuestionView addSubview:arrowImgV];
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"assistants_question_icon"] forState:UIControlStateNormal];
        [button setTitle:@"有学生提出疑问" forState:UIControlStateNormal];
        [button setTitleColor:project_main_blue  forState:UIControlStateNormal];
        button.titleLabel.font = fontSize_13;
        //        [button addTarget:self action:@selector(gotoAssistantsQuestionVC) forControlEvents:UIControlEventTouchUpInside];
        [button setFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        [_assistantsQuestionView addSubview:button];
    }
    return _assistantsQuestionView;
}

- (CGSize)setupTitle:(UILabel *)lable boundingRectWithSize:(CGSize)size
{
    NSDictionary *attribute = @{NSFontAttributeName: fontSize_13};
    
    CGSize retSize = [lable.text boundingRectWithSize:size
                                              options:
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                           attributes:attribute
                                              context:nil].size;
    
    return retSize;
}

- (UIView *)bottomView{
    if (!_bottomView) {
        CGFloat bottomHeight = FITSCALE(60);
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0,self.view.frame.size.height - bottomHeight, IPHONE_WIDTH,bottomHeight)];
        UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,  bottomHeight )];
        UIImage * tempImage =  [UIImage imageNamed:@"new_bottom_button_background"]  ;
        // 指定为拉伸模式，伸缩后重新赋值
        tempImage = [tempImage resizableImageWithCapInsets:UIEdgeInsetsMake(10, 15, 15, 10) resizingMode:UIImageResizingModeStretch];
        imageV.image = tempImage;
        imageV.backgroundColor = [UIColor clearColor];
        [_bottomView addSubview:imageV];
        CGFloat top = FITSCALE(8);
        self.sendRewardBtn.frame = CGRectMake(10, top, self.view.frame.size.width-20,  bottomHeight -top*2);
        NSString * sendRewardBtnTitle = @"";
        if ([self.allRewardDataList count] < MinSendCoinStudentsNumber) {
            sendRewardBtnTitle = @"确认检查";
        }else{
            sendRewardBtnTitle = @"发放奖励";
        }
         [self.sendRewardBtn setTitle:sendRewardBtnTitle forState:UIControlStateNormal];
         self.sendRewardBtn.backgroundColor = project_main_blue;
         self.sendRewardBtn.layer.masksToBounds  = YES;
         self.sendRewardBtn.layer.borderColor = [UIColor clearColor].CGColor;
         self.sendRewardBtn.layer.borderWidth = 1.0;
         self.sendRewardBtn.layer.cornerRadius =( bottomHeight - top*2) /2;
        [_bottomView addSubview:self.sendRewardBtn];

    }
    return _bottomView;
}

- (UIButton *)sendRewardBtn{
    if (!_sendRewardBtn) {
        _sendRewardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
         [_sendRewardBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
         _sendRewardBtn.titleLabel.font = fontSize_14;
        [_sendRewardBtn addTarget:self action:@selector(sendRewardButtonAction:) forControlEvents:UIControlEventTouchUpInside];
      
       
    }
    return _sendRewardBtn;
}
//- (UIView *)bottomView {
//    if (!_bottomView) {
//
//        CGFloat bottomHeight = FITSCALE(60);
//        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0,self.view.frame.size.height - bottomHeight, IPHONE_WIDTH,bottomHeight)];
//        UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,  bottomHeight )];
//
//
//        UIImage * tempImage =  [UIImage imageNamed:@"new_bottom_button_background"]  ;
//        // 指定为拉伸模式，伸缩后重新赋值
//        tempImage = [tempImage resizableImageWithCapInsets:UIEdgeInsetsMake(10, 15, 15, 10) resizingMode:UIImageResizingModeStretch];
//        imageV.image = tempImage;
//        imageV.backgroundColor = [UIColor clearColor];
//        [_bottomView addSubview:imageV];
//
//
//        CGFloat top = FITSCALE(8);
//
//        UIView * backgroundView = [[UIView alloc]initWithFrame:CGRectMake(10, top, self.view.frame.size.width-20,  bottomHeight -top*2)];
//        backgroundView.backgroundColor = project_main_blue;
//        backgroundView.layer.masksToBounds  = YES;
//        backgroundView.layer.borderColor = [UIColor clearColor].CGColor;
//        backgroundView.layer.borderWidth = 1.0;
//        backgroundView.layer.cornerRadius =( bottomHeight - top*2) /2;
//        [_bottomView addSubview:backgroundView];
//
//
//        UIButton * checkFeedbackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [checkFeedbackBtn setTitle:@"查看反馈" forState:UIControlStateNormal];
//
//        if (self.backfeedType == HomeworkBackfeedType_nono) {
//            [checkFeedbackBtn setImage:[UIImage imageNamed:@"homework_nono_look"] forState:UIControlStateNormal];
//            [checkFeedbackBtn setImage:[UIImage imageNamed:@"homework_nono_look"] forState:UIControlStateSelected];
//            [checkFeedbackBtn setImage:[UIImage imageNamed:@"homework_nono_look"] forState:UIControlStateHighlighted];
//            [checkFeedbackBtn setTitleColor:UIColorFromRGB(0xaccaff) forState:UIControlStateNormal];
//
//
//            //中划线
//            NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle],NSStrokeColorAttributeName:UIColorFromRGB(0xaccaff), NSBaselineOffsetAttributeName:@(0)};
//
//            NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString: @"查看反馈" attributes:attribtDic];
//
//
//            // 赋值
//            checkFeedbackBtn.titleLabel.attributedText = attribtStr;
//
//        }else{
//            [checkFeedbackBtn setImage:[UIImage imageNamed:@"student_homework_look"] forState:UIControlStateNormal];
//            [checkFeedbackBtn setImage:[UIImage imageNamed:@"student_homework_look"] forState:UIControlStateSelected];
//            [checkFeedbackBtn setImage:[UIImage imageNamed:@"student_homework_look"] forState:UIControlStateHighlighted];
//            [checkFeedbackBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            [checkFeedbackBtn addTarget:self action:@selector(checkFeedbackAction:) forControlEvents:UIControlEventTouchUpInside];
//        }
//
//
//        [checkFeedbackBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
//
//
//        checkFeedbackBtn.titleLabel.font = fontSize_14;
//
//        [backgroundView addSubview:checkFeedbackBtn];
//
//
//        self.sendRewardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//
//        NSString * sendRewardBtnTitle = @"";
//        if ([self.allRewardDataList count] < MinSendCoinStudentsNumber) {
//            sendRewardBtnTitle = @"确认检查";
//        }else{
//            sendRewardBtnTitle = @"发放奖励";
//        }
//        [self.sendRewardBtn setTitle:sendRewardBtnTitle forState:UIControlStateNormal];
//        [self.sendRewardBtn setImage:[UIImage imageNamed:@"student_homework_reward"] forState:UIControlStateNormal];
//        [self.sendRewardBtn setImage:[UIImage imageNamed:@"student_homework_reward"] forState:UIControlStateSelected];
//        [self.sendRewardBtn setImage:[UIImage imageNamed:@"student_homework_reward"] forState:UIControlStateHighlighted];
//        [self.sendRewardBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        self.sendRewardBtn.titleLabel.font = fontSize_14;
//
//
//        [self.sendRewardBtn addTarget:self action:@selector(sendRewardButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//        [self.sendRewardBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
//        [backgroundView addSubview:self.sendRewardBtn];
//
//
//        UIImageView  * imgV = [[UIImageView alloc]initWithFrame:CGRectMake( self.view.frame.size.width/2 - 0.5,  10, 1,  backgroundView.frame.size.height -20)];
//
//        imgV.backgroundColor = UIColorFromRGB(0xB8F2FA);
//        [backgroundView addSubview:imgV];
//
//        if (self.type == RewardStudentViewControlleType_lookUnonlineHomework ||self.type == RewardStudentViewControlleType_lookOnlineHomework) {
//            imgV.hidden = YES;
//            self.sendRewardBtn.hidden =YES;
//            [checkFeedbackBtn setFrame:CGRectMake(0, 0, self.view.frame.size.width, backgroundView.frame.size.height)];
//        }else if (self.type == RewardStudentViewControlleType_checkOnlineHomework){
//            imgV.hidden = NO;
//            self.sendRewardBtn.hidden = NO;
//            [checkFeedbackBtn setFrame:CGRectMake(0, 0, self.view.frame.size.width/2, backgroundView.frame.size.height)];
//            [self.sendRewardBtn setFrame:CGRectMake( self.view.frame.size.width/2,0, self.view.frame.size.width/2,  backgroundView.frame.size.height)];
//
//        }else if (self.type == RewardStudentViewControlleType_checkUnonlineHomework){
//
//            [self.sendRewardBtn  setTitle:@"确认检查" forState:UIControlStateNormal];
//            imgV.hidden = NO;
//            self.sendRewardBtn.hidden = NO;
//            [checkFeedbackBtn setFrame:CGRectMake(0, 0, self.view.frame.size.width/2, backgroundView.frame.size.height)];
//            [self.sendRewardBtn setFrame:CGRectMake( self.view.frame.size.width/2,0, self.view.frame.size.width/2,  backgroundView.frame.size.height)];
//        }
//
//
//
//    }
//    return _bottomView;
//
//}

- (UIView *)adjustRewardView{
    if (!_adjustRewardView) {
         CGFloat bottomHeight = FITSCALE(60);
        _adjustRewardView = [[AdjustRewardView alloc]initWithFrame:CGRectMake(0,self.view.frame.size.height - bottomHeight, IPHONE_WIDTH,bottomHeight)];
        [_adjustRewardView setBackgroundColor:[UIColor whiteColor]];
    }
    WEAKSELF
    _adjustRewardView.coinBlock = ^(NSString * coin ,NSString * adjustCoinNubmer){
        STRONGSELF
        strongSelf.coinNumber =  coin;
        //更新数据表的数据
        RewardBaseViewController * baseVC = strongSelf.pagerTabStripChildViewControllers[strongSelf.currentIndex];
        [baseVC updateTVCoin:strongSelf.coinNumber withAdjustCoinNubmer:adjustCoinNubmer];
        
        //修改调整框里的豆
        NSString * key = [NSString stringWithFormat:@"%zd",strongSelf.currentIndex];
        [strongSelf.adjustableCoinNumberDic setObject:adjustCoinNubmer forKey:key];
    };
    _adjustRewardView.sendCoinBlock = ^{
        [self sendRewardButtonAction:nil];
    };
    return _adjustRewardView;
}


- (void)sendRewardButtonAction:(id)sender{
    
    
    NSString * title = @"温馨提示";
    NSString * content = @"";
    RewardBaseViewController * baseTableVC = self.pagerTabStripChildViewControllers[0];
    if ( baseTableVC.listData && baseTableVC.listData.count >0) {
        if (self.isAllComplete) {
            if (self.type == RewardStudentViewControlleType_checkUnonlineHomework) {
                content = @"是否确认检查？";
                
            }else{
                if (self.isSendCoin) {
                    content = [NSString stringWithFormat:@"是否发放 %@ 奖励?",self.titleStr];
                }else{
                    content = @"是否确认检查？";
                }
                
            }
        }else{
            
            if (self.type == RewardStudentViewControlleType_checkUnonlineHomework) {
                content = @"本次作业还有未完成的学生,是否确认检查?";
            }else{
                if (self.isSendCoin) {
                    content = @"本次作业还有未完成的学生,是否发放奖励?";
                }else{
                    content = @"本次作业还有未完成的学生,是否确认检查?";
                }
            }
        }
        
    }else{
        content = @"是否关闭本次作业";
    }
    
    MMPopupItemHandler itemHandler = ^(NSInteger index){
        [self requestRemarkHomework:[[NSUserDefaults standardUserDefaults] objectForKey:@"allRewardDataList"]];
        
    };
    NSArray * items =
    @[MMItemMake(@"取消", MMItemTypeHighlight, nil),
      MMItemMake(@"确定", MMItemTypeHighlight, itemHandler)];;
    
    [self showNormalAlertTitle:title content:content  items:items block:nil];
    
    
    NSLog(@"%zd==",self.currentIndex);
    
}

- (void)requestRemarkHomework:(NSArray *)remarkArray{
    
    
    NSMutableArray *studentList = [[NSMutableArray alloc]init];
    for (int i = 0; i < [remarkArray count] ; i++  ) {
        
        NSDictionary * studentiItem = remarkArray[i];
        NSString  * remarkStr =  [NSString stringWithFormat:@"{\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\"}",@"studentId",studentiItem[@"studentId"],@"remark",@"回评",@"coin",studentiItem[@"coin"]];
        [studentList addObject:remarkStr];
        
    }
    
    NSString * remarkList = [NSString stringWithFormat:@"[%@]",[studentList componentsJoinedByString:@","] ];
    
    NSDictionary * parameterDic = @{@"homeworkId":self.homeworkId,
                                    @"remarkList":remarkList};
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_TeacherRemarkHomework] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_TeacherRemarkHomework];
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

- (void)checkFeedbackAction:(UIButton *)button{
    
//    StudentsFeedbackViewController * feedbackVC = [[StudentsFeedbackViewController alloc]initWithHomeworkId:self.homeworkId];
//    [self pushViewController:feedbackVC];
}

#pragma mark ---

- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu{
    
    switch (index) {
        case 0:
            [self normaAction];
            break;
        case 1:
            [self resultsAction];
            
            break;
            
        case 2:
            
            [self completeAction];
            break;
        case 3:
            
            break;
            
        default:
            break;
    }
    [ybPopupMenu dismiss];
}

#pragma mark ---
- (void)requestHomeworkStudentScore{
    
    NSDictionary * parameterDic = @{@"homeworkId":self.homeworkId};
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_ListHomeworkStudentScore] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_ListHomeworkStudentScore];
    
}
- (void)netRequest:(NetRequest *)request failedWithError:(NSError *)error{
    
    [super netRequest:request failedWithError:error]; 
}
- (void)setNetworkRequestStatusBlocks{
    
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_ListHomeworkStudentScore) {
            strongSelf.allRewardData = successInfoObj;
            [strongSelf updateALLRewardData];
            
        }else if (request.tag == NetRequestType_TeacherRemarkHomework) {
            if (successInfoObj[@"coin"]) {
                NSString * content = [NSString stringWithFormat:@"奖励发放成功"];
                RewardBaseViewController * baseTableVC = strongSelf.pagerTabStripChildViewControllers[0];
                if ( baseTableVC.listData && baseTableVC.listData.count >0) {
                    if (self.type == RewardStudentViewControlleType_checkUnonlineHomework) {
                        content = @"作业检查成功";
                    }else{
                        if (strongSelf.isSendCoin) {
                            content = @"奖励发放成功";
                        }else{
                            content = @"作业检查成功";
                        }
                        
                    }
                }else{
                    content = @"作业关闭成功";
                }
                if ([successInfoObj[@"coin"] integerValue] >0) {
                    [strongSelf showCoinAnimation:successInfoObj[@"coin"]];
                }else{
                    [strongSelf showAlert:TNOperationState_OK content:content block:^(NSInteger index) {
                        [strongSelf  backCheckListVC];
                    }];
                }
            }
            
        }
    }];
}

- (void)updateALLRewardData{
    
    [self resetDate];
    RewardBaseViewController * baseTableVC = self.pagerTabStripChildViewControllers[0];
    
    BOOL onlyKhlxOnline = NO;
    if(self.allRewardData[@"onlyKhlxOnline"]){
        if ([self.allRewardData[@"onlyKhlxOnline"] boolValue]) {
            onlyKhlxOnline = [self.allRewardData[@"onlyKhlxOnline"] boolValue];
        }
    }
    baseTableVC.onlyKhlxOnline = onlyKhlxOnline;
    [baseTableVC resetData];
    [baseTableVC updateTableView];
    baseTableVC.isShowResultsGroup = self.isShowResultsGroup;
    if (self.type == RewardBaseViewControllerType_checkOnlineHomework) {
        baseTableVC.isCheck = NO;
    }else if (self.type == RewardBaseViewControllerType_lookOnlineHomework|| self.type == RewardBaseViewControllerType_lookUnonlineHomework) {
        baseTableVC.isCheck = YES;
    }else if (self.type == RewardBaseViewControllerType_checkUnonlineHomework){
        baseTableVC.isCheck = NO;
    }
    NSString * sendRewardBtnTitle = @"";
    if ([self.allRewardDataList count] < MinSendCoinStudentsNumber) {
        self.isSendCoin = NO;
    }else{
        self.isSendCoin = YES;
    }
    if ( baseTableVC.listData && baseTableVC.listData.count >0) {
        if (self.type == RewardBaseViewControllerType_checkUnonlineHomework) {
            sendRewardBtnTitle = @"确认检查";
        }else{
            if (self.isSendCoin) {
                sendRewardBtnTitle = @"发放奖励";
            }else{
                sendRewardBtnTitle = @"确认检查";
            }
            
        }
    }else{
        sendRewardBtnTitle = @"关闭作业";
    }
    [self.sendRewardBtn setTitle:sendRewardBtnTitle forState:UIControlStateNormal];
    self.allSelectedBtn.hidden = [baseTableVC allSelectedBtnHidden];
    
    if ([self.allRewardData objectForKey:@"hasJfHomework"] && ([[self.allRewardData objectForKey:@"hasJfHomework"] boolValue] ||[[self.allRewardData objectForKey:@"hasJfHomework"] integerValue] == 1)) {
        
        self.assistantsQuestionView.hidden = NO;
    }else{
        self.assistantsQuestionView.hidden = YES;
    }
}
- (void)backCheckListVC{
    [[[UIApplication sharedApplication].keyWindow viewWithTag: 989898] removeFromSuperview];
    [self.coinAnimationBgView removeFromSuperview];
    
    [[NSNotificationCenter defaultCenter]  postNotificationName:@"UPDATA_HOMEWORK_LIST_DATA" object:nil];
    
//    if (self.checkSuccessBlock) {
//        self.checkSuccessBlock();
//    }
  
    
    for (UIViewController * vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[BaseCheckHomeworkListViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
        }
        if ([vc isKindOfClass:[CheckHomeworkNewListViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
    //发送更新金币 通知
    [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_CHECKLIST_TEARCHER_COIN object:nil];
}


#pragma mark group
- (void) normaAction{
    
    AllRewardViewController * rewardVC = self.pagerTabStripChildViewControllers[self.currentIndex];
    [rewardVC setupAllRewardViewControllerGroupType:  AllRewardStudentGroupType_normal];
    [rewardVC updateTableView];
    
}
- (void) resultsAction{
    
    AllRewardViewController * rewardVC = self.pagerTabStripChildViewControllers[self.currentIndex];
    [rewardVC setupAllRewardViewControllerGroupType:  AllRewardStudentGroupType_Results];
    
    [rewardVC updateTableView];
    
}
- (void) feedbackAction{
    
    AllRewardViewController * rewardVC = self.pagerTabStripChildViewControllers[self.currentIndex];
    [rewardVC setupAllRewardViewControllerGroupType:  AllRewardStudentGroupType_Feedback];
    [rewardVC updateTableView];
}
- (void) completeAction{
    
    
    AllRewardViewController * rewardVC = self.pagerTabStripChildViewControllers[self.currentIndex];
    [rewardVC setupAllRewardViewControllerGroupType:  AllRewardStudentGroupType_Complete];
    [rewardVC updateTableView];
    
}
- (void)gotoOnlineHomeworkAssistantsQuestionVC:(NSString *)studentId withStudentName:(NSString *)studentName{
    BOOL onlyKhlxOnline = NO;
    if(self.allRewardData[@"onlyKhlxOnline"]){
        if ([self.allRewardData[@"onlyKhlxOnline"] boolValue]) {
            onlyKhlxOnline = [self.allRewardData[@"onlyKhlxOnline"] boolValue];
        }
    }
    BOOL isCheck = NO;
    if (self.type == RewardBaseViewControllerType_checkOnlineHomework) {
        isCheck = NO;
    }else if (self.type == RewardBaseViewControllerType_lookOnlineHomework|| self.type == RewardBaseViewControllerType_lookUnonlineHomework) {
        isCheck = YES;
    }else if (self.type == RewardBaseViewControllerType_checkUnonlineHomework){
        isCheck = NO;
    }
    JFHomeNoItemViewController * vc = [[JFHomeNoItemViewController alloc]initWithBookId:@"" withHomeworkId:self.homeworkId withStudentId:studentId withIsOnlineHomework:YES withOnlyKhlxOnline: onlyKhlxOnline withStudentName: studentName withHomeworkState:isCheck];
    [self pushViewController:vc];
}
- (void)gotoUnOnlineAssistantsQuestionVC:(NSString *)studentId {
    
    JFHomeNoItemViewController * vc = [[JFHomeNoItemViewController alloc]initWithBookId:@"" withHomeworkId:self.homeworkId withStudentId:studentId];
    [self pushViewController:vc];
}
- (UIColor *)getTabTitleColorNor{
    
    return UIColorFromRGB(0x9f9f9f);
}
- (UIColor *)getTabTitleColorSelected{
    
    return UIColorFromRGB(0x4C6B9A);
}
@end

