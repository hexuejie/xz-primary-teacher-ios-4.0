//
//  WebViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/6/9.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "ReleaseHWWebViewController.h"
#import "WebProgressLayer.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "SessionHelper.h"
#import "SessionModel.h"
#import "JSBridge.h"
#import "ProUtils.h"
#import "UIWebView+TS_JavaScriptContext.h"
#import "ZFPlayer.h"
#import "GTMBase64.h"
#import <AVFoundation/AVFoundation.h>
#import "AFNetworking.h"
#import "HSDownloadManager.h"
#import "HWCircleView.h"
#import "LoginController.h"

@interface ReleaseHWWebViewController ()<UIWebViewDelegate,ZFPlayerDelegate,JSBridgePlayerPlayerDelegate>{
 
}
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) WebProgressLayer * progressLayer;
@property (nonatomic, copy)  NSString * bookworkInfo;
@property (nonatomic, strong) JSContext *jsContext;
@property (nonatomic, assign) BOOL shouldIntercept;
@property (nonatomic, strong) UIView * errorView;
@property (nonatomic, strong) ZFPlayerView *playerView;
@property (nonatomic, strong)  id playModel;

// 下载任务句柄
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
//@property (nonatomic, strong) NSArray * cartoonBookArray;//绘本原始数据

@property (nonatomic, strong) NSMutableArray * callCartoonBookArray;//js回调需要的数据
@property (nonatomic, strong) NSMutableArray * cartoonBookDownloadUrlArray;//音频下载地址

@property(nonatomic, assign) NSInteger currentDownPage;//
@property(nonatomic, assign) NSInteger downIndex;

@property (nonatomic, strong) HWCircleView *circleView;
@end

@implementation ReleaseHWWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //开始检测网络
    [NetworkStatusManager startNetworkStatus];
    
    // Do any additional setup after loading the view.
    [self setNavigationItemTitle:@""];
    [self.view addSubview:self.webView];
    [self.navigationController.navigationBar.layer addSublayer:self.progressLayer];
    [self loadHtml];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(creatJSContex:) name:@"LLCreatJSContex" object:nil];
    [self creatProgressView];
//    [self requestQueryCartoonPages:@"c3e2f4ed-b3cd-444e-ac69-cfa821415a0e"];
  
}

- (void)creatProgressView{

    //圆圈
     self.circleView = [[HWCircleView alloc] initWithFrame:CGRectMake(0,0, 150, 150)];
     self.circleView.hidden = YES;
     self.circleView.center = self.view.center;
    [self.view addSubview: self.circleView];
   
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     
}

- (void)registerContext{
   
    
    self.jsContext = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    JSBridge * brigdge = [[JSBridge alloc] init];
    brigdge.delegate = self;
    self.jsContext[@"jiaoshiduan"] = brigdge;
    
}

- (UIWebView *)webView{
    
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _webView.delegate = self;
        _webView.scrollView.bounces =NO;
        
    }
    return _webView;
}

- (void)setupUserAget{

    UIWebView *tempWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString *oldAgent = [tempWebView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSLog(@"old agent :%@", oldAgent);
    
    
    NSString * newAgentT = [NSString stringWithFormat:@""];
    //add my info to the new agent
    NSString *newAgent = [oldAgent stringByAppendingString:newAgentT];
    //    NSLog(@"new agent :%@", newAgent);
    
    //regist the new agent
    NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:newAgent, @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
    
    
    
}



- (void)loadHtml{
    
    NSString * htmlCont = [NSString stringWithFormat:@"%@",  Request_Homework_webview_url];
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:EnvironmentIndex] == 2) {//181
        htmlCont = @"http://192.168.1.181/ajiau-res/mybook.html";
    }else if ([[NSUserDefaults standardUserDefaults] integerForKey:EnvironmentIndex] == 1) {//150
        htmlCont = @"http://218.76.7.150:8080/ajiau-appweb/mybook.html";
    }else if ([[NSUserDefaults standardUserDefaults] integerForKey:EnvironmentIndex] == 0) {//正式
        htmlCont = @"https://api.p.ajia.cn/ajiau-appweb/mybook.html";//
    }
    
    [self loadUrl:htmlCont];
 
}
- (void)loadUrl:(NSString *)urlStr{
 
   
    if (![NetworkStatusManager  isConnectNetwork])
    {
        self.webView.hidden = YES;
        [self showFailLoadErrorView];
        return;
    }
    NSURL * url = [NSURL URLWithString:urlStr];
    
    NSURLRequest * request =   [NSURLRequest requestWithURL: url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20];
    //添加header
    
    //传token
    NSString * token;
    if ([[SessionHelper sharedInstance] checkSession]) {
        
        token =  [[SessionHelper sharedInstance] getAppSession].token;
    }
    
    NSMutableURLRequest *mutableRequest = [request mutableCopy];    //拷贝request
    [mutableRequest setValue:token  forHTTPHeaderField:@"TOKEN"];
    request = [mutableRequest copy];        //拷贝回去
//     NSLog(@"%@", request.allHTTPHeaderFields);  //打印出header验证
    [self.webView loadRequest:request];
    
}
- (WebProgressLayer *)progressLayer{

    if (!_progressLayer) {
        _progressLayer = [WebProgressLayer new];
        _progressLayer.frame = CGRectMake(0, 42, IPHONE_WIDTH, 2);
        
    }
    return _progressLayer;
}
#pragma mark - UIWebViewDelegate

//-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
//    
// 
//    //这里加了一些判断，避免死循环，因为修改完成后webview需要重新加载request （其中DEFAULTS 是NSUserDefaults存了一些后台程序返回的内容）
//    NSMutableURLRequest *mutableReqeust = [request mutableCopy];
//    
//    NSString *token = [self findToken ];
//    [mutableReqeust addValue:token forHTTPHeaderField:@"auth-token"];
//    
// 
//    return YES;
//    
//}
//

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
//    NSString* usr =   request.URL.absoluteString;
//     NSString* string6 = [usr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSString * scheme =  request.URL.scheme;
//    NSString * host =  request.URL.host;
 
    if (![NetworkStatusManager  isConnectNetwork])
    {
        self.webView.hidden = YES;
        [self showFailLoadErrorView];
        return NO;
    }
    return [self getRequset:request];
}

- (BOOL )getRequset:(NSURLRequest *)request{
    
    
    NSString* usr =   request.URL.absoluteString;
    //iOS最简单的url编码
    NSString* urlAbsoluteString = [usr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSString * urlAbsoluteString = [request.URL.absoluteString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    if ([urlAbsoluteString containsString:@"ajiat://"]) {
        if ([urlAbsoluteString componentsSeparatedByString:@"type="]) {
            NSArray * tempArray = [urlAbsoluteString componentsSeparatedByString:@"type="];
            if ([tempArray isKindOfClass:[NSArray  class]] && [tempArray count] >1) {
                NSString * urlStr = tempArray[1];
                
                if ([urlStr componentsSeparatedByString:@"&params="]) {
                    NSArray * tempArray = [urlStr componentsSeparatedByString:@"&params="];
                    if ([tempArray isKindOfClass:[NSArray  class]] && [tempArray count] >1) {
                        NSString * type = tempArray[0];
                        if ([type integerValue] == 1) {
                            NSString *stringEncode = tempArray[1] ;
                             if (self.chooseBookBlock&& stringEncode && stringEncode.length>0 && ![stringEncode isEqualToString:@"[object Object]"]) {
                                self.chooseBookBlock( stringEncode);
                            }
                            //关闭 APP
                            [super backViewController];
                            return NO;
                        }else{
                             [self loadUrl:tempArray[1]];
                         }
                    }
                }
            }
        }
        
    }
    
     return YES;
}
-(void)creatJSContex:(NSNotification*)noti
{
//        NSLog(@"%@==creatJSContex",noti);
        //注意以下代码如果不在主线程调用会发生闪退。
        dispatch_async( dispatch_get_main_queue(), ^{
           [self registerContext];
//              NSLog(@"==creatJSContex");
            self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
                context.exception = exceptionValue;
                NSLog(@"异常信息：%@", exceptionValue);
            };
        });
    
    
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [_progressLayer startLoad];
    [self showHUDInfoByType:HUDInfoType_Loading];
   
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_progressLayer finishedLoad];
    self.webView.hidden = NO;
    self.errorView.hidden = YES;
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.shouldIntercept = YES;
//    NSString *alertJS=@"alert('GLOBLE_CONFIG.token')"; //准备执行的js代码
//    [self.context evaluateScript:alertJS];//通过oc方法调用js的alert
     [self hideHUD];
   
}



- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [_progressLayer finishedLoad];
    [self hideHUD];
    if ( [error.localizedDescription isEqualToString:@"请求超时。"] ) {
        self.webView.hidden = YES;
        [self showFailLoadErrorView];
        NSString * content = @"请求超时。102" ;
        [self showAlert:TNOperationState_Fail content:content block:^(NSInteger index) {
//            [self.webView goBack];
        }];
    }
 
       NSLog(@"=%s %@======%@==error==%zd=errorcode",__FUNCTION__,webView.request.URL.absoluteString,error.localizedDescription,error.code);
//
    
}
- (UIView *)errorView{

    if (!_errorView) {
        _errorView = [[UIView alloc]initWithFrame:self.webView.frame];
    }
    return _errorView;
}
- (void)showFailLoadErrorView{
 
    [self.view addSubview:self.errorView];
    self.errorView.hidden = NO;
    self.title = @"网页加载失败";
    UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 229/1.5, 207/1.5)];
    imageV.image = [UIImage imageNamed:@"not_Info"];
    imageV.center =CGPointMake( self.errorView.center.x,  self.errorView.center.y- 30) ;
    [self.errorView addSubview:imageV];
    
    
    NSString * resetStr = @"重新加载" ;
    UIButton * btn = [UIButton buttonWithType: UIButtonTypeCustom];
    [btn setFrame:CGRectMake(self.errorView.center.x - FITSCALE(130)/2, CGRectGetMaxY(imageV.frame)+10, FITSCALE(130), FITSCALE(40))];
    btn.titleLabel.font = fontSize_14;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[ProUtils createImageWithColor:project_main_blue withFrame:CGRectMake(0, 0, 1, 1)] forState:UIControlStateNormal];
    [btn setTitle:resetStr forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(loadHtml) forControlEvents:UIControlEventTouchUpInside];
    [self.errorView addSubview:btn];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = btn.frame.size.height/2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)backViewController{
    
    self.circleView.hidden = YES;
    //首先创建JSContext 对象（此处通过当前webView的键获取到jscontext）
//    JSContext *context=[self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    NSString *alertJS=@"backToMyBook()"; //准备执行的js代码
    JSValue *backJSValue = [self.jsContext evaluateScript:alertJS];//通过oc方法调用js的alert
//    NSLog(@"=backJSValue=%@",[backJSValue toString]);
   self.jsContext.exceptionHandler = ^ (JSContext *con , JSValue *exception){
        NSLog(@"exception~~~~~~~~~~~~~~~~~%@", exception);
        con.exception = exception;
    };
    
   NSString * backValue =  [self.webView stringByEvaluatingJavaScriptFromString:@"backToMyBook()"];
 
    if ( [backValue length]>0 && ![backValue  isEqualToString: @"undefined"] ) {
//        NSLog(@"%s-%@-",__FUNCTION__,backValue );
        [self loadUrl:backValue ];
        
    }else{
        if ([self.title   isEqualToString:@"我的书架"]) {
             [super backViewController];
        }else{
            if (self.webView.hidden ) {
                 [super backViewController];
            }else{
                if ([self.webView canGoBack]) {
                    [self.webView goBack];
                }else{
                    [super backViewController];
                }
            
            }
        }
    }
     [self.playerView resetPlayer];
 }
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.progressLayer removeFromSuperlayer];
     [self.playerView resetPlayer];
}
- (void)dealloc {
    
    [_progressLayer closeTimer];
    [_progressLayer removeFromSuperlayer];
    _progressLayer = nil;
    [self setWebView:nil];
 
     [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LLCreatJSContex" object:nil];
    
}

#pragma mark - JSExport Methods


//指定跳转url
- (void)handleGotoUrl:(NSString *)url{

    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

//选的的布置书本作业信息
- (void)handlechooseBookwork:(NSString *)str{
    
    self.bookworkInfo = str;
    
}

#pragma mark ----
 
- (ZFPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [ZFPlayerView sharedPlayerView];
        _playerView.delegate = self;
        // 当cell播放视频由全屏变为小屏时候，不回到中间位置
        _playerView.cellPlayerOnCenter = NO;
         ZFPlayerShared.isLockScreen = YES;
        // 当cell划出屏幕的时候停止播放
//             _playerView.stopPlayWhileCellNotVisable = YES;
        //（可选设置）可以设置视频的填充模式，默认为（等比例填充，直到一个维度到达区域边界）
        // _playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
        // 静音
        // _playerView.mute = YES;
    }
    return _playerView;
}
- (void)zf_playerItemStatusFailed:(NSError *)error{
//    NSString * content = @"语音播放失败！请稍后再试";
//    [self showAlert:TNOperationState_Fail content:content block:^(NSInteger index) {
//        
//    }];
    //首先创建JSContext 对象（此处通过当前webView的键获取到jscontext）
   
    NSString *alertJS =  @"playError()"; //准备执行的js代码
    [ self.jsContext evaluateScript:alertJS];//通过oc方法调用js的alert
     self.jsContext.exceptionHandler = ^ (JSContext *con , JSValue *exception){
        NSLog(@"exception~~~~~~~~~~~~~~~~~%@", exception);
        con.exception = exception;
    };
}


/**开始播放 调用js方法*/
- (void)zf_playerItemStartPlayer{
//  JSContext *context=[self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//     NSString *alertJS=@"startPlayer()";
//    [context evaluateScript:alertJS];
    
}

/**播放完成 调用js方法*/
- (void)zf_playerItemPlayerComplete{


//    JSContext *context=[self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
     NSString * alertStr =   [NSString stringWithFormat:@"'%@'",self.playModel];
   
//    alertStr = [alertStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    alertStr = [alertStr stringByReplacingOccurrencesOfString:@" " withString:@""];
//    alertStr = [alertStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
   
    NSString *alertJS =[NSString stringWithFormat:@"playEnd(%@)",alertStr];

    [ self.jsContext evaluateScript:alertJS];
    
    self.jsContext.exceptionHandler = ^ (JSContext *con , JSValue *exception){
        NSLog(@"exception~~~~~~~~~~~~~~~~~%@", exception);
        con.exception = exception;
    };

}


#pragma mark ---JSBridgePlayerPlayerDelegate

//开始播放
- (void)startPlayerUrl:(id)urlStr{

    self.playModel =urlStr;
//     NSLog(@"==url=---%s",__FUNCTION__);
    [self stopPlayer];
 
    NSDictionary * json = [NSJSONSerialization JSONObjectWithData:[GTMBase64 decodeString:urlStr]  options:NSJSONReadingAllowFragments error:nil];
    //网络音频url
//    NSURL * playurl = [NSURL URLWithString:json[@"urlStr"]];
    if (json && [json[@"urlStr"] length]>0) {
 
        //本地音频url
        NSURL * playurl = [NSURL fileURLWithPath:json[@"urlStr"]];
        [self playerAudio:playurl];
    }else{
        NSLog(@"%s=方法=参数数据格式问题==json=%@",__FUNCTION__,json);
    }
    

}

- (void)playerAudio:(NSURL *)url{

    //   URL
    NSURL *videoURL = url;
    
    ZFPlayerModel *playerModel = [[ZFPlayerModel alloc] init];
    playerModel.videoURL         = videoURL;
  
    [self.playerView playerControlView:[UIView new] playerModel:playerModel playerView:[UIView new]];
    // 下载功能
    self.playerView.hasDownload = NO;
   
    [self.playerView hiddenContentView];
    // 自动播放
    [self.playerView autoPlayTheVideo];
     
}



//停止播放
- (void)stopPlayer{
    [self.playerView resetPlayer];
}
//暂停播放
- (void)suspendedPlayer{

    NSLog(@"----暂停");
    [self.playerView pause];
}

//恢复播放
-(void)restorePlayer{
    NSLog(@"----恢复");
     [self.playerView play];
}


- (void)exitLogin{

    [[SessionHelper sharedInstance] clearMessageList];
 
     [[SessionHelper sharedInstance] clearSaveCacheSession];
    [[UINavigationBar appearance] setTintColor:project_main_blue];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
//    LoginController * loginVC = [[LoginController alloc]initWithNibName:NSStringFromClass([LoginController class]) bundle:nil];
 
//    
//    UINavigationController * loginNaviVC =  [[UINavigationController alloc]initWithRootViewController:loginVC];
//    [self presentViewController:loginNaviVC animated:NO completion:nil];
    [self gotoLoginViewController];
    
}
- (void)startDownLoadAudio:(id)bookIdObj{

    NSDictionary * json = [NSJSONSerialization JSONObjectWithData:[GTMBase64 decodeString:bookIdObj]  options:NSJSONReadingAllowFragments error:nil];
    NSString *bookId  = json[@"bookId"];
    
    [self requestQueryCartoonPages:bookId];
}
#pragma mark --------
- (id)getPlayerAudioURL{
    
  
    NSMutableArray * playerURLArray =  [[NSMutableArray alloc]init];
    for (int i = 0; i< [self.callCartoonBookArray  count]; i++) {
        NSArray  *tempArray = self.callCartoonBookArray[i];
        NSString * tempStr = [NSString stringWithFormat:@"[%@]",[tempArray componentsJoinedByString:@","]];
        [playerURLArray addObject:tempStr];
    }
    
//    NSArray * array = [self getPlayerURLs];
    NSString * playUrls =[NSString stringWithFormat: @"[%@]",[playerURLArray componentsJoinedByString:@","]];
    return  playUrls;
}

//- (NSArray *)getPlayerURLs{
//
//    NSMutableArray * array = [[NSMutableArray alloc]init];
//    NSString  * pathResource = @"";
//    NSInteger page = 0;
//    NSInteger number = 0;
//    for (int i = 1; i< 10; i++) {
//         NSMutableArray * tempArray = [[NSMutableArray alloc]init];
//        NSInteger tempJ = 0;
//        if (i == 1) {
//            tempJ = 2;
//        }
//        if (i == 2) {
//            tempJ = 4;
//        }
//        if (i == 3) {
//            tempJ = 4;
//        }
//        if (i == 4) {
//            tempJ = 4;
//        }
//        if (i == 5) {
//            tempJ = 4;
//        }
//        if (i == 6) {
//            tempJ = 2;
//        }
//        if (i == 7) {
//            tempJ = 4;
//        }
//        if (i == 8) {
//            tempJ = 2;
//        }
//        if (i == 9) {
//            tempJ = 2;
//        }
//        
//        
//        for (int j = 1;j < tempJ ; j++) {
//            
//            page = i;
//            number = j;
//            pathResource = [NSString stringWithFormat:@"%d-%d",i,j];
//            
//            NSString *playUrl = [[NSBundle mainBundle] pathForResource:pathResource ofType:@"mp3"];
//            
//            [tempArray addObject:[ProUtils dictionaryToJson:@{@"page":@(page),@"number":@(number),@"url":playUrl}]];
//        }
//        [array addObject:[NSString stringWithFormat:@"[%@]",[tempArray componentsJoinedByString:@","]]];
//        
//        
//    }
//    
////    NSLog(@"%@",array);
//    return array;
//}

#pragma mark ------
//书本id  c3e2f4ed-b3cd-444e-ac69-cfa821415a0e
- (void)requestQueryCartoonPages:(NSString *)bookId{

    self.startedBlock = nil;
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_QueryCartoonPages] parameterDic:@{@"bookId":bookId} requestMethodType:RequestMethodType_POST requestTag:NetRequestType_QueryCartoonPages];
}

- (NSMutableArray *)callCartoonBookArray{

    if (!_callCartoonBookArray) {
        _callCartoonBookArray = [[NSMutableArray alloc]init];
    }
    return _callCartoonBookArray;
}
- (NSMutableArray *)cartoonBookDownloadUrlArray{

    if (!_cartoonBookDownloadUrlArray ) {
        _cartoonBookDownloadUrlArray = [[NSMutableArray alloc]init];
        
    }
    
    return _cartoonBookDownloadUrlArray;
}
- (void)setNetworkRequestStatusBlocks{

    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
       STRONGSELF
        if (request.tag == NetRequestType_QueryCartoonPages) {
            NSArray * pagesArray = successInfoObj[@"pages"];
//            strongSelf.cartoonBookArray = pagesArray;
            [strongSelf.cartoonBookDownloadUrlArray  removeAllObjects];
            [strongSelf.callCartoonBookArray removeAllObjects];
            if (pagesArray.count > 0) {
                for (int i = 0; i <[pagesArray  count]; i++) {
                     NSDictionary *pageDic = pagesArray[i];
                     NSArray * sentences = pageDic[@"sentences"];
                    for (int j = 0; j< [sentences count]; j++) {
                         NSDictionary * sectenceDic = sentences[j];
                         NSString * audioUrl = sectenceDic[@"voice"];
                        NSDictionary * dic =  @{@"page":@(i+1),@"nubmer":@(j+1),@"url":audioUrl};
                        [strongSelf.cartoonBookDownloadUrlArray addObject:dic];
                      
                    }
                    if (!sentences ||(sentences && sentences== 0)) {
                        
                        NSString * content = [NSString stringWithFormat:@"第%zd页,音频资源下载失败",i+1];
                        [strongSelf showAlert:TNOperationState_Fail content:content block:^(NSInteger index) {
                            [strongSelf.webView goBack];
                        }];
                        return ;
                    }
                 
                 
                }
            }
 
            if ([strongSelf.cartoonBookDownloadUrlArray count]>0) {

//                strongSelf.downIndex = 0;
                strongSelf.currentDownPage = 0;
                NSString *urlSr = strongSelf.cartoonBookDownloadUrlArray.firstObject[@"url"];
                
                //准备从远程下载文件
//                [strongSelf downFileFromServer:urlSr];
//                //开始下载
//                [strongSelf.downloadTask resume];
                dispatch_async(dispatch_get_main_queue(), ^{
                   strongSelf.circleView.progress = 0;
                    strongSelf.circleView.hidden = NO;
                });
                
                
                [strongSelf downLoadAudio:urlSr];
 
                
            }
        }
    }];
    

    
}

-(BOOL)cacheFileExistsAudioAtPath:(NSString *)audioPath{
    BOOL isExists = NO;
    NSString* cacheFolder= [self gatCacheFileAudioAtPath:audioPath];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    isExists = [fileManager fileExistsAtPath:cacheFolder];
    return isExists;
}

- (NSString *)gatCacheFileAudioAtPath:(NSString *)audioPath{
    NSArray * array = [audioPath componentsSeparatedByString:@"/"];
    NSString *suggestedFilename = array.lastObject;
    //指定缓存文件路径
    NSString *cacheFolder=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    cacheFolder=[cacheFolder stringByAppendingPathComponent: suggestedFilename];
    return cacheFolder;
}
#pragma mark ---
- (void)downLoadAudio:(NSString *)audioURLStr{
    
    WEAKSELF
//    strongSelf.downIndex ++;
    
    [[HSDownloadManager sharedInstance] download:audioURLStr progress:^(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    } state:^(DownloadState state,NSString *url) {
        STRONGSELF
        if (state == DownloadStateCompleted) {
            
            for (int i = 0; i< [strongSelf.cartoonBookDownloadUrlArray count]; i++) {
                NSDictionary * dic = strongSelf.cartoonBookDownloadUrlArray[i];
                if ([url isEqualToString:dic[@"url"]]) {
                    [strongSelf setupDownloadIndex: i+1 withDownFilePath:[[HSDownloadManager sharedInstance] getFileAudioPath:url]];
                    if (i == [strongSelf.cartoonBookDownloadUrlArray count]-1) {
                        NSLog(@"===%zd===下载完毕",i);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSString *alertJS =[NSString stringWithFormat:@"audioDownLoadFinish()"];
                            [strongSelf.jsContext evaluateScript:alertJS];
                            strongSelf.jsContext.exceptionHandler = ^ (JSContext *con , JSValue *exception){
                                con.exception = exception;
                            };
                            
                            strongSelf.circleView.progress = 1.00;
                            strongSelf.circleView.hidden = YES;
                            
                        });
                        
                    }else{
//                        NSLog(@"==%zd===开始下载",i+1);
                        float download = (float)(i+1)/(float)[strongSelf.cartoonBookDownloadUrlArray count];
                        NSLog(@"%f===",download);
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            strongSelf.circleView.progress = download;
                            strongSelf.circleView.hidden = NO;
                            
                        });

                        
                        [strongSelf downLoadAudio:strongSelf.cartoonBookDownloadUrlArray[i+1][@"url"]];
                        
                    }
                }
                
            }
        }
        
        
    }];
    
 
}

- (NSString *)updateFinish{

    return [NSString stringWithFormat:@"%zd",self.currentDownPage];
}

/*
- (void)downFileFromServer:(NSString *)audioUrlStr{
 
  
    WEAKSELF
    STRONGSELF
    strongSelf.downIndex ++;
    
//    //检查地址是否下载
//    if ([strongSelf cacheFileExistsAudioAtPath:audioUrlStr]) {
//        NSString* cacheFolder= [self gatCacheFileAudioAtPath:audioUrlStr];
//        [strongSelf  setupDownloadIndex: strongSelf.downIndex withDownFilePath:cacheFolder];
//        
//        return;
//    }
    
    if (audioUrlStr.length <= 0) {
        //下载完成后 进行下一个任务
        if ( strongSelf.downIndex < weakSelf.cartoonBookDownloadUrlArray.count) {
            [weakSelf downFileFromServer:weakSelf.cartoonBookDownloadUrlArray[ strongSelf.downIndex] [@"url"]];
        }
        return ;
    }
    NSURL *URL = [NSURL URLWithString:audioUrlStr];
    
    //默认配置
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    //AFN3.0+基于封住URLSession的句柄
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    //请求
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    //下载Task操作
    self.downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        // @property int64_t totalUnitCount;     需要下载文件的总大小
        // @property int64_t completedUnitCount; 当前已经下载的大小
        //        downloadProgress.totalUnitCount;
        //        downloadProgress.completedUnitCount;
        
        // 给Progress添加监听 KVO
        
        // 回到主队列刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            // 设置进度条的百分比
          
        });
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        // 要求返回一个URL, 这个URL就是文件的位置的路径
        
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *path = [cachesPath stringByAppendingPathComponent:response.suggestedFilename];
        
        return [NSURL fileURLWithPath:path];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
//            NSString *alertJS =  @"playError()"; //准备执行的js代码
//            [ self.jsContext evaluateScript:alertJS];//通过oc方法调用js的alert
//            self.jsContext.exceptionHandler = ^ (JSContext *con , JSValue *exception){
//         
//                con.exception = exception;
//            };
            
            
            return ;
        }
        STRONGSELF
        [strongSelf setupDownloadIndex: strongSelf.downIndex withDownFilePath:[filePath path]];
        //设置下载完成操作
//         filePath就是下载文件的位置, [filePath path];// 将NSURL转成NSString
        NSLog(@"[filePath path] ==%@",[filePath path]);
//        if (downIndex -1 == 0) {
//            weakSelf.currentDownPage ++;
//            NSDictionary * currentDic= weakSelf.cartoonBookDownloadUrlArray[downIndex -1];
//            NSMutableDictionary * tempDic =  [[NSMutableDictionary alloc]initWithDictionary:currentDic];
//            //修改为本地播放地址
//            [tempDic setObject:[filePath path] forKey:@"url"];
//            NSString * tempDicStr = [ProUtils dictionaryToJson:tempDic];
//            NSMutableArray * tempArray =  [[NSMutableArray alloc]initWithObjects:tempDicStr, nil];
//            [weakSelf.callCartoonBookArray addObject: tempArray];
//            
//        }else{
//            //
//          NSDictionary * currentDic= weakSelf.cartoonBookDownloadUrlArray[downIndex -1];
//            //前一条
//          NSDictionary * preDic= weakSelf.cartoonBookDownloadUrlArray[downIndex -2];
//          NSMutableDictionary * tempDic =  [[NSMutableDictionary alloc]initWithDictionary:currentDic];
//            //修改为本地播放地址
//          [tempDic setObject:[filePath path] forKey:@"url"];
//            //在同一页
//            if ( [currentDic[@"page"] integerValue] == [preDic[@"page"] integerValue]) {
//                NSMutableArray *currentPageArray =[[NSMutableArray alloc]initWithArray: weakSelf.callCartoonBookArray[[currentDic[@"page"] integerValue]-1]];
//                
//                 NSString * tempDicStr = [ProUtils dictionaryToJson:tempDic];
//                  [currentPageArray addObject:tempDicStr];
//                 NSInteger index = [currentDic[@"page"] integerValue]-1;
//                [weakSelf.callCartoonBookArray replaceObjectAtIndex:index  withObject:currentPageArray];
//                
//            }else{
//                 self.currentDownPage ++;
//                NSMutableArray *currentPageArray = [NSMutableArray array];
//                NSString * tempDicStr = [ProUtils dictionaryToJson:tempDic];
//                [currentPageArray addObject:tempDicStr];
//                [weakSelf.callCartoonBookArray addObject:currentPageArray];
//               
//            }
//            
//        }
//        
//        NSString * alertStr =   [NSString stringWithFormat:@"'%zd'",weakSelf.currentDownPage];
//        NSString *alertJS =[NSString stringWithFormat:@"updateFinish(%@)",alertStr];
//        [ self.jsContext evaluateScript:alertJS];
//        self.jsContext.exceptionHandler = ^ (JSContext *con , JSValue *exception){
//            NSLog(@"exception~~~~~~~~~~~~~~~~~%@", exception);
//            con.exception = exception;
//        };
//        //下载完成后 进行下一个任务
//       if (downIndex < weakSelf.cartoonBookDownloadUrlArray.count) {
//             [weakSelf downFileFromServer:weakSelf.cartoonBookDownloadUrlArray[downIndex][@"url"]];
//            //开始下载
//            [_downloadTask resume];
//        }else{
//           NSLog(@"--最后一个下载完成-%d==%@",downIndex,weakSelf.callCartoonBookArray);
//        }
        
    }];
   
    
}
*/

- (void)setupDownloadIndex:(NSInteger )downloadIndex withDownFilePath:(NSString *)filePath{

    WEAKSELF
    STRONGSELF
    if (downloadIndex -1 == 0) {
        strongSelf.currentDownPage ++;
        NSDictionary * currentDic= strongSelf.cartoonBookDownloadUrlArray[downloadIndex -1];
        NSMutableDictionary * tempDic =  [[NSMutableDictionary alloc]initWithDictionary:currentDic];
        //修改为本地播放地址
        [tempDic setObject:filePath forKey:@"url"];
        NSString * tempDicStr = [ProUtils dictionaryToJson:tempDic];
        NSMutableArray * tempArray =  [[NSMutableArray alloc]initWithObjects:tempDicStr, nil];
        [strongSelf.callCartoonBookArray addObject: tempArray];
        
//        NSString * alertStr =   [NSString stringWithFormat:@"'%zd'",strongSelf.currentDownPage];
//        NSString *alertJS =[NSString stringWithFormat:@"updateFinish(%@)",alertStr];
//        [ strongSelf.jsContext evaluateScript:alertJS];
    }else{
        //
        NSDictionary * currentDic = strongSelf.cartoonBookDownloadUrlArray[downloadIndex -1];
        //前一条
        NSDictionary * preDic= strongSelf.cartoonBookDownloadUrlArray[downloadIndex -2];
        NSMutableDictionary * tempDic =  [[NSMutableDictionary alloc]initWithDictionary:currentDic];
        //修改为本地播放地址
        [tempDic setObject:filePath forKey:@"url"];
        //在同一页
        if ( [currentDic[@"page"] integerValue] == [preDic[@"page"] integerValue]) {
            NSMutableArray *currentPageArray =[[NSMutableArray alloc]initWithArray: strongSelf.callCartoonBookArray[[currentDic[@"page"] integerValue]-1]];
            
            NSString * tempDicStr = [ProUtils dictionaryToJson:tempDic];
            [currentPageArray addObject:tempDicStr];
            NSInteger index = [currentDic[@"page"] integerValue]-1;
            [strongSelf.callCartoonBookArray replaceObjectAtIndex:index  withObject:currentPageArray];
            
        }else{
            strongSelf.currentDownPage ++;
            NSMutableArray *currentPageArray = [NSMutableArray array];
            NSString * tempDicStr = [ProUtils dictionaryToJson:tempDic];
            [currentPageArray addObject:tempDicStr];
            [strongSelf.callCartoonBookArray addObject:currentPageArray];
            
//            NSString * alertStr =   [NSString stringWithFormat:@"'%zd'",strongSelf.currentDownPage];
//            NSString *alertJS =[NSString stringWithFormat:@"updateFinish(%@)",alertStr];
//            [ strongSelf.jsContext evaluateScript:alertJS];
            
        }
        
    }
    
    strongSelf.jsContext.exceptionHandler = ^ (JSContext *con , JSValue *exception){
//        NSLog(@"exception~~~~~~~~~~~~~~~~~%@", exception);
        con.exception = exception;
    };
    //下载完成后 进行下一个任务
    if ( downloadIndex < strongSelf.cartoonBookDownloadUrlArray.count) {
//        [strongSelf downFileFromServer:weakSelf.cartoonBookDownloadUrlArray[downloadIndex][@"url"]];
//        [strongSelf.downloadTask resume];
        
//        [strongSelf downLoadAudio:weakSelf.cartoonBookDownloadUrlArray[downloadIndex][@"url"]];
        
          NSLog(@"- downLoadAudio");
    }else{
        
    
//        NSString *alertJS =[NSString stringWithFormat:@"audioDownLoadFinish()"];
//        [strongSelf.jsContext evaluateScript:alertJS];
//        strongSelf.jsContext.exceptionHandler = ^ (JSContext *con , JSValue *exception){
//           
//            con.exception = exception;
//        };
        
    }
    
    
}
#pragma mark ---

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
