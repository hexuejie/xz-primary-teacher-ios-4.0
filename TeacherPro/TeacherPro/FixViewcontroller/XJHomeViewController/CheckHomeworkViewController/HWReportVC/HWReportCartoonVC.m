

//
//  HWReportCartoonVC.m
//  TeacherPro
//
//  Created by DCQ on 2018/8/2.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "HWReportCartoonVC.h"
#import "WebProgressLayer.h"
#import "ProUtils.h"

@interface HWReportCartoonVC ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) WebProgressLayer * progressLayer;
@property (nonatomic, copy) NSString * studentId;
@property (nonatomic, copy) NSString * bookId;
@property (nonatomic, strong) UIView * errorView;
@end

@implementation HWReportCartoonVC
- (instancetype)initWithStudentId:(NSString *)studentId withBookId:(NSString *)bookId{
    self = [super init];
    if (self) {
        self.studentId = studentId;
        self.bookId = bookId;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationItemTitle:@""];
    [self.view addSubview:self.webView];
    [self.navigationController.navigationBar.layer addSublayer:self.progressLayer];
    [self loadHtml];
}

- (void)loadHtml{
    
    NSString *str = Invitation_Student_Cartoon_internal;
    if ([[NSUserDefaults standardUserDefaults] integerForKey:EnvironmentIndex] == 2) {//181
        str = @"http://192.168.1.181/ajiau-res/student/share_cartoon.html";//
    }else if ([[NSUserDefaults standardUserDefaults] integerForKey:EnvironmentIndex] == 1) {//150
        str = @"http://218.76.7.150:8080/ajiau-appweb/student/share_cartoon.html";//
    }else if ([[NSUserDefaults standardUserDefaults] integerForKey:EnvironmentIndex] == 0) {//正式
        str = @"https://api.p.ajia.cn/ajiau-appweb/student/share_cartoon.html";//
    }
    
    NSString * htmlCont = [NSString stringWithFormat:@"%@?bookId=%@&studentId=%@",str,self.bookId,self.studentId];
    [self loadUrl:htmlCont];
    
}
- (void)loadUrl:(NSString *)urlStr{
    
    
    if (![NetworkStatusManager  isConnectNetwork])
    {
        self.webView.hidden = YES;
        
        return;
    }
    NSURL * url = [NSURL URLWithString:urlStr];
    
    NSURLRequest * request =   [NSURLRequest requestWithURL: url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20];
    
    [self.webView loadRequest:request];
    
}

- (UIView *)errorView{
    
    if (!_errorView) {
        _errorView = [[UIView alloc]initWithFrame:self.webView.frame];
    }
    return _errorView;
}
- (UIWebView *)webView{
    
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _webView.delegate = self;
        _webView.scrollView.bounces =NO;
        
    }
    return _webView;
}
- (WebProgressLayer *)progressLayer{
    
    if (!_progressLayer) {
        _progressLayer = [WebProgressLayer new];
        _progressLayer.frame = CGRectMake(0, 42, IPHONE_WIDTH, 2);
        
    }
    return _progressLayer;
}

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
    return YES;
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
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_progressLayer finishedLoad];
    self.webView.hidden = NO;
    self.errorView.hidden = YES;
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
  
 
    [self hideHUD];
    
}



- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [_progressLayer finishedLoad];
 
    if ( [error.localizedDescription isEqualToString:@"请求超时。"] ) {
        self.webView.hidden = YES;
        [self showFailLoadErrorView];
        NSString * content = @"请求超时。101" ;
        [self showAlert:TNOperationState_Fail content:content block:^(NSInteger index) {
            //            [self.webView goBack];
        }];
    }
    
    NSLog(@"=%s %@======%@==error==%zd=errorcode",__FUNCTION__,webView.request.URL.absoluteString,error.localizedDescription,error.code);
    //
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
