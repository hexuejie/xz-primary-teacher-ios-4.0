//
//  BaseTableViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/5/10.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BaseTableViewController.h"
#import "UIScrollView+EmptyDataSet.h"

@interface BaseTableViewController ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate,UITableViewDelegate, UITableViewDataSource>

@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self registerCell];
    [self.view addSubview:self.tableView];
   
    
    if ([self isAddRefreshHeader]) {
        [self addHeader:self.tableView];
        self.tableView.bounces =  YES;
        if ([self isBeginRefreshing]) {
            [self beginRefresh];
        }
       
    }
    if ([self isAddRefreshFooter]) {
        [self addFooter:self.tableView];
        self.tableView.bounces = YES;
    }
    
    [self configBaseTableView];
}

- (void)configBaseTableView{
    
    self.tableView.backgroundColor = [UIColor clearColor];
    // 隐藏UITableViewStyleGrouped上边多余的间隔
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    self.view.backgroundColor = project_background_gray;
     
    // 默认是自动调整的。内容显示在安全区
   
 
    if ( [self.tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
        if (@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    if(iPhoneX ){
        if ([self getNavBarBgHidden] && CGRectGetHeight(self.view.frame) == IPHONE_HEIGHT) {
            [self adjustTableView];
        }else if (![self getNavBarBgHidden] && CGRectGetHeight(self.view.frame) == IPHONE_HEIGHT - NavigationBar_Height) {
             [self adjustTableView];
         }
        
    }
 
 
}
- (void)adjustTableView{
    
//    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, PHONEX_HOME_INDICATOR_HEIGHT, 0);
//    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,PHONEX_HOME_INDICATOR_HEIGHT)];
    self.tableView.tableFooterView.backgroundColor = [UIColor clearColor];
    
}
- (void)getNetworkData{

    if (![self isAddRefreshHeader]) {
        [self getNormalTableViewNetworkData];
    }
}

//   页面加载调用 子类重写
- (void)getNormalTableViewNetworkData{
    NSLog(@"进入页面请求 子类重写");
}

- (UITableView *)tableView{

    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:[self getTableViewFrame] style:[self getTableViewStyle]];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.dataSource = self;
        _tableView.delegate = self;
         /* STEP5:去掉TableView中的默认横线  用fd height 库计算高度 bug 待解决*/
//        _tableView.tableFooterView = [UIView new];
        _tableView.separatorColor = [UIColor clearColor];
        _tableView.bounces = YES;
        
    }
    
    return _tableView;
}
- (void)registerCell{

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"identifer"];
}
- (CGRect)getTableViewFrame{

    return CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

//添加此句，确保_tableView是用0，64 开始的（ _tableView.frame=CGRectMake(0, 64, KWidth, KHeight);）
- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
   /**
    添加下面两行代码 功能去掉 UIRectEdgeAll 模式下 tableview frame下移导航条间距 bug
    */
//    self.tableView.contentInset = UIEdgeInsetsZero;
//    
//    self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
    
}

- (UITableViewStyle )getTableViewStyle{

    return UITableViewStyleGrouped;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setupTableViewEdit:(BOOL )edit{

    self.tableView.editing = edit;
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 0;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 44;
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [ tableView dequeueReusableCellWithIdentifier:@"identifer"];
    
    cell.textLabel.text = @"baseTableViewCell";
    
    return cell;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
     return 0.0001;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
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
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12],
                                 NSForegroundColorAttributeName: HexRGB(0x8A8F99),
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSString *)getDescriptionText{

    return @"暂无数据!";
}
/**
 *  返回文字按钮
 */
- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
//    NSLog(@"buttonTitleForEmptyDataSet: ");
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:17.0f]};
    
    return [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
}


#if 0
/**
 *  返回图片按钮（如果设置了此方法，buttonTitleForEmptyDataSet: ，返回文字按钮方法就会失效
 */
- (UIImage *)buttonImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
//    NSLog(@"buttonImageForEmptyDataSet:button_image");
    return [UIImage imageNamed:@""];
}
#endif

/**
 *  自定义背景颜色
 */
- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
//    NSLog(@"backgroundColorForEmptyDataSet");
    return [UIColor clearColor]; // redColor whiteColor
}

//#if 0
/* 显示等待状态:
 If you need a more complex layout, you can return a custom view instead: */
- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView
{
//    NSLog(@"customViewForEmptyDataSet");
    
//    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    [activityView startAnimating];
    
    return nil;
}
//#endif

/**
 *  设置垂直或者水平方向的偏移量，推荐使用verticalOffsetForEmptyDataSet这个方法
 *
 *  @return 返回对应的偏移量（默认都为0）
 */
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
//    NSLog(@"verticalOffsetForEmptyDataSet");
    return - 64;
}

/**
 *  设置垂直方向的偏移量 （推荐使用）
 */
- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView
{
//    NSLog(@"spaceHeightForEmptyDataSet");
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
//    NSLog(@"emptyDataSetShouldDisplay");
    
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
//    NSLog(@"emptyDataSetShouldAllowTouch");
    return YES;
}


/**
 *  是否允许滚动 (默认为 NO)
 */
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
//    NSLog(@"emptyDataSetShouldAllowScroll");
    return NO;
}

/* Asks for image view animation permission (Default is NO) : */
- (BOOL)emptyDataSetShouldAllowImageViewAnimate:(UIScrollView *)scrollView
{
//    NSLog(@"emptyDataSetShouldAllowImageViewAnimate");
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
    
    [self getNetworkData];
}
/**
 *  处理按钮的点击事件
 */
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
     NSLog(@"%s",__FUNCTION__);
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
 

- (void)endRefreshwithNoNetwork{
    
    NSLog(@"%s",__PRETTY_FUNCTION__);
    self.isNetReqeustEmptyData =  YES;
    [self.tableView reloadData];
    // do nothing
}


- (void)beginRefresh{

    [self.tableView.mj_header beginRefreshing];
}
#pragma mark - custom method
- (BOOL)isAddRefreshHeader{
    
    return NO;
}
- (BOOL)isAddRefreshFooter{
    
    return NO;
}
 

//tableview是否加载完
- (BOOL)tableIsFull {
    
    BOOL isFull= NO;
    if ([self getNetworkTableViewDataCount] < self.pageCount *  self.currentPageNo) {
        isFull = YES;
    }
    return isFull;
    
}

- (NSInteger )getNetworkTableViewDataCount{

    return 0;
}

- (void)addFooter:(UITableView *)tableView{
    
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
    tableView.mj_footer = footer;
    
}
- (void)addHeader:(UITableView *)tableView{
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
    self.tableView.mj_header = header;
    
}
//上提加载更多调用方法
- (void)loadMoreRefreshing {
    
    if ([self tableIsFull]) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        
        [self.tableView.mj_footer resetNoMoreData];
        [self getLoadMoreTableViewNetworkData];
    }
   
}

- (void)getLoadMoreTableViewNetworkData{
    
    NSLog(@"__%s__子类入需要进页面马上加载数据 需要重写该方法",__PRETTY_FUNCTION__);
}
//下拉刷新调用方法
- (void)drogDownRefresh{
    [self getNormalTableViewNetworkData];
    [self updateTableView];
}


//更新
- (void)updateTableView {
    @try {
        if(self.tableView) {
            if ([self isAddRefreshHeader]) {
                [self.tableView.mj_header endRefreshing];
            }
            if ([self isAddRefreshFooter]) {
                [self.tableView.mj_footer endRefreshing];
            }
            
            [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:true];
        }
    }
    @catch (NSException *e) {
        NSLog(@"%@ tableview 更新数据问题",e);
         NSAssert(NO, @"tableview 更新数据问题" );
    }
}

- (void)drogDownbeginRefreshing{
    [self.tableView.mj_header beginRefreshing];
}

- (void)loadMorebeginRefreshing{
    
    [self.tableView.mj_footer beginRefreshing];
}

//是否第一次进来就执行下拉刷新
- (BOOL)isBeginRefreshing{

    return YES;
}

@end
