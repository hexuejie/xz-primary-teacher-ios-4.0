
//
//  GFMallAddAddressViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/12/7.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "GFMallAddAddressViewController.h"
#import "GFMallChooseAreaViewController.h"
#import "GFMallAddressEditNameOrPhoneCell.h"
#import "GFMallChooseAreaCell.h"
#import "GFMallAddressEditDetailCell.h"
#import "GFMallChooseAreaViewController.h"
#import "GFMallAddressListModel.h"
#import "IQKeyboardManager.h"

NSString  * const GFMallAddressEditDetailCellIdentifier = @"GFMallAddressEditDetailCellIdentifier";
NSString * const GFMallAddressEditNameCellIdentifier = @"GFMallAddressEditNameCellIdentifier";
NSString * const  GFMallChooseAreaCellIdentifier = @"GFMallChooseAreaCellIdentifier";
NSString * const  GFMallAddressEditPhoneCellIdentifier = @"GFMallAddressEditPhoneCellIdentifier";
NSString * const  UITableViewHeaderFooterViewIdentifier = @"UITableViewHeaderFooterViewIdentifier";


@interface GFMallAddAddressViewController ()
@property(nonatomic, copy) NSString * name ;// 收件人姓名
@property(nonatomic, copy) NSString *phone ;//收件人电话号码
@property(nonatomic, copy) NSString *province;//省编码
@property(nonatomic, copy) NSString *city ;// 市编码
@property(nonatomic, copy) NSString *addressDetail;//收件人详细地址
@property(nonatomic, copy) NSString *area;//选择区 名
@property(nonatomic, strong) GFMallAddressModel * modifyModel;

@end

@implementation GFMallAddAddressViewController
- (instancetype)initWithModel:(GFMallAddressModel*) model{
    if (self == [super init]) {
        self.modifyModel = model;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString * titleStr = @"";
    if (self.modifyModel) {
        titleStr = @"修改地址";
        self.province = self.modifyModel.province;
        self.city = self.modifyModel.city;
        self.addressDetail = self.modifyModel.addressDetail;
        self.phone = self.modifyModel.contactPhone;
        self.name = self.modifyModel.contactName;
        if ([self.modifyModel.completeAddress componentsSeparatedByString:@"市"]) {
            self.area = [NSString stringWithFormat:@"%@市",[self.modifyModel.completeAddress componentsSeparatedByString:@"市"][0]];
        }
       
    }else{
        titleStr = @"添加新地址";
        
    }
    self.title = titleStr;
    [self confightNavigationRightView];
    
    self.view.backgroundColor = project_background_gray;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
}
- (UITableViewStyle)getTableViewStyle{
    
    return UITableViewStyleGrouped;
}
- (CGRect)getTableViewFrame{
    CGRect tableViewFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height );
    return tableViewFrame;
}


- (void)confightNavigationRightView{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, 2, 60, 46);
 
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(addNewAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)addNewAction:(id)sender{
    //回收键盘
      [[IQKeyboardManager sharedManager] resignFirstResponder];
    if (self.modifyModel) {
        [self requestUpdateTeacherAddress ];
    }else{
        [self requestAddTeacherAddress];
        
    }
}

- (void)registerCell{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GFMallAddressEditDetailCell class]) bundle:nil] forCellReuseIdentifier:  GFMallAddressEditDetailCellIdentifier];
      [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GFMallChooseAreaCell  class]) bundle:nil] forCellReuseIdentifier:  GFMallChooseAreaCellIdentifier];
      [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GFMallAddressEditNameOrPhoneCell class]) bundle:nil] forCellReuseIdentifier: GFMallAddressEditNameCellIdentifier];
      [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GFMallAddressEditNameOrPhoneCell class]) bundle:nil] forCellReuseIdentifier:  GFMallAddressEditPhoneCellIdentifier];
     [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:UITableViewHeaderFooterViewIdentifier];
}


#pragma mark  ---

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row = 1;
    if (section == 0) {
        row = 3;
    }
    return row;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat height = FITSCALE(0);
    if (indexPath.section == 0) {
        height = FITSCALE(44);
    }else{
        height = FITSCALE(140);
    }
    return height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell =  nil;
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                cell = [self confightAddressNameTalbeView:tableView AtIndexPath:indexPath];
                break;
            case 1:
                cell = [self confightAddressPhoneTalbeView:tableView AtIndexPath:indexPath];
                break;
            case 2:
                cell = [self confightAddressAreaTalbeView:tableView AtIndexPath:indexPath];
                break;
            default:
                break;
        }
    }else{
        cell = [self confightAddressTextTalbeView:tableView AtIndexPath:indexPath];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2) {
        [self gotoGFMallChooseAreaVC];
    }
}
- (UITableViewCell *)confightAddressNameTalbeView:(UITableView *)tableView AtIndexPath:(NSIndexPath *)indexPath{
    GFMallAddressEditNameOrPhoneCell * cell = [tableView dequeueReusableCellWithIdentifier:GFMallAddressEditNameCellIdentifier];
     cell.indexPath = indexPath;
    [cell setupTitle:@"收货人："   withPlaceholder:@"请输入收货人姓名"];
   
     if (self.modifyModel) {
         [cell setupContent:self.modifyModel.contactName];
     }
    cell.inputBlock = ^(NSString *inputText) {
        self.name = inputText;
    };
    return cell;
}

- (UITableViewCell *)confightAddressPhoneTalbeView:(UITableView *)tableView AtIndexPath:(NSIndexPath *)indexPath{
    GFMallAddressEditNameOrPhoneCell * cell = [tableView dequeueReusableCellWithIdentifier:GFMallAddressEditPhoneCellIdentifier];
       cell.indexPath = indexPath;
    [cell setupTitle:@"电话："  withPlaceholder:@"请输入收货人电话"];
  
     if (self.modifyModel) {
         [cell setupContent:self.modifyModel.contactPhone];
     }
    cell.inputBlock = ^(NSString *inputText) {
        self.phone = inputText;
    };
    return cell;
}

- (UITableViewCell *)confightAddressAreaTalbeView:(UITableView *)tableView AtIndexPath:(NSIndexPath *)indexPath{
    GFMallChooseAreaCell * cell = [tableView dequeueReusableCellWithIdentifier:GFMallChooseAreaCellIdentifier];
   
    [cell setupArea:self.area];
    return cell;
}
- (UITableViewCell *)confightAddressTextTalbeView:(UITableView *)tableView AtIndexPath:(NSIndexPath *)indexPath{
    GFMallAddressEditDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:GFMallAddressEditDetailCellIdentifier];
    if (self.modifyModel) {
         [cell setupContent:self.modifyModel.addressDetail];
    }
   
    cell.inputBlock = ^(NSString *inputText) {
        self.addressDetail = inputText;
    };
    return cell;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView * view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:UITableViewHeaderFooterViewIdentifier];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 6;
}

- (void)requestAddTeacherAddress{
     NSMutableDictionary * parameterDic = [NSMutableDictionary dictionary];
    if (self.name) {
        [parameterDic addEntriesFromDictionary:@{@"name":self.name}];
    }else{
        [self showAlert:TNOperationState_Unknow content:@"请填写收货人"];
        return ;
    }
    if (self.phone) {
        [parameterDic addEntriesFromDictionary:@{@"phone":self.phone}];
    }else{
        [self showAlert:TNOperationState_Unknow content:@"请填写电话"];
        return ;
    }
    
    if (self.province) {
        [parameterDic addEntriesFromDictionary:@{@"province":self.province}];
    }else{
         [self showAlert:TNOperationState_Unknow content:@"请选择地区"];
        return ;
    }
    if (self.city) {
        [parameterDic addEntriesFromDictionary:@{@"city":self.city}];
    }else{
        [self showAlert:TNOperationState_Unknow content:@"请选择地区"];
        return ;
    }
    if (self.addressDetail) {
        [parameterDic addEntriesFromDictionary:@{@"addressDetail":self.addressDetail}];
    }else{
        [self showAlert:TNOperationState_Unknow content:@"请填写详情"];
        return ;
    }
   
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_AddTeacherAddress] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_AddTeacherAddress];
}

- (void)setNetworkRequestStatusBlocks{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_AddTeacherAddress ) {
            [strongSelf updateAddList];
        }else if (NetRequestType_UpdateTeacherAddress == request.tag){
            [strongSelf updateAddList];
        }
    }];
}
- (void)updateAddList{
    //
    if (self.updateAddressBlock) {
        self.updateAddressBlock();
    }
     [self backViewController];
}

- (void)gotoGFMallChooseAreaVC{
    
    GFMallChooseAreaViewController * areaVC = [[GFMallChooseAreaViewController alloc]init];
    areaVC.chooseAreaBlock = ^(NSString *area, NSString *province, NSString *city) {
        
        if ([area componentsSeparatedByString:@"市"] ) {
            if ([[area componentsSeparatedByString:@"市"][0] isEqualToString: [area componentsSeparatedByString:@"市"][0]]){
               area = [NSString stringWithFormat:@"%@市",[area componentsSeparatedByString:@"市"][0] ];
            }
        }
        self.area = area;
        self.province = province;
        self.city = city;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    };
    [self pushViewController:areaVC];
}


- (void)requestUpdateTeacherAddress{
    NSDictionary * parameterDic = @{@"addressId":self.modifyModel.id,@"name":self.name,@"phone":self.phone,@"province":self.province,@"city":self.city,@"addressDetail":self.addressDetail};
    [self  sendHeaderRequest: [NetRequestAPIManager getRequestURLStr:NetRequestType_UpdateTeacherAddress] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_UpdateTeacherAddress];
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
