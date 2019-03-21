//
//  InformationDetailViewController.m
//  TeacherPro
//
//  Created by DCQ on 2018/6/21.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "InformationDetailViewController.h"
#import "WebProgressLayer.h"
#import "SessionModel.h"
#import "SessionHelper.h"
#import "ShareManagerUtils.h"
#import "LXActivity.h"
#import "HomeListModel.h"
@interface InformationDetailViewController ()<UIWebViewDelegate,LXActivityDelegate>
@property(nonatomic, strong) HomeNewsModel * model;
@property(nonatomic, copy) NSString  * loadWebUrl;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) WebProgressLayer *progressLayer; ///< 网页加载进度条
@property(nonatomic, assign) InformationDetailType   style;
@end

@implementation InformationDetailViewController
- (instancetype)initWithModel:(HomeNewsModel *)newsModel{
    self = [super init];
    if (self) {
        self.model = newsModel;
        self.style = InformationDetailType_newsDetail;
    }
    return self;
}

- (instancetype)initWithUrl:(NSString *)url withStyle:(InformationDetailType )style{
    self = [super init];
    if (self) {
        self.loadWebUrl = url;
        self.style = style;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString * titleStr = @"";
    BOOL isShowShare = NO;
    if (self.style == InformationDetailType_newsDetail) {
        titleStr = @"资讯详情";
        if (self.model.shareUrl && self.model.shareUrl.length >0) {
            isShowShare = YES;
        }
        [self requestAddNewsReadCount];
    }else if (self.style == InformationDetailType_advDetail){
         titleStr = @"详情";
         isShowShare = NO;
    }
    [self setNavigationItemTitle:titleStr];
    [self.view addSubview:self.webView];
    [self.view.layer addSublayer:self.progressLayer];
    if (isShowShare) {
         [self setupRightItem];
    }

}

- (void)requestAddNewsReadCount{
    
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_AddNewsReadCount] parameterDic:@{@"newsId":self.model.newsId} requestMethodType:RequestMethodType_POST requestTag:NetRequestType_AddNewsReadCount];
    
}

- (void)setNetworkRequestStatusBlocks{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_AddNewsReadCount) {
            if (successInfoObj[@"readCount"]) {
                if (strongSelf.newsBlock) {
                     strongSelf.newsBlock(strongSelf.indexPath, successInfoObj[@"readCount"]);
                }
               
            }
        }
    }];
}
- (void)setupRightItem{
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"share_detail"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(shareAction)];
    self.navigationItem.rightBarButtonItem = rightBtn;
}
- (BOOL )getShowBackItem{
    return YES;
}
- (BOOL )getNavBarBgHidden{
    return  NO;
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
    
    NSString * htmlCont =  @"";
    if (self.style == InformationDetailType_newsDetail) {
        htmlCont = self.model.newsUrl;
    }else if (self.style == InformationDetailType_advDetail){
        htmlCont = self.loadWebUrl;
    }
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:htmlCont]];
    [self.webView loadRequest:request];
    
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
    
    [self.progressLayer finishedLoad];
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self.progressLayer finishedLoad];
    [self showAlert:TNOperationState_Fail content:@"加载失败,请稍后再试"];
    //    [self hideHUD];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)shareAction{
    
    
    
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
    NSString * shareUrl = @"";
    NSString * shareTitle = @"";
    NSString * shareDesc = @"";
    NSString * shareLogo = @"";
    
    if (self.model.shareUrl) {
        shareUrl = self.model.shareUrl;
    }
    if (self.model.shareTitle) {
         shareTitle = self.model.shareTitle;
    }
    if(self.model.shareDesc){
        shareDesc = self.model.shareDesc;
    }
    if(self.model.shareLogo){
        shareLogo = self.model.shareLogo;
    }
    
    NSDictionary * infoDic =  @{informationAppDownloadUrlkey:shareUrl ,informationTitlekey:shareTitle ,informationSubtitlekey:shareDesc ,informationContentImgIconKey: shareLogo};
    
    
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

@end
