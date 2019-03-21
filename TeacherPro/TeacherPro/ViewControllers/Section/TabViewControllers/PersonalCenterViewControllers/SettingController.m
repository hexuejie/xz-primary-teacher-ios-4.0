//
//  SettingController.m
//  TeacherPro
//
//  Created by DCQ on 2017/7/5.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "SettingController.h"
#import "SessionHelper.h"
#import "LoginController.h"
#import "AboutController.h"
#import "HelpViewController.h"
#import "ChangePasswordViewController.h"
#import "ChangePhoneViewController.h"
#import "SettingControllerCell.h"

NSString * const SettingControllerIdentifier = @"SettingControllerIdentifier";
@interface SettingController ()
@property (nonatomic,strong) NSArray *settingList;
@property (nonatomic,strong) UIView  *bottomView;

@end
@implementation SettingController
- (void)viewDidLoad {
    [super viewDidLoad];
     // Do any additional setup after loading the view.
    [self setNavigationItemTitle:@"设置"];
    self.settingList = @[@[@"修改手机号码",@"修改密码"],@[@"帮助与反馈",@"关于我们"]];
     self.view.backgroundColor = project_background_gray;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = self.bottomView;
    
     [self navUIBarBackground:0];
 
}
- (void)registerCell{

//    [self.tableView registerClass:[UITableViewCell  class] forCellReuseIdentifier:SettingControllerIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SettingControllerCell class]) bundle:nil] forCellReuseIdentifier:SettingControllerIdentifier];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return  [self.settingList count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return FITSCALE(44);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return FITSCALE(20);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger row =  0;
    
     row = [self.settingList[section] count];
    
    return  row;
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
             case 0:{
                [self gotoChangePhoneVC];
                break;
            }
            case 1:{
                [self gotoChangePasswordVC];
                break;
                
            }
                
            default:
                break;
        }

    }else if(indexPath.section == 1) {
        switch (indexPath.row) {
                
            case 0:{
                [self gotoHelpVC];
                break;
            }
            case 1:{
                [self gotoAboutVC];
                break;
                
            }
                
            default:
                break;
        }
        
    
    }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell ;
    
     SettingControllerCell* tempCell = [tableView dequeueReusableCellWithIdentifier:SettingControllerIdentifier];
    [tempCell setupCellInfo:self.settingList[indexPath.section][indexPath.row]];
    cell = tempCell;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    return cell;
}

#pragma mark config

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, FITSCALE(90))];
        
        
//        UIView *separateLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 1)];
//        separateLine.backgroundColor = UIColorFromRGB(0x6b6b6b);
//        [_bottomView addSubview:separateLine];
        
        
        UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [nextBtn setAdjustsImageWhenHighlighted:NO];
        nextBtn.titleLabel.font = fontSize_15;
        [nextBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [nextBtn setBackgroundImage:[UIImage imageNamed:@"btn_normal_bg"] forState:UIControlStateNormal];
        [nextBtn setBackgroundImage:[UIImage imageNamed:@"btn_highlight_bg"] forState:UIControlStateHighlighted];
        
        
        [nextBtn addTarget:self action:@selector(exitLogin) forControlEvents:UIControlEventTouchUpInside];
        
        [_bottomView addSubview:nextBtn];
        [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(_bottomView);
            make.size.mas_equalTo(CGSizeMake( IPHONE_WIDTH -FITSCALE(28), FITSCALE(54)));
            
        }];
        
        
    }
    return _bottomView;
}

- (void)exitLogin{
    [[SessionHelper sharedInstance] clearMessageList];
    [[SessionHelper sharedInstance] clearSaveCacheSession];
    [[UINavigationBar appearance] setTintColor:project_main_blue];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

//    LoginController * loginVC = [[LoginController alloc]initWithNibName:NSStringFromClass([LoginController class]) bundle:nil];
  
//    UINavigationController * loginNaviVC =  [[UINavigationController alloc]initWithRootViewController:loginVC];
//    [self presentViewController:loginNaviVC animated:NO completion:nil];
    [self gotoLoginViewController];
    
}

- (void)gotoChangePhoneVC{
    ChangePhoneViewController * changePhoneVC = [[ChangePhoneViewController alloc]initWithNibName:NSStringFromClass([ChangePhoneViewController class]) bundle:nil];
    [self pushViewController:changePhoneVC];
    
}
- (void)gotoAboutVC{

    AboutController * aboutVC = [[AboutController alloc]init];
    [self pushViewController:aboutVC];
}

- (void)gotoHelpVC{

    HelpViewController * helpVC = [[HelpViewController alloc]init];
    [self pushViewController:helpVC];
}

- (void)gotoChangePasswordVC{

    ChangePasswordViewController * changePasswordVC =   [[ChangePasswordViewController alloc]init];
    [self pushViewController:changePasswordVC];
}
@end
