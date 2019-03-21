
//
//  HelpViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/7/5.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "HelpViewController.h"
#import "ProUtils.h"
#import "ResponseViewController.h"


#define bottomHeight    FITSCALE(55)
@interface HelpViewController ()<UIWebViewDelegate>
@property(nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // Do any additional setup after loading the view.
    [self setNavigationItemTitle:@"帮助与反馈"];
    [self.view addSubview:self.bottomView];
//    [self resetUserAgent];
    [self.view addSubview:self.webView];
    [self loadHtml];
    
    [self navUIBarBackground:0];
}
- (void)resetUserAgent{
    
    UIWebView *tempWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString *oldAgent = [tempWebView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSLog(@"old agent :%@", oldAgent);
   
    
    NSString * newAgentT = @"";
    //add my info to the new agent
    NSString *newAgent = [oldAgent stringByAppendingString:newAgentT];
    //    NSLog(@"new agent :%@", newAgent);
    
    //regist the new agent
    NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:newAgent, @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
    
}
- (void)loadHtml{
    
    NSString * htmlCont = [NSString stringWithFormat:@"%@",HEADURL_HELP_WEB];
    
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:htmlCont]];
    [self.webView loadRequest:request];
    
    
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self showHUDInfoByType:HUDInfoType_Loading];
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [self hideHUD];
 
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    [self hideHUD];
}

- (UIWebView *)webView{
    
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - bottomHeight- PHONEX_HOME_INDICATOR_HEIGHT)];
        _webView.delegate = self;
        _webView.scrollView.bounces =NO;
        
    }
    return _webView;
}
- (UIView *)bottomView{
    
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height- bottomHeight- PHONEX_HOME_INDICATOR_HEIGHT  , self.view.frame.size.width, bottomHeight)];
        _bottomView.backgroundColor = [UIColor clearColor];
        
        UIButton *responseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [responseBtn setBackgroundImage:[UIImage imageNamed:@"btn_normal_bg"] forState:UIControlStateNormal];
        [responseBtn.layer setMasksToBounds:YES];
        [responseBtn.layer setCornerRadius:25];
        
        [responseBtn setTitle:@"反馈" forState:UIControlStateNormal];
        [responseBtn addTarget:self action:@selector(responseAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:responseBtn];
        [responseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(_bottomView).offset(FITSCALE(20));
            make.right.mas_equalTo(_bottomView).offset(FITSCALE(-20));
            make.centerY.mas_equalTo(_bottomView);
            make.height.mas_equalTo(@60);
        }];
        
        
    }
    return _bottomView;
}

- (void)responseAction:(id)sender{
    ResponseViewController *repcVC = [[ResponseViewController alloc]init];
    [self pushViewController:repcVC];
    
}
- (void)dealloc{
    
    self.webView = nil;
  
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
