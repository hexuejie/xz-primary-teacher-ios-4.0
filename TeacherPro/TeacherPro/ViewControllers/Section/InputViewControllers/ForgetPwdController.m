//
//  ForgetPwdController.m
//  AplusKidsMasterPro
//
//  Created by neon on 16/6/6.
//  Copyright © 2016年 neon. All rights reserved.
//

#import "ForgetPwdController.h"
#import "ProUtils.h"

@interface ForgetPwdController ()
@property NSInteger smsReq,validateReq,timeCount;
@property (nonatomic) NSTimer *sendTimer;
@property (nonatomic) NSDate  *fireDate;
@property (weak, nonatomic) IBOutlet UIImageView *loginIconView;
@property (weak, nonatomic) IBOutlet UIView *passworkView;
@property (weak, nonatomic) IBOutlet UITextField *passworkTF;
@property (weak, nonatomic) IBOutlet UIButton *eyesBtn;
@end

@implementation ForgetPwdController

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

- (BOOL )getLayoutIncludesOpaqueBars{
    
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTintColor: project_main_blue];
    
    [self setNavigationItemTitle:@"忘记密码" titleFont:fontSize_18 titleColor:[UIColor blackColor]];
    [self setupViews];

    self.sendTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(sendSms) userInfo:nil repeats:YES];
 
   [self.mobileInput addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
}
#pragma mark - Notification Method
-(void)textFieldEditChanged:(UITextField *)textField
{
    
    [ProUtils phoneTextFieldEditChanged:textField];
    
}


- (void)getNetworkData{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupViews {
    
    
    
    self.eyesBtn.titleLabel.font = fontSize_10;
    self.mobileInput.font = fontSize_14;
    self.smscodeInput.font = fontSize_14;
    self.passworkTF.font = fontSize_14;
    self.smsButton.titleLabel.font = fontSize_12;
    self.nextBtn.titleLabel.font = fontSize_16;
    
    self.eyesBtn.titleEdgeInsets = UIEdgeInsetsMake(self.eyesBtn.bounds.size.height/2 + 10, - self.eyesBtn.imageView.bounds.size.width- self.eyesBtn.titleLabel.bounds.size.width, 0 , 0);//设置title在button
    
    self.eyesBtn.imageEdgeInsets = UIEdgeInsetsMake( -5, 0, 5 , 0);//设置title在button
    
//    [self.nextBtn setBackgroundImage:[UIImage imageNamed:@"btn_normal_bg"] forState:UIControlStateNormal];
//
//    [self.nextBtn setBackgroundImage:[UIImage imageNamed:@"btn_normal_bg"] forState:UIControlStateSelected];
    self.nextBtn.backgroundColor = [UIColor clearColor];
    self.nextBtn.layer.cornerRadius = FITSCALE(45)/2;
     self.nextBtn.layer.borderWidth = 1;
     self.nextBtn.layer.borderColor = [UIColor clearColor].CGColor;
    [self.mobileBgView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.height.mas_equalTo(FITSCALE(42.5));
    }];
    
    [self.smsBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mobileBgView.mas_bottom).offset(FITSCALE(16.5));
    }];
    
    

    
    [self.passworkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.smsBgView.mas_bottom).offset(FITSCALE(16.5));
        make.height.mas_equalTo(FITSCALE(42.5));
    }];
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(FITSCALE(45));
        make.top.mas_equalTo(self.passworkView.mas_bottom).offset(FITSCALE(20));
    }];
    
}

 

- (IBAction)smsAction:(id)sender {
    
    [self.mobileInput resignFirstResponder];
    [self.smscodeInput resignFirstResponder];
    
    NSString *accountFlag = [ProUtils checkMobilePhone:self.mobileInput.text];
    if (![ProUtils isNilOrEmpty:accountFlag]) {
//        [PromptView showResultViewWithResult:TNStateUnknow withContent:accountFlag withDoneBlock:nil];
       
       [self showAlert:TNOperationState_Unknow content:accountFlag];
        return ;
    }
    [self sendForgetPwdValidate];
 
}

- (IBAction)nextAction:(id)sender {
    [self.mobileInput resignFirstResponder];
    [self.smscodeInput resignFirstResponder];
     
    NSString *accountFlag = [ProUtils checkMobilePhone:self.mobileInput.text];
    if (![ProUtils isNilOrEmpty:accountFlag]) {
//        [PromptView showResultViewWithResult:TNStateUnknow withContent:accountFlag withDoneBlock:nil];
 
          [self showAlert:TNOperationState_Unknow content:accountFlag];
        return ;
    }
    if ([ProUtils isNilOrEmpty:self.smscodeInput.text]) {
//         [PromptView showResultViewWithResult:TNStateUnknow withContent: withDoneBlock:nil];
         [self showAlert:TNOperationState_Unknow content:@"请输入短信验证码"];
        
        return ;
    }
    
    [self sendForgetPwd];
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
 
        [self.smsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
 
        self.smsButton.backgroundColor = project_main_blue;
        return ;
    }
    self.smsButton.userInteractionEnabled = NO;
    [self.smsButton setTitle:[NSString stringWithFormat:@"%zd秒", timeT] forState:UIControlStateNormal];
    [self.smsButton setBackgroundColor:UIColorFromRGB(0xcdd2da)];
    [self.smsButton setTitleColor: UIColorFromRGB(0x9ca1ab) forState:UIControlStateNormal];
    self.smsButton.layer.borderColor = UIColorFromRGB(0xcdd2da).CGColor;
  
}


- (IBAction)eyesBtn:(UIButton *)sender {
   
    self.passworkTF.secureTextEntry = sender.selected;
     sender.selected = !sender.selected;
    
}

#pragma mark ---
- (void)sendForgetPwd{
    NSDictionary * parameterDic = @{@"phone":self.mobileInput.text,@"newPassword":self.passworkTF.text,@"authcode":self.smscodeInput.text};
    [self sendRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_TeacherResetPassword] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_TeacherResetPassword];
    
}
- (void)sendForgetPwdValidate{
    NSDictionary * parameterDic = @{@"phone":self.mobileInput.text,@"event":@"forget_password"};
    [self sendRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_TeacherForgetPwdSendAuthCode] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_TeacherForgetPwdSendAuthCode];
    
}
- (void)setNetworkRequestStatusBlocks{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_TeacherResetPassword) {
      
            [strongSelf backViewController];
        }
        else if (request.tag == NetRequestType_TeacherForgetPwdSendAuthCode){
            
            strongSelf.fireDate = [NSDate date];
            [strongSelf.sendTimer setFireDate:[NSDate date]];
            
        }
        
    }];
}

@end
