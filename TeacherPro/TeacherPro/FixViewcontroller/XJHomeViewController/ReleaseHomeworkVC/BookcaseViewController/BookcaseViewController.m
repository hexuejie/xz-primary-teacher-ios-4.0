
//
//  BookcaseViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/9/4.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BookcaseViewController.h"
#import "BookcaseCell.h"
#import "BookcaseListsModel.h"
#import "RepositoryViewController.h"
#import "BookHomeworkViewController.h"
#import "BookcaseSectionCell.h"
#import "ProUtils.h"
#import "YYCache.h"

#import "PhonicsHomeworkViewController.h"
#import "RespositoryPageViewController.h"
#import "AssistantsHomeworkViewController.h"
#import "BookcaseHeaderView.h"


NSString * const BookcaseCellIdentifier = @"BookcaseCellIdentifier";
NSString * const BookcaseSectionCellIdentifier = @"BookcaseSectionCellIdentifier";
NSInteger const repositoryBtnTag = 1232112;
@interface BookcaseViewController ()
@property(nonatomic, strong) BookcaseListsModel *listModel;
@property(nonatomic, assign) BOOL isTableViewEditing;//编辑
@property(nonatomic, strong) NSIndexPath *seletedIndex;//选中要删除的下标
@property(nonatomic, copy)   NSString *bzSubjectName;
@property(nonatomic, strong) BookcaseHeaderView * headerView;
@property(nonatomic, assign) NSInteger totalNumber;
@property(nonatomic, assign)  BOOL isFromHome;//是否首页跳转我的书籍
@end

@implementation BookcaseViewController
- (instancetype)initWithbzSubjectName:(NSString *)bzSubjectName{
    if (self == [super init]) {
        self.bzSubjectName = bzSubjectName;
    }
    return self;
}
- (instancetype)initWithHomeSubjectName:(NSString *)bzSubjectName{
    if (self == [super init]) {
  
        self.isFromHome = YES;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationItemTitle:@"我的书架"];
    [self setupNavigatioBarRight];
    

    [self setupBookCityButton];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateListBook) name:@"UPDATE_BOOKCASE" object:nil];
   [self configTableView];
   self.pageCount = 20;
   [self requestListBookFromTeacherBookShelf];
    
    
    [self.view addSubview:self.headerView];
    self.headerView.hidden =YES;
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@44);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.view.mas_top);
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self navUIBarBackground:0];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self navUIBarBackground:8];
}

- (void)updateListBook{
    self.pageCount = 20;
    self.currentPageNo = 0;
    self.listModel = nil;
    [self requestListBookFromTeacherBookShelf];
}
- (BookcaseHeaderView *)headerView{
    
    if (!_headerView) {
        _headerView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([BookcaseHeaderView class]) owner:nil options:nil].firstObject;
    }
    return _headerView;
}
- (BOOL)isAddRefreshFooter {
    return YES;
}



- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    NSLog(@"imageForEmptyDataSet:empty_placeholder");
    return [UIImage imageNamed:@"no_book"];
}



- (NSString *)getDescriptionText{
    
    return @"哎呀 快去充实你的书架吧";
}

- (nullable UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView{
    UIView * customView  = [[UIView alloc]initWithFrame:self.view.frame];
    customView.backgroundColor = [UIColor redColor];
    
    UIImage *bookImgNor = [UIImage imageNamed:@"no_book.png"];
    
    UILabel * descrioptionLabel = [[UILabel alloc]init];
    descrioptionLabel.text = [self getDescriptionText];
    descrioptionLabel.textColor = HexRGB(0x8A8F99);
    descrioptionLabel.font = systemFontSize(12);
    descrioptionLabel.textAlignment = NSTextAlignmentCenter;
    descrioptionLabel.numberOfLines = 0;
    CGFloat  descrioptionLabelW = self.view.frame.size.width - 40*2;
    CGFloat  descrioptionLabelL = 40;
     CGFloat  descrioptionLabelH = [ProUtils heightForString:[self getDescriptionText] andWidth:descrioptionLabelW];
    descrioptionLabel.frame = CGRectMake(descrioptionLabelL,0, descrioptionLabelW,descrioptionLabelH);
    
    [customView addSubview:descrioptionLabel];
    
    UIImageView * bookImgView = [[UIImageView alloc]initWithImage:bookImgNor];
    CGFloat  bookImgViewW = bookImgNor.size.width;
    CGFloat  bookImgViewH = bookImgNor.size.height;
    CGFloat  bookImgViewY = CGRectGetMinY(descrioptionLabel.frame) - bookImgViewH;
 
    bookImgView.frame = CGRectMake(descrioptionLabel.center.x - bookImgViewW/2 ,bookImgViewY, bookImgViewW, bookImgViewH);
    
    [customView addSubview:bookImgView];
    
//     UIImage *arrowImg = [UIImage imageNamed:@"gobook_arrow.png"];
//
//    UIImageView * arrowView = [[UIImageView alloc]initWithImage:arrowImg];
//    CGFloat  arrowViewY = CGRectGetMaxY(descrioptionLabel.frame)+ FITSCALE(50);
//    CGFloat  arrowImgW = arrowImg.size.width;
//    CGFloat  arrowImgH = arrowImg.size.height;
//
//    arrowView.frame = CGRectMake(descrioptionLabel.center.x,arrowViewY, arrowImgW, arrowImgH);
//    [customView addSubview:arrowView];
    
    return customView;
}
- (void)showBookButtonArrowView{
  
}
- (void)configTableView{
    
    self.tableView.backgroundColor = [UIColor clearColor];
    // 隐藏UITableViewStyleGrouped上边多余的间隔
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    
    self.view.backgroundColor = project_background_gray;
}
- (void)setupNavigatioBarRight{
    UIButton * editingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [editingBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [editingBtn setTitle:@"完成" forState:UIControlStateSelected];
    [editingBtn setTitleColor:HexRGB(0x4D4D4D) forState:UIControlStateHighlighted];
    [editingBtn setTitleColor:HexRGB(0x4D4D4D) forState:UIControlStateNormal ];
    [editingBtn addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
    [editingBtn setFrame:CGRectMake(0, 5, 40,60)];
    editingBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    editingBtn.hidden = YES;
    UIBarButtonItem * rightBar = [[UIBarButtonItem alloc]initWithCustomView:editingBtn];
    
    self.navigationItem.rightBarButtonItem = rightBar;
    
}

- (void)setupBookCityButton{

     CGFloat btnW =  64;
    UIButton * repositoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [repositoryBtn setBackgroundImage:[UIImage imageNamed:@"homework_gotoBookcase"] forState:UIControlStateNormal];
    
    [repositoryBtn addTarget:self action:@selector(repositoryAction:) forControlEvents:UIControlEventTouchUpInside];
    [repositoryBtn setFrame:CGRectMake(kScreenWidth- btnW -8, kScreenHeight-64- btnW-18, btnW,btnW)];
    repositoryBtn.tag = repositoryBtnTag;
    [self.view addSubview:repositoryBtn];
    
}
- (void)repositoryAction:(UIButton *)button{
   
    RespositoryPageViewController * repostoryVC = [[RespositoryPageViewController alloc]init];
    
    [self pushViewController:repostoryVC];
}
- (void)rightAction:(UIButton *)button{

    button.selected = !button.selected;
    self.isTableViewEditing = button.selected;

    [self updateRepositoryBtn:button.selected];
    
    [self updateHeaderView];
    [self updateTableView];
}

- (void)updateHeaderView{
    if ([self.listModel.list count] > 0) {
        self.headerView.hidden = NO;
    }else{
        self.headerView.hidden = YES;
    }
    [self.headerView setupNumber:self.totalNumber withEditState:self.isTableViewEditing];
}
- (void)updateRepositoryBtn:(BOOL)selected{
    
    UIButton * btn = [self.view viewWithTag:repositoryBtnTag];
    btn.hidden = selected;
    
}

- (CGRect)getTableViewFrame{
    
    return CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height - 44);
}
- (UITableViewStyle)getTableViewStyle{

    return UITableViewStylePlain;
}
- (void)registerCell{
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BookcaseCell class]) bundle:nil] forCellReuseIdentifier:BookcaseCellIdentifier];
     [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BookcaseSectionCell class]) bundle:nil] forCellReuseIdentifier:BookcaseSectionCellIdentifier];
    
}
#pragma mark ---
- (void)requestListBookFromTeacherBookShelf{
    
    NSDictionary *parameterDic = @{@"pageSize":@(self.pageCount),@"pageIndex":@(self.currentPageNo)};
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_ListBookFromTeacherBookShelf] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_ListBookFromTeacherBookShelf];
}
- (void)getLoadMoreTableViewNetworkData{
    [self requestListBookFromTeacherBookShelf];
}

- (NSInteger )getNetworkTableViewDataCount{
    
    return [self.listModel.list count];
}
- (void)setNetworkRequestStatusBlocks{
    
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_ListBookFromTeacherBookShelf) {
            if (!strongSelf.listModel && strongSelf.currentPageNo == 0) {
                 strongSelf.listModel = [[BookcaseListsModel alloc]initWithDictionary:successInfoObj error:nil];
            }else{
                BookcaseListsModel * tempModel = [[BookcaseListsModel alloc]initWithDictionary:successInfoObj error:nil];
                [strongSelf.listModel.list addObjectsFromArray:tempModel.list];
            }
            strongSelf.currentPageNo++;
            strongSelf.totalNumber = [strongSelf.listModel.total integerValue ];
        
        }else if (request.tag == NetRequestType_TeacherDeleteBookToBookShelf) {
   
            [strongSelf.listModel.list removeObjectAtIndex:strongSelf.seletedIndex.section  ];
//            strongSelf.isTableViewEditing = NO;
//            [strongSelf.view viewWithTag: repositoryBtnTag].hidden = NO;
            strongSelf.totalNumber--;
             [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_HOME_BOOKCASE_LIST" object:nil];
        }
        [strongSelf configurationEditButton];
        [strongSelf updateTableView];
        [strongSelf updateHeaderView];
       
        
    }];
}


#pragma mark --
- (void)configurationEditButton{
    UIButton * btn = self.navigationItem.rightBarButtonItem.customView;
    if ([self.listModel.list count] == 0) {
        btn.selected = NO;
        btn.hidden = YES;
        self.isTableViewEditing = NO;
        [self showRepositoryBtn];
    }else{
        if (self.isTableViewEditing) {
             btn.selected = YES;
        }else{
            btn.selected = NO;
            [self showRepositoryBtn];
        } 
        btn.hidden = NO;
    }
}

- (void)showRepositoryBtn{

    UIButton * btn = [self.view viewWithTag:repositoryBtnTag];
    btn.hidden = NO;

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger section = 0;
    if ([self.listModel.list count]>0) {
        section = [self.listModel.list  count] ;
    }
    return section;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger row = 1;
    
    return row;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BookcaseCell * teampCell = [tableView dequeueReusableCellWithIdentifier:BookcaseCellIdentifier];
    
    [teampCell setupBookcaseInfo:self.listModel.list[indexPath.section] isEditState:self.isTableViewEditing];
    teampCell.index = indexPath;
    WEAKSELF
    teampCell.deleteBlock = ^(NSIndexPath *index) {
        [weakSelf deleteBook:index];
    };
    
    teampCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return teampCell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
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

          if (section >=1){
          headerHeight = 1;
      }
    return headerHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    CGFloat footerHeight =  0.0001;
    return footerHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (!self.isTableViewEditing  ) {
        
        [self gotoBookHomeworkIndex:indexPath];
    }
    
}

#pragma mark ----
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view viewWithTag: repositoryBtnTag].alpha = 0.5;
    
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    [self.view viewWithTag: repositoryBtnTag].alpha = 1;
}


- (void)gotoBookHomeworkIndex:(NSIndexPath *)index{
    BookcaseModel *model = self.listModel.list[index.section ];
    
//    if (self.bzSubjectName &&![model.subjectName isEqualToString:self.bzSubjectName]) {
//        
//        [self showAlert:TNOperationState_Fail content:@"不能同时布置不同科目"];
//        return ;
//    }
    if ([model.bookType isEqualToString:@"JFBook"]) {//教辅 备注
        AssistantsHomeworkViewController * bookHomeworkVC = [[AssistantsHomeworkViewController alloc]initWithBookId:model.bookId  ];
        [self pushViewController:bookHomeworkVC];
    }else{//教材 备注
        if ([model.courseType isEqualToString:@"phonics_textbook"]) {
            PhonicsHomeworkViewController * bookHomeworkVC = [[PhonicsHomeworkViewController alloc]initWithBookId:model.bookId];
            [self pushViewController:bookHomeworkVC];
            return;
        }
        
        BookHomeworkViewController * bookHomeworkVC = [[BookHomeworkViewController alloc]initWithBookId:model.bookId withBookType:model.bookType withClear:YES];
        [self pushViewController:bookHomeworkVC];
        
    }
}
- (void)deleteBook:(NSIndexPath *)index{

    BookcaseModel * model = self.listModel.list[index.section ];
    NSDictionary * parameterDic  = nil;
    if (model.bookId) {
       parameterDic = @{@"bookIds":model.bookId};
        self.seletedIndex = index;
    }else{
        self.seletedIndex = nil;
        return ;
    }
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr: NetRequestType_TeacherDeleteBookToBookShelf] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_TeacherDeleteBookToBookShelf];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
