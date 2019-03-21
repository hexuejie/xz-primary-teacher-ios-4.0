//
//  ChangeNewPhoneViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/7/20.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "ChangeNewPhoneViewController.h"
#import "ProUtils.h"
#import "SessionHelper.h"
#import "SessionModel.h"
#import "LoginController.h"

@interface ChangeNewPhoneViewController ()
@property (nonatomic) NSTimer *sendTimer;
@property (nonatomic) NSDate  *fireDate;
@property (weak, nonatomic) IBOutlet UIView *smsBgView;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UITextField *smscodeInput;
@property (weak, nonatomic) IBOutlet UIView  *mobileBgView;
@property (weak, nonatomic) IBOutlet UIButton *smsButton;
@property (weak, nonatomic) IBOutlet UITextField *mobileInput;
@end

@implementation ChangeNewPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavigationItemTitle:@"修改手机号码"];
    [self setup];
    
    [self navUIBarBackground:0];
}
- (void)setup{
  
    self.sendTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(sendSms) userInfo:nil repeats:YES];
    
    self.smscodeInput.font = fontSize_14;
      self.mobileInput.font = fontSize_14;
    self.smsButton.titleLabel.font = fontSize_12;
    self.nextBtn.titleLabel.font = fontSize_16;
    self.nextBtn.backgroundColor = project_main_blue;
    self.nextBtn.layer.cornerRadius = FITSCALE(45)/2;
    self.nextBtn.layer.borderWidth = 1;
    self.nextBtn.layer.borderColor = [UIColor clearColor].CGColor;
    
    [self.smsBgView mas_makeConstraints:^(MASConstraintMaker *make) {
     
        make.height.mas_equalTo(FITSCALE(42.5));
    }];
    [self.mobileBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(FITSCALE(42.5));
    }];
  
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(FITSCALE(45));
        make.top.mas_equalTo(self.smsBgView.mas_bottom).offset(FITSCALE(20));
    }];
    
  
    
    [self.mobileInput addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
}




#pragma mark - Notification Method
-(void)textFieldEditChanged:(UITextField *)textField
{
    
    [ProUtils phoneTextFieldEditChanged:textField];
    
}
- (IBAction)nextAction:(id)sender {
    
    [self.smscodeInput resignFirstResponder];
    
    
    if ([ProUtils isNilOrEmpty:self.smscodeInput.text]) {
        
        [self showAlert:TNOperationState_Unknow content:@"请输入短信验证码"];
        
        return ;
    }
    [self requestValidateCode];
    
}


- (void)requestValidateCode{
    
    NSString * phone =  self.mobileInput.text;
    NSString * authcode = self.smscodeInput.text;
    NSDictionary * parameterDic = @{@"newPhone":phone ,@"authcode":authcode};
    [self sendHeaderRequest: [NetRequestAPIManager getRequestURLStr:NetRequestType_ResetTeacherPhone] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_ResetTeacherPhone];
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
- (IBAction)smsAction:(id)sender {
    
    
    [self.smscodeInput resignFirstResponder];
   
    NSString * phone = self.mobileInput.text;
    NSDictionary * parameterDic = @{@"phone":phone ,@"event":@"bind_phone"};
    [self sendRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_BindPhoneSendAuthCode] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_BindPhoneSendAuthCode];
    
    
}

- (void)setNetworkRequestStatusBlocks{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag ==  NetRequestType_ResetTeacherPhone) {
           NSString * content = @"您已成功更换手机号码,请重新登录！";
            [strongSelf showAlert:TNOperationState_OK content:content block:^(NSInteger index) {
                [strongSelf logoutAction];
            }];
         
        }
        else if (request.tag == NetRequestType_BindPhoneSendAuthCode){
            
            
            strongSelf.fireDate = [NSDate date];
            [strongSelf.sendTimer setFireDate:[NSDate date]];
            
        }
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)logoutAction{
    [[SessionHelper sharedInstance] clearMessageList];
    [[SessionHelper sharedInstance] clearSaveCacheSession];
    [[UINavigationBar appearance] setTintColor:project_main_blue];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
//    LoginController * loginVC = [[LoginController alloc]initWithNibName:NSStringFromClass([LoginController class]) bundle:nil];
 
//    UINavigationController * loginNaviVC =  [[UINavigationController alloc]initWithRootViewController:loginVC];
//    [self presentViewController:loginNaviVC animated:NO completion:nil];
    
    [self gotoLoginViewController];
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
