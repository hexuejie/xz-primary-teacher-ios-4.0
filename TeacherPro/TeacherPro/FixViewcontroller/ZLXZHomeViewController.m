

//
//  ZLXZHomeViewController.m
//  TeacherPro
//
//  Created by DCQ on 2018/5/28.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//
#import "PhonicsHomeworkViewController.h"
#import "RespositoryPageViewController.h"
#import "ZLXZHomeViewController.h"
#import "HomeAdvertisingCell.h"
#import "HomeworkSectionView.h"
#import "HomeworkSpecialCell.h"
#import "HomeworkMyBooksCell.h"
#import "NewsCell.h"
#import "TNTabbarController.h"
#import "CheckHomeworkNewListViewController.h"
#import "HomeworkReviewViewController.h"
#import "ReleaseHomeworkViewController.h"
#import "UIViewController+HBD.h"
#import "InformationDetailViewController.h"
#import "RecommendedViewController.h"
#import "JPUSHService.h"
#import "HWGuidePageManager.h"
#import "AddressListViewController.h"
#import "SessionHelper.h"
#import "SessionModel.h"
#import "HomeListModel.h"
#import "RepositoryViewController.h"
#import "AssistantsHomeworkViewController.h"
#import "BookHomeworkViewController.h"
#import "PublicDocuments.h"
#import "BookcaseViewController.h"
#import "HomeBannerHeaderView.h"
#import "HomeworkSuspensionView.h"
#import "CheckNewListPageViewController.h"

NSString *const HomeAdvertisingCellIdentifier = @"HomeAdvertisingCellIdentifier";
NSString *const HomeworkSectionViewIdentifier = @"HomeworkSectionViewIdentifier";
NSString *const HomeworkSpecialCellIdentifier = @"HomeworkSpecialCellIdentifier";
NSString *const HomeworkMyBooksCellIdentifier = @"HomeworkMyBooksCellIdentifier";
NSString *const HomeworkSuspensionViewIdentifier = @"HomeworkSuspensionViewIdentifier";
NSString *const NewsCellIdentifier = @"NewsCellIdentifier";

static const NSInteger   kSegmentViewTag = 8979697;
static const NSInteger   KReviewBtnTag = 656565;
static const NSInteger   kShareTag = 343434;
static const  CGFloat  advImgVScale =  1.9;

@interface ZLXZHomeViewController (){
    CGFloat _gradientProgress;
}
@property (nonatomic, assign) ZLXZHomeViewControllerType type;
@property (nonatomic, assign) __block BOOL firstOpen;
@property (nonatomic, strong) HomeListModel * homeModel;
@property (nonatomic, strong) HomeListModel * homeNewsModel;
@property (nonatomic, assign)   BOOL reviewBtnHidden;
@property (nonatomic, assign)   CGFloat preScrollY;
@property (nonatomic, assign)   BOOL isDragging;
@property (nonatomic, assign)  BOOL isUpdateBookself;
@property (nonatomic, assign) BOOL  isNewsUpdate;

@property (nonatomic, strong)HomeworkSuspensionView * suspensionView;

@property(nonatomic, assign) BOOL isScrollTop;

@end

@implementation ZLXZHomeViewController
- (instancetype)initWithType:(ZLXZHomeViewControllerType)type{
    if (self == [super init]) {
        self.type = type;
        
    }
    return self;
}
- (HomeworkSuspensionView *)suspensionView{
    if (!_suspensionView) {
        _suspensionView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([HomeworkSuspensionView class]) owner:nil options:nil].firstObject;
        _suspensionView.backgroundColor = [UIColor clearColor];
        _suspensionView.touckBlock = ^(HomeworkSuspensionTouchType type) {
            if (type == HomeworkSuspensionTouchType_check) {
                 [self gotoCheckJob];
            }else if (type == HomeworkSuspensionTouchType_release){
                      [self  gotoDecorateHomework];
              
            }else if (type == HomeworkSuspensionTouchType_huigu){
                [self  gotoReview];
                
            }
            
            
        };
    }
    return _suspensionView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupForwarding];
    self.preScrollY = 0.0;

    [self validationUserBindingSchool];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateBooks) name:@"UPDATE_HOME_BOOKCASE_LIST" object:nil];
    
    UIView * bgView = [[UIView  alloc]initWithFrame:CGRectMake(0, - IPHONE_HEIGHT, self.view.frame.size.width, IPHONE_HEIGHT)];
    bgView.backgroundColor = HexRGB(0x52b7ff);
    [self.tableView  addSubview:bgView];
    [self.tableView sendSubviewToBack:bgView];
    
}

- (void)addHeader:(UITableView *)tableView{
    WEAKSELF
    MJRefreshNormalHeader * header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf drogDownRefresh];

    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
 
//    header.backgroundColor = project_main_blue;
    if (iPhoneX) {
        header.frame = CGRectMake(0, 0, self.view.frame.size.width, 80);
    }

    // 设置文字
    [header setTitle:@"下拉可以刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"松开立即刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"正在刷新数据中.." forState:MJRefreshStateRefreshing];

    header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    // 设置字体
    header.stateLabel.font = fontSize_14;
    header.lastUpdatedTimeLabel.font = fontSize_14;

    // 设置颜色
    header.stateLabel.textColor = [UIColor whiteColor];
    header.lastUpdatedTimeLabel.textColor = [UIColor whiteColor];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden =YES;
    self.tableView.mj_header = header;

}

- (void)updateBooks{
    //    [self  getQueryTeacherIndexPreview];
    self.isUpdateBookself = YES;
}

- (void)getQueryTeacherIndexPreview{
    
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_QueryTeacherIndexPreview] parameterDic:nil requestMethodType:RequestMethodType_POST requestTag:NetRequestType_QueryTeacherIndexPreview];
}


- (void)requestNewsList{
    NSDictionary * parameterDic = @{@"pageIndex":@(self.currentPageNo),@"pageSize":@(self.pageCount)};
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_QueryListNews] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_QueryListNews];
}
- (void)validationUserBindingSchool{
    if (self.type == ZLXZHomeViewControllerType_Info) {
        [self showBindingAlert];
        
    }else if(self.type == ZLXZHomeViewControllerType_Login){
        
        SessionModel *sesstion = [[SessionHelper sharedInstance] getAppSession];
        
        if (!sesstion.schoolId) {
            
            [self showBindingAlert];
            
        }
        
    }
    
    [self registerJPush];
    // Do any additional setup after loading the view from its nib.
    
    [self registerClient];
    
}

- (void)showBindingAlert{
    
    NSString * title = @"温馨提示";
    NSString * content = @"您需要绑定学校才可使用其它功能！";
    
    MMPopupItemHandler sureHandler = ^(NSInteger index){
        [self gotoAddressVC];
    };
    
    MMPopupItemHandler cancelHandler = ^(NSInteger index){
        if (self.type == ZLXZHomeViewControllerType_Info) {
            //            if (self.firstOpen) {
            //                [self showGuideView];
            //
            //            }
        }
        
    };
    NSArray * items = @[MMItemMake(@"暂不绑定", MMItemTypeHighlight, cancelHandler),
                        MMItemMake(@"去绑定", MMItemTypeHighlight, sureHandler)];
    [self showNormalAlertTitle:title content:content  items:items block:sureHandler];
    
}


- (void)showCreateClassAlert{
    
    NSString * title = @"温馨提示";
    NSString * content = @"您需要创建班级才可使用其它功能！";
    
    MMPopupItemHandler sureHandler = ^(NSInteger index){
        self.tnTabbarController.selectedIndex = 1;
    };
    
  
    NSArray * items = @[ MMItemMake(@"去创建", MMItemTypeHighlight, sureHandler)];
    [self showNormalAlertTitle:title content:content  items:items block:sureHandler];
    
}
- (void)registerClient{
    
    NSString * registrationID = [[NSUserDefaults standardUserDefaults] objectForKey:@"clientId"];
    if (registrationID) {
        //取消加载loading
        self.startedBlock = nil;
        [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_TeacherBindClientId] parameterDic:@{@"clientId":registrationID} requestMethodType:RequestMethodType_POST requestTag:NetRequestType_TeacherBindClientId];
    }
}

- (void)setNetworkRequestStatusBlocks{
    
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_TeacherBindClientId) {
            NSLog(@"===绑定成功");
        }else if (request.tag == NetRequestType_TeacherHandleNotify){
            
            
        }else if (request.tag== NetRequestType_QueryTeacherIndexPreview){
            NSLog(@"%@===",successInfoObj);
            strongSelf.homeModel = [[HomeListModel alloc]initWithDictionary:successInfoObj error:nil];
            [strongSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
            [strongSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
            
        }else if (request.tag == NetRequestType_QueryListNews){
            if (strongSelf.currentPageNo ==0) {
                strongSelf.homeNewsModel  = nil;
                strongSelf.homeNewsModel = [[HomeListModel alloc]initWithDictionary:successInfoObj error:nil];
                strongSelf.currentPageNo++;
            }else {
                HomeListModel * tempModel = [[HomeListModel alloc]initWithDictionary:successInfoObj error:nil];
                if (tempModel.news && [tempModel.news count] >0) {
                    [strongSelf.homeNewsModel.news addObjectsFromArray: tempModel.news ];
                }
                strongSelf.currentPageNo++;
            }
            [strongSelf updateTableView];
            
            
        }
        
    } failedBlock:^(NetRequest *request, NSError *error) {
        
        [super  setDefaultNetFailedBlockImplementationWithNetRequest: request error: error otherExecuteBlock:nil];
        
        [weakSelf updateTableView];
        
    } ];
}

- (void)netRequest:(NetRequest *)request failedWithError:(NSError *)error{
    
    if (request.tag != NetRequestType_TeacherBindClientId) {
        [super netRequest:request failedWithError:error];
    }else{
        
        NSLog(@"绑定失败");
        [self updateTableView];
    }
}
- (void)registerJPush{
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    //    [defaultCenter addObserver:self
    //                      selector:@selector(networkDidSetup:)
    //                          name:kJPFNetworkDidSetupNotification
    //                        object:nil];
    //    [defaultCenter addObserver:self
    //                      selector:@selector(networkDidClose:)
    //                          name:kJPFNetworkDidCloseNotification
    //                        object:nil];
    //    [defaultCenter addObserver:self
    //                      selector:@selector(networkDidRegister:)
    //                          name:kJPFNetworkDidRegisterNotification
    //                        object:nil];
    //    [defaultCenter addObserver:self
    //                      selector:@selector(networkDidLogin:)
    //                          name:kJPFNetworkDidLoginNotification
    //                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidReceiveMessage:)
                          name:kJPFNetworkDidReceiveMessageNotification
                        object:nil];
    //    [defaultCenter addObserver:self
    //                      selector:@selector(serviceError:)
    //                          name:kJPFServiceErrorNotification
    //                        object:nil];
}

- (void)networkDidReceiveMessage:(NSNotification *)notification {
    //    NSDictionary *userInfo = [notification userInfo];
    //    NSString *title = [userInfo valueForKey:@"title"];
    //    NSString *content = [userInfo valueForKey:@"content"];
    //    NSDictionary *extra = [userInfo valueForKey:@"extras"];
    //    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //
    //    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    //
    //    NSString *currentContent = [NSString
    //                                stringWithFormat:
    //                                @"收到自定义消息:%@\ntitle:%@\ncontent:%@\nextra:%@\n",
    //                                [NSDateFormatter localizedStringFromDate:[NSDate date]
    //                                                               dateStyle:NSDateFormatterNoStyle
    //                                                               timeStyle:NSDateFormatterMediumStyle],
    //                                title, content, [self logDic:extra]];
    //
    //
    //    NSDictionary * jsonDic =  [NSJSONSerialization JSONObjectWithData:[content dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
    //    NSString * type = @"";
    //      type  = jsonDic[@"type"] ;
    //
    //    NSString * alertContent = @"";
    //    if ([type isEqualToString:@"05"]) {
    //        alertContent = @"申请班级";
    //    }
    //
    //    MMPopupItemHandler refusedHandler = ^(NSInteger index){
    //        [self refusedAction];
    //    };
    //    MMPopupItemHandler agreedHandler = ^(NSInteger index){
    //
    //    };
    //    NSArray * items = @[MMItemMake(@"拒绝", MMItemTypeHighlight, refusedHandler),
    //                        MMItemMake(@"同意", MMItemTypeHighlight, agreedHandler)];
    //    [self showNormalAlertTitle:@"提示" content:alertContent items:items block: nil];
    
    TNTabbarItem *item  = self.tnTabbarController.tabBar.items[2];
    item.badgeValue = @"1";
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_MESSAGEE_LIST" object:nil];
    
}
- (CGRect)getTableViewFrame{
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    return frame;
}
- (BOOL)isShowTabarController{
    return YES;
}
- (BOOL )getShowBackItem{
    
    return NO;
}
- (BOOL)getNavBarBgHidden{
    
    return YES;
}
- (BOOL)isAddRefreshHeader{
    return YES;
}
- (BOOL)isAddRefreshFooter{
    return YES;
}
- (UIRectEdge)getViewRect{
    
    return UIRectEdgeAll;
}
//-  (UITableViewStyle)getTableViewStyle{
//
//    return UITableViewStylePlain;
//}
- (void)setupForwarding{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(gotoRecommended) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:[UIImage imageNamed:@"share_btn"]   forState:UIControlStateNormal];
    btn.tag = kShareTag;
    [self.view addSubview:btn];
    [btn setFrame:CGRectMake(self.tableView.frame.size.width -12 -64, self.tableView.frame.size.height -12 -64, 64, 64)];
    
    
}


- (void)gotoReview{
    
    HomeworkReviewViewController * homeworkReviewVC  = [[HomeworkReviewViewController alloc]init];
    [self pushViewController:homeworkReviewVC];
    
}
- (void)gotoView:(TouchType)type{
    
    if ( type == TouchType_release) {
        [self  gotoDecorateHomework];
    }else if (type == TouchType_check){
        [self gotoCheckJob];
        
    }else if (type == TouchType_huigu){
        [self gotoReview];
        
    }
}

- (void)registerCell{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeAdvertisingCell class]) bundle:nil] forCellReuseIdentifier:HomeAdvertisingCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeworkSectionView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:HomeworkSectionViewIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeworkSpecialCell class]) bundle:nil] forCellReuseIdentifier:HomeworkSpecialCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeworkMyBooksCell class]) bundle:nil] forCellReuseIdentifier:HomeworkMyBooksCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NewsCell class]) bundle:nil] forCellReuseIdentifier:NewsCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeworkSuspensionView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:HomeworkSuspensionViewIdentifier];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [[self getSections] count]  ;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row = 1;
    if (section == 2) {
        row = [self.homeNewsModel.news count];
    }
 
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = nil;
    if (indexPath.section == 0) {
        HomeAdvertisingCell * tempCell = [tableView dequeueReusableCellWithIdentifier:HomeAdvertisingCellIdentifier];
        tempCell.touckBlock = ^(TouchType type) {
            [self gotoView:type];
        };
        tempCell.advertisingBlock = ^(NSInteger advertisingIndex) {
            [self gotoAdvertisingVC:advertisingIndex];
        };
        tempCell.msgImgV.hidden = YES;
        [tempCell setupHomeAdModel:self.homeModel];
        cell = tempCell;
    } else if (indexPath.section == 1){
        
        HomeworkMyBooksCell * tempCell = [tableView dequeueReusableCellWithIdentifier:HomeworkMyBooksCellIdentifier];
        [tempCell setupHomeBooksModel:self.homeModel];
        tempCell.selectedBooksBlock = ^(HomeBooksModel *booksModel) {
            if (booksModel) {
                //布置作业
                [self gotoHomeworkVC:booksModel];
            }else{
                //添加书本
                [self gotoMyBooksV];
            }
        };
        
        tempCell.bookSelfBlock = ^{
            [self gotoBookSelfVC];
        };
        cell = tempCell;
    }else{
        NewsCell *tempCell = [tableView dequeueReusableCellWithIdentifier:NewsCellIdentifier];
        [tempCell setupNewsModel:self.homeNewsModel.news[indexPath.row]];
        cell = tempCell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height =  0;
    if (indexPath.section == 0) {
        height = (self.view.frame.size.width/advImgVScale + 44  +13);
    }else if (indexPath.section == 1) {
        height = 218;
    }if (indexPath.section == 2){
        height = 97+12;
        if (self.homeNewsModel.news.count-1 == indexPath.row) {
            height = 97;
        }
    }
    return height ;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headerView = [UIView new];
    if (section !=0) {
        HomeworkSectionView * tempView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([HomeworkSectionView class]) owner:nil options:nil ].firstObject;
        [tempView setupSectionTitle:[self getSections][section]];
        
        tempView.titleBottom.constant = 14;
        BOOL isShow = NO;
        if (section == 1) {
            isShow = YES;
            tempView.titleBottom.constant = 12;
        }
        [tempView setupMoreBtnState:isShow];
        tempView.moreBlock = ^{
            [self gotoMyBooksV];
        };
        headerView = tempView;
    }
 
    return headerView;
}
- (NSArray *)getSections{
    
    NSMutableArray * arrays =[NSMutableArray arrayWithCapacity:3];
    [arrays addObjectsFromArray: @[@"广告",@"我的书架"]];
    [arrays addObject:@"新知精选"];
    return arrays;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = 0.0001;
    if (section != 0) {
        height = 40;
        if (section == 2) {
            height = 52+6;
        }
    }
 
    return height;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    CGFloat height = 0.00001;
    if (section >0) {
        height = FITSCALE(8);
    }
    return height;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.isDragging = YES;
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    self.isDragging = NO;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat headerHeight = (self.view.frame.size.width/advImgVScale + 44) - 60;
    if (@available(iOS 11,*)) {
        headerHeight -= self.view.safeAreaInsets.top;
    } else {
        headerHeight -= [self.topLayoutGuide length];
        
    }
    
    CGFloat progress = scrollView.contentOffset.y + scrollView.contentInset.top;
    CGFloat gradientProgress = MIN(1, MAX(0, progress  / headerHeight));
    gradientProgress = gradientProgress * gradientProgress * gradientProgress * gradientProgress;
    if (gradientProgress != _gradientProgress) {
        _gradientProgress = gradientProgress;
        self.hbd_barAlpha = 0;
        [self hbd_setNeedsUpdateNavigationBar];
    }
//    [self confightHomeworkAnimation:scrollView withHomeworkViewY:headerHeight+60-20];  ///
    
    [self confightShareBtnAnimation:scrollView];
    
}

- (void)confightHomeworkAnimation:(UIScrollView *)scrollView withHomeworkViewY:(CGFloat)hwY {
  
//    printf("\n==%f----",scrollView.contentOffset.y);
    if(scrollView.contentOffset.y >= hwY  )
        
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        HomeAdvertisingCell * cell  = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
       
        if ( self.isScrollTop ) {
             printf("dddddddd--\n");

            
            if (![self.view viewWithTag:kSegmentViewTag]) {
               self.suspensionView.segementView.tag  = kSegmentViewTag;
                [self.view addSubview:self.suspensionView.segementView ];
            }
            self.suspensionView.segementView.hidden = NO;
            [self.suspensionView.segementView mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.leading.mas_equalTo(self.view.mas_leading).offset(26);
                make.trailing.mas_equalTo(self.view.mas_trailing).offset(-26);
                make.top.mas_equalTo(self.view.mas_top).offset([UIApplication sharedApplication].statusBarFrame.size.height);
            }];
      
            cell.segmentView.hidden = YES;
            
            self.isScrollTop =  NO;
        }

          cell.advertisingView.hidden = YES;

    }
    else if(scrollView.contentOffset.y > 0 )
        
    {
    
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        HomeAdvertisingCell * cell  = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
//        UIView * segementView = [self.view viewWithTag:kSegmentViewTag];
 
        if (!self.isScrollTop) {
             printf("sssssss--\n");
             cell.segmentView.hidden = NO;
            self.suspensionView.segementView.hidden = YES;

        }
        
        cell.advertisingView.hidden = NO;
        self.isScrollTop =  YES;
    }
    
    
}
-  (void)confightShareBtnAnimation:(UIScrollView *)scrollView{
    if (!self.isDragging) {
        return ;
    }
//    NSLog(@"%f====",scrollView.contentOffset.y);
    //移动分享按钮
    UIButton * shareBtn = [self.view viewWithTag:kShareTag];
    if (self.preScrollY +5 < scrollView.contentOffset.y ) {
        
        [UIView animateWithDuration:0.5 animations:^{
            
            [shareBtn setFrame:CGRectMake(self.tableView.frame.size.width -12 -64, self.tableView.frame.size.height +12, 64, 64)];
        }];
    }else if( self.preScrollY > scrollView.contentOffset.y +5){
        
        [UIView animateWithDuration:0.5 animations:^{
            [shareBtn setFrame:CGRectMake(self.tableView.frame.size.width -12 -64, self.tableView.frame.size.height -12 -64, 64, 64)];
        }];
        
    }
    self.preScrollY = scrollView.contentOffset.y;
}

#pragma mark ---
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        
        HomeNewsModel * newsModel = self.homeNewsModel.news[indexPath.row];
         newsModel.readCount = @([newsModel.readCount integerValue]+1);
//        self.isNewsUpdate = YES;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self gotoInformationDetail:newsModel withIndexPath:indexPath];
//        self.isNewsUpdate = NO;
     
    }
 
}
#pragma mark ----
- (void)viewWillAppear:(BOOL)animated{
    [self.tnTabbarController setIsTabbarHidden:NO];
//    UIView * segementView = [self.navigationController.navigationBar viewWithTag:kSegmentViewTag];
//    if (segementView) {
//        segementView.hidden = NO;
//
//    }
//    UIView * review = [self.navigationController.navigationBar viewWithTag:KReviewBtnTag];
//    review.hidden = self.reviewBtnHidden;
    [super viewWillAppear:animated];
    
    UIButton * shareBtn = [self.view viewWithTag:kShareTag];
    [shareBtn setFrame:CGRectMake(self.tableView.frame.size.width -12 -64, self.tableView.frame.size.height -12 -64, 64, 64)];
    
    if (self.isUpdateBookself ) {
        [self beginRefresh];
        self.isUpdateBookself = NO;
    }
   [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent ;
    
    [self navUIBarBackground:0];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.tnTabbarController setIsTabbarHidden:YES];
    
    [self navUIBarBackground:8];
}

#pragma mark --- 刷新
- (void)getLoadMoreTableViewNetworkData{
    
    [self requestNewsList];
}

- (void)drogDownRefresh{

    self.currentPageNo = 0;
    self.pageCount = 10;
    if (self.homeModel || self.homeNewsModel) {
        self.startedBlock = nil;
    }
    [self getQueryTeacherIndexPreview];
    [self requestNewsList];
    
}
- (NSInteger )getNetworkTableViewDataCount{
   
    return [self.homeNewsModel.news count];
}

#pragma mark ----
- (void)gotoAddressVC{
    
    AddressListViewController * addressVC = [[AddressListViewController alloc]init];
    addressVC.addressSuccessblock = ^{
        if (self.type == ZLXZHomeViewControllerType_Info) {
            
            //            [self showGuideView];
        }
        
    };
    [self pushViewController:addressVC];
}

#pragma mark -----------------------------------------------------
//检查作业
- (void)gotoCheckJob{
    
    SessionModel *sesstion = [[SessionHelper sharedInstance] getAppSession];
    if (!sesstion.schoolId) {
        [self showBindingAlert];
        return;
    }
    if (![sesstion.hasClazz boolValue]) {
        [self showCreateClassAlert];
        return;
    }
    CheckNewListPageViewController * checkHomeworkVC = [[CheckNewListPageViewController alloc]init];
    
    [self pushViewController:checkHomeworkVC];
}
//布置作业

- (void)gotoDecorateHomework{
    SessionModel *sesstion = [[SessionHelper sharedInstance] getAppSession];
    if (!sesstion.schoolId) {
        [self showBindingAlert];
        return;
    }
    if (![sesstion.hasClazz boolValue]) {
        [self showCreateClassAlert];
        return;
    }
    ReleaseHomeworkViewController * homeworkVC = [[ReleaseHomeworkViewController alloc]init];
    [self pushViewController:homeworkVC];
}
//资讯详情
- (void)gotoInformationDetail:( HomeNewsModel *) newsModel withIndexPath:(NSIndexPath *)indexPath{
    
    InformationDetailViewController * informationVC = [[InformationDetailViewController alloc]initWithModel:newsModel];
    informationVC.indexPath = indexPath;
  
//    WEAKSELF
//    informationVC.newsBlock = ^(NSIndexPath *IndexPath, NSNumber *readCount) {
//       HomeNewsModel * tempModel  = weakSelf.homeNewsModel.news[indexPath.row];
//       tempModel.readCount = readCount;
//        weakSelf.selectedNewsIndexPath = indexPath;
//
//    };
    [self pushViewController:informationVC];
}


//推荐好友

- (void)gotoRecommended{
    SessionModel *sesstion = [[SessionHelper sharedInstance] getAppSession];
    if (!sesstion.schoolId) {
        [self showBindingAlert];
        return;
    }
    if (![sesstion.hasClazz boolValue]) {
        [self showCreateClassAlert];
        return;
    }
    RecommendedViewController * recommentdedVC = [[RecommendedViewController alloc]init];
    [self pushViewController:recommentdedVC];
}

//添加书架
- (void)gotoMyBooksV{
    SessionModel *sesstion = [[SessionHelper sharedInstance] getAppSession];
    if (!sesstion.schoolId) {
        [self showBindingAlert];
        return;
    }
    if (![sesstion.hasClazz boolValue]) {
        [self showCreateClassAlert];
        return;
    }
    RespositoryPageViewController * repostoryVC = [[RespositoryPageViewController alloc]init];
    [self pushViewController:repostoryVC];
    
}
//布置作业
- (void)gotoHomeworkVC:(HomeBooksModel *)model{
    SessionModel *sesstion = [[SessionHelper sharedInstance] getAppSession];
    if (!sesstion.schoolId) {
        [self showBindingAlert];
        return;
    }
    if (![sesstion.hasClazz boolValue]) {
        [self showCreateClassAlert];
        return;
    }
    if ([model.bookType isEqualToString:@"JFBook"]) {
        AssistantsHomeworkViewController * bookHomeworkVC = [[AssistantsHomeworkViewController alloc]initWithBookId:model.bookId  ];
        [self pushViewController:bookHomeworkVC];
    }else{
        if ([model.courseType isEqualToString:@"phonics_textbook"]) {
            PhonicsHomeworkViewController * bookHomeworkVC = [[PhonicsHomeworkViewController alloc]initWithBookId:model.bookId];
            [self pushViewController:bookHomeworkVC];
            return;
        }
        BookHomeworkViewController * bookHomeworkVC = [[BookHomeworkViewController alloc]initWithBookId:model.bookId withBookType:model.bookType withClear:YES];
        [self pushViewController:bookHomeworkVC];
    }
}


// 书架
- (void)gotoBookSelfVC{
    SessionModel *sesstion = [[SessionHelper sharedInstance] getAppSession];
    if (!sesstion.schoolId) {
        [self showBindingAlert];
        return;
    }
    if (![sesstion.hasClazz boolValue]) {
        [self showCreateClassAlert];
        return;
    }
    BookcaseViewController * bookcaseVC = [[BookcaseViewController alloc]initWithHomeSubjectName:@""];
    [self pushViewController:bookcaseVC];
    
}



- (void) gotoAdvertisingVC:(NSInteger )index{
    HomeSysAdvertsModel * model  = self.homeModel.sysAdverts[index];
    
    if (!model.redirectUrl) {
        return;
    }
    InformationDetailViewController * detailVC = [[InformationDetailViewController alloc]initWithUrl:model.redirectUrl withStyle:InformationDetailType_advDetail];
    [self pushViewController:detailVC];
    
    NSLog(@"%@",model);
}
- (void)dealloc {
    [self unObserveAllNotifications];
    [self clearDelegate];
}

- (void)unObserveAllNotifications {
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    //    [defaultCenter removeObserver:self
    //                             name:kJPFNetworkDidSetupNotification
    //                           object:nil];
    //    [defaultCenter removeObserver:self
    //                             name:kJPFNetworkDidCloseNotification
    //                           object:nil];
    //    [defaultCenter removeObserver:self
    //                             name:kJPFNetworkDidRegisterNotification
    //                           object:nil];
    //    [defaultCenter removeObserver:self
    //                             name:kJPFNetworkDidLoginNotification
    //                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidReceiveMessageNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFServiceErrorNotification
                           object:nil];
}


@end


