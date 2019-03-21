//
//  RegisterController.m
//  AplusKidsMasterPro
//
//  Created by neon on 16/4/18.
//  Copyright © 2016年 neon. All rights reserved.
//

#import "RegisterController.h"
#import "UserInfoViewController.h"
#import "ProUtils.h"
#import "SessionHelper.h"
#import "SessionModel.h"
@interface RegisterController ()
@property NSInteger smsReq,passwordReq,timeCount,existReq;
@property (nonatomic) NSTimer *sendTimer;
@property (nonatomic) NSDate  *fireDate;
@property (weak, nonatomic) IBOutlet UIButton *eyesBtn;

@end

@implementation RegisterController

- (instancetype)init
{
    self = [super init];
    if (self) {
 
    }
    return self;
}
- (BOOL)getNavBarBgHidden{
    
    return NO;
}
- (UIRectEdge)getViewRect{
    
    return UIRectEdgeAll;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTintColor: project_main_blue];
    
    [self setNavigationItemTitle:@"注册" titleFont:fontSize_18 titleColor:[UIColor blackColor]];
    [self setupViews];
    self.smsButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.sendTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(sendSms) userInfo:nil repeats:YES];
    
   [self.mobileInput addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];

}

#pragma mark -   Method
-(void)textFieldEditChanged:(UITextField *)textField
{
    
    [ProUtils phoneTextFieldEditChanged:textField];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupViews {
    self.eyesBtn.titleLabel.font = fontSize_10;
    self.eyesBtn.titleEdgeInsets = UIEdgeInsetsMake(self.eyesBtn.bounds.size.height/2 + 10, - self.eyesBtn.imageView.bounds.size.width- self.eyesBtn.titleLabel.bounds.size.width, 0 , 0);//设置title在button
    
     self.eyesBtn.imageEdgeInsets = UIEdgeInsetsMake( -5, 0, 5 , 0);//设置title在button
   
    
    self.mobileInput.font = fontSize_14;
    self.smscodeInput.font = fontSize_14;
    self.passwordInput.font = fontSize_14;
    self.smsButton.titleLabel.font = fontSize_12;
    self.nextBtn.titleLabel.font = fontSize_16;
    
    [self.mobileBgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.view).offset(FITSCALE(18));
        make.height.mas_equalTo(FITSCALE(42.5));
    }];
    
    [self.smsBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mobileBgView.mas_bottom).offset(FITSCALE(16.5));
    }];
    
    [self.pwdbgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.smsBgView.mas_bottom).offset(FITSCALE(16.5));
    }];
    
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.pwdbgView.mas_bottom).offset(FITSCALE(20));
        make.height.mas_equalTo(64);
    }];

   
}


- (void)sendSms {
    NSDate *sDate = self.fireDate;
    NSTimeInterval t = [[NSDate date] timeIntervalSinceDate:sDate];
    NSInteger timeT = 60 - t;
    if (timeT <= 0)
    {
        [self.smsButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.smsButton setUserInteractionEnabled:YES];
        [self.sendTimer setFireDate:[NSDate distantFuture]];
        self.smsButton.layer.borderColor = project_main_blue.CGColor;
        [self.smsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.smsButton setBackgroundColor:project_main_blue];
        return ;
    }
    self.smsButton.userInteractionEnabled = NO;
    [self.smsButton setTitle:[NSString stringWithFormat:@"%zd秒", timeT] forState:UIControlStateNormal];
    [self.smsButton setBackgroundColor:UIColorFromRGB(0xcdd2da)];
    [self.smsButton setTitleColor: UIColorFromRGB(0x9ca1ab) forState:UIControlStateNormal];
    self.smsButton.layer.borderColor = UIColorFromRGB(0xcdd2da).CGColor;
}

- (void)checkUserExist {
    
    [self.mobileInput resignFirstResponder];
    [self.passwordInput resignFirstResponder];
    [self.smscodeInput resignFirstResponder];
    
 
}



- (IBAction)smsAction:(id)sender {
    
    [self checkUserExist];
    NSString *accountFlag = [ProUtils checkMobilePhone:self.mobileInput.text];
    if (![ProUtils isNilOrEmpty:accountFlag]) {
//        [PromptView showResultViewWithResult:TNStateUnknow withContent:accountFlag withDoneBlock:nil];
        [self showAlert:TNOperationState_Unknow content:accountFlag];
        return ;
    }
    [self sendRegisterValidate];
}

#pragma mark ---
- (void)sendRegister{
    NSDictionary * parameterDic = @{@"phone":self.mobileInput.text,@"password":self.passwordInput.text,@"authcode":self.smscodeInput.text};
    [self sendRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_TeacherRegister] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_TeacherRegister];
    
}
- (void)sendRegisterValidate{
    NSDictionary * parameterDic = @{ @"phone":self.mobileInput.text,@"event":@"register"};
    [self sendRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_TeacherRegisterSendAuthCode] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_TeacherRegisterSendAuthCode];
    
}
- (void)setNetworkRequestStatusBlocks{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_TeacherRegister) {
            if (successInfoObj[@"teacher"]) {
                
                SessionModel *model = [[SessionModel alloc]initWithDictionary:successInfoObj[@"teacher" ]error:nil];
                    [[SessionHelper sharedInstance] setAppSession:model];
                [[SessionHelper sharedInstance] saveCacheSession:model];
               [strongSelf gotoUserInfoVC];
            
            }
        }
        else if (request.tag == NetRequestType_TeacherRegisterSendAuthCode){
        
            strongSelf.fireDate = [NSDate date];
            [strongSelf.sendTimer setFireDate:[NSDate date]];

        }
        
    }];
}

#pragma mark --------

- (IBAction)nextAction:(id)sender {
     [self checkUserExist];
    
    NSString *accountFlag = [ProUtils checkMobilePhone:self.mobileInput.text];
    if (![ProUtils isNilOrEmpty:accountFlag]) {
//        [PromptView showResultViewWithResult:TNStateUnknow withContent:accountFlag withDoneBlock:nil];
          [self showAlert:TNOperationState_Unknow content:accountFlag];
        return ;
    }
    
 
    if ([ProUtils isNilOrEmpty:self.smscodeInput.text]) {
//        [PromptView showResultViewWithResult:TNStateUnknow withContent:@"请输入短信验证码" withDoneBlock:nil];
         [self showAlert:TNOperationState_Unknow content:@"请输入短信验证码"];
        return ;
    }
    
    NSString *passwordFlag = [ProUtils checkPwd:self.passwordInput.text];
    if (![ProUtils isNilOrEmpty:passwordFlag]) {
//        [PromptView showResultViewWithResult:TNStateUnknow withContent:passwordFlag withDoneBlock:nil];
         [self showAlert:TNOperationState_Unknow content:@"请输入短信验证码"];
        return ;
    }
    
    [self sendRegister];
//    [self gotoUserInfoVC];
    
}

- (void)gotoUserInfoVC{
    UserInfoViewController * userInfo = [[UserInfoViewController alloc]initWithNibName:NSStringFromClass([UserInfoViewController class ]) bundle:nil];;
   
    /**
     重新设置导航条样式
     */
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    [self presentViewController:[[UINavigationController alloc]initWithRootViewController:userInfo] animated:YES completion:nil];
//    [self presentViewController:[[UINavigationController alloc]initWithRootViewController:userInfo] modalTransitionStyle:UIModalTransitionStyleFlipHorizontal completion:nil];
     [self pushViewController:userInfo];
 
}
//是否显示输入的密码
- (IBAction)eyesBtn:(UIButton *)sender {
    self.passwordInput.secureTextEntry = sender.selected;
    sender.selected = !sender.selected;
  
    
}
 
@end
