//
//  ResponseViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/7/5.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "ResponseViewController.h"
#import "TTextView.h"
#import "SessionHelper.h"
#import "SessionModel.h"
@interface ResponseViewController ()
@property(nonatomic, copy) NSString * inputContent;
@property(nonatomic, strong) TTextView * textView;

@end

@implementation ResponseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationItemTitle:@"意见反馈"];
    [self setupSubviews];
    
    [self navUIBarBackground:0];
}

- (void)setupSubviews{
 
    //标题
    CGFloat titleHeight =  FITSCALE(44);
    UIView * titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,titleHeight)];
 
    titleView.backgroundColor = UIColorFromRGB(0xF0F3F6);
    [self.view addSubview:titleView];
    
    UIImageView * imgV = [[UIImageView alloc]init];
    [imgV setFrame:CGRectMake(0, 0, 36, 36)];
    [imgV setImage:[UIImage imageNamed:@"response_icon"]];
    [titleView addSubview:imgV];
    
    UILabel * titleLabel = [[UILabel alloc]init];
    titleLabel.textColor = UIColorFromRGB(0x6b6b6b);
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = fontSize_15;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    
    titleLabel.text = @"意见反馈";
    [titleView addSubview:titleLabel];
    
    
    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo( titleView);
        make.left.mas_equalTo( FITSCALE(14));
        
    }];
    
    
     [titleLabel  mas_updateConstraints:^(MASConstraintMaker *make) {
         make.centerY.mas_equalTo( imgV);
         make.left.mas_equalTo(imgV.mas_right).offset(FITSCALE(14));
     }];
    
    
    
    //输入框
     self.textView = [TTextView textView];
     self.textView.frame = CGRectMake(10, CGRectGetMaxY(titleView.frame)+ 10, self.view.frame.size.width - 20,FITSCALE(200));
     self.textView.placeholder = @"请输入反馈意见内容";
     self.textView.textColor = UIColorFromRGB(0x6b6b6b);
     self.textView.font = fontSize_14;
     self.textView.placeholderFont = fontSize_14;
     self.textView.placeholderColor = UIColorFromRGB(0x9f9f9f);
    self.textView.backgroundColor = UIColorFromRGB(0xF0F3F6);
    [self.view addSubview: self.textView];
    
    
    WEAKSELF
    [self.textView addTextDidChangeHandler:^(TTextView *textView) {
       STRONGSELF
        strongSelf.inputContent = textView.text;
        
    }];

    
    UIButton * nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setAdjustsImageWhenHighlighted:YES];
     nextBtn.titleLabel.font = fontSize_15;
    [ nextBtn setTitle:@"发送" forState:UIControlStateNormal];
    [ nextBtn setBackgroundImage:[UIImage imageNamed:@"btn_normal_bg"] forState:UIControlStateNormal];
    [ nextBtn setBackgroundImage:[UIImage imageNamed:@"btn_highlight_bg"] forState:UIControlStateHighlighted];
    [ nextBtn addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview: nextBtn];
    
    [ nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.height.mas_equalTo(FITSCALE(54));
        make.left.mas_equalTo(FITSCALE(14));
        make.top.mas_equalTo(self.textView.mas_bottom).offset(FITSCALE(15));
    }];

    
}
- (IBAction)sendAction:(id)sender {
    if (self.inputContent.length == 0) {
        
        [self showAlert:TNOperationState_Unknow content:@"请输入反馈意见内容"];
        return;
    }
    NSString * contentText = self.inputContent ;
    
    NSString * userId =  [[SessionHelper sharedInstance] getAppSession].teacherId;
    NSString * userPhone =  [[SessionHelper sharedInstance] getAppSession].phone;
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *newVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString * release = newVersion;
    
    NSDictionary * paramsDicValue =  @{
                                  @"terminal": @{
                                          @"platform": @"ios 7",                //平台版本信息 （ios 7，Android 5.0）
                                          @"type":@"P-T",
                                          @"release": release                //应用程序发布版本（v1.0）
                                          },
                                  @"content":@{
                                          @"text":contentText,                //用户反馈信息
                                          @"extension":@""                //扩展信息（关联：学生名+学校+班级/老师名+学校+职务）
                                          },
                                  @"submitter":@{
                                          @"userId":userId,                //用户ID
                                          @"phone":userPhone,               //用户手机号
                                          }
                                  };
    
   
    NSDictionary * paramsDic = @{@"feedback":paramsDicValue};
    
    [self sendHeaderFeedbackRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_ClientSubmitFeedbackDetails] parameterDic:paramsDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_ClientSubmitFeedbackDetails];
    
}

- (void)setNetworkRequestStatusBlocks{

    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
       STRONGSELF
        if (request.tag == NetRequestType_ClientSubmitFeedbackDetails) {
            NSString * content = @"您反馈的问题，我们尽快核实解决，谢谢您的支持！小佳有你更精彩！" ;
            [strongSelf showAlert:TNOperationState_OK content:content block:^(NSInteger index) {
                [strongSelf.navigationController popToRootViewControllerAnimated:YES];
            }];
        }
    }];
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
