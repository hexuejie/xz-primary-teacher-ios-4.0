//
//  GFMallOrderViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/12/5.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "GFMallOrderViewController.h"
#import "GFMallListModel.h"
#import "GFMallOrderMallCell.h"
#import "GFMallOrderBottomView.h"
#import "GFMallOrderAddressTitleCell.h"
#import "GFMallOrderAddressContentCell.h"
#import "GFMallOrderAddAddressCell.h"
#import "GFMallAddressListModel.h"
#import "GFMallViewController.h"
#import "GFMallAddAddressViewController.h"
#import "GFMallMyAddressListViewController.h"
#import "UITableView+FDTemplateLayoutCell.h"


NSString * const  GFMallOrderMallCellIdentifer = @"GFMallOrderMallCellIdentifer";

NSString * const  GFMallOrderAddressTitleCellIdentifer = @"GFMallOrderAddressTitleCellIdentifer";
NSString * const  GFMallOrderAddressContentCellIdentifer = @"GFMallOrderAddressContentCellIdentifer";
NSString * const  GFMallOrderAddAddressCellIdentifer = @"GFMallOrderAddAddressCellIdentifer";
NSString * const  GFMallOrderUITableViewHeaderFooterViewIdentifier = @"GFMallOrderUITableViewHeaderFooterViewIdentifier";
#define  kMallOrderBottomHeight   FITSCALE(80)
@interface GFMallOrderViewController ()
@property(nonatomic, strong) GFMallOrderBottomView * bottomView;
@property(nonatomic, strong) GFMallAddressListModel * addressModel ;
@property(nonatomic, strong) GFMallModel *  model;
@property(nonatomic, copy) NSString * addressId;
@property(nonatomic, copy) GFMallAddressModel * chooseAddressModel;
@property(nonatomic, copy) NSString * giftId;
@property(nonatomic, copy) NSString * giftCount;
@property(nonatomic, assign) NSInteger selectedIndex;
@property(nonatomic, assign) BOOL  isShowData;//是否显示
@end

@implementation GFMallOrderViewController
- (instancetype)initWithModel:(GFMallModel *)model{
    if (self == [super init]) {
        self.model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"订单填写";
    self.isShowData = NO;
    [self.view addSubview:self.bottomView];
    self.bottomView.hidden = YES;
    self.giftCount = @"1";
    self.selectedIndex = 0;
    [self confightBottomView];
    [self confightTableView];
    [self requestQueryTeacherAddressById];
 
}

- (void)requestQueryTeacherAddressById{
    
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_QueryTeacherAddressById] parameterDic:nil requestMethodType:RequestMethodType_POST requestTag:NetRequestType_QueryTeacherAddressById];
}

- (void)setNetworkRequestStatusBlocks{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_QueryTeacherAddressById) {
            strongSelf.addressModel = [[GFMallAddressListModel alloc]initWithDictionary:successInfoObj error:nil];
            if ([strongSelf.addressModel.items count] > 0) {
                GFMallAddressModel * addressModel = strongSelf.addressModel.items[strongSelf.selectedIndex];
                strongSelf.addressId = addressModel.id;
                
            }
            strongSelf.isShowData = YES;
            strongSelf.bottomView.hidden = NO;
            [strongSelf updateTableView];
        }else  if (request.tag == NetRequestType_TeacherExchangeGift) {
           NSString * timerStr  = successInfoObj[@"deliveryTime"];
            NSString * content = [NSString stringWithFormat:@"兑换成功,预计发货时间:%@",timerStr];
            [strongSelf showAlert:TNOperationState_OK content:content block:^(NSInteger index) {
                  [strongSelf backPersonalVC];
                  [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_CHECKLIST_TEARCHER_COIN object:nil];
            }];
          
        }
    }];
}

- (void)backPersonalVC{
    UIViewController * vc = self.navigationController.viewControllers[0];
    [self.navigationController popToViewController:vc animated:YES];
}
- (void)confightTableView{
    
    self.view.backgroundColor = project_background_gray;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
}
- (void)confightBottomView{
    
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        CGFloat bottomHeight = kMallOrderBottomHeight;
        CGFloat top = self.view.frame.size.height - bottomHeight;
        make.leading.mas_equalTo(self.view.mas_leading);
        make.trailing.mas_equalTo(self.view.mas_trailing);
        make.top.mas_equalTo(@(top));
        make.height.mas_equalTo(@(bottomHeight));
    }];
    WEAKSELF
    self.bottomView.sureBlock = ^{
        STRONGSELF
        [strongSelf requestTeacherExchangeGift];
    };
    [self updateBottomViewData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)registerCell{
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GFMallOrderMallCell class])  bundle:nil] forCellReuseIdentifier:GFMallOrderMallCellIdentifer];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GFMallOrderAddAddressCell class])  bundle:nil] forCellReuseIdentifier:GFMallOrderAddAddressCellIdentifer];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GFMallOrderAddressTitleCell class])  bundle:nil] forCellReuseIdentifier:GFMallOrderAddressTitleCellIdentifer];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GFMallOrderAddressContentCell class])  bundle:nil] forCellReuseIdentifier:GFMallOrderAddressContentCellIdentifer];
    
      [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:GFMallOrderUITableViewHeaderFooterViewIdentifier];
}

- (GFMallOrderBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GFMallOrderBottomView class]) owner:nil options:nil].firstObject;
    }
    return _bottomView;
}

- (CGRect)getTableViewFrame{
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - kMallOrderBottomHeight);
    
    return frame;
}

#pragma mark  ---

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger section = 0;
    if (self.isShowData) {
        section = 2;
    }
    return section;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row = 1;
    if (section == 0) {
        row = 2;
    }
    return row;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat height = FITSCALE(0);
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            height = FITSCALE(44);
        }else{
            if ([self.addressModel.items count] == 0) {
               height = FITSCALE(60);
            }else{
                height =  [tableView fd_heightForCellWithIdentifier:GFMallOrderAddressContentCellIdentifer configuration:^(id cell) {
                    [self configureCell:cell atIndexPath:indexPath];
                } ]+10;
                
            }
        }
    }else{
        height = FITSCALE(120);
    }
    return height;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView * view = [UIView new];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell =  nil;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            GFMallOrderAddressTitleCell * tempCell = [tableView dequeueReusableCellWithIdentifier:GFMallOrderAddressTitleCellIdentifer];
            cell = tempCell;
        }else{
            //新增
            if ([self.addressModel.items count] == 0) {
                GFMallOrderAddAddressCell * tempCell = [tableView dequeueReusableCellWithIdentifier:GFMallOrderAddAddressCellIdentifer];
                tempCell.addBlock = ^{
                    [self gotoAddAddressVC];
                };
                cell = tempCell;
            }else{
                //默认地址
                GFMallOrderAddressContentCell * tempCell = [tableView dequeueReusableCellWithIdentifier:GFMallOrderAddressContentCellIdentifer];
                [self configureCell:tempCell atIndexPath:indexPath];
                cell = tempCell;
            }
        
        }
    }else{
        GFMallOrderMallCell * tempCell = [tableView dequeueReusableCellWithIdentifier:GFMallOrderMallCellIdentifer];
        [tempCell setupModel:self.model];
  
        WEAKSELF
        tempCell.giftBlock = ^(NSInteger giftCount) {
            weakSelf.giftCount = [NSString stringWithFormat:@"%ld",giftCount];
            [self updateBottomViewData];
        };
        cell = tempCell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)configureCell:(GFMallOrderAddressContentCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.fd_enforceFrameLayout = NO; // Enable to use "-sizeThatFits:"
    GFMallAddressModel * model=  nil;
    if (self.chooseAddressModel) {
        model = self.chooseAddressModel;
    }else{
        model = self.addressModel.items[self.selectedIndex];
        
    }
    [cell setupModel:model];
}


- (void)updateBottomViewData{
    
    NSInteger payCoin = [self.giftCount integerValue] * [self.model.count integerValue];
    [self.bottomView setupPayCoin:[NSString stringWithFormat:@"%@",@(payCoin)]];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 ) {
        if ([self.addressModel.items count] == 0) {
           [self gotoAddAddressVC];
        }else{
            [self gotoChangeAddressVC];
        }
    }
 
}

- (void)gotoAddAddressVC{
    GFMallAddAddressViewController * addAddressVC = [[GFMallAddAddressViewController alloc]init];
    addAddressVC.updateAddressBlock = ^{
        [self requestQueryTeacherAddressById];
    };
    [self pushViewController:addAddressVC];
}
- (void)gotoChangeAddressVC{
    GFMallMyAddressListViewController * addressListVC = [[GFMallMyAddressListViewController alloc]initWithModel:self.addressModel withSelectedIndex:self.selectedIndex];
    WEAKSELF
    addressListVC.chooseblock = ^(NSInteger index,GFMallAddressModel * addressModel) {
        weakSelf.selectedIndex = index;
        weakSelf.chooseAddressModel = addressModel;
        [weakSelf updateTableView];
//        [weakSelf requestQueryTeacherAddressById];
        
    };
    
    addressListVC.emptyBlock = ^{
        weakSelf.addressModel = nil;
        [weakSelf updateTableView];
    };
    [self pushViewController:addressListVC];
}

- (void)requestTeacherExchangeGift{
    self.giftId   = [NSString stringWithFormat:@"%@",self.model.id];
    if (!self.addressId) {
        [self showAlert:TNOperationState_Unknow content:@"请选择收货地址"];
        return;
    }
    if (!self.giftId) {
        
        return;
    }
    if (!self.giftCount) {
        
        return;
    }
  
    NSDictionary * parameterDic = @{@"addressId":self.addressId,@"giftId":self.giftId,@"giftCount":self.giftCount};
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_TeacherExchangeGift] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_TeacherExchangeGift];
}


@end
