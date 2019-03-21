 //
//  ChangePhoneViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/7/20.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "ChangePhoneViewController.h"
#import "SessionModel.h"
#import "SessionHelper.h"
#import "ProUtils.h"
#import "ChangeNewPhoneViewController.h"

@interface ChangePhoneViewController ()
@property (nonatomic) NSTimer *sendTimer;
@property (nonatomic) NSDate  *fireDate;
@property (weak, nonatomic) IBOutlet UIView *smsBgView;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UITextField *smscodeInput;
@property (weak, nonatomic) IBOutlet UILabel *oldPhone;
@property (weak, nonatomic) IBOutlet UIButton *smsButton;
@end

@implementation ChangePhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavigationItemTitle:@"修改手机号码"];
    [self setup];
    
    [self navUIBarBackground:0];
}

- (void)setup{
    SessionModel *model = [[SessionHelper sharedInstance]getAppSession];
    self.oldPhone.text = [ProUtils replacingCenterPhone:model.phone withReplacingSymbol:@"*"];
    self.sendTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(sendSms) userInfo:nil repeats:YES];
    
    self.smscodeInput.font = fontSize_14;
    
    self.smsButton.titleLabel.font = fontSize_12;
    self.nextBtn.titleLabel.font = fontSize_16;
    self.nextBtn.backgroundColor = [UIColor clearColor];
    self.nextBtn.layer.cornerRadius = FITSCALE(45)/2;
    self.nextBtn.layer.borderWidth = 1;
    self.nextBtn.layer.borderColor = [UIColor clearColor].CGColor;
    
    [self.smsBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.oldPhone.mas_bottom).offset(FITSCALE(16.5));
        make.height.mas_equalTo(FITSCALE(42.5));
    }];
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(FITSCALE(45));
        make.top.mas_equalTo(self.smsBgView.mas_bottom).offset(FITSCALE(20));
    }];

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

    SessionModel * model = [[SessionHelper sharedInstance]getAppSession];
    NSString * phone = model.phone;
    NSString * authcode = self.smscodeInput.text;
    NSDictionary * parameterDic = @{@"phone":phone ,@"event":@"unbind_phone",@"authcode":authcode};
    [self sendRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_ValidateUnbindPhoneAuthCode] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_ValidateUnbindPhoneAuthCode];
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
    SessionModel * model = [[SessionHelper sharedInstance]getAppSession];
    NSString * phone = model.phone;
    NSDictionary * parameterDic = @{@"phone":phone ,@"event":@"unbind_phone"};
    [self sendRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_UnbindPhoneSendAuthCode] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_UnbindPhoneSendAuthCode];
    
    
}

- (void)setNetworkRequestStatusBlocks{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_ValidateUnbindPhoneAuthCode) {
            
            [strongSelf  gotoChangeNewPhoneVC];
        }
        else if (request.tag == NetRequestType_UnbindPhoneSendAuthCode){
            
            strongSelf.fireDate = [NSDate date];
            [strongSelf.sendTimer setFireDate:[NSDate date]];
            
        }
        
    }];
}

- (void)gotoChangeNewPhoneVC{

    ChangeNewPhoneViewController * newPhoneVC = [[ChangeNewPhoneViewController alloc]initWithNibName:NSStringFromClass([ChangeNewPhoneViewController class]) bundle:nil];
    [self pushViewController:newPhoneVC];
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
