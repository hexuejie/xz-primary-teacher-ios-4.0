//
//  RecommendedViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/6/20.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "RecommendedViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "GTMBase64.h"
#import "ShareManagerUtils.h"
#import "LXActivity.h"
#import "SessionModel.h"
#import "SessionHelper.h"
#import "WebProgressLayer.h"
@interface RecommendedViewController ()<UIWebViewDelegate,LXActivityDelegate>
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, copy) NSString *shareContentStr;
@property (nonatomic, strong) WebProgressLayer *progressLayer; ///< 网页加载进度条
@end

@implementation RecommendedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationItemTitle:@"推荐好友"];
    [self.view addSubview:self.webView];
    [self.view.layer addSublayer:self.progressLayer];
  
    // Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //开始检测网络
    [NetworkStatusManager startNetworkStatus];
    [self resetUserAgent];
    [self loadHtml];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)resetUserAgent{
    
    UIWebView *tempWebView = [UIWebView new];
    NSString *oldAgent = [tempWebView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSLog(@"old agent :%@", oldAgent);
    
    //重置 navigator.userAgent 过滤上次添加的值
    if ([[oldAgent componentsSeparatedByString:@"UserAgent"] count]>1) {

        NSArray * userAgentArray = [oldAgent componentsSeparatedByString:@"UserAgent"];
        if(userAgentArray[1] && [(NSString *)userAgentArray[1] length]>0){

            oldAgent = userAgentArray[0];
        }
    }
    
//    //add my info to the new agent
    NSString *newAgent = [oldAgent stringByAppendingString:[self getNewAgent]];
    //    NSLog(@"new agent :%@", newAgent);

    //regist the new agent
    NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:newAgent, @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
}
- (NSString *)getNewAgent{
    
    //    NickName=13739060010$code=170497$school=长沙市雨花区车站南路小学;
    NSString * nickName = [NSString stringWithString:[[SessionHelper sharedInstance] getAppSession].name];
    NSString * code = [NSString  stringWithString: [[SessionHelper sharedInstance]getAppSession].inviteCode];
    NSString * school = @"";
    if ([[SessionHelper sharedInstance]getAppSession].schoolName ) {
        school = [NSString stringWithString:[[SessionHelper sharedInstance]getAppSession].schoolName ];
    }else{
#warning -----
        NSLog(@"错误---未找到学校名字=====");
    }
    
    NSString * newAgentT = [NSString stringWithFormat:@"UserAgent$$$NickName=%@$code=%@$school=%@$$$",nickName,code,school];
    return newAgentT;
}
- (void)loadHtml{
   
    if (![NetworkStatusManager  isConnectNetwork])
    {
        
    }
    
    NSString * htmlCont = [NSString stringWithFormat:@"%@",HEADURL_RECOMMENDED_WEB];
 
    if ([[NSUserDefaults standardUserDefaults] integerForKey:EnvironmentIndex] == 2) {//181
        htmlCont = @"http://192.168.1.181/ajiau-res/recommend/rec_teacher.html";//
    }else if ([[NSUserDefaults standardUserDefaults] integerForKey:EnvironmentIndex] == 1) {//150
        htmlCont = @"https://api.p.ajia.cn/ajiau-appweb/recommend/rec_teacher.html";//
    }else if ([[NSUserDefaults standardUserDefaults] integerForKey:EnvironmentIndex] == 0) {//正式
        htmlCont = @"https://api.p.ajia.cn/ajiau-appweb/recommend/rec_teacher.html";//
    }
    
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:htmlCont]];
    [self.webView loadRequest:request];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
//    [self showHUDInfoByType:HUDInfoType_Loading];
      [self.progressLayer startLoad];
}
- (WebProgressLayer *)progressLayer{
    if (!_progressLayer) {
        _progressLayer = [WebProgressLayer layerWithFrame:CGRectMake(0, -1, IPHONE_WIDTH, 2)];
    }
    return _progressLayer;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
//    [self hideHUD];
    [self.progressLayer finishedLoad];
    [self shareContentData];
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
     [self.progressLayer finishedLoad];
    [self showAlert:TNOperationState_Fail content:@"加载失败,请稍后再试"];
//    [self hideHUD];
}

- (void)shareContentData{
    
    JSContext *context = [self.webView  valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    __weak __typeof(self)weakSelf = self;
    //    //检查点击的方法
    
    context[@"jiaoshiduan"] = ^() {
        NSLog(@"+++++++Begin Log+++++++");
        NSArray *args = [JSContext currentArguments];
        __strong __typeof__(weakSelf) strongSelf = weakSelf;
        
        for (JSValue *jsVal in args) {
            //            NSLog(@"%@", jsVal.toString);
            NSData *EncryptData = [GTMBase64 decodeData:[jsVal.toString dataUsingEncoding:NSUTF8StringEncoding]];
            NSString *base64EncodedString = [[NSString alloc]initWithData:EncryptData encoding:NSUTF8StringEncoding];
            strongSelf.shareContentStr =  base64EncodedString;
           
        }
        //        JSValue *this = [JSContext currentThis];
        //        NSLog(@"this: %@",this);
        //        NSLog(@"-------End Log-------");
        if (strongSelf.shareContentStr) {
            [strongSelf showShareView];
        }
    };
    
    
    context = nil;
}

- (void)showShareView{
     
    
    NSMutableArray *shareButtonTitleArray = [NSMutableArray arrayWithArray:@[@"微信好友",@"朋友圈",@"QQ好友"]];
    NSMutableArray *shareButtonImageNameArray =[NSMutableArray arrayWithArray:@[@"sns_icon_WX",@"sns_icon_WXCircle",@"sns_icon_QQ"]];
    LXActivity *lxActivity = [[LXActivity alloc]initWithTitle:@"分享到:"
                                                     delegate:self
                                            cancelButtonTitle:@"取消" ShareButtonTitles:shareButtonTitleArray
                                    withShareButtonImagesName:shareButtonImageNameArray];
    
    [lxActivity showInView:[UIApplication sharedApplication].keyWindow];
}
#pragma mark - LXActivityDelegate

- (void)didClickOnImageIndex:(NSInteger )imageIndex
{
    NSDictionary * shareInfo = [NSJSONSerialization JSONObjectWithData:[self.shareContentStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
    
    NSDictionary * infoDic =  @{informationAppDownloadUrlkey:shareInfo[@"url"],informationTitlekey:shareInfo[@"title"],informationSubtitlekey:shareInfo[@"content"],informationContentImgIconKey: shareInfo[@"imgPath"]};
    
    
    switch (imageIndex) {
        case  0:{
            [[ShareManagerUtils shareManager]shareInformationWithContentDic:infoDic rootViewController:self shareType:ShareManagerType_WXFriend shareContentType:ShareContentType_Line];
        }
            
            break;
            
        case 1:{
            [[ShareManagerUtils shareManager]shareInformationWithContentDic:infoDic rootViewController:self shareType:ShareManagerType_WXTimeline shareContentType:ShareContentType_Line];
        }
            
            break;
            
        case 2:{
            [[ShareManagerUtils shareManager]shareInformationWithContentDic:infoDic rootViewController:self shareType:ShareManagerType_QQFriend shareContentType:ShareContentType_Line];
        }
            
            break;
        case 3:{
            
            [[ShareManagerUtils shareManager]shareInformationWithContentDic:infoDic rootViewController:self shareType:ShareManagerType_QQZone shareContentType:ShareContentType_Line];
        }
            break;
        default:
            break;
    }
}

- (void)didClickOnCancelButton
{
    NSLog(@"didClickOnCancelButton");
}

- (UIWebView *)webView{
    
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _webView.delegate = self;
        _webView.scrollView.bounces =NO;
        
    }
    return _webView;
}

- (void)dealloc{

    self.webView = nil;
     [self clearDelegate];
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
     [_progressLayer finishedLoad];
}
@end
