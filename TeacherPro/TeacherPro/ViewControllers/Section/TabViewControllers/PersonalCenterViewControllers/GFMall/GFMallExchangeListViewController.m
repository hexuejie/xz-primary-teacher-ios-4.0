
//
//  GFMallExchangeListViewController.m
//  TeacherPro
//
//  Created by DCQ on 2018/1/8.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "GFMallExchangeListViewController.h"
#import "GFMallExchangeListCell.h"
#import "GFMallExchangeListModel.h"

NSString * const GFMallExchangeListCellIdentifier = @"GFMallExchangeListCellIdentifier";
@interface GFMallExchangeListViewController ()
@property(nonatomic, strong) GFMallExchangeListModel * listModel;
@property(nonatomic, assign) GFMallExchangeVCType  type;
@property(nonatomic, copy) NSString *mallId;
@end

@implementation GFMallExchangeListViewController
- (instancetype)initWithId:(NSString*)mallId withVC:(GFMallExchangeVCType )type{
    if (self == [super init]) {
        self.mallId = mallId;
        self.type = type;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"兑换记录"];
    self.pageCount = 20;
    [self confightTableView];
    if (self.type == GFMallExchangeType_detail) {
        [self requestTeacherGiftExchangeLog];
    }
}
//查询单个商品
- (void)requestTeacherGiftExchangeLog{
    if (!self.mallId) {
        return;
    }
    NSDictionary * parameterDic = @{@"orderId":self.mallId, @"pageSize":@(self.pageCount),@"pageIndex":@(self.currentPageNo)};
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_ListTeacherGiftExchangeLog] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_ListTeacherGiftExchangeLog ];
}


- (void)confightTableView{
    self.tableView.backgroundColor = [UIColor clearColor];
     self.view.backgroundColor = project_background_gray;
}
- (void)requestListTeacherGiftExchangeLog{
    NSDictionary * parameterDic = @{@"pageSize":@(self.pageCount),@"pageIndex":@(self.currentPageNo)};
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_ListTeacherGiftExchangeLog] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_ListTeacherGiftExchangeLog ];
}
- (NSInteger )getNetworkTableViewDataCount{
    
    return [self.listModel.items count];
}
- (void)getLoadMoreTableViewNetworkData{
    if (self.type == GFMallExchangeType_normal) {
      self.currentPageNo++;
      [self requestListTeacherGiftExchangeLog];
            
   }
}
- (void)getNormalTableViewNetworkData{
    if (self.type == GFMallExchangeType_normal) {
        self.currentPageNo = 0;
        [self requestListTeacherGiftExchangeLog];
    }
    
}

- (void)setNetworkRequestStatusBlocks{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_ListTeacherGiftExchangeLog) {
            
            if (strongSelf.currentPageNo == 0||!strongSelf.listModel) {
                strongSelf.listModel = nil;
                  strongSelf.listModel =  [[GFMallExchangeListModel alloc]initWithDictionary:successInfoObj error:nil];
                
            }else{
                
                GFMallExchangeListModel  *listModel =  [[GFMallExchangeListModel alloc]initWithDictionary:successInfoObj error:nil];
                if (listModel.items) {
                    [strongSelf.listModel.items addObjectsFromArray:listModel.items];
                   
                }
            }
            [strongSelf updateTableView];
            
        }
    }];
}
- (BOOL)isAddRefreshHeader{
    BOOL  yesOrNo = NO;
    if (self.type == GFMallExchangeType_normal) {
        yesOrNo = YES;
    }
    return yesOrNo;
}
- (BOOL)isAddRefreshFooter{
    BOOL  yesOrNo = NO;
    if (self.type == GFMallExchangeType_normal) {
        yesOrNo = YES;
    }
    return yesOrNo;
  
}

- (void)registerCell{
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GFMallExchangeListCell class]) bundle:nil] forCellReuseIdentifier:GFMallExchangeListCellIdentifier];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [self.listModel.items count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 160;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = nil;
    GFMallExchangeListCell * tempCell = [tableView dequeueReusableCellWithIdentifier:GFMallExchangeListCellIdentifier];
    [tempCell setupInfoModel:self.listModel.items[indexPath.section]];
    cell = tempCell;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height =  0.0000001;
    if (section == 0) {
        height = 8;
    }
    return height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    CGFloat height =  0.0000001;
    height = 8;
    return height;
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
