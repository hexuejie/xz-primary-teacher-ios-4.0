//
//  CheckHomeworkDetailVC.m
//  TeacherPro
//
//  Created by DCQ on 2018/7/6.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "CheckHomeworkDetailVC.h"
#import "CheckHomeworkTypeVC.h"
#import "CheckHomeworkDetailHeaderView.h"
#import "UIViewController+HBD.h"
#import "TeacherPro-Swift.h"
#import "CHWListModel.h"
#import "StudentsFeedbackViewController.h" 
#import "RewardStudentViewController.h"
#import "StudentFBViewController.h"
#import "NewRewardStudentViewController.h"

@interface CheckHomeworkDetailVC ()<LTAdvancedScrollViewDelegate>{
    CGFloat _gradientProgress;
}
@property(copy, nonatomic) NSArray <UIViewController *> *viewControllers;
@property(copy, nonatomic) NSArray <NSString *> *titles;
@property(strong, nonatomic) LTLayout *layout;
@property(strong, nonatomic) LTAdvancedManager *managerView;
@property(copy, nonatomic) NSString  * homeworkId;
@property(strong, nonatomic) CHWListModel * listModel;
@property(assign, nonatomic) CheckHomeworkDetailVCType  style;
@property(strong, nonatomic) NSNumber *onlineHomework;
@end

@implementation CheckHomeworkDetailVC
- (instancetype)initHomeworkID:(NSString *)homeworkId  withType:(CheckHomeworkDetailVCType )type withOnlineHomework:(NSNumber *)onlineHomework{
    if (self == [super init]) {
        self.homeworkId = homeworkId;
        self.style = type;
        self.onlineHomework = onlineHomework;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationItemTitle:@"作业检查"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
   
    [self requestListHomeworkStudents];
    
}
- (void)requestListHomeworkStudents{
    NSDictionary * parameterDic = @{@"homeworkId":self.homeworkId};
//    [self sendRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_ListHomeworkStudents] parameterDic:parameterDic requestHeaders:@{@"auth-token":@"6448f83e24c04a4eac12fdf68c25488a"}  requestMethodType:RequestMethodType_POST requestTag:NetRequestType_ListHomeworkStudents];
    [self  sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_ListHomeworkStudents] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_ListHomeworkStudents];
}

- (void)setNetworkRequestStatusBlocks{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_ListHomeworkStudents) {
            NSMutableDictionary *infoDic  = [NSMutableDictionary dictionaryWithDictionary:successInfoObj];
            NSMutableArray * tempArray = [NSMutableArray array];
            if ([successInfoObj[@"homeworkItems"] count] == 1) {
                 [tempArray addObjectsFromArray:successInfoObj[@"homeworkItems"]];
            }else{
                for (int i = 0; i< [successInfoObj[@"homeworkItems"] count]; i++) {
                    NSDictionary * dic = successInfoObj[@"homeworkItems"][i];
                    if ([dic objectForKey:@"practiceType"]){
                        [tempArray addObject:dic];
                    }
                    //                if (![dic[@"title"] isEqualToString:@"作业总览"]) {
                    //                     [tempArray addObject:dic];
                    //                }
                };
            }
        
            infoDic[@"homeworkItems"] = tempArray;
            
            strongSelf.listModel = [[CHWListModel alloc]initWithDictionary:@{@"info":infoDic} error:nil];
            [strongSelf setupSubViews];
            strongSelf.hbd_barAlpha = 0.0;
            strongSelf.hbd_tintColor = [UIColor whiteColor];
            [strongSelf hbd_setNeedsUpdateNavigationBar];
        }else   if (request.tag == NetRequestType_TeacherRemarkHomework) {
            [strongSelf showAlert:TNOperationState_OK content:@"作业检查成功" block:^(NSInteger index) {
                [[NSNotificationCenter defaultCenter]  postNotificationName:@"UPDATA_HOMEWORK_LIST_DATA" object:nil];
                [strongSelf  backViewController];
            }];
        }
        
    }];
}
-(void)setupSubViews {
    
//    [self.view addSubview:self.managerView];

    if (self.style == CheckHomeworkDetailVCType_check){
        
        [self setupBottomView];
    }
    [self.managerView setAdvancedDidSelectIndexHandle:^(NSInteger index) {
        NSLog(@"%ld", index);
    }];
}

- (void)setupBottomView{
    CGFloat bottomHeight = FITSCALE(50);
    
//    CGFloat bottomY = CGRectGetHeight(self.view.frame)- bottomHeight- NavigationBar_Height;
//
//    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0,  bottomY, self.view.frame.size.width, bottomHeight)];
 
    
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0,  kScreenHeight-bottomHeight, kScreenWidth, bottomHeight)];
    bottomView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,  self.view.frame.size.width, 0.5)];
    lineView.backgroundColor = project_line_gray;
    [bottomView addSubview:lineView];
    UIButton * sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setTitle:@"检 查 作 业" forState:UIControlStateNormal];
    sureBtn.frame = CGRectMake(10, 5, bottomView.frame.size.width - 10*2, bottomHeight-5*2);
    sureBtn.layer.masksToBounds = YES;
    sureBtn.layer.cornerRadius = sureBtn.frame.size.height/2;
    sureBtn.backgroundColor = project_main_blue;
    [sureBtn addTarget:self action:@selector(gotoCheckHomework) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:sureBtn];
    [self.view addSubview:bottomView];
    [self.view bringSubviewToFront:bottomView];
//    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.view.mas_left);
//        make.right.mas_equalTo(self.view.mas_right);
//        make.top.mas_equalTo(self.managerView.mas_bottomMargin);
//        make.height.mas_equalTo(@(bottomHeight));
//    }];
    
//    NSLog(@"%@====%@==",NSStringFromCGRect(self.managerView.frame),NSStringFromCGRect(bottomView.frame));
    
    
}
-(LTAdvancedManager *)managerView {
    if (!_managerView) {
         CGFloat bottomHeight = 0;
        if (self.style == CheckHomeworkDetailVCType_check){
            bottomHeight = FITSCALE(50);
        }
        CGRect managerViewFrame= CGRectMake(0, 0, self.view.frame.size.width, IPHONE_HEIGHT - bottomHeight  );
        
     
        _managerView = [[LTAdvancedManager alloc] initWithFrame:managerViewFrame viewControllers:self.viewControllers titles:self.titles currentViewController:self layout:self.layout headerViewHandle:^UIView * _Nonnull{
//            return [self setupHeaderView];
            return self.view;
        }];
       
        _managerView.hoverY = NavigationBar_Height;
        /* 设置代理 监听滚动 */
        _managerView.delegate = self;
    }
    return _managerView;
}

-(void)glt_scrollViewOffsetY:(CGFloat)offsetY {
//    NSLog(@"=---> %lf", offsetY);
    if (offsetY) {
        CGFloat progress = offsetY ;
        CGFloat headerHeight = [self getHeaderHeight];
        CGFloat gradientProgress = MIN(1, MAX(0, progress  / headerHeight));
        gradientProgress = gradientProgress * gradientProgress * gradientProgress * gradientProgress;
        if (gradientProgress != _gradientProgress) {
            _gradientProgress = gradientProgress;
             self.hbd_barAlpha = _gradientProgress;
            [self hbd_setNeedsUpdateNavigationBar];
        }
    }
  
}



-(LTLayout *)layout {
    if (!_layout) {
        _layout = [[LTLayout alloc] init];
        _layout.isAverage = NO;
        _layout.sliderWidth = 60;
        /* 更多属性设置请参考 LTLayout 中 public 属性说明 */
        _layout.titleColor = UIColorFromRGB(0x6b6b6b);
        _layout.titleSelectColor = project_main_blue;
        _layout.titleViewBgColor = [UIColor whiteColor];
        _layout.bottomLineColor = project_main_blue;
        _layout.titleFont = fontSize_13;
        _layout.isNeedScale = false;
   
    }
    return _layout;
}


- (NSArray <NSString *> *)titles {
    if (!_titles) {
        NSMutableArray * tempArray = [NSMutableArray array];
        for (NSDictionary * tempDic in self.listModel.info.homeworkItems) {
            
           NSString * titleStr =  tempDic[@"title"];
              [tempArray addObject:titleStr];
            
        }
        _titles = tempArray;
    }
    return _titles;
}


-(NSArray <UIViewController *> *)viewControllers {
    if (!_viewControllers) {
        _viewControllers = [self setupViewControllers];
    }
    return _viewControllers;
}


-(NSArray <UIViewController *> *)setupViewControllers {
    NSMutableArray <UIViewController *> *testVCS = [NSMutableArray arrayWithCapacity:0];
    
    [self.titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger index, BOOL * _Nonnull stop) {
        NSDictionary * tempDic = self.listModel.info.homeworkItems[index];
        
            NSString * practiceType = @"";
            NSArray * studentList = nil;
            if ([tempDic objectForKey:@"practiceType"]) {
                //布置没有书本的作业
                if ([[tempDic objectForKey:@"practiceType"] length] == 1) {
                     studentList =  tempDic[@"students"];
                }else{
                     practiceType = [tempDic objectForKey:@"practiceType"];
                }
               
            }else{
                //
                studentList =  tempDic[@"students"];
            }
            BOOL isCheck = NO;
            if (self.style == CheckHomeworkDetailVCType_look) {
                isCheck = YES;
            }else {
                isCheck = NO;
            }
        CheckHomeworkTypeVC *checkHWVC = [[CheckHomeworkTypeVC alloc] initWithTitle:obj withHomeworkId: self.homeworkId  withPracticeType:practiceType withHWStudentList:studentList withCheck:isCheck withOnlineHomework:self.onlineHomework];
            [testVCS addObject:checkHWVC];
      
       
    }];
    return testVCS.copy;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
   
     
}
- (UIView *)setupHeaderView{
    
    CheckHomeworkDetailHeaderView * header = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([CheckHomeworkDetailHeaderView class]) owner:nil options:nil].firstObject;
    BOOL checkState = NO;
    if (self.style == CheckHomeworkDetailVCType_look) {
        checkState = YES;
    }else if (self.style == CheckHomeworkDetailVCType_check){
        checkState = NO;
    }
    [header setupHeaderData:self.listModel.info withCheckState:checkState];
    header.frame = CGRectMake(0, 0, self.view.frame.size.width,[self getHeaderHeight]);
    header.feedbackBlock = ^{
        
        [self gotoFeedbackVC];
    };
   return header;
}
- (CGFloat) getHeaderHeight{
    return   NavigationBar_Height + 190 + 30;
}
 
- (BOOL )getShowBackItem{
    
    return YES;
}
- (BOOL)getNavBarBgHidden{
    
    return NO;
}

- (UIRectEdge)getViewRect{
    
    return UIRectEdgeAll;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)gotoCheckHomework{
    
    if ([self.listModel.info.sendCoin boolValue]) {
        NSString * title = [NSString stringWithFormat:@"%@ %@",self.listModel.info.gradeName,self.listModel.info.clazzName];
        NewRewardStudentViewController * rewardVC = [[NewRewardStudentViewController alloc]init];
        rewardVC.homeworkId = self.homeworkId;
        [self pushViewController:rewardVC];
    }else{

        MMPopupItemHandler itemHandler = ^(NSInteger index){
            [self requestTeacherRemarkHomework];

        };
        NSArray * items =
        @[MMItemMake(@"取消", MMItemTypeHighlight, nil),
          MMItemMake(@"确定", MMItemTypeHighlight, itemHandler)];;
        NSString * title = @"温馨提示";
        NSString * content = @"是否确认检查？";
        [self showNormalAlertTitle:title content:content  items:items block:nil];

    }
//
}

- (void)requestTeacherRemarkHomework{
    
    NSDictionary * parameterDic = @{@"homeworkId":self.homeworkId};
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_TeacherRemarkHomework] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_TeacherRemarkHomework];
}
- (void)gotoFeedbackVC{
   
    
    StudentFBViewController * feedbackVC = [[StudentFBViewController alloc]initWithHomeworkId:self.homeworkId];
     [self pushViewController:feedbackVC];

}

@end
