//
//  GratitudeCurrencyViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/7/6.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "GratitudeCurrencyViewController.h"
#import "GratitudeCurrencyCell.h"
#import "GratitudeCurrencyListModel.h"
#import "PublicDocuments.h"
#import "HeaderElasticBgView.h"
#import "GFMallViewController.h"
#import "HelpViewController.h"
#import "GFMallExchangeListViewController.h"
#import "GratitudeTopView.h"

#define headerBgViewTag  112222
typedef NS_ENUM(NSInteger, GratitudeCurrencyType) {
   GratitudeCurrencyType_normal = 0,
   GratitudeCurrencyType_obtain   ,//获取
   GratitudeCurrencyType_consumption  ,//消耗
};

NSString * const GratitudeCurrencyCellIdentifier = @"GratitudeCurrencyCellIdentifier";
@interface GratitudeCurrencyViewController ()
@property (nonatomic, assign) GratitudeCurrencyType type;
@property (nonatomic, strong) GratitudeCurrencyListModel * models;
@property (nonatomic,strong) UIView *navigationBackgroundView;
//
@property (nonatomic,strong) UIView *headerView,*consumeLine,*obtainLine;
@property (nonatomic,strong) UILabel *coinCountLabel, *obtainReason,*obtainTime,*obtainCount;
@property (nonatomic,strong) NSString *coinNumber;
@end

@implementation GratitudeCurrencyViewController


- (instancetype)initWithCoin:(NSString *)coinNumber{
    
    if (self == [super init]) {
        self.type = GratitudeCurrencyType_obtain;
        self.coinNumber = coinNumber;
       
    }
    return self;
}
- (void)viewDidLoad {
    self.currentPageNo = 0;
    self.pageCount = 10;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationItemTitle:@"我的感恩币"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.separatorColor = UIColorFromRGB(0x6b6b6b);
//    self.tableView.separatorInset = UIEdgeInsetsMake(0, -10, 0, 0);
    self.tableView.tableHeaderView = self.headerView;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    
//    [self navigationConfig];
 
//    [self navigationRightItem];
}
- (void)navigationRightItem{
    
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"获取规则" forState:UIControlStateNormal];
    [rightBtn setFrame:CGRectMake(0, 0, 80, 44)];
    rightBtn.titleLabel.font = fontSize_14;
    [rightBtn addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView: rightBtn];
}

- (void)rightAction:(id)sender{
    
    HelpViewController * helpVC = [[HelpViewController alloc]init];
    [self pushViewController:helpVC];
    
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    
    return [UIImage imageNamed:@""];
}
///**
// 导航栏的各种配置
// */
//- (void)navigationConfig {
//    
//    
//    //navigationBar下面的黑线隐藏掉
//    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
//    
//    UIView *uiBarBackground = self.navigationController.navigationBar.subviews.firstObject;
//    
//    [uiBarBackground addSubview:self.navigationBackgroundView];
//    
//    
//}
//
//-  (UIView *)navigationBackgroundView{
//    
//    if (!_navigationBackgroundView) {
//        //添加一个背景颜色view
//        _navigationBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
//        _navigationBackgroundView.backgroundColor = project_main_blue;
//        
//        _navigationBackgroundView.alpha = 1.0;
//        
//    }
//    return _navigationBackgroundView;
//}
- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];

    
}

- (BOOL)getNavBarBgHidden{
    
    return NO;
}
- (UIRectEdge)getViewRect{
    
    return UIRectEdgeNone;
}

 
- (UILabel *)createLabelWithContent:(NSString *)content withFont:(UIFont *)font withTextColor:(UIColor *)textColor{
    UILabel *label = [[UILabel alloc] init];
    label.text = content;
    label.textColor = textColor;
    label.font = font;
    return label;
}
- (UIButton *)createButtonWithTitle:(NSString *)title withFont:(UIFont *)font withTitleColor:(UIColor *)titleColor withBackgroundColor:(UIColor *)backcolor withCornerRadius:(CGFloat)radius {
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:font];
    if(titleColor){
        [button setTitleColor:titleColor forState:UIControlStateNormal];
    }
    if (backcolor) {
        [button setBackgroundColor:backcolor];
    }
    [button.layer setCornerRadius:FITSCALE(radius)];
    return button;
}
- (UIView *)headerView {
    if (!_headerView) {
        
        CGFloat pacing = 64.0f;
        CGFloat headerHeight = FITSCALE(240) + pacing;
        
        
        HeaderElasticBgView * headerBgView = [[HeaderElasticBgView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,FITSCALE(140) + pacing )];
//        headerBgView.layerColor = project_main_blue;
        headerBgView.backgroundColor = project_main_blue;
        headerBgView.tag = headerBgViewTag;
        [self.tableView addSubview:headerBgView];
        
        [self.tableView sendSubviewToBack:headerBgView];
        
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, headerHeight)];
        _headerView.backgroundColor = [UIColor clearColor];
        [self setupTopView] ;
        [self setupOperationView];
   
    }
    return _headerView;
}

- ( void)setupTopView{
      CGFloat pacing = 64.0f;
      CGFloat topHeight = FITSCALE(140) +pacing ;

    
    GratitudeTopView * topView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GratitudeTopView class]) owner:nil options:nil][0];
    topView.backgroundColor = [UIColor clearColor];
    topView.frame = CGRectMake(0, 0, self.view.frame.size.width, topHeight);
    [topView setupNumber:self.coinNumber];
    topView.giftMallBtnBlock = ^{
        [self gotoGFMallViewController];
    };
    topView.rulesBtnBlock = ^{
        [self rightAction:nil];
    };
    [_headerView addSubview:topView];
    
    
 
}

- (void )setupOperationView{
    
    CGFloat pacing = 64.0f;
    
    NSString * obtainLabelText = @"获取记录";
    NSString * consumeLabelText = @"消费记录";
    UIButton *obtainLabel = [self createButtonWithTitle:obtainLabelText withFont:fontSize_14 withTitleColor:UIColorFromRGB(0x6b6b6b) withBackgroundColor:[UIColor whiteColor] withCornerRadius:0];
    obtainLabel.frame = CGRectMake(0, FITSCALE(140) + pacing, IPHONE_WIDTH/2, FITSCALE(50));
    UIButton *consumeLabel = [self createButtonWithTitle:consumeLabelText withFont:fontSize_14 withTitleColor:UIColorFromRGB(0x6b6b6b) withBackgroundColor:[UIColor whiteColor]  withCornerRadius:0];
    
    consumeLabel.frame = CGRectMake(IPHONE_WIDTH/2, obtainLabel.frame.origin.y, IPHONE_WIDTH/2, FITSCALE(50));
    [_headerView addSubview:obtainLabel];
    [_headerView addSubview:consumeLabel];
    
    self.obtainLine = [[UIView alloc]initWithFrame:CGRectMake(0, FITSCALE(188)+pacing, IPHONE_WIDTH/2, FITSCALE(2))];
    self.obtainLine.backgroundColor = project_main_blue;
    [_headerView addSubview:self.obtainLine];
    
    self.consumeLine = [[UIView alloc]initWithFrame:CGRectMake(IPHONE_WIDTH/2,self.obtainLine.frame.origin.y, IPHONE_WIDTH/2, FITSCALE(2))];
    self.consumeLine.backgroundColor = project_main_blue;
    self.consumeLine.alpha = 0;
    [_headerView addSubview:self.consumeLine];
    
    NSString * obtainTimeText = @"获取时间";
    self.obtainTime = [self createLabelWithContent:obtainTimeText withFont:fontSize_14 withTextColor:UIColorFromRGB(0x6b6b6b)];
    self.obtainTime.frame = CGRectMake(0,obtainLabel.frame.origin.y+FITSCALE(50.5) , IPHONE_WIDTH/3, FITSCALE(50));
    self.obtainTime.backgroundColor = [UIColor whiteColor] ;
    self.obtainTime.textAlignment = NSTextAlignmentCenter;
    
    NSString * obtainCountText = @"获取数量";
    self.obtainCount = [self createLabelWithContent:obtainCountText withFont:fontSize_14 withTextColor:UIColorFromRGB(0x6b6b6b)];
    self.obtainCount.frame = CGRectMake(IPHONE_WIDTH/3,obtainLabel.frame.origin.y+FITSCALE(50.5) , IPHONE_WIDTH/3, FITSCALE(50));
    self.obtainCount.backgroundColor = [UIColor whiteColor] ;
    self.obtainCount.textAlignment = NSTextAlignmentCenter;
    
    NSString * obtainReasonText = @"获取缘由";
    self.obtainReason = [self createLabelWithContent:obtainReasonText withFont:fontSize_14 withTextColor:UIColorFromRGB(0x6b6b6b)];
    self.obtainReason.frame = CGRectMake(IPHONE_WIDTH/3*2,obtainLabel.frame.origin.y+FITSCALE(50.5) , IPHONE_WIDTH/3, FITSCALE(50));
    self.obtainReason.backgroundColor = [UIColor whiteColor];
    self.obtainReason.textAlignment = NSTextAlignmentCenter;
    
    [_headerView addSubview:self.obtainTime];
    [_headerView addSubview:self.obtainCount];
    [_headerView addSubview:self.obtainReason];
    
    [obtainLabel setUserInteractionEnabled:YES];
    [obtainLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(obtainAction)]];
    
    [consumeLabel setUserInteractionEnabled:YES];
    [consumeLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(consumeAction)]];
    
    
    UIView *lineview = [[UIView alloc]initWithFrame:CGRectMake(0, _headerView.frame.size.height- 0.5 , IPHONE_WIDTH,  0.5 )];
    lineview.backgroundColor = project_line_gray;
    [_headerView addSubview:lineview];
    
 
}
- (UILabel *)coinCountLabel {
    if (!_coinCountLabel) {
        _coinCountLabel = [self createLabelWithContent:@"0" withFont:fontSize_22 withTextColor:[UIColor whiteColor]];
        _coinCountLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _coinCountLabel;
}

- (void)consumeAction {
   self.type = GratitudeCurrencyType_consumption;
    self.consumeLine.alpha = 1;
    self.obtainLine.alpha = 0;
    self.obtainReason.text = @"消费缘由";
    self.obtainTime.text = @"消费时间";
    self.obtainCount.text = @"消费数量";
    self.currentPageNo = 0;
    self.models = nil;
    [self requestGratitude];
    
}

- (void)obtainAction {
    self.type = GratitudeCurrencyType_obtain;
    self.consumeLine.alpha = 0;
    self.obtainLine.alpha = 1;
    self.obtainReason.text = @"获取缘由";
    self.obtainTime.text = @"获取时间";
    self.obtainCount.text = @"获取数量";
    self.currentPageNo = 0;
    self.models = nil;
    [self requestGratitude];
}

- (void)registerCell{

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GratitudeCurrencyCell class]) bundle:nil] forCellReuseIdentifier:GratitudeCurrencyCellIdentifier];
}
- (void)getNormalTableViewNetworkData{
    
    [self requestGratitude];
}
- (BOOL)isAddRefreshFooter{

    return YES;
}


- (NSInteger)getNetworkTableViewDataCount{

    return [self.models.changeLogs count];
}

- (void)getLoadMoreTableViewNetworkData{

    [self getNormalTableViewNetworkData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}

-  (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

  
    return [self.models.changeLogs count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell * cell = nil;
    GratitudeCurrencyCell * tempCell = [tableView dequeueReusableCellWithIdentifier:GratitudeCurrencyCellIdentifier];
    [tempCell setupGratitudeCellInfo:self.models.changeLogs[indexPath.row]];
    if (self.type == GratitudeCurrencyType_consumption ) {
        
        tempCell.indexPath = indexPath;
        WEAKSELF
        tempCell.giftChangeBlock = ^(NSIndexPath *indexPath) {
            STRONGSELF
            GratitudeCurrencyModel * model= strongSelf.models.changeLogs[indexPath.row];
            if ([model.event isEqualToString:@"exchange_gift"]) {
                NSString * eventID = model.eventId;
                [strongSelf gotoGFMallExchange:eventID];
            }
        };
        GratitudeCurrencyModel * model= self.models.changeLogs[indexPath.row];
        if ([model.event isEqualToString:@"exchange_gift"]) {
             [tempCell giftExchangeConsumption];
        }
  
    }else{
        [tempCell giftExchangeObtain];
        
    }
    tempCell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell = tempCell;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return FITSCALE(40);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ( self.type == GratitudeCurrencyType_consumption) {
        GratitudeCurrencyModel * model= self.models.changeLogs[indexPath.row];
        if ([model.event isEqualToString:@"exchange_gift"]) {
            NSString * eventID = model.eventId;
            [self gotoGFMallExchange:eventID];
        }
       
    }
    
}
#pragma mark --
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    HeaderElasticBgView * view =  [self.tableView viewWithTag:headerBgViewTag];
//    [view setupProgress: scrollView.contentOffset.y];
 
    CGFloat offsetY = scrollView.contentOffset.y;
    HeaderElasticBgView * view =  [self.tableView viewWithTag:headerBgViewTag];
    if (offsetY < 0) {
        view.frame = CGRectMake(0, offsetY, IPHONE_WIDTH , FITSCALE(240) +64 - offsetY);  // 修改头部的frame值就行了
        
    }
//    CGFloat upDistance = scrollView.contentOffset.y + 64;
//    
//    //1.navigationBar透明度计算
//    CGFloat alphaScale = 0.0;
//    
//    CGFloat criticalHeight =  FITSCALE(60);
//    
//    if (upDistance <= criticalHeight) {
//        alphaScale = (upDistance-20) / criticalHeight;
//    } else {
//        alphaScale = 1.0;
//    }
//    
//    [self.navigationBackgroundView setAlpha:alphaScale];

}

 
#pragma mark ---

- (void)requestGratitude{
    
    NSString * isGain = nil ;
    if (self.type == GratitudeCurrencyType_obtain) {
        isGain = @"true" ;
    }else if (self.type == GratitudeCurrencyType_consumption ){
        
        isGain =  @"false";
    }else{
        isGain = @"true";
    }
    NSString *pageIndex = [NSString stringWithFormat:@"%zd",self.currentPageNo];
    NSString *pageSize = [NSString stringWithFormat:@"%zd",self.pageCount];
    NSDictionary *parameterDic = @{@"type":@"coin",
                                   @"isGain":isGain,
                                   @"pageIndex":pageIndex,
                                   @"pageSize":pageSize
                                   };
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_ListTeacherChangeLog] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_ListTeacherChangeLog];
}

- (void)setNetworkRequestStatusBlocks{
    
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_ListTeacherChangeLog) {
            if (!strongSelf.models.changeLogs) {
                strongSelf.models = [[GratitudeCurrencyListModel alloc]initWithDictionary:successInfoObj error:nil];
                if ([strongSelf.models.changeLogs count] > 0) {
                    strongSelf.currentPageNo++;
                }
                 
            }else{
                GratitudeCurrencyListModel * tempModel = [[GratitudeCurrencyListModel alloc]initWithDictionary:successInfoObj error:nil];
                if ([tempModel.changeLogs count] > 0) {
                    [strongSelf.models.changeLogs addObjectsFromArray:tempModel.changeLogs];
                }
                strongSelf.currentPageNo ++;
            }
            [strongSelf updateTableView];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)gotoGFMallViewController{
    GFMallViewController * mallVC = [[GFMallViewController alloc]init];
    [self pushViewController:mallVC];
}

- (void)gotoGFMallExchange:(NSString *)exchangeGiftID{
    GFMallExchangeListViewController * gfmallVC = [[GFMallExchangeListViewController alloc]initWithId:exchangeGiftID withVC:GFMallExchangeType_detail];
    [self pushViewController:gfmallVC];
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
