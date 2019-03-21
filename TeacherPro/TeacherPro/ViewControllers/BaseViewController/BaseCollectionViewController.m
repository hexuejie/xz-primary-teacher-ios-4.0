//
//  BaseCollectionViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/6/2.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BaseCollectionViewController.h"
#import "UIScrollView+EmptyDataSet.h"

#import "UIView+add.h"

@interface BaseCollectionViewController ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@end
// 注意const的位置
static NSString *const CollectionViewCell = @"CollectionViewCell";
static NSString *const CollectionReusableViewHeader = @"CollectionReusableViewHeader";
static NSString *const CollectionReusableViewFooter = @"CollectionReusableViewFooter";
@implementation BaseCollectionViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    UIView *uiBarBackground = self.navigationController.navigationBar.subviews.firstObject;
    [uiBarBackground setCornerRadius:0 withShadow:YES withOpacity:0];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    UIView *uiBarBackground = self.navigationController.navigationBar.subviews.firstObject;
//    [uiBarBackground setCornerRadius:0 withShadow:YES withOpacity:8];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPageNo = 0;
    self.pageCount = 10;
    // Do any additional setup after loading the view.
    [self.view addSubview:self.collectionView];
 
    [self registerCell];
    
    if ([self isAddRefreshHeader]) {
        [self addHeader:self.collectionView];
        self.collectionView.bounces =  YES;
        [self beginRefresh];
    }
    if ([self isAddRefreshFooter]) {
        [self addFooter:self.collectionView];
        self.collectionView.bounces = YES;
    }
    
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}


- (void)addFooter:(UICollectionView *)collectionView{
    
    WEAKSELF
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf loadMoreRefreshing];
        // 结束刷新
        
    }];
    
    // 设置文字
    [footer setTitle:@"上拉可以加载更多" forState:MJRefreshStateIdle];
    [footer setTitle:@"松开立即加载更多" forState:MJRefreshStatePulling];
    [footer setTitle:@"正在加载更多的数据..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"已经全部加载完毕" forState:MJRefreshStateNoMoreData];
    
    // 设置字体
    footer.stateLabel.font = fontSize_14;
    
    // 设置颜色
    footer.stateLabel.textColor = UIColorFromRGB(0x6b6b6b);
    
    // 上拉刷新
    collectionView.mj_footer = footer;
    
}
- (void)addHeader:(UICollectionView *)collectionView{
    WEAKSELF
    MJRefreshNormalHeader * header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf drogDownRefresh];
        
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    // 设置文字
    [header setTitle:@"下拉可以刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"松开立即刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"正在刷新数据中.." forState:MJRefreshStateRefreshing];
    
    // 设置字体
    header.stateLabel.font = fontSize_14;
    header.lastUpdatedTimeLabel.font = fontSize_14;
    
    // 设置颜色
    header.stateLabel.textColor = UIColorFromRGB(0x6f6f6f);
    header.lastUpdatedTimeLabel.textColor = UIColorFromRGB(0x9f9f9f);
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden =YES;
    collectionView.mj_header = header;
    
}
//上提加载更多调用方法
- (void)loadMoreRefreshing {
    
    if ([self tableIsFull]) {
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
    }else{
        
        [self.collectionView.mj_footer resetNoMoreData];
        [self getLoadMoreCollectionViewNetworkData];
    }
    
}

- (BOOL)isAddRefreshHeader{
    
    return NO;
}
- (BOOL)isAddRefreshFooter{
    
    return NO;
}

//tableview是否加载完
- (BOOL)tableIsFull {
    
    BOOL isFull= NO;
    if ([self getNetworkCollectionViewDataCount] < self.pageCount * self.currentPageNo) {
        isFull = YES;
    }
    return isFull;
    
}

- (NSInteger )getNetworkCollectionViewDataCount{
    
    return 0;
}

//下拉刷新调用方法
- (void)drogDownRefresh{
    [self  getNormalCollectionViewNetworkData];
    [self updateCollectionView];
}
//   页面加载调用 子类重写
- (void)getNormalCollectionViewNetworkData{
    NSLog(@"进入页面请求 子类重写");
}
- (void)getLoadMoreCollectionViewNetworkData{
    
    NSLog(@"__%s__子类入需要进页面马上加载数据 需要重写该方法",__PRETTY_FUNCTION__);
}
- (UICollectionView *)collectionView{
    
    if (!_collectionView) {
       _collectionView = [[UICollectionView alloc]initWithFrame:[self getCollectionViewFrame] collectionViewLayout: [self getCollectionViewLayout]];
    
        _collectionView.emptyDataSetSource = self;
        _collectionView.emptyDataSetDelegate = self;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.bounces = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}
- (void)registerCell{
    // 注册cell、sectionHeader、sectionFooter
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CollectionViewCell];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CollectionReusableViewHeader];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:CollectionReusableViewFooter];
  
}
- (CGRect)getCollectionViewFrame{

     return CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

- (void)updateCollectionView{

    @try {
        if(self.collectionView) {
            if ([self isAddRefreshHeader]) {
                [self.collectionView.mj_header endRefreshing];
            }
            if ([self isAddRefreshFooter]) {
                [self.collectionView.mj_footer endRefreshing];
            }
          [self.collectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:true];
        }
    }
    @catch (NSException *e) {
        NSLog(@"%@ tableview 更新数据问题",e);
        NSAssert(NO, @"tableview 更新数据问题" );
    }
}
- (void)drogDownbeginRefreshing{
    [self.collectionView.mj_header beginRefreshing];
}

- (void)loadMorebeginRefreshing{
    
    [self.collectionView.mj_footer beginRefreshing];
}
- (void)beginRefresh{
    
    [self.collectionView.mj_header beginRefreshing];
}
//是否第一次进来就执行下拉刷新
- (BOOL)isBeginRefreshing{
    
    return NO;
}

- (UICollectionViewLayout *)getCollectionViewLayout{
     UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc]init];
    //设置布局方向为垂直流布局
     collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    return collectionViewLayout;
    
}

#pragma mark ---- UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 22;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCell forIndexPath:indexPath];
    cell.backgroundColor = [UIColor purpleColor];
    
    return cell;
}

// 和UITableView类似，UICollectionView也可设置段头段尾
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    
//    if([kind isEqualToString:UICollectionElementKindSectionHeader])
//    {
//        UICollectionReusableView *headerView = [_collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:CollectionReusableViewHeader forIndexPath:indexPath];
//        if(headerView == nil)
//        {
//            headerView = [[UICollectionReusableView alloc] init];
//        }
//        headerView.backgroundColor = [UIColor grayColor];
//        
//        return headerView;
//    }
//    else if([kind isEqualToString:UICollectionElementKindSectionFooter])
//    {
//        UICollectionReusableView *footerView = [_collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:CollectionReusableViewFooter forIndexPath:indexPath];
//        if(footerView == nil)
//        {
//            footerView = [[UICollectionReusableView alloc] init];
//        }
//        footerView.backgroundColor = [UIColor lightGrayColor];
//        
//        return footerView;
//    }
//    
//    return nil;
//}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}


- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath
{
    
}




#pragma mark ---- UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(IPHONE_WIDTH, 44);
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
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




#pragma mark ---- UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// 点击高亮
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
//    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
//    cell.backgroundColor = [UIColor greenColor];
}


// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}


// 长按某item，弹出copy和paste的菜单
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

// 使copy和paste有效
- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender
{
    if ([NSStringFromSelector(action) isEqualToString:@"copy:"] || [NSStringFromSelector(action) isEqualToString:@"paste:"])
    {
        return YES;
    }
    
    return NO;
}

//
- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender
{
    if([NSStringFromSelector(action) isEqualToString:@"copy:"])
    {
        //        NSLog(@"-------------执行拷贝-------------");
        [_collectionView performBatchUpdates:^{
       
//         [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
        } completion:nil];
    }
    else if([NSStringFromSelector(action) isEqualToString:@"paste:"])
    {
        NSLog(@"-------------执行粘贴-------------");
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)netRequest:(NetRequest *)request successWithInfoObj:(id)infoObj
{
    self.isNetReqeustEmptyData = YES;
    [super netRequest:request successWithInfoObj:infoObj];
    
}

- (void)netRequest:(NetRequest *)request failedWithError:(NSError *)error
{
    self.isNetReqeustEmptyData = YES;
    [super netRequest:request failedWithError:error];
    
}

// 解决 ios 11  collectionview 的VerticalScrollIndicator被header 挡住了，求解
- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        view.layer.zPosition = 0;
    } 
}
- (void)endRefreshwithNoNetwork{
    
    NSLog(@"%s",__PRETTY_FUNCTION__);
    self.isNetReqeustEmptyData =  YES;
    [self.collectionView reloadData];
    // do nothing
}
 
/**
 Return the content you want to show on the empty state, and take advantage of NSAttributedString
 features to customise the text appearance.*/
#pragma mark ---- Data Source Implementation ----

/**
 *  返回占位图图片
 */
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    NSLog(@"imageForEmptyDataSet:empty_placeholder");
    return [UIImage imageNamed:@"new_empty_list"];
}

/* The image view animation */
- (CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *)scrollView
{
    NSLog(@"imageAnimationForEmptyDataSet");
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath: @"transform"];
    
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0)];
    
    animation.duration = 0.25;
    animation.cumulative = YES;
    animation.repeatCount = MAXFLOAT;
    
    return animation;
}

#if 0
/* The attributed string for the title of the empty state */
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSLog(@"titleForEmptyDataSet:Please Allow Photo Access");
    
    NSString *text = @"Please Allow Photo Access";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
#endif

/**
 *  返回详情文字
 */
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSLog(@"descriptionForEmptyDataSet: ");
    
    NSString *text = [self getDescriptionText];
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: fontSize_14,
                                 NSForegroundColorAttributeName: project_main_blue,
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSString *)getDescriptionText{
    
    return @"";
}
/**
 *  返回文字按钮
 */
- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    NSLog(@"buttonTitleForEmptyDataSet: ");
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:17.0f]};
    
    return [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
}


#if 0
/**
 *  返回图片按钮（如果设置了此方法，buttonTitleForEmptyDataSet: ，返回文字按钮方法就会失效
 */
- (UIImage *)buttonImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    NSLog(@"buttonImageForEmptyDataSet:button_image");
    return [UIImage imageNamed:@""];
}
#endif

/**
 *  自定义背景颜色
 */
- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    NSLog(@"backgroundColorForEmptyDataSet");
    return [UIColor clearColor]; // redColor whiteColor
}

#if 0
/* 显示等待状态:
 If you need a more complex layout, you can return a custom view instead: */
- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView
{
    NSLog(@"customViewForEmptyDataSet");
    
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activityView startAnimating];
    
    return activityView;
}
#endif

/**
 *  设置垂直或者水平方向的偏移量，推荐使用verticalOffsetForEmptyDataSet这个方法
 *
 *  @return 返回对应的偏移量（默认都为0）
 */
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    NSLog(@"verticalOffsetForEmptyDataSet");
    return - 64;
}

/**
 *  设置垂直方向的偏移量 （推荐使用）
 */
- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView
{
    NSLog(@"spaceHeightForEmptyDataSet");
    return 20.0f;
}

/* STEP7:
 Return the behaviours you would expect from the empty states, and receive the user events.*/
#pragma mark ---- Delegate Implementation ----

/**
 *  数据源为空时是否渲染和显示 (默认为 YES)
 */
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
 
    if (self.isNetReqeustEmptyData) {
        
        return  YES;
    }else{
        return NO;
    }
    
}

/**
 *  是否允许点击 (默认为 YES)
 */
- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    NSLog(@"emptyDataSetShouldAllowTouch");
    return YES;
}


/**
 *  是否允许滚动 (默认为 NO)
 */
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    NSLog(@"emptyDataSetShouldAllowScroll");
    return NO;
}

/* Asks for image view animation permission (Default is NO) : */
- (BOOL)emptyDataSetShouldAllowImageViewAnimate:(UIScrollView *)scrollView
{
    NSLog(@"emptyDataSetShouldAllowImageViewAnimate");
    return YES;
}

///* Notifies when the dataset view was tapped: */
//- (void)emptyDataSetDidTapView:(UIScrollView *)scrollView
//{
//    NSLog(@"emptyDataSetDidTapView");
//    // Do something
//}
//
///* Notifies when the data set call to action button was tapped: */
//- (void)emptyDataSetDidTapButton:(UIScrollView *)scrollView
//{
//    NSLog(@"emptyDataSetDidTapButton");
//    // Do something
//}

/**
 *  处理空白区域的点击事件
 */
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    NSLog(@"%s",__FUNCTION__);
}
/**
 *  处理按钮的点击事件
 */
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    NSLog(@"%s",__FUNCTION__);
}
 

@end
