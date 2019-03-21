//
//  BaseCollectionViewController.h
//  TeacherPro
//
//  Created by DCQ on 2017/6/2.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BaseNetworkViewController.h"
#import "MJRefresh.h"
@interface BaseCollectionViewController : BaseNetworkViewController
@property (strong, nonatomic)  UICollectionView *collectionView;
@property (assign, nonatomic)  BOOL isNetReqeustEmptyData;
@property (nonatomic, assign)NSInteger currentPageNo;//当前加载页数 默认 0
@property (nonatomic, assign)NSInteger pageCount;//每次请求条数 默认 12
//返回列表frame 子类重写
- (CGRect)getCollectionViewFrame;
- (UICollectionViewLayout *)getCollectionViewLayout;
- (void)registerCell;


//返回空白页描述文字
- (NSString *)getDescriptionText;
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView;

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;

//马上进入下拉刷新
- (void)beginRefresh;
//是否添加下拉刷新
- (BOOL)isAddRefreshHeader ;
//是否添加上啦加载
- (BOOL)isAddRefreshFooter ;

/**
 @ 方法描述    获取当前加载的最大长度 用于判断是否可以继续上啦加载
 @ 输入参数     无
 @ 返回值
 @ 创建人      DCQ
 @ 创建时间
 */
- (NSInteger )getNetworkCollectionViewDataCount;
/**
 @ 方法描述     更新collectionview视图
 @ 输入参数     无
 @ 返回值
 @ 创建人      DCQ
 @ 创建时间
 */
- (void)updateCollectionView;


/**
 @ 方法描述    上提加载更多完成动画前执行该方法  子类可重写
 @ 输入参数     无
 @ 返回值      无
 @ 创建人      DCQ
 @ 创建时间
 */
- (void)loadMoreRefreshing;
/**
 @ 方法描述     下拉刷新完成动画前执行该方法  子类可重写
 @ 输入参数     无
 @ 返回值      无
 @ 创建人      DCQ
 @ 创建时间
 */
- (void)drogDownRefresh;
/**
 开始下拉刷新动画
 */
- (void)drogDownbeginRefreshing;
/**
 开始提刷新动画
 */
- (void)loadMorebeginRefreshing;

/**
 进页面加载调用 子类重写
 */
- (void)getNormalCollectionViewNetworkData ;
/**
 上拉加载更多
 */
- (void)getLoadMoreCollectionViewNetworkData;

@end
