
//
//  SearchResultsViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/9/12.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "SearchResultsViewController.h"
#import "RepositoryListModel.h"
#import "BookcaseCell.h"
#import "BookPreviewDetailViewController.h"
NSString *const SearchResultsCellIdentifier = @"SearchResultsCellIdentifier";
@interface SearchResultsViewController () 
@property(nonatomic, copy)NSString * searchName;
@property(nonatomic, strong) RepositoryListModel *listModel;
@end

@implementation SearchResultsViewController
#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
   
    
}

#pragma mark - UISearchControllerDelegate代理

- (UIRectEdge)getViewRect{
    
    return UIRectEdgeAll;
}

#pragma mark - SearchInputtingDelegate
- (void)cancelSearch{
    self.view.alpha = 0;
    self.searchName = @"";
    self.currentPageNo = 0;
    self.listModel = nil;
    [self.tableView reloadData];
}
- (void)searchMyInput:(NSString *)inputStr
{
    NSLog(@"To Search My Inputthing");
 
    self.searchName = inputStr;
    self.currentPageNo = 0;
    self.pageCount = 20;
    [self requestListBooks];
    
}
- (void)updateCellAtIndexPath:(NSIndexPath *)indexPath{
     RepositoryModel * model = self.listModel.list[indexPath.section];
    model.hasInBookShelf = @(1);
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIApplicationBackgroundFetchIntervalNever;
    } else { 
          self.automaticallyAdjustsScrollViewInsets = NO;
        // Fallback on earlier versions
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BookcaseCell class]) bundle:nil] forCellReuseIdentifier:SearchResultsCellIdentifier ];
    
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(handleColorChange:) name:@"searchBarDidChange" object:nil];
    [self configTableView];
}

- (BOOL)isAddRefreshFooter{
    return YES;
}
- (void)loadMorebeginRefreshing{
    
    [self requestListBooks];
}
- (NSInteger)getNetworkTableViewDataCount{
    
    return [self.listModel.list count];
}
- (void)configTableView{
    
    self.tableView.backgroundColor = [UIColor clearColor];
    // 隐藏UITableViewStyleGrouped上边多余的间隔
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.0001)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 20)];
    self.view.backgroundColor = project_background_gray;
}
- (UITableViewStyle)getTableViewStyle{
    return UITableViewStyleGrouped;
}

-(void)handleColorChange:(NSNotification* )sender
{
    NSString *text = sender.userInfo[@"searchText"];
    self.searchName = text;
    self.listModel = nil;
    self.currentPageNo = 0;
    [self requestListBooks];
    NSLog(@"%@", text);
}

- (CGRect)getTableViewFrame{
//    CGFloat searchBarHeight  = FITSCALE(44);
    CGFloat searchBarHeight  = 0;
    CGRect frame =   CGRectMake(0, searchBarHeight, self.view.frame.size.width, self.view.frame.size.height- searchBarHeight);
    return frame;
}
#pragma mark ---
- (void)requestListBooks{
     
    NSMutableDictionary * parameterDic =[NSMutableDictionary dictionary];
    [parameterDic addEntriesFromDictionary: @{@"pageIndex":@(self.currentPageNo),
                                              @"pageSize":@(self.pageCount)
                                              }];
    if (self.searchName) {
        [parameterDic addEntriesFromDictionary:@{@"bookName":self.searchName}];
    }
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_ListBooks] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_ListBooks];
    
}

- (void)setNetworkRequestStatusBlocks{
    
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_ListBooks) {
            if (strongSelf.currentPageNo == 0) {
                strongSelf.listModel = nil;
                strongSelf.listModel = [[RepositoryListModel alloc]initWithDictionary:successInfoObj error:nil];
                strongSelf.currentPageNo ++;
                
            }else{
               
                RepositoryListModel * tempModel  =  [[RepositoryListModel alloc]initWithDictionary:successInfoObj error:nil];
                if (tempModel.list && [tempModel.list count] >0) {
                   [strongSelf.listModel.list addObjectsFromArray:tempModel.list];
                    strongSelf.currentPageNo ++;
                }
               
            }
             strongSelf.view.alpha = 1; 
            [strongSelf updateTableView];
        }
        
    }];
    
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self.listModel.list count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    BookcaseCell  * tempCell = [tableView dequeueReusableCellWithIdentifier:SearchResultsCellIdentifier];
    RepositoryModel * model = self.listModel.list[indexPath.section];
    
    [tempCell setupSearchItemInfo:self.listModel.list[indexPath.section]];
    BOOL  hasBookSelfState = NO;
    if ([model.hasInBookShelf integerValue] == 1) {
        hasBookSelfState = YES;
    }
    [tempCell hasBookSelfState: hasBookSelfState];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell = tempCell;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat height =   FITSCALE(122); 
    return height;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    self.didSelectText([tableView cellForRowAtIndexPath:indexPath].textLabel.text);
    [self gotoBookPreviewDetailVC:indexPath];
  
}

- ( UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView * headerView = [UIView new];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- ( UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footerView = [UIView new];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat headerHeight = 0.00000001;
    
    if (section == 0){
        headerHeight =   FITSCALE(10) ;
    }else {
        headerHeight = FITSCALE(7);
    }
    return headerHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    CGFloat footerHeight =  0.0001;
    return footerHeight;
}
- (void)gotoBookPreviewDetailVC:(NSIndexPath *)indexPath{
    
    RepositoryModel *model = self.listModel.list[indexPath.section];
    if (self.selectedBlock) {
        self.selectedBlock(model,indexPath);
    }
//    BOOL existsState = NO;
//    if ([model.hasInBookShelf integerValue] == 1) {
//        existsState = YES;
//    }
//    NSString * bookType = model.bookType;
//    BookPreviewDetailViewController * detail = [[BookPreviewDetailViewController alloc]initWithBookId:model.id withBookType:bookType withExistsBookcase:existsState];
//    [self pushViewController:detail];
    
}
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    self.didSelectText(@"");
//}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    NSLog(@"imageForEmptyDataSet:empty_placeholder");
    return [UIImage imageNamed:@"new_empty_list"];
}
- (NSString *)getDescriptionText{
    
    return @"暂无相关书籍~";
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated]; 
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
