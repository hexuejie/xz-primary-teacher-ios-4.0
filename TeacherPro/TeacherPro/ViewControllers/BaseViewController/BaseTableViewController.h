//
//  BaseTableViewController.h
//  TeacherPro
//
//  Created by DCQ on 2017/5/10.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BaseNetworkViewController.h"
#import "MJRefresh.h"
@interface BaseTableViewController : BaseNetworkViewController
@property (strong, nonatomic)  UITableView *tableView;
@property (assign, nonatomic)   BOOL isNetReqeustEmptyData;
@property (nonatomic, assign)NSInteger currentPageNo;//当前加载页数 默认 0
@property (nonatomic, assign)NSInteger pageCount;//每次请求条数 默认 10
//返回列表frame 子类重写 
- (CGRect)getTableViewFrame;

//返回列表样式 子类重写
- (UITableViewStyle )getTableViewStyle;
//返回空白页描述文字
- (NSString *)getDescriptionText;

//注册cell 子类重写
- (void)registerCell;
//编辑状态
- (void)setupTableViewEdit:(BOOL )edit;
#pragma delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

#pragma --
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
- (NSInteger )getNetworkTableViewDataCount;
/**
 @ 方法描述     更新tableview视图
 @ 输入参数     无
 @ 返回值
 @ 创建人      DCQ
 @ 创建时间    
 */
- (void)updateTableView;


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
- (void)getNormalTableViewNetworkData ;
/**
 上拉加载更多
 */
- (void)getLoadMoreTableViewNetworkData;
@end
