
//
//  GFMallViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/12/4.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "GFMallViewController.h"
#import "GFMallListCell.h"
#import "GFMallListModel.h"
#import "GFMallBottomView.h"
#import "GFMallOrderViewController.h"
#import "ExchangeInstructionViewController.h"
#import "GFMallExchangeListViewController.h"
NSString * const GFMallListCellIdentifier = @"GFMallListCellIdentifier";

#define kMallBottomHeight    FITSCALE(40)
@interface GFMallViewController ()
@property(nonatomic, strong) GFMallListModel * model;
@property(nonatomic, strong) GFMallBottomView * bottomView;
@property (nonatomic,strong) UIView *navigationBackgroundView;
@end

@implementation GFMallViewController
- (instancetype)init{
    if (self == [super init]) {
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商城";
    self.view.backgroundColor = project_background_gray;
    [self confightCollectionView];
    [self requestListTeacherGifts];
    [self.view addSubview:self.bottomView];
    [self confightBottomView];
    [self navigationRightItem];
}

 
 

- (void)navigationRightItem{
    
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"兑换记录" forState:UIControlStateNormal];
    [rightBtn setFrame:CGRectMake(0, 0, 80, 44)];
    rightBtn.titleLabel.font = fontSize_14;
    [rightBtn addTarget:self action:@selector(gotoGFMallExchange) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView: rightBtn];
}
- (void)gotoGFMallExchange{
    GFMallExchangeListViewController * gfmallVC = [[GFMallExchangeListViewController alloc]init];
    [self pushViewController:gfmallVC];
}
- (void)confightBottomView{
    
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        CGFloat bottomHeight = kMallBottomHeight; 
        CGFloat bottom =   PHONEX_HOME_INDICATOR_HEIGHT;
        make.leading.mas_equalTo(self.view.mas_leading);
        make.trailing.mas_equalTo(self.view.mas_trailing);
        make.top.mas_equalTo(self.collectionView.mas_bottom);
        make.height.mas_equalTo(@(bottomHeight));
    }];
    UITapGestureRecognizer * tap =  [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoExchangeInstructionVC)];
    [self.bottomView addGestureRecognizer:tap];
}
- (void)confightCollectionView{
    self.collectionView.backgroundColor = [UIColor clearColor];
    UIView * bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor clearColor];
     self.collectionView.backgroundView = bgView;
}

- (GFMallBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([GFMallBottomView class]) owner:nil options:nil].firstObject; 
    }
    return _bottomView;
}
- (CGRect)getCollectionViewFrame{
 
    CGRect frame =  CGRectMake(0, 0, self.view.frame.size.width,IPHONE_HEIGHT - kMallBottomHeight - PHONEX_HOME_INDICATOR_HEIGHT- NavigationBar_Height);
    return frame;
}
- (void)requestListTeacherGifts{
    
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_ListTeacherGifts] parameterDic:nil  requestMethodType:RequestMethodType_POST requestTag:NetRequestType_ListTeacherGifts];
}

- (void)setNetworkRequestStatusBlocks{
    
    WEAKSELF
    [self setSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (NetRequestType_ListTeacherGifts == request.tag) {
            strongSelf.model = [[GFMallListModel alloc]initWithDictionary:successInfoObj error:nil];
            [strongSelf updateCollectionView];
        }
    }];
}
- (void)registerCell{
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GFMallListCell class]) bundle:nil] forCellWithReuseIdentifier:GFMallListCellIdentifier];
    
}

#pragma mark ---- UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  [self.model.list count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = nil;
    GFMallListCell * tempCell =  [self.collectionView dequeueReusableCellWithReuseIdentifier:GFMallListCellIdentifier forIndexPath:indexPath];
    [tempCell setupGFMallModel:self.model.list[indexPath.row]];
    cell = tempCell;
    return cell;
}

  //和UITableView类似，UICollectionView也可设置段头段尾
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{

    return nil;
}

#pragma mark ---- UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((IPHONE_WIDTH-30)/2, 190);
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets  edgeinsets = UIEdgeInsetsZero;
    edgeinsets = UIEdgeInsetsMake(10, 10, 10, 10);
    return edgeinsets;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.f;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return (CGSize){IPHONE_WIDTH,0};
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return (CGSize){IPHONE_WIDTH,0};
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
     [self setupView:indexPath];
}
- (void)setupView:(NSIndexPath *)indexPath{
    GFMallModel * detailModel = self.model.list[indexPath.row];
    GFMallOrderViewController * orderVC = [[GFMallOrderViewController alloc]initWithModel:detailModel];
    [self pushViewController:orderVC];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)gotoExchangeInstructionVC{
    NSString * detail = self.model.giftExchangeNotice;
    ExchangeInstructionViewController * vc = [[ExchangeInstructionViewController alloc]initWithDetail:detail];
    [self pushViewController:vc];
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
