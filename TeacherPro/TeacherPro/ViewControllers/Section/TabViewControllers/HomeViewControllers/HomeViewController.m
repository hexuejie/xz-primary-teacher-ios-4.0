//
//  HomeViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/5/3.
//  Copyright © 2017年 ZNXZ. All rights reserved.
// 首页

#import "HomeViewController.h"
#import "UIImage+Color.h"

#import "TNTabbarController.h"
#import "AddressListViewController.h"
#import "SessionHelper.h"
#import "SessionModel.h"
#import "JKGuideView.h"
#import "JPUSHService.h"

#import "AppDelegate.h"
#import "ReleaseHomeworkViewController.h"
#import "CheckHomeworkReviewListViewController.h"
#import "RecommendedViewController.h"
#import "MessageListViewController.h"
#import "UIView+WZLBadge.h"
#import "HomeworkReviewViewController.h"
#import "ClassManagementNewViewController.h"

#import "CheckHomeworkNewListViewController.h"

#import "ZLXZHomeViewController.h"

typedef NS_ENUM(NSInteger ,HomeButtonType){
    /**
     布置作业
     */
    HomeButtonType_homeworkBtnTag           = 0,
    /**
     发布消息
     */
    HomeButtonType_sendInfoBtnTag              ,
    /**
     检查作业
     */
    HomeButtonType_checkBtnTag                 ,
    /**
     作业回顾
     */
    HomeButtonType_historyBtnTag               ,
    /**
     班级管理
     */
    HomeButtonType_classBtnTag                 ,
    /**
     推荐好友
    */
    HomeButtonType_recommendedBtnTag           ,
    
};

#define ReadPointTag      323
@interface HomeViewController ()
@property (nonatomic, assign) HomeViewControllerType type;
@property (nonatomic, assign) __block BOOL firstOpen;
@end

@implementation HomeViewController
- (instancetype)initWithType:(HomeViewControllerType)type{
    if (self == [super init]) {
        self.type = type;
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.firstOpen =  YES;
//    UIBarButtonItem *infoBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"info_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(infoAction)];
//    self.navigationItem.rightBarButtonItem = infoBtn;
    [self setNavigationItemTitle:@"小佳老师"];
    
    [self setupSubview];
    
    if (self.type == HomeViewControllerType_Info) {
        [self showBindingAlert];
        
    }else if(self.type == HomeViewControllerType_Login){
        
        SessionModel *sesstion = [[SessionHelper sharedInstance] getAppSession];
        
        if (!sesstion.schoolId) {
            
            [self showBindingAlert];
             
        }
        
    }
  
    
    [self registerJPush];
    // Do any additional setup after loading the view from its nib.
    
    [self registerClient];
   
 
}
- (void)gotoZLXZHomeViewController{
    
    ZLXZHomeViewController * homeVC = [[ZLXZHomeViewController alloc]init];
    [self pushViewController:homeVC];
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
    
    
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        if (request.tag == NetRequestType_TeacherBindClientId) {
             NSLog(@"===绑定成功");
        }else if (request.tag == NetRequestType_TeacherHandleNotify){
        
            
        }
       
    }];
}

- (void)netRequest:(NetRequest *)request failedWithError:(NSError *)error{

    if (request.tag != NetRequestType_TeacherBindClientId) {
        [super netRequest:request failedWithError:error];
    } else{
    
        NSLog(@"绑定失败");
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
 
   [[self.view viewWithTag:1] viewWithTag:ReadPointTag].hidden = NO;
    
   
}
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}


//拒绝
- (void)refusedAction{

    
}

//同意
- (void)agreedAction{

    
}

//  处理通知
- (void)requestHandleNotify{
 
    NSString * recvId = @"";
    NSString * handleStatus = @"";
    NSDictionary * parameterDic = @{@"recvId":recvId,@"handleStatus":handleStatus};
    [self  sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_TeacherHandleNotify] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_TeacherHandleNotify];
    
    
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//     [self showGuideView];
   
}
- (BOOL )getShowBackItem{
    
    return NO;
}
- (BOOL)getNavBarBgHidden{
    
    return NO;
}
- (UIRectEdge)getViewRect{
    
    return UIRectEdgeAll;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.tnTabbarController setIsTabbarHidden:YES];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [self.tnTabbarController setIsTabbarHidden:NO];
    [super viewWillAppear:animated];
    
}
- (void)setupSubview{
    UIImageView * bannerView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"index_banner"]];
    [self.view addSubview:bannerView];
    [bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.view.mas_top);
        make.height.mas_equalTo(FITSCALE(167)+64);
    }];
    
    NSDictionary * homeworkBtnDic = @{@"img":@"index_assign_work_icon",@"title":@"布置作业"};
    NSDictionary * sendInfoBtnDic = @{@"img":@"index_interact_icon",@"title":@"我的消息"};
    NSDictionary * checkBtnDic = @{@"img":@"index_comment_work_icon",@"title":@"检查作业"};
    NSDictionary * historyBtnDic = @{@"img":@"index_hot_recommend_icon",@"title":@"作业回顾"};
    NSDictionary * classBtnDic = @{@"img":@"classManagement",@"title":@"班级管理"};
    NSDictionary * recommendedBtnDic = @{@"img":@"index_sendinfo_icon",@"title":@"推荐好友"};
    NSArray * btnInfoArray = @[homeworkBtnDic, sendInfoBtnDic,checkBtnDic,historyBtnDic, classBtnDic,recommendedBtnDic];
    [self configBtnView:btnInfoArray];
}



- (void)configBtnView:(NSArray *)btnInfoArray{

    for (int index = 0; index < 6; index ++) {
        CGFloat btnX =  index%3 *IPHONE_WIDTH/3;
        CGFloat btnY =  FITSCALE(180)+64 + index/3*FITSCALE(120);
        CGFloat btnWidth = IPHONE_WIDTH/3;
        CGFloat btnHeight = FITSCALE(120);
        CGRect btnFrame = CGRectMake(btnX, btnY, btnWidth, btnHeight);
        
        [self configBtnWithImage:btnInfoArray[index][@"img"] withTitle:btnInfoArray[index][@"title"]  withRect:btnFrame withTag:index];
    }
}
 - (void)configBtnWithImage:(NSString *)imagename withTitle:(NSString *)title  withRect:(CGRect )frame withTag:(NSInteger)btnTag{
    UIButton *btn = [[UIButton alloc]initWithFrame:frame];
     if (btnTag == 1) {
         UIView * readPointView = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width - FITSCALE(20), FITSCALE(10), FITSCALE(10),FITSCALE(10)) ];
         readPointView.tag = ReadPointTag;
         readPointView.hidden =  YES;
         readPointView.layer.masksToBounds = YES;
         readPointView.backgroundColor = [UIColor redColor];
         readPointView.layer.cornerRadius = readPointView.frame.size.height/2;
         [btn addSubview:readPointView];
         
     }
   
    UIImage *image = [UIImage imageNamed:imagename];
    UILabel *label = [[UILabel alloc]init];
    label.text = title;
    label.textColor = UIColorFromRGB(0x505760);
    label.font = fontSize_14;
    btn.tag = btnTag;
    [btn addTarget:self action:@selector(homeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
 
    
    
    UIImageView *contentImageview = [[UIImageView alloc]initWithImage:image];
    
    [btn addSubview:contentImageview];
    [contentImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(btn);
        make.top.mas_equalTo(FITSCALE(5));
        make.size.mas_equalTo(CGSizeMake(80, 74));
    }];
    
    [btn addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(contentImageview.mas_bottom).offset(FITSCALE(8));
        make.centerX.mas_equalTo(btn);
       
    }];
    
    [btn setAdjustsImageWhenDisabled:NO];
    [btn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0xf6f8fb)] forState:UIControlStateHighlighted];
     
}


- (void)homeBtnAction:(UIButton *)btn{

    [self homeSegetmentAction:btn.tag];
//    [self gotoClassManagementVC ];
  
}

- (void)homeSegetmentAction:(NSInteger )tag{

    if ( tag != HomeButtonType_sendInfoBtnTag && tag != HomeButtonType_recommendedBtnTag ) {
        if (!(SessionModel *)[[SessionHelper sharedInstance] getAppSession].schoolId) {
            
            [self showBindingAlert];
            return;
        }
    }
    
    switch ( tag) {
        case HomeButtonType_homeworkBtnTag:
            [self gotoDecorateHomework];
            break;
        case HomeButtonType_sendInfoBtnTag:
             [self gotoSendMessage];
            break;
        case HomeButtonType_checkBtnTag:
             [self gotoCheckJob];
            break;
        case HomeButtonType_historyBtnTag:
             [self gotoReviewVC];
            break;
        case HomeButtonType_classBtnTag:
            [self gotoClassManagementVC ];
            break;
        case HomeButtonType_recommendedBtnTag:
             [self gotoRecommended];
            break;
            
        default:
            break;
    }
    

}


- (void)showBindingAlert{

    NSString * title = @"温馨提示";
    NSString * content = @"您需要绑定学校才可使用其它功能！";
    
    MMPopupItemHandler sureHandler = ^(NSInteger index){
     [self gotoAddressVC];
    };
   
    MMPopupItemHandler cancelHandler = ^(NSInteger index){
        if (self.type == HomeViewControllerType_Info) {
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
- (void)infoAction{

  
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)gotoAddressVC{

    AddressListViewController * addressVC = [[AddressListViewController alloc]init];
    addressVC.addressSuccessblock = ^{
        if (self.type == HomeViewControllerType_Info) {
            
            [self showGuideView];
        }
        
    };
    [self pushViewController:addressVC];
}


- (void)showGuideView{

    NSInteger classIndex =  4;
    //进入引导页
    CGFloat btnX =  classIndex%3 *IPHONE_WIDTH/3;
    CGFloat btnY =  FITSCALE(180)+64 + classIndex/3*FITSCALE(112);
//    CGFloat btnWidth = IPHONE_WIDTH/3;
    CGFloat btnHeight = FITSCALE(112) ;
    CGRect frame = CGRectMake(btnX , btnY  , btnHeight, btnHeight);
    NSArray  *titles = @[@"在这里创建/加入/管理班级"];
    
    JKGuideView *guideView = [[JKGuideView alloc] initWithFrame:[UIScreen mainScreen].bounds titles:titles frames:@[NSStringFromCGRect(frame)] alpha:0.8];
    self.firstOpen = NO;
    guideView.block = ^(){
        if (!self.firstOpen) {
             [self homeSegetmentAction:HomeButtonType_classBtnTag];
        }
        
    };
    AppDelegate * delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [delegate.window addSubview:guideView];
}

//班级管理
- (void)gotoClassManagementVC{

 
    ClassManagementNewViewController * classManagementVC = [[ClassManagementNewViewController alloc]init];
    
    [self pushViewController:classManagementVC];
    
    
}
//布置作业
- (void)gotoDecorateHomework{

    ReleaseHomeworkViewController * homeworkVC = [[ReleaseHomeworkViewController alloc]init];
    [self pushViewController:homeworkVC];
}

//检查作业
- (void)gotoCheckJob{

    CheckHomeworkNewListViewController * checkHomeworkVC = [[CheckHomeworkNewListViewController alloc]init];
    [self pushViewController:checkHomeworkVC];
   
//    CheckHomewrokListViewController * checkJobVC = [[CheckHomewrokListViewController alloc]initWithType:CheckHomewrokListViewControllerFromType_check];
//    [self pushViewController:checkJobVC];
    
}

//推荐好友

- (void)gotoRecommended{

    
    RecommendedViewController * recommentdedVC = [[RecommendedViewController alloc]init];
    [self pushViewController:recommentdedVC];
}

//我的消息
- (void)gotoSendMessage{
    [[self.view viewWithTag:1] viewWithTag:ReadPointTag].hidden = YES;
    MessageListViewController * messageListVC = [[MessageListViewController alloc]init];
    [self pushViewController:messageListVC];
}

//作业回顾
- (void)gotoReviewVC{

    HomeworkReviewViewController * homeworkReviewVC  = [[HomeworkReviewViewController alloc]init];
    [self pushViewController:homeworkReviewVC];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
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
