//
//  GFMallMyAddressListViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/12/7.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "GFMallMyAddressListViewController.h"
#import "GFMallAddressListModel.h"
#import "GFMallAddressAdministerCell.h"
#import "GFMallAddressAdministerFooterCell.h"
#import "GFMallAddAddressViewController.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "GFMallAddressAdministerBottomView.h"

NSString * GFMallAddressAdministerFooterCellIdentifier = @"GFMallAddressAdministerFooterCellIdentifier";
NSString * GFMallAddressAdministerCellIdentifier = @"GFMallAddressAdministerCellIdentifier";

#define kMyAddressBottomHeight 60
@interface GFMallMyAddressListViewController ()
@property(nonatomic, copy) GFMallAddressListModel * model;
@property(nonatomic, strong) NSIndexPath * selectedIndexPath;
@property(nonatomic, strong) GFMallAddressAdministerBottomView * bottomView;
@property(nonatomic, assign) NSInteger selectedIndex;
@end

@implementation GFMallMyAddressListViewController
- (instancetype)initWithModel:(GFMallAddressListModel *) model withSelectedIndex:(NSInteger)selectedIndex{
    if (self == [super init]) {
        self.selectedIndex = selectedIndex;
    }
    return self;
}

- (GFMallAddressAdministerBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GFMallAddressAdministerBottomView class]) owner:nil options:nil].firstObject;
        
    }
    return _bottomView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择收货地址";
    [self confightTableView];
    if (!self.selectedIndex) {
        self.selectedIndex = 0;
    }
    [self.view addSubview:self.bottomView];
    [self confightTableView];
    [self confightBottomView];
    [self requestQueryTeacherAddressById];
}
- (void)requestQueryTeacherAddressById{
    
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_QueryTeacherAddressById] parameterDic:nil requestMethodType:RequestMethodType_POST requestTag:NetRequestType_QueryTeacherAddressById];
}

- (void)confightBottomView{
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        CGFloat bottomHeight = kMyAddressBottomHeight;
         CGFloat top = self.view.frame.size.height - bottomHeight;
        make.leading.mas_equalTo(self.view.mas_leading);
        make.trailing.mas_equalTo(self.view.mas_trailing);
        make.top.mas_equalTo(@(top));
        make.height.mas_equalTo(@(bottomHeight));
    }];
    WEAKSELF
    self.bottomView.addBlock = ^{
        if ([weakSelf.model.items count] >= 10) {
            [weakSelf showAlert:TNOperationState_Unknow content:@"地址最多添加10个，请删除一个或多个地址再点添加"];
        }else{
            [weakSelf  gotoAddAddressVC];
        }
        
    };
    
}
- (void)confightTableView{
    
    self.view.backgroundColor = project_background_gray;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
}
- (void)registerCell{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GFMallAddressAdministerCell class]) bundle:nil] forCellReuseIdentifier:GFMallAddressAdministerCellIdentifier];
   [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GFMallAddressAdministerFooterCell class]) bundle:nil] forCellReuseIdentifier:GFMallAddressAdministerFooterCellIdentifier];
}
- (CGRect)getTableViewFrame{
    CGRect  frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - kMyAddressBottomHeight);
    return frame;
}
#pragma mark  ---

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [self.model.items count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row = 2;
    
    return row;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat height = FITSCALE(0);
    if (indexPath.row == 0) {
  
        height = [tableView fd_heightForCellWithIdentifier:GFMallAddressAdministerCellIdentifier configuration:^(id cell) {
            [self configureCell:cell atIndexPath:indexPath];
        } ];
    }else{
        height = FITSCALE(40);
    }
    return height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell =  nil;
    if (indexPath.row == 0) {
        GFMallAddressAdministerCell * tempCell = [tableView dequeueReusableCellWithIdentifier:GFMallAddressAdministerCellIdentifier];
        [self configureCell:tempCell atIndexPath:indexPath];
        cell = tempCell;
    }else{
        GFMallAddressAdministerFooterCell * tempCell = [tableView dequeueReusableCellWithIdentifier:GFMallAddressAdministerFooterCellIdentifier];
        tempCell.indexPath = indexPath;
        BOOL show = NO;
        if (indexPath.section == self.selectedIndex) {
            show = YES;
        }
        [tempCell setupShowChooseAddressSate:show];
        tempCell.editBlock = ^(NSIndexPath *indexPath) {
            [self gotoEditVC:indexPath];
        };
        tempCell.delBlock = ^(NSIndexPath *indexPath) {
            [self deleteAddress:indexPath];
        };
        cell = tempCell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     GFMallAddressModel * addressModel = self.model.items[indexPath.section];
    if (self.chooseblock) {
        self.chooseblock(indexPath.section,addressModel);
    }
    [self backViewController];
}
- (void)configureCell:(GFMallAddressAdministerCell *)cell atIndexPath:(NSIndexPath *)indexPath {
     cell.fd_enforceFrameLayout = NO; // Enable to use "-sizeThatFits:"
     [cell setupModel: self.model.items[indexPath.section]]; 
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
}

- (void)gotoEditVC:(NSIndexPath *)indexPath{
    GFMallAddressModel * addressModel = self.model.items[self.selectedIndexPath.section];
    GFMallAddAddressViewController * editVC = [[GFMallAddAddressViewController alloc]initWithModel:addressModel];
    editVC.updateAddressBlock = ^{
        [self requestQueryTeacherAddressById];
    };
    [self pushViewController:editVC];
}

- (void)deleteAddress:(NSIndexPath *)indexPath{
    self.selectedIndexPath = indexPath;
    MMPopupItemHandler itemHandler = ^(NSInteger index){
        [self requestDeleteTeacherAddress];
    };
    NSArray * array =  @[MMItemMake(@"否", MMItemTypeHighlight, nil),
                         MMItemMake(@"是", MMItemTypeHighlight, itemHandler)];
    [self showNormalAlertTitle:@"温馨提示" content:@"是否删除该地址"  items:array block:nil];
    

}


- (void)requestDeleteTeacherAddress{
    GFMallAddressModel * addressModel = self.model.items[self.selectedIndexPath.section];
    NSString * addressId = addressModel.id;
    
    NSDictionary * parameterDic = @{@"addressId":addressId};
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_DeleteTeacherAddress] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_DeleteTeacherAddress];
}

- (void)setNetworkRequestStatusBlocks{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_DeleteTeacherAddress) {
           [strongSelf.model.items removeObjectAtIndex:strongSelf.selectedIndexPath.section];
            [strongSelf updateTableView];
            //删除最后一个地址 需要情况订单列表的地址
            if ([strongSelf.model.items count] == 0) {
                if (strongSelf.emptyBlock) {
                    strongSelf.emptyBlock();
                }
            }
            
        }else if (request.tag == NetRequestType_QueryTeacherAddressById) {
            strongSelf.model = [[GFMallAddressListModel alloc]initWithDictionary:successInfoObj error:nil];
           
            [strongSelf updateTableView];
        }
    }];
}


- (void)gotoAddAddressVC{
    GFMallAddAddressViewController * addAddressVC = [[GFMallAddAddressViewController alloc]init];
    addAddressVC.updateAddressBlock = ^{
        [self requestQueryTeacherAddressById];
    };
    [self pushViewController:addAddressVC];
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
