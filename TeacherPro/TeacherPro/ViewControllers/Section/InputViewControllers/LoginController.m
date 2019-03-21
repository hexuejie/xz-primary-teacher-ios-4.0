 //
//  LoginController.m
//  AplusKidsMasterPro
//
//  Created by neon on 16/4/17.
//  Copyright © 2016年 neon. All rights reserved.
//

#import "LoginController.h"
#import "RegisterController.h"
#import "ForgetPwdController.h"
#import "ProUtils.h"
#import "SessionModel.h"
#import "SessionHelper.h"
#import "TabbarConfigManager.h"
#import "UserInfoViewController.h"
#import "AlertView.h"


@interface LoginController ()
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
//     self.accountInput.text = @"18622222222";
//    self.accountInput.text = @"18670053810";
//    self.accountInput.text = @"17373105045";
//     self.accountInput.text = @"18670000000";
//    self.accountInput.text = @"17777777777";
//    self.accountInput.text = @"13444444444";
//    self.accountInput.text = @"16300000000";
//    self.accountInput.text = @"16900000000";
//    self.passwordInput.text = @"111111";
    //13272059308
    //123456
    
    [self.accountInput addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    
    
    NSString * phone = CustomerServicePhoneNumber;
    NSString * phoneBtnTitle = [NSString stringWithFormat:@"登录如有疑问\n请联系客服咨询：%@",phone];
    self.phoneLabel.font = fontSize_11;
    self.phoneLabel.textColor = UIColorFromRGB(0x9f9f9f);
    NSRange range = [phoneBtnTitle rangeOfString:phone];
   self.phoneLabel.attributedText = [ProUtils setAttributedText:phoneBtnTitle withColor:project_main_blue withRange:range withFont:fontSize_11];
    [self.phoneBtn addTarget:self action:@selector(phoneAction) forControlEvents:UIControlEventTouchUpInside];
 }

- (void)phoneAction{
    NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@",CustomerServicePhoneNumber];
    if (@available(iOS 10.0, *)) {
        /// 大于等于10.0系统使用此openURL方法
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
    }else{
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
    }
    
   
    
}
- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
     
    self.accountInput.text = [[SessionHelper sharedInstance] getSessionPhone];
  
    self.passwordInput.text = @"";
}
#pragma mark - Notification Method
-(void)textFieldEditChanged:(UITextField *)textField
{
    
    [ProUtils phoneTextFieldEditChanged:textField];
 
}

- (BOOL )getShowBackItem{
    return NO;
}
- (void)showTestAlert{


}
- (BOOL)getNavBarBgHidden{
    
    return YES;
}
- (UIRectEdge)getViewRect{
    
    return UIRectEdgeAll;
}

- (BOOL )getLayoutIncludesOpaqueBars{
    
    return YES;
}
 

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
 
- (IBAction)nextAction:(id)sender {
    
    [self.accountInput resignFirstResponder];
    [self.passwordInput resignFirstResponder];
    
    NSString *accountFlag = [ProUtils checkMobilePhone:self.accountInput.text];
    
    if (![ProUtils isNilOrEmpty:accountFlag]) {
 
        [self showAlert:TNOperationState_Unknow content:accountFlag];
        
        return ;
    }
        NSString *passwordFlag = [ProUtils checkPwd:self.passwordInput.text];
    if (![ProUtils isNilOrEmpty:passwordFlag]) {
 
         [self showAlert:TNOperationState_Unknow content:passwordFlag];
        return ;
    }
    [self sendLogin];
 
}
- (void)sendLogin{
    NSDictionary * parameterDic = @{@"phone":self.accountInput.text,@"password":self.passwordInput.text};
    [self sendRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_TeacherLogin] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_TeacherLogin];
    
}
- (void)setNetworkRequestStatusBlocks{

    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (successInfoObj[@"teacher"]) {
           
            NSMutableDictionary * tempDic = [NSMutableDictionary dictionary];
            [tempDic addEntriesFromDictionary:successInfoObj[@"teacher" ]];
            [tempDic addEntriesFromDictionary:@{@"hasClazz":successInfoObj[@"hasClazz" ]}];
            
            SessionModel *model = [[SessionModel alloc]initWithDictionary:tempDic error:nil];
            [[SessionHelper sharedInstance] setAppSession:model];
            [[SessionHelper sharedInstance] saveCacheSession:model];
            
            if (model.sex) {
               
                 [strongSelf gotoHomeViewController];
                  
            }else{
              //没有性别的 必须要先填写用户性别
                [strongSelf gotoUserInfoViewController];
               
            }
            
       
        }
       
        
    }];
}


- (NSString *)getLoadingHUDStr{
    
    return LoginLoading;
}

- (IBAction)registerAction:(id)sender {

   
    RegisterController *registVC = [[RegisterController alloc] initWithNibName:NSStringFromClass([RegisterController class]) bundle:nil];
    [self pushViewController:registVC];
  
}

- (IBAction)forgetPwdAction:(id)sender {
    ForgetPwdController *forgetVC = [[ForgetPwdController alloc] initWithNibName:NSStringFromClass([ForgetPwdController class]) bundle:nil];
  
     [self pushViewController:forgetVC];
    
}





- (void)setupViews {
    self.view.backgroundColor = [UIColor whiteColor];
    
    
//    [self.loginIconView mas_makeConstraints:^(MASConstraintMaker *make) {
//        if (iPhone4) {
//            make.top.mas_equalTo(self.view).offset(60);
//        }else {
////           make.top.mas_equalTo(self.view).offset(95);
//        }
//    }];


    
    self.titleLabel.font = fontSize_18 ;
    self.accountInput.font = fontSize_14;
    self.passwordInput.font = fontSize_14;
    self.nextButton.titleLabel.font = fontSize_16;
    self.registerButton.titleLabel.font = fontSize_12;
    self.forgetPwdButton.titleLabel.font = fontSize_12;
    
    
}

- (void)gotoHomeViewController{

    UIViewController * viewController = [TabbarConfigManager getTabbarViewController:TabbarViewControllerType_Login withDelegate:[UIApplication sharedApplication].delegate];
    /**
     重新设置导航条样式
     */
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self presentViewController:viewController modalTransitionStyle:UIModalTransitionStyleCrossDissolve completion:nil];
//    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)gotoUserInfoViewController{
    
    UserInfoViewController * userInfo = [[UserInfoViewController alloc]initWithNibName:NSStringFromClass([UserInfoViewController class ]) bundle:nil];;
    
    /**
     重新设置导航条样式
     */
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self pushViewController:userInfo];
    
//    [self presentViewController:[[UINavigationController alloc]initWithRootViewController:userInfo] modalTransitionStyle:UIModalTransitionStyleFlipHorizontal completion:nil];
}


@end
