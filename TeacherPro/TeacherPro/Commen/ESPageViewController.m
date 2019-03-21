//
//  ESOrderPageViewController.m
//  eShop
//
//  Created by Kyle on 14/11/19.
//  Copyright (c) 2014年 yujiahui. All rights reserved.
//

#import "ESPageViewController.h"
#import "Utility.h"
#import "UIHelper.h"
#import "UIView+AutoLayout.h"
#import "LXSeparateView.h"
#import "Interface.h"
#import "SessionModel.h"
#import "HBDNavigationController.h"
#import "UIViewController+HBD.h"

#define kSegmentHeight 40

@interface ESPageViewController ()<WMPageControllerDataSource,WMPageControllerDelegate>


@end

@implementation ESPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.menuViewStyle = WMMenuViewStyleLine;
    self.titleSizeSelected = 16;
    self.titleSizeNormal = 16;
    self.automaticallyCalculatesItemWidths = NO;
    self.titleColorNormal = HexRGB(0xA1A7B3);
    self.titleColorSelected = HexRGB(0x525B66);
    self.progressColor = HexRGB(0x3DAEFF);
    self.delegate = self;
    self.dataSource = self;
    self.progressHeight = 3.0;
    self.progressViewCornerRadius = 1.5;
    self.progressWidth = 20.0;
    self.progressViewBottomSpace = 5.0;
    
    [self configNavigationBar];
    
    [self initializeVCBlock];
    [self setNetworkRequestStatusBlocks];
    [self getNetworkData];
}

- (void)backViewController
{
    
    NSArray *viewControllers = [self.navigationController viewControllers];
    
    // 根据viewControllers的个数来判断此控制器是被present的还是被push的
    if (1 <= viewControllers.count && 0 < [viewControllers indexOfObject:self])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
    [self clearDelegate];
}

- (void)configNavigationBar{
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"testreturn"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backViewController)];
    self.navigationItem.leftBarButtonItem = backItem;
    
    
    UIColor * navbgColor = [UIColor whiteColor];
    UIColor * titleColor = [UIColor whiteColor];
    CGFloat alpha = 1.0f;
    
    self.hbd_barAlpha = alpha;
    self.hbd_tintColor = titleColor;
    self.hbd_barTintColor =  navbgColor;
    [self hbd_setNeedsUpdateNavigationBar];
    //navigationBar下面的黑线隐藏掉
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];

}

#pragma mark
#pragma mark set viewcontroller

-(void)setSubViewControllers:(NSArray *)subViewControllers{
    
    _subViewControllers = subViewControllers;

    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];

    [_subViewControllers enumerateObjectsUsingBlock:^(UIViewController *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.title != nil){
            [array addObject:obj.title];
        }else{
            [array addObject:@""];
        }

    }];

    self.titles = [array copy];

    [self reloadData];
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {

    CGFloat tempOriginY = 0;
//    if (self.edgesForExtendedLayout != UIRectEdgeNone && self.extendedLayoutIncludesOpaqueBars == true && self.navigationController.navigationBar != nil){
//        tempOriginY = CGRectGetMaxY(self.navigationController.navigationBar.frame);
//    }else{
//        tempOriginY = 0;
//    }
    tempOriginY = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    CGFloat leftMargin = self.showOnNavigationBar ? 50 : 0;
    CGFloat originY = self.showOnNavigationBar ? 0 : tempOriginY;
    return CGRectMake(leftMargin, originY, self.view.frame.size.width - 2*leftMargin, 44);
}


- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    return [_subViewControllers count];
}

-(UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    return _subViewControllers[index];
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    if ([self.subViewControllers count] <= self.currentPageIndex ) {
        return UIStatusBarStyleDefault;
        
    }else{
        UIViewController *controller = [self.subViewControllers objectAtIndex:self.currentPageIndex];
        if ([controller respondsToSelector:@selector(preferredStatusBarStyle)]) {
            return [controller preferredStatusBarStyle];
        }
    }
    
    return UIStatusBarStyleDefault;
}




/////////////////////////////////////
/////////////////////////////////////
- (void)initializeVCBlock{

    // 该地方一定要注意block引起的retain cycle
    __weak ESPageViewController *weakSelf = self;
    self.noNetworkBlock = ^{
        ESPageViewController *strongSelf = weakSelf;
        if (strongSelf)
        {
            // 给主view赋值状态背景图(无网络连接)
            [strongSelf setNoNetworkConnectionStatusView];
        }
    };

    self.startedBlock = ^(NetRequest *request)
    {
//        [weakSelf showHUDInfoByType:HUDInfoType_Loading];
    };
    self.startedUploadBlock = ^(NetRequest *request)
    {

//        [weakSelf showHUDInfoByType:HUDInfoType_Loading];
    };

    self.progressBlock = ^(NetRequest *request, float progress) {
//        [weakSelf  showUploadHUDProgress:progress];

    };
    [self setDefaultNetFailedBlock];

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
    typeof(self) __weak weakSelf = self;
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
//        if (![super viewIsExistWarning]){
//
//            [self showAlert:TNOperationState_Fail content:error.localizedDescription block:^(NSInteger index) {
//                NSLog(@"error.code=====%zd",error.code);
//
//                [self resetLogin];
//            }];
//        }


    }
    else
    {
        /*
         [weakSelf showHUDInfoByType:HUDInfoType_Failed];
         */

        if (error.localizedDescription)
        {


            //            if ([error.localizedDescription containsString:@"Request failed"]) {
            //                 [self showHUDInfoByString:@"网络连接失败,请稍后再试"];
            //            }else if([error.localizedDescription containsString:@"Could not connect"]){
            //                 [self showHUDInfoByString:@"网络连接失败,请稍后再试"];
            //
            //            }else if([error.localizedDescription containsString:@"timed out"]){
            //               [self showHUDInfoByString:@"网络连接失败,请稍后再试"];
            //            } else{
            //               [self showHUDInfoByString:error.localizedDescription];
            //
            //            }

        }
        else
        {
//            [self showHUDInfoByString:@"网络连接失败,请稍后再试"];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc
{
    [self clearDelegate];
    [self removeNotification];
}

- (void)removeNotification{}
- (void)isShowNetBackgroundStatusImgView:(BOOL)yesOrNo{}

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
//        [self showHUDInfoByType:HUDInfoType_NoConnectionNetwork];

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
//        [self hideHUD];
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
//    [self hideHUD];
}

@end
