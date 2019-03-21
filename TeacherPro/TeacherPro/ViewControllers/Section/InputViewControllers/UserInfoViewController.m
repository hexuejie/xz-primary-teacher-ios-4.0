//
//  UserInfoViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/5/5.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "UserInfoViewController.h"
#import "ProUtils.h"
#import "TabbarConfigManager.h"
#import "SessionHelper.h"
#import "SessionModel.h"
#import "FourPingTransition.h"
#import "LoginController.h"
#import "UIViewController+BackButtonHandler.h"
@interface UserInfoViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameInput;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIButton *manBtn;
@property (weak, nonatomic) IBOutlet UIButton *wmanBtn;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    // Do any additional setup after loading the view from its nib.
    [self setNavigationItemTitle:@"完善资料" ];
    [self setupViews];
    self.wmanBtn.selected = YES;
    
    
    SessionModel *sesstion = [[SessionHelper sharedInstance] getAppSession];
  
    if (sesstion.name) {
        NSString * defaultName = @"";
        if (sesstion.name.length>5) {
            defaultName = [sesstion.name substringFromIndex:sesstion.name.length- 5];
        }else{
            defaultName = sesstion.name;
        }
        
         self.nameInput.text = defaultName;
    }
 

}
- (BOOL )getShowBackItem{
    
    return YES;
}
- (void)backViewController
{
    NSArray *viewControllers = [self.navigationController viewControllers];
    
    // 根据viewControllers的个数来判断此控制器是被present的还是被push的
    if (1 <= viewControllers.count && 0 < [viewControllers indexOfObject:self])
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        [self exitLogin];

    }
}



- (void)exitLogin{
    [[SessionHelper sharedInstance] clearMessageList];
     [[SessionHelper sharedInstance] clearSaveCacheSession];
    [[UINavigationBar appearance] setTintColor:project_main_blue];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

//    LoginController * loginVC = [[LoginController alloc]initWithNibName:NSStringFromClass([LoginController class]) bundle:nil];
//    [[UINavigationBar appearance] setTintColor:project_main_blue];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
//
//    UINavigationController * loginNaviVC =  [[UINavigationController alloc]initWithRootViewController:loginVC];
//    [self presentViewController:loginNaviVC animated:NO completion:nil];
    [self gotoLoginViewController];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setupViews {
 
    self.detailLabel.font = fontSize_11;
    self.detailLabel.textColor = UIColorFromRGB(0x9f9f9f);
    self.titleLabel.textColor =  UIColorFromRGB(0x6f6f6f);
    self.titleLabel.font = fontSize_14;
    
    

    
    CGSize btnTitleSize = [self getTitleSize: self.manBtn.currentTitle ];
    CGSize btnImageSize =  self.manBtn.currentImage.size;
    
    
    self.manBtn.titleEdgeInsets = UIEdgeInsetsMake(btnImageSize.height + btnTitleSize.height, -btnImageSize.width , 0, 0);//设置title在button
    
     btnTitleSize = [self getTitleSize: self.wmanBtn.currentTitle ];
     btnImageSize =  self.wmanBtn.currentImage.size;
    self.wmanBtn.titleEdgeInsets = UIEdgeInsetsMake(btnImageSize.height + btnTitleSize.height, - btnImageSize.width , 0, 0);//设置title在button
    
    [self.nextBtn addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.nameInput.font = fontSize_14;
    
    self.nameInput.textColor =  UIColorFromRGB(0x6b6b6b);
    [self.nameInput setDelegate:self];
    [self.nameInput addTarget:self action:@selector(changeTextField:) forControlEvents:UIControlEventEditingChanged];
    [self.wmanBtn setTitleColor:UIColorFromRGB(0x6b6b6b) forState:UIControlStateNormal];
    [self.wmanBtn setTitleColor:project_main_blue forState:UIControlStateSelected];
    
    [self.manBtn setTitleColor:UIColorFromRGB(0x6b6b6b) forState:UIControlStateNormal];
    [self.manBtn setTitleColor:project_main_blue forState:UIControlStateSelected];
    self.manBtn.titleLabel.font = fontSize_14;
    self.wmanBtn.titleLabel.font = fontSize_14;
    self.nextBtn.titleLabel.font = fontSize_16;
    
    [self.nextBtn setBackgroundImage:[UIImage imageNamed:@"btn_normal_bg"] forState:UIControlStateNormal];
    [self.nextBtn setBackgroundImage:[UIImage imageNamed:@"btn_highlight_bg"] forState:UIControlStateHighlighted];
    
    self.lineView.backgroundColor = UIColorFromRGB(0x6b6b6b);
    [self.nameInput mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(FITSCALE(42.5));
    }];
    
   
     [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(FITSCALE(54));
        make.top.mas_equalTo(self.nameInput.mas_bottom).offset(FITSCALE(20));
    }];
    
}


- (CGSize )getTitleSize:(NSString *)attributeStr{
    NSDictionary *attr=@{NSFontAttributeName:fontSize_14};
    CGSize lableSize=[attributeStr boundingRectWithSize:CGSizeMake(1000, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size;
    
    return lableSize;
}

- (void)changeTextField:(UITextField *)textField{

//    if (textField.text.length > 5) {
//      
////        NSString * content = @"老师的姓名最多为五个字";
//    
////        [self showAlert:TNOperationState_Unknow content:content];
//        [ProUtils shake:textField];
//        textField.text = [textField.text substringToIndex:5];
//        [textField resignFirstResponder];
//        
//    }
    
    
    NSInteger kMaxLength = 5;
    NSString *toBeString = textField.text;
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage; //ios7之前使用[UITextInputMode currentInputMode].primaryLanguage
    if ([lang isEqualToString:@"zh-Hans"]) { //中文输入
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        if (!position) {// 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (toBeString.length > kMaxLength) {
                textField.text = [toBeString substringToIndex:kMaxLength];
                [ProUtils shake:textField];
                [textField resignFirstResponder];
            }
            //             NSLog(@"没有高亮选择的字，则对已输入的文字进行字数统计和限制");
        }
        else{//有高亮选择的字符串，则暂不对文字进行统计和限制
            //            NSLog(@"有高亮选择的字符串，则暂不对文字进行统计和限制");
        }
        
        
    }else{//中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length > kMaxLength) {
            textField.text = [toBeString substringToIndex:kMaxLength];
        }
    }
}


- (void)nextAction:(id)sender {
 
    
    if ([ProUtils isNilOrEmpty:self.nameInput.text]) {
 
         [self showAlert:TNOperationState_Unknow content: @"请输入您的姓名"];
        return ;
    }
    
    
    [self sendRequest];
 
}

- (IBAction)wmanBtnAction:(id)sender {
    if(!self.wmanBtn.selected){
        self.wmanBtn.selected = YES;
        self.manBtn.selected = NO;
    }
}
- (IBAction)manBtnAction:(id)sender {
     if(!self.manBtn.selected){
         self.manBtn.selected = YES;
         self.wmanBtn.selected = NO;
     }
}


- (void)sendRequest{
    NSString * gender ;
    if (self.manBtn.selected) {
        gender = @"male";
    }
    if (self.wmanBtn.selected) {
        gender = @"female";
    }
    
    NSString * username = self.nameInput.text;
    NSDictionary * parameter = @{@"sex":gender,@"teacherName":username};
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_TeacherRegisterAddInfo] parameterDic:parameter requestMethodType:RequestMethodType_POST requestTag:NetRequestType_TeacherRegisterAddInfo];
}

#pragma mark ====

- (void)setNetworkRequestStatusBlocks{

    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        
        SessionModel *sesstion = [[SessionHelper sharedInstance] getAppSession];
         NSString * gender = @"";
        if (strongSelf.manBtn.selected) {
            gender = @"male";
        }
        if (strongSelf.wmanBtn.selected) {
            gender = @"female";
        }
        sesstion.sex = gender;
        sesstion.name =  strongSelf.nameInput.text;
   
        [[SessionHelper sharedInstance]saveCacheSession:sesstion];

        [strongSelf gotoHomeVC];
    }];
}

- (void)gotoHomeVC{

    UIViewController * viewController = [TabbarConfigManager getTabbarViewController:TabbarViewControllerType_Info withDelegate:[UIApplication sharedApplication].delegate];
    /**
     重新设置导航条样式
     */
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
   
//    [self presentViewController:viewController modalTransitionStyle:UIModalTransitionStyleCrossDissolve completion:nil];
       [self presentViewController:viewController animated:YES completion:nil];
}


/**
 * 协议中的方法，获取返回按钮的点击事件
 */
- (BOOL)navigationShouldPopOnBackButton
{
    return NO;
    
}

@end
