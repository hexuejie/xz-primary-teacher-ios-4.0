//
//  ChangePasswordViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/7/15.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "PasswordView.h"
#import "ProUtils.h"
#import "SessionModel.h"
#import "SessionHelper.h"
#import "LoginController.h"

@interface ChangePasswordViewController ()
@property (strong, nonatomic)   PasswordView *pwdbgview;
@property (strong, nonatomic)   PasswordView *resetview;
@property (strong, nonatomic)   UIButton *nextBtn;
@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationItemTitle:@"修改密码"];
    [self setupSubview];
    
    [self navUIBarBackground:0];
}

- (void)setupSubview{

    self.pwdbgview = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([PasswordView class]) owner:nil options:nil].firstObject;
    self.pwdbgview.backgroundColor = UIColorFromRGB(0xEFEFEF);
    self.pwdbgview.layer.cornerRadius = FITSCALE(20);
    self.pwdbgview.layer.masksToBounds = YES;
    self.pwdbgview.textField.placeholder = @"请输入新密码";
   
    
    
    self.resetview = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([PasswordView class]) owner:nil options:nil].firstObject;
    self.resetview.layer.cornerRadius = FITSCALE(20);
    self.resetview.backgroundColor = UIColorFromRGB(0xEFEFEF);
    self.resetview.layer.masksToBounds = YES;
    self.resetview.textField.placeholder = @"请再次输入新密码";
    
    [self.view addSubview:self.pwdbgview];
    [self.view addSubview:self.resetview];
    [self.pwdbgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(FITSCALE(18));
        make.size.mas_equalTo(CGSizeMake(IPHONE_WIDTH-FITSCALE(28), FITSCALE(42.5)));
        make.left.mas_equalTo(self.view).offset(FITSCALE(10));
        
    }];
    
    [self.resetview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.pwdbgview.mas_bottom).offset(FITSCALE(18));
        make.size.mas_equalTo(self.pwdbgview);
        make.left.mas_equalTo(self.pwdbgview);
    }];
    
    
    self.nextBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.nextBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.nextBtn.titleLabel.font = fontSize_14;
    [self.nextBtn setBackgroundImage:[UIImage imageNamed:@"btn_normal_bg"] forState:UIControlStateNormal];
    [self.nextBtn setBackgroundImage:[UIImage imageNamed:@"btn_highlight_bg"] forState:UIControlStateHighlighted];
   
    [self.view addSubview:self.nextBtn];
    [self.nextBtn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    [self.nextBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(IPHONE_WIDTH-FITSCALE(28), FITSCALE(54)));
        make.top.mas_equalTo(self.resetview.mas_bottom).offset(FITSCALE(28));
        make.left.mas_equalTo(self.pwdbgview);
    }];
    
    
   
}

- (void)nextAction{

    [self.pwdbgview.textField resignFirstResponder];
    [self.resetview.textField resignFirstResponder];
    if (self.pwdbgview.textField.text.length<=0) {
         [ProUtils shake:self.resetview];
        return;
    }
    
    if (self.resetview.textField.text.length<=0) {
        [ProUtils shake:self.resetview];
       
        return;
    }
    if (![self.pwdbgview.textField.text isEqualToString:self.resetview.textField.text]) {
        NSString * content = @"两次密码输入不一致，请重新输入";
        [self showAlert:TNOperationState_Unknow content:content];
       
        return;
    }

    
    [self requestPassword];
}

- (void)requestPassword{

    NSString * newPassword = self.resetview.textField.text;
    NSDictionary * parameterDic = @{@"newPassword":newPassword
                                    
                                    };
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_TeacherUpdatePassword] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_TeacherUpdatePassword];
}

- (void)setNetworkRequestStatusBlocks{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        if (request.tag  == NetRequestType_TeacherUpdatePassword) {
         NSString * content = @"密码修改成功，请重新登录";
         [weakSelf showAlert:TNOperationState_OK content:content block:^(NSInteger index) {
             [weakSelf exitLogin];
         }];
        }
    }];
}


- (void)exitLogin{
     [[SessionHelper sharedInstance] clearMessageList];
     [[SessionHelper sharedInstance] clearSaveCacheSession];
    [[UINavigationBar appearance] setTintColor:project_main_blue];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
//    LoginController * loginVC = [[LoginController alloc]initWithNibName:NSStringFromClass([LoginController class]) bundle:nil];
 
//    
//    UINavigationController * loginNaviVC =  [[UINavigationController alloc]initWithRootViewController:loginVC];
//    [self presentViewController:loginNaviVC animated:NO completion:nil];
    [self gotoLoginViewController];
    
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
