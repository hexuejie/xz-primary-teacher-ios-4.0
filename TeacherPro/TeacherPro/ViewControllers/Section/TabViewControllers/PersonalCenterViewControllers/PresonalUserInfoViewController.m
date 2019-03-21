//
//  UserInfoViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/7/15.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "PresonalUserInfoViewController.h"
#import "ModifyUserCell.h"
#import <objc/runtime.h>
#import "SessionModel.h"
#import "SessionHelper.h"
#import "PresonalUserInfoSectionCell.h"
#import "AddressListViewController.h"


NSString * const     ModifyUserCellreuseIdentifier = @"ModifyUserCellreuseIdentifier";
NSString * const     PresonalUserInfoSectionCellreuseIdentifier = @"PresonalUserInfoSectionCellreuseIdentifier";
@interface PresonalUserInfoViewController ()<UITextFieldDelegate>
@property BOOL editable;
@property (nonatomic,strong) NSString *newusername;
@property (nonatomic,strong) NSString *newusersex;
@end

@implementation PresonalUserInfoViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.editable = NO;
     
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationItemTitle:@"个人信息"];
    self.view.backgroundColor = project_background_gray;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self navUIBarBackground:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)registerCell{

    [self.tableView registerNib: [UINib nibWithNibName:NSStringFromClass([ModifyUserCell class]) bundle:nil ] forCellReuseIdentifier:ModifyUserCellreuseIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PresonalUserInfoSectionCell class]) bundle:nil] forCellReuseIdentifier:PresonalUserInfoSectionCellreuseIdentifier];
    
}

- (UITableViewStyle)getTableViewStyle{

    return UITableViewStyleGrouped;
}
#pragma mark evnet
- (void)updateUserName:(NSString *)newname   {
   self.newusername = newname;
    self.newusersex = [[SessionHelper sharedInstance]getAppSession].sex;
    NSDictionary *parameterDic = @{@"teacherName":newname};
  
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_TeacherUpdateName] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_TeacherUpdateName];
    
   
}

- (void)updateUserSex:(NSString *)sex{
    self.newusername =  [[SessionHelper sharedInstance]getAppSession].name;
    self.newusersex = sex;
     NSDictionary *parameterDic = @{@"teacherName": [[SessionHelper sharedInstance]getAppSession].name ,
                                    @"sex":sex};
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_TeacherUpdateName] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_TeacherUpdateName];
}
- (void)setNetworkRequestStatusBlocks{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_TeacherUpdateName) {
            [[SessionHelper sharedInstance]getAppSession].name = strongSelf.newusername;
            [[SessionHelper sharedInstance]getAppSession].sex = strongSelf.newusersex;
            
            [[SessionHelper sharedInstance]saveCacheSession:[[SessionHelper sharedInstance] getAppSession]];
            NSString * content = @"修改成功";
            [strongSelf showAlert:TNOperationState_OK content:content];
            [strongSelf updateTableView];

        }else if(request.tag == NetRequestType_QueryTeacherExistsClazz){
        
            if (successInfoObj[@"exists"]) {
                if ([successInfoObj[@"exists"] boolValue] ) {
                    [strongSelf showAlert:TNOperationState_Fail content:@"你还在本校班级任教，请解除班级关系后，再来修改学校！"];
                }else{
                    AddressListViewController * addressVC = [[AddressListViewController alloc]init];
                    addressVC.addressSuccessblock = ^{
                        
                        [strongSelf updateTableView];
                    };
                    [strongSelf pushViewController:addressVC];
                }
            }
        }
    }];
}


#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return FITSCALE(50);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return FITSCALE(10);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger row = 0;
    if (section == 0) {
        row = 1;
    }else{
        row = 3;
    }
    return row;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView * headerView = [[UIView alloc]init];
    return headerView;
 
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = nil;
    if (indexPath.section == 0) {
          PresonalUserInfoSectionCell *tempCell = [tableView dequeueReusableCellWithIdentifier:PresonalUserInfoSectionCellreuseIdentifier];
        tempCell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell = tempCell;
        
    }else{
        
        ModifyUserCell *tempCell = [tableView dequeueReusableCellWithIdentifier:ModifyUserCellreuseIdentifier];
        tempCell.indexPath = indexPath;
        tempCell.changeBlock = ^(NSIndexPath *index, UITextField *contentInput,UIButton * changeBtn) {
            if (indexPath.row == 0) {
                [self changeName:contentInput  ];
            }else  if (indexPath.row == 1) {
                [self changeSix:contentInput  ];
            }else  if (indexPath.row == 2) {
                [self changeSchoolName:contentInput ];
            }
        };
        
        switch (indexPath.row) {
            case 0:{
                
                tempCell.contentInput.text = [[SessionHelper sharedInstance]getAppSession].name;
                
                break;
            }
                
            case 1:
            {
                tempCell.titleLabel.text = @"性 别:";
                
                NSString * gender = [[SessionHelper sharedInstance]getAppSession].sex;
                NSString * sex = @"";
                if ( [gender isEqualToString: @"male"]) {
                   sex = @"男";
                }else if ([gender isEqualToString: @"female"]) {
                   sex = @"女";
                }
                tempCell.contentInput.text = sex;
            }
                break;
            case 2:
                tempCell.titleLabel.text = @"学 校:";
                tempCell.contentInput.text = [[SessionHelper sharedInstance]getAppSession].schoolName;
                break;
                
            default:
                break;
        }
        cell = tempCell;
    }
      return cell;
}



- (void)changeName:(UITextField *)contentInput  {
    NSString * title =  @"修改姓名";
    NSString * placeholder = [contentInput text];
    NSArray * items =  @[MMItemMake(@"取消", MMItemTypeHighlight, nil),
                         MMItemMake(@"确定", MMItemTypeHighlight, nil)];
    
    [self showAlertNormalInputTitle:title content:nil items:items placeholder:placeholder handler:^(NSString *text) {
        [self updateUserName:text];
    }];
}

- (void)changeSix:(UITextField *)contentInput  {
    NSString * title =  @"修改性别";
    NSString * sex = [contentInput text];
    
 
    NSArray * items =  @[MMItemMake(@"取消", MMItemTypeHighlight, nil),
                         MMItemMake(@"确定", MMItemTypeHighlight, nil)];
    
    AlertView  * alertView = [[AlertView alloc]initWithTitle:title normarlSex:sex items:items];
    
    alertView.sexBlock = ^(NSString *sex) {
         [self updateUserSex:sex];
        
         [self updateTableView];
    };
    [alertView show];
}

- (void)changeSchoolName:(UITextField *)contentInput  {

    [self requestExistsClazz];
  
 
}

- (void)requestExistsClazz{
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_QueryTeacherExistsClazz] parameterDic:nil requestMethodType:RequestMethodType_POST requestTag:NetRequestType_QueryTeacherExistsClazz];
    
}
@end
