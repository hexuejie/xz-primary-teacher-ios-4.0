//
//  BookSearchViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/12/20.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//
#import "BookcaseCell.h"
#import "BookSearchViewController.h"
#import "BookSearchHotTitleCell.h"
#import "BookSearchHotContentCell.h"
#import "SearchModel.h"
#import "RepositoryListModel.h"
#import "SearchResultsViewController.h"
#import "BookPreviewDetailViewController.h"
#import "JFBookPreviewViewController.h"
#import "BookBookPreDetailViewController.h"

NSString * const  BookSearchHotTitleCellIdentifer = @"BookSearchHotTitleCellIdentifer";
NSString * const  BookSearchHotContentCellIdentifier = @"BookSearchHotContentCellIdentifier";

@interface BookSearchViewController ()<UISearchResultsUpdating,UISearchBarDelegate,UITextFieldDelegate>

@property (nonatomic, strong) SearchsModel * models;

@property (nonatomic, strong) UITextField *searchField;
@property (nonatomic, strong) UISearchBar *searchBar;


@property(nonatomic, strong) RepositoryListModel *listModel;
@end

@implementation BookSearchViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0,0,kScreenWidth,30)];
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(12, 0, kScreenWidth - 85, 30)];
    _searchBar.placeholder = @"请输入关键字搜索";
    _searchBar.layer.cornerRadius = 15;
    _searchBar.layer.masksToBounds = YES;
    _searchBar.backgroundImage = [[UIImage alloc] init];
    _searchBar.backgroundColor = HexRGB(0xF6F6F8);
    _searchBar.showsCancelButton = NO;
    _searchBar.barStyle=UIBarStyleDefault;
    _searchBar.keyboardType = UIKeyboardTypeNamePhonePad;
    _searchBar.delegate = self;
    _searchBar.showsSearchResultsButton = NO;
//    [searchBar setImage:[UIImage imageNamed:@"Search_Icon"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    [_searchBar setImage:[UIImage imageNamed:@"Rectangle 4"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
    _searchBar.tintColor = HexRGB(0x33aaff);
    
    _searchField = [_searchBar valueForKey:@"_searchField"];
//    _searchField.delegate = self;
    [_searchField setBackgroundColor:[UIColor clearColor]];
    _searchField.textColor= HexRGB(0x525b66);
    _searchField.font = [UIFont systemFontOfSize:15];
    [_searchField setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    [_searchField setValue:HexRGB(0xA1A7B3) forKeyPath:@"_placeholderLabel.textColor"];
    //只有编辑时出现出现那个叉叉
    _searchField.clearButtonMode = UITextFieldViewModeWhileEditing;

    [titleView addSubview:_searchBar];
    UIButton *calButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-64, 0, 46, 30)];
    [calButton setTitle:@"取消" forState:UIControlStateNormal];
    [calButton setTitleColor:HexRGB(0x4d4d4d4d) forState:UIControlStateNormal];
    calButton.titleLabel.font = [UIFont systemFontOfSize:16];
    calButton.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [titleView addSubview:calButton];
    [calButton addTarget:self action:@selector(backViewController) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleView;
  
    [self requestListQuerySearchWords];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = nil;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
//    [self navUIBarBackground:0];
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text NS_AVAILABLE_IOS(3_0){
    if([text isEqualToString:@"\n"]){
        [self requestListBooks];
    }
    return YES;
} // called before text changes


#pragma mark --- 热词请求
- (void)requestListQuerySearchWords{
     NSMutableDictionary * parameterDic = nil;
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_QuerySearchWords] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_QuerySearchWords];
}

#pragma mark --- 搜索请求
- (void)requestListBooks{
    [_searchBar resignFirstResponder];
    
    NSMutableDictionary * parameterDic =[NSMutableDictionary dictionary];
    [parameterDic addEntriesFromDictionary: @{@"pageIndex":@(0),
                                              @"pageSize":@(999)
                                              }];
    if (_searchBar.text) {
        [parameterDic addEntriesFromDictionary:@{@"bookName":_searchBar.text}];
    }
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_ListBooks] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_ListBooks];
}
- (void)setNetworkRequestStatusBlocks{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_QuerySearchWords) {
            strongSelf.models = [[SearchsModel alloc]initWithDictionary:successInfoObj error:nil];
            [strongSelf updateTableView];
            strongSelf.listModel = nil;
            
        }else if (request.tag == NetRequestType_ListBooks) {
            
            strongSelf.models = nil;
            strongSelf.listModel = nil;
            strongSelf.listModel = [[RepositoryListModel alloc]initWithDictionary:successInfoObj error:nil];
            
            [strongSelf updateTableView];
        }
    }];
}


#pragma mark ---tableViewdelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row = 0;
    if (self.models) {
        row = 2;
    }else if (self.listModel.list){
        row = [self.listModel.list count];
    }
    return row;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    if (self.models) {
        if (indexPath.row == 0) {
            height = 40;
        }else if (indexPath.row == 1){
            
            height = [BookSearchHotContentCell getCellHeight:self.models.items];
        }
    }else if (self.listModel.list){
        height = 140;
    }
    return height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = nil;
    if (self.models) {
        if (indexPath.row == 0) {
            BookSearchHotTitleCell * tempCell =  [tableView dequeueReusableCellWithIdentifier:BookSearchHotTitleCellIdentifer];
            tempCell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell = tempCell;
        }else if (indexPath.row == 1){
            
            BookSearchHotContentCell * tempCell =  [tableView dequeueReusableCellWithIdentifier:BookSearchHotContentCellIdentifier];
            [tempCell setupData:self.models.items];
            tempCell.backgroundColor = [UIColor whiteColor];
            WEAKSELF
            tempCell.searchBlock = ^(NSString *searchText) {
                [weakSelf searchHot:searchText];
            };
            tempCell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell = tempCell;
        }
    }else if (self.listModel.list){
      
        BookcaseCell  * tempCell = [tableView dequeueReusableCellWithIdentifier:@"BookcaseCell"];
        RepositoryModel * model = self.listModel.list[indexPath.row];
        
        [tempCell setupSearchItemInfo:self.listModel.list[indexPath.row]];
        BOOL  hasBookSelfState = NO;
        if ([model.hasInBookShelf integerValue] == 1) {
            hasBookSelfState = YES;
        }
        [tempCell hasBookSelfState: hasBookSelfState];
        tempCell.lineHeight.constant = 1;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell = tempCell;
    }
    return cell;
}

//- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    CGFloat heigt = 0.01;
//    if (self.models) {
//        heigt = 1;
//    }else if (self.listModel.list){
//        heigt = 10;
//    }
//    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
//    line.backgroundColor = HexRGB(0xF4F4F4);
//    return line;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (self.models) {
//        return 1;
//    }else if (self.listModel.list){
//        return 10 ;
//    }
//    return 0.01;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.listModel.list){
        // 取消选中
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        RepositoryModel * model = self.listModel.list[indexPath.row];
        BOOL existsState = NO;
        if ([model.hasInBookShelf integerValue] == 1) {
            existsState = YES;
        }
        BookPreviewDetailViewController * detail;
        if ([model.bookType isEqualToString:BookTypeBookJF]) {
            detail = [[JFBookPreviewViewController alloc]initWithBookId:model.id withExistsBookcase:existsState];
        }else if([model.bookType isEqualToString:BookTypeCartoon]){
            detail = [[BookPreviewDetailViewController alloc]initWithBookId:model.id withExistsBookcase:existsState];
        }else if([model.bookType isEqualToString:BookTypeBook]){
            detail = [[BookBookPreDetailViewController alloc]initWithBookId:model.id withExistsBookcase:existsState];
        }
        
        detail.indexPath = indexPath;
        detail.selectedBlock = ^(NSIndexPath *indexPath) {
            
            model.hasInBookShelf = @(1);
            //        [self.searchResultVC updateCellAtIndexPath:indexPath];
        };
        [self pushViewController:detail];
    }
}

-(void)searchHot:(NSString *)searchText{
    
    _searchBar.text = searchText;
//    [_searchBar  becomeFirstResponder];
    //    self.searchResultVC.searchVC.searchBar.text = searchText;
    //    [self.searchResultVC.searchVC.searchBar becomeFirstResponder];
    //    [self pushViewController:self.searchResultVC];
    
    [self requestListBooks];
}

- (void)registerCell{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BookSearchHotTitleCell class]) bundle:nil] forCellReuseIdentifier:BookSearchHotTitleCellIdentifer];
    [self.tableView registerClass: [BookSearchHotContentCell class] forCellReuseIdentifier:BookSearchHotContentCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BookcaseCell class]) bundle:nil] forCellReuseIdentifier:@"BookcaseCell" ];
}
- (NSString *)getDescriptionText{
    
    return @"未查询到相关书籍";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
