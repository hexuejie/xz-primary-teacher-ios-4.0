//
//  BaseNetworkViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/4/24.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BaseNetworkViewController.h"
#import "SessionModel.h"
#import "SessionHelper.h"
#import "LoginController.h"
#import "HBDNavigationController.h"
@interface BaseNetworkViewController ()

@end

@implementation BaseNetworkViewController

- (instancetype)init{
    self = [super init];
    if (self)
    {
         [self initializeVCBlock];
    }
    return self;
    
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initializeVCBlock];

    }
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
          [self initializeVCBlock];
    
    }
    return self;
}


- (void)initializeVCBlock{
    
    // 该地方一定要注意block引起的retain cycle
    __weak BaseNetworkViewController *weakSelf = self;
    self.noNetworkBlock = ^{
       BaseNetworkViewController *strongSelf = weakSelf;
        if (strongSelf)
        {
            // 给主view赋值状态背景图(无网络连接)
            [strongSelf setNoNetworkConnectionStatusView];
        }
    };
    
    self.startedBlock = ^(NetRequest *request)
    {
        [weakSelf showHUDInfoByType:HUDInfoType_Loading];
    };
    self.startedUploadBlock = ^(NetRequest *request)
    {
 
         [weakSelf showHUDInfoByType:HUDInfoType_Loading];
    };
    
    self.progressBlock = ^(NetRequest *request, float progress) {
        [weakSelf  showUploadHUDProgress:progress];
        
    };
    [self setDefaultNetFailedBlock];
   
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 设置网络请求中每个阶段需要执行的代码块
    [self setNetworkRequestStatusBlocks];
    [self getNetworkData];
}
- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)getNetworkData
{
//    NSAssert(NO, @"%s - 子类没有实现此方法",__PRETTY_FUNCTION__);
    NSLog(@"%s",__PRETTY_FUNCTION__);
    // do nothing
    
}

- (void)setNoNetworkConnectionStatusView
{
  
}

- (void)setLoadFailureStatusView
{
   
}


#pragma mark - 设置代码块

- (void)setNetSuccessBlock:(ExtendVCNetRequestSuccessBlock)successBlock
{
    [self setNetSuccessBlock:successBlock failedBlock:self.failedBlock];
}

- (void)setNetUploadSuccessBlock:(ExtendVCNetRequestSuccessBlock)successBlock
{
    [self setNoNetworkBlock:self.noNetworkBlock StartedBlock:self.startedUploadBlock progressBlock:self.progressBlock successBlock:successBlock failedBlock:self.failedBlock];
}
 
- (void)setNetSuccessBlock:(ExtendVCNetRequestSuccessBlock)successBlock failedBlock:(ExtendVCNetRequestFailedBlock)failedBlock
{
    [self setNoNetworkBlock:self.noNetworkBlock SuccessBlock:successBlock failedBlock:failedBlock];
}

- (void)setNoNetworkBlock:(ExtendVCNetRequestNoNetworkBlock)noNetworkBlock SuccessBlock:(ExtendVCNetRequestSuccessBlock)successBlock failedBlock:(ExtendVCNetRequestFailedBlock)failedBlock
{
    [self setNoNetworkBlock:noNetworkBlock StartedBlock:self.startedBlock successBlock:successBlock failedBlock:failedBlock];
}

- (void)setNoNetworkBlock:(ExtendVCNetRequestNoNetworkBlock)noNetworkBlock StartedBlock:(ExtendVCNetRequestStartedBlock)startedBlock successBlock:(ExtendVCNetRequestSuccessBlock)successBlock failedBlock:(ExtendVCNetRequestFailedBlock)failedBlock
{
    [self setNoNetworkBlock:noNetworkBlock StartedBlock:startedBlock progressBlock:self.progressBlock successBlock:successBlock failedBlock:failedBlock];
}

- (void)setNoNetworkBlock:(ExtendVCNetRequestNoNetworkBlock)noNetworkBlock StartedBlock:(ExtendVCNetRequestStartedBlock)startedBlock progressBlock:(ExtendVCNetRequestProgressBlock)progressBlock successBlock:(ExtendVCNetRequestSuccessBlock)successBlock failedBlock:(ExtendVCNetRequestFailedBlock)failedBlock
{
    self.noNetworkBlock = noNetworkBlock;
    self.startedBlock = startedBlock;
    self.progressBlock = progressBlock;
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
}

#pragma mark - 发送网络请求

- (void)clearDelegate
{
   
    self.noNetworkBlock =  nil;
    
    self.startedBlock =  nil;
    self.startedUploadBlock =  nil;
    
    self.progressBlock =  nil;

    [[NetRequestManager sharedInstance] clearDelegate:self];
}

- (void)setNetworkRequestStatusBlocks
{
    // 子类实现,需在getNetworkData方法前调用
    //    NSAssert(NO, @"%s - 子类没有实现此方法",__PRETTY_FUNCTION__);
}

// 设置默认的失败后执行的代码块
- (void)setDefaultNetFailedBlock;
{
    WEAKSELF
    self.failedBlock = ^(NetRequest *request, NSError *error)
    {
        [weakSelf setDefaultNetFailedBlockImplementationWithNetRequest:request error:error otherExecuteBlock:nil];
    };
}

- (void)setDefaultNetFailedBlockImplementationWithNetRequest:(NetRequest *)request error:(NSError *)error otherExecuteBlock:(void (^)(void))otherBlock
{
    [self setDefaultNetFailedBlockImplementationWithNetRequest:request error:error isAddFailedActionView:NO otherExecuteBlock:otherBlock];
}

- (void)setDefaultNetFailedBlockImplementationWithNetRequest:(NetRequest *)request error:(NSError *)error isAddFailedActionView:(BOOL)isAddActionView otherExecuteBlock:(void (^)(void))otherBlock
{
    // 无数据
    if (error.code == MyHTTPCodeType_DataSourceNotFound)
    {
//        [self showHUDInfoByString:[LanguagesManager getStr:All_DataSourceNotFoundKey]];
    }
    // 未登录或登录过期
    else if (error.code == MyHTTPCodeType_TokenIllegal ||
             error.code == MyHTTPCodeType_TokenIncomplete ||
             error.code == MyHTTPCodeType_TokenOverdue||
             error.code == MyHTTPCodeType_NoLogin ||
             error.code == MyHTTPCodeType_NoUser  ||
             error.code == MyHTTPCodeType_NoStudent  )
    {
        if (![super viewIsExistWarning]){
           
            [self showAlert:TNOperationState_Fail content:error.localizedDescription block:^(NSInteger index) {
                NSLog(@"error.code=====%zd",error.code);
             
                [self resetLogin];
            }];
        }
        

    }
    else
    {
        /*
         [weakSelf showHUDInfoByType:HUDInfoType_Failed];
         */
       
        if (error.localizedDescription)
        {
           
            if ([error.localizedDescription rangeOfString:@"Request failed"].location !=NSNotFound ) {
                [self showHUDInfoByString:@"网络连接失败,请稍后再试"];
            }else if([error.localizedDescription rangeOfString:@"Could not connect"].location !=NSNotFound ){
                [self showHUDInfoByString:@"网络连接失败,请稍后再试"];
                
            }else if([error.localizedDescription rangeOfString:@"timed out"].location != NSNotFound ){
                [self showHUDInfoByString:@"网络连接失败,请稍后再试"];
            }else if ([error.localizedDescription rangeOfString:@"couldn’t be completed"] .location != NSNotFound){
               [self showHUDInfoByString:@"网络连接失败,请稍后再试"];
            }else if ([error.localizedDescription rangeOfString:@"connection was"].location != NSNotFound ){
                    [self showHUDInfoByString:@"网络连接失败,请稍后再试"];
            } else{
                [self showHUDInfoByString:error.localizedDescription];
                
            }

        }
        else
        {
            [self showHUDInfoByString:@"网络连接失败,请稍后再试"];
        }
        
        // 设置主view的状态背景图(点击重新刷新的图)
        if (isAddActionView)
        {
            [self setLoadFailureStatusView];
        }
    }
    
    if (otherBlock)
    {
        otherBlock();
    }
}


- (void)resetLogin{
   
    [[SessionHelper sharedInstance] clearMessageList];
    [[SessionHelper sharedInstance] clearSaveCacheSession];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

//    [[UINavigationBar appearance]setBarTintColor:project_main_blue];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self gotoLoginViewController];
    
}

- (void)gotoLoginViewController{

    dispatch_async(dispatch_get_main_queue(), ^{
        LoginController * loginVC = [[LoginController alloc]initWithNibName:NSStringFromClass([LoginController class]) bundle:nil];
        HBDNavigationController *navLoginVC=[[HBDNavigationController alloc]initWithRootViewController:loginVC];
        UIViewController *rootVC=[[[[UIApplication sharedApplication]delegate]window]rootViewController];
        
        
        //防止重复弹
        if ([rootVC.presentedViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navigation = (id)rootVC.presentedViewController;
            if ([navigation.topViewController isKindOfClass:[LoginController class]]) {
                [navigation.topViewController dismissViewControllerAnimated:false completion:^{
                    
                }];
                return;
            }
        }
        if (rootVC.presentedViewController) {
            //要先dismiss结束后才能重新present否则会出现Warning: Attempt to present <UINavigationController: 0x7fdd22262800> on <UITabBarController: 0x7fdd21c33a60> whose view is not in the window hierarchy!就会present不出来登录页面
            [rootVC.presentedViewController dismissViewControllerAnimated:false completion:^{
                
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
                
            }];
        }else {
            
            [rootVC presentViewController:navLoginVC animated:false completion:nil];
        }
        
    });
    

}

- (void)backViewController{

    [super backViewController];
     [self clearDelegate];
}
- (void)dealloc
{
    [self clearDelegate];
    [self removeNotification];
}

- (void)removeNotification{

   
}
- (void)isShowNetBackgroundStatusImgView:(BOOL)yesOrNo{
    
    
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)endRefreshwithNoNetwork{
    
    NSLog(@"%s",__PRETTY_FUNCTION__);
    // do nothing
}



- (void)sendRequest:(NSString *)urlMethodName parameterDic:(NSDictionary *)parameterDic requestTag:(int)tag
{
    [self sendRequest:urlMethodName parameterDic:parameterDic requestMethodType:RequestMethodType_GET requestTag:tag];
}

- (void)sendRequest:(NSString *)urlMethodName parameterDic:(NSDictionary *)parameterDic requestMethodType:(NSString *)methodType requestTag:(int)tag
{
    [self sendRequest:urlMethodName parameterDic:parameterDic requestHeaders:nil requestMethodType:methodType requestTag:tag];
}
- (void)sendHeaderRequest:(NSString *)urlMethodName parameterDic:(NSDictionary *)parameterDic requestMethodType:(NSString *)methodType requestTag:(int)tag
{
    NSDictionary * requestHeaders ;
    if ([[SessionHelper sharedInstance] checkSession]) {
        requestHeaders =@{@"auth-token":(SessionModel *)[[SessionHelper sharedInstance] getAppSession].token};
    }
    [self sendRequest:urlMethodName parameterDic:parameterDic requestHeaders:requestHeaders requestMethodType:methodType requestTag:tag];
}


- (void)sendHeaderFeedbackRequest:(NSString *)urlMethodName parameterDic:(NSDictionary *)parameterDic requestMethodType:(NSString *)methodType requestTag:(int)tag{
    
    NSDictionary * requestHeaders ;
    if ([[SessionHelper sharedInstance] checkSession]) {
        requestHeaders =@{@"auth-token":(SessionModel *)[[SessionHelper sharedInstance] getAppSession].token};
    }

    
    if (![NetworkStatusManager isConnectNetwork])
    {
        // 执行没有网络连接的代码块
        if (self.noNetworkBlock)
        {
            self.noNetworkBlock();
        }
        [self endRefreshwithNoNetwork];
        [self showHUDInfoByType:HUDInfoType_NoConnectionNetwork];
        
        return;
    }
    
    NSURL *url = nil;

    url = [NSURL URLWithString:Request_SubmitFeedback_internal];
    if ([[NSUserDefaults standardUserDefaults] integerForKey:EnvironmentIndex] == 2) {//181
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.1.181/csc/api/xterm/ClientSubmitFeedbackDetails"]];//
    }else if ([[NSUserDefaults standardUserDefaults] integerForKey:EnvironmentIndex] == 1) {//150
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://218.76.7.150:8080/csc/api/xterm/ClientSubmitFeedbackDetails"]];//
    }else if ([[NSUserDefaults standardUserDefaults] integerForKey:EnvironmentIndex] == 0) {//正式
        url = [NSURL URLWithString:[NSString stringWithFormat:@"https://csc.ajia.cn/api/xterm/ClientSubmitFeedbackDetails"]];//
    }
    
    NSMutableDictionary * requestParameterDic = [NSMutableDictionary dictionary ];
    NSMutableDictionary * tempParametersDic = [NSMutableDictionary dictionary ];
    if (!parameterDic) {
        [tempParametersDic addEntriesFromDictionary:@{}];
    }else{
        for (NSString *key in parameterDic.allKeys) {
             [tempParametersDic addEntriesFromDictionary:@{key:@[parameterDic[key]]}];
        }
    }
  
    [requestParameterDic addEntriesFromDictionary:@{@"parameters":tempParametersDic}];
    
    [[NetRequestManager sharedInstance] sendRequest:url parameterDic:  requestParameterDic requestHeaders:requestHeaders requestMethodType:methodType requestTag:tag delegate:self userInfo:nil   ];

}
- (void)sendRequest:(NSString *)urlMethodName parameterDic:(NSDictionary *)parameterDic requestHeaders:(NSDictionary *)headers requestMethodType:(NSString *)methodType requestTag:(int)tag
{
    [self sendRequest:urlMethodName parameterDic:parameterDic requestHeaders:headers requestMethodType:methodType requestTag:tag delegate:self];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

/**
 @ 方法描述    发送必须带header的请求(如果没有登录,header就会为nil,那么就会自动跳转到登录页面)
 @ 创建人      DCQ
 */
- (void)sendMustWithTokenHeadersRequest:(NSString *)urlMethodName parameterDic:(NSDictionary *)parameterDic requestHeaders:(NSDictionary *)headers requestMethodType:(NSString *)methodType requestTag:(int)tag delegate:(id<NetRequestDelegate>)delegate userInfo:(NSDictionary *)userInfo
{
    // 待实现...
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void)sendRequest:(NSString *)urlMethodName parameterDic:(NSDictionary *)parameterDic requestHeaders:(NSDictionary *)headers requestMethodType:(NSString *)methodType requestTag:(int)tag delegate:(id<NetRequestDelegate>)delegate
{
    [self sendRequest:urlMethodName parameterDic:parameterDic requestHeaders:headers requestMethodType:methodType requestTag:tag delegate:delegate userInfo:nil];
}



- (void)sendRequest:(NSString *)urlMethodName parameterDic:(NSDictionary *)parameterDic requestHeaders:(NSDictionary *)headers requestMethodType:(NSString *)methodType requestTag:(int)tag delegate:(id<NetRequestDelegate>)delegate userInfo:(NSDictionary *)userInfo
{
    
//    if (![NetworkStatusManager isConnectNetwork])
//    {
//        // 执行没有网络连接的代码块
//        if (self.noNetworkBlock)
//        {
//            self.noNetworkBlock();
//        }
//        [self endRefreshwithNoNetwork];
//        [self showHUDInfoByType:HUDInfoType_NoConnectionNetwork];
//        
//        return;
//    }
//    
    NSURL *url = nil;
    BOOL isGETRequest = [methodType isEqualToString:RequestMethodType_GET]; // 是否为GET方式的请求
    
    if (isGETRequest)
    {
        url = [UrlManager getRequestUrlByMethodName:urlMethodName andArgsDic:parameterDic];
    }
    else
    {
//        url = [UrlManager getRequestUrlByMethodName:urlMethodName];
        url = [NSURL URLWithString:[UrlManager getRequestNameSpace]];
    }
    NSMutableDictionary * requestParameterDic = [NSMutableDictionary dictionary ];
    NSMutableDictionary * tempParametersDic = [NSMutableDictionary dictionary ];
    if (!parameterDic) {
        [tempParametersDic addEntriesFromDictionary:@{}];
    }else{
       
        for (NSString *key in parameterDic.allKeys) {
            
            [tempParametersDic addEntriesFromDictionary:@{key:@[parameterDic[key]]}];
            
        }
    }
    [requestParameterDic addEntriesFromDictionary:@{@"id":@(tag)}];
    [requestParameterDic addEntriesFromDictionary:@{@"functionName": urlMethodName}];
    [requestParameterDic addEntriesFromDictionary:@{@"parameters":tempParametersDic}];
    [[NetRequestManager sharedInstance] sendRequest:url parameterDic:!isGETRequest ? requestParameterDic : nil requestHeaders:headers requestMethodType:methodType requestTag:tag delegate:delegate userInfo:userInfo];
}


////////////////////////////////////////////下载////////////////////////////////////////////////////



////////////////////////////////////////////上传/////////////////////////////////////////////////



/////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NetRequestDelegate Methods

- (void)netRequestDidStarted:(NetRequest *)request
{
    if (self.startedBlock)
    {
        self.startedBlock(request);
    }
}
- (void)netRequestDidStartedUpload:(NetRequest *)request{
    if (self.startedUploadBlock) {
        self.startedUploadBlock(request);
    }
    
}
- (void)netRequest:(NetRequest *)request setProgress:(float)newProgress
{
    if (self.progressBlock)
    {
        self.progressBlock(request, newProgress);
    }
}

- (void)netRequest:(NetRequest *)request successWithInfoObj:(id)infoObj
{
  
    if (request && infoObj ) {
        NSArray *objects = @[request, infoObj];
        [self performSelector:@selector(requestSuccess:) withObject:objects afterDelay:1.0];
    }
    
    //    [self parserNetworkData:infoObj request:request];
}

- (void)requestSuccess:(NSArray *)objects{
    NetRequest *request = objects.firstObject;
    id infoObj = objects[1];
    if (self.successBlock)
    {
        self.successBlock(request, infoObj);
    }
    if ([self requestEndHidHud]) {
          [self hideHUD];
    }
   
}

- (BOOL)requestEndHidHud{
    return YES;
}
- (void)netRequest:(NetRequest *)request failedWithError:(NSError *)error
{
  
    if (self.failedBlock)
    {
        self.failedBlock(request, error);
    }
    [self hideHUD];
}


- (void)showTestInfo{
     [self showAlert:TNOperationState_OK content:@"功能正在开发"];
    
    
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
