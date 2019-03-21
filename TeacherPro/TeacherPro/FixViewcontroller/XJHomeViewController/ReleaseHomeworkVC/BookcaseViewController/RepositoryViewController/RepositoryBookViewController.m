
//
//  RepositoryBookViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/9/18.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "RepositoryBookViewController.h"
#import "RepositoryListModel.h"
 
#import "RepositoryTitleCell.h"
#import "PlainFlowLayout.h"
#import "RepositoryBookSectionView.h"
#import "RepositoryCell.h"
#import "BookPreviewDetailViewController.h"
#import "RepositoryEmptyCell.h"
#import "RepositoryScreeningView.h"
#import "QueryBookFilterModel.h"
#import "BookSearchViewController.h"
#import "JFBookPreviewViewController.h"
#import "BookBookPreDetailViewController.h"

#define   KscreeningHeaderHeight    80
NSString * const RepositoryBookTitleCellIdentifier = @"RepositoryBookTitleCellIdentifier";
NSString * const RepositoryBookSectionViewIdentifier = @"RepositoryBookSectionViewIdentifier";
NSString * const RepositoryBookCellIdentifer    = @"RepositoryBookCellIdentifer";
NSString * const RepositoryBookEmptyCellIdentifer    = @"RepositoryBookEmptyCellIdentifer";

typedef NS_ENUM(NSInteger,QueryBoutiqueBookFilterType){
    QueryBookFilterType_grade =  0,
    QueryBookFilterType_subjects ,
    QueryBookFilterType_types ,
    QueryBookFilterType_publishers ,
};
@interface RepositoryBookViewController ()<RepositoryScreeningViewDelegate>
@property(nonatomic, strong) RepositoryListModel *listModel;
@property(nonatomic, strong) RepositoryScreeningView *screeningView;
@property(nonatomic, strong) NSNumber * grade;
@property(nonatomic, copy) NSString * subjectId;

@property(nonatomic, copy) NSString * publisherId;
@property(nonatomic, assign) NSInteger selectedScreeningtType;
@property(nonatomic, copy) NSString * selectedScreeningtName;
@property(nonatomic, assign) BOOL isScrollPosition;
@property(nonatomic, strong) NSArray *publishers;
@property(nonatomic, assign) NSInteger selectedGradeIndex;//年级
@property(nonatomic, assign) NSInteger selectedSubjuctsIndex;//科目
@property(nonatomic, assign) NSInteger selectedVersionIndex;//版本
@property(nonatomic, assign) QueryBoutiqueBookFilterType  filterType;
@end

@implementation RepositoryBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationItemTitle:@"精品教材"];
    self.pageCount = 12;
    [self requestListBooks];
    [self setupNavigatioBarRight];
    [self.view addSubview:self.screeningView];
    self.selectedScreeningtType = -1;
}
- (RepositoryScreeningView *)screeningView{
    
    if (!_screeningView) {
        _screeningView = [[RepositoryScreeningView alloc]initWithFrame:CGRectMake(0,KscreeningHeaderHeight, self.view.frame.size.width, self.view.frame.size.height-KscreeningHeaderHeight)  ];
        _screeningView.backgroundColor = [UIColor clearColor];
        _screeningView.delegate = self;
        _screeningView.hidden = YES;
        
    }
    return   _screeningView;
}
- (void)setupNavigatioBarRight{
    UIButton * searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    
    [searchBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
    [searchBtn addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
    [searchBtn setFrame:CGRectMake(0, 5, 40,60)];
    searchBtn.titleLabel.font = fontSize_14;
    UIBarButtonItem * rightBar = [[UIBarButtonItem alloc]initWithCustomView:searchBtn];
    self.navigationItem.rightBarButtonItem = rightBar;
    
    
    
}

 
#pragma mark ---
- (void)requestListBooks{
    
    
    NSMutableDictionary * parameterDic =[NSMutableDictionary dictionary];
    [parameterDic addEntriesFromDictionary: @{@"pageIndex":@(self.currentPageNo),
                                              @"pageSize":@(self.pageCount)
                                              }];
    if (self.grade) {
        [parameterDic addEntriesFromDictionary: @{@"grade":self.grade,
                                                  
                                                  }];
        
    }
    if (self.subjectId) {
        [parameterDic addEntriesFromDictionary: @{@"subjectId":self.subjectId,
                                                  
                                                  }];
    }
  
    
    if (self.publisherId) {
        [parameterDic addEntriesFromDictionary: @{@"publisherId":self.publisherId,
                                                  
                                                  }];
    }
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_ListBooks] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_ListBooks];
    
}
- (void)requestQueryBookFilterDic{
    
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_QueryBookFilterDic] parameterDic:nil requestMethodType:RequestMethodType_POST requestTag:NetRequestType_QueryBookFilterDic];
    
}

//查询出版社
- (void)requestPublisherQueryBookFilterDic2{
    NSDictionary * parameterDic = nil;
     if (self.subjectId) {
         parameterDic = @{@"subjectId":self.subjectId};
     } 
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_QueryBookFilterDic2] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_QueryBookFilterDic2];
}
- (void)setNetworkRequestStatusBlocks{
    
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_ListBooks) {
            if (!strongSelf.listModel.list) {
                strongSelf.listModel = [[RepositoryListModel alloc]initWithDictionary:successInfoObj error:nil];
            }else{
                RepositoryListModel * tempModel  =  [[RepositoryListModel alloc]initWithDictionary:successInfoObj error:nil];
                
                [strongSelf.listModel.list addObjectsFromArray:tempModel.list];
                
            }
            
            strongSelf.currentPageNo ++;
            [strongSelf updateCollectionView];
            if (strongSelf.isScrollPosition) {
//                [strongSelf.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
            }
            strongSelf.collectionView.mj_footer.hidden = NO;
        }else if (request.tag == NetRequestType_QueryBookFilterDic){
            [strongSelf confitgFilterDic:successInfoObj];
        }else if (request.tag == NetRequestType_QueryBookFilterDic2){
            NSLog(@"%@---",successInfoObj);
            [strongSelf  confitgFilterDic2:successInfoObj];
        }
        
    }];
    
}
- (void)confitgFilterDic2:(NSDictionary *)successInfoObj{
    
    NSDictionary * publisherDic = @{@"publishers":successInfoObj[@"dics"]};
    self.publishersModel = [[PublishersModel alloc]initWithDictionary:publisherDic error:nil];
    
}
- (void)confitgFilterDic:(NSDictionary *)successInfoObj{
    
    self.publishersModel = [[PublishersModel alloc]initWithDictionary:successInfoObj error:nil];
    self.gradesModel = [[GradesModel alloc]initWithDictionary:successInfoObj error:nil];
    self.subjectsModel = [[SubjectsModel alloc]initWithDictionary:successInfoObj error:nil];
 
    
    switch (self.filterType) {
        case QueryBookFilterType_publishers:
            [self versionViewShowState:YES];
            break;
        case QueryBookFilterType_subjects:
            [self subjectsViewShowState:YES];
            break;
  
        case QueryBookFilterType_grade:
            [self gradeViewShowState:YES];
            break;
            
        default:
            break;
    }
    
}
- (void)rightAction:(UIButton *)sender{
    
    [self gotoSearchBookVC];
}

- (void)gotoSearchBookVC{
    
//    SearchBookViewController * searchBookVC = [[SearchBookViewController alloc]init];
//
//    [self pushViewController:searchBookVC];
    
    BookSearchViewController * searchBookVC = [[BookSearchViewController alloc]init];
    [self pushViewController:searchBookVC];
}

- (BOOL)isAddRefreshFooter{
    
    return YES;
}
- (NSInteger )getNetworkCollectionViewDataCount{
    
    return [self.listModel.list count];
}
- (void)getLoadMoreCollectionViewNetworkData{
     [self requestListBooks];
    
}
- (void)registerCell{
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([RepositoryCell class]) bundle:nil] forCellWithReuseIdentifier:RepositoryBookCellIdentifer];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([RepositoryBookSectionView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:RepositoryBookSectionViewIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([RepositoryTitleCell class]) bundle:nil] forCellWithReuseIdentifier:RepositoryBookTitleCellIdentifier];
     [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([RepositoryEmptyCell class]) bundle:nil] forCellWithReuseIdentifier:RepositoryBookEmptyCellIdentifer];
}

- (UICollectionViewLayout *)getCollectionViewLayout{
    UICollectionViewLayout * collectionViewLayout ;
    PlainFlowLayout * plainFlowLayout = [[PlainFlowLayout alloc]init];
    plainFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    plainFlowLayout.naviHeight = 0.0f;
    collectionViewLayout = plainFlowLayout;
    
    return collectionViewLayout;
}

#pragma mark ---

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    NSInteger section = 2;
    return  section;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger row = 0;
    if (section == 0) {
        row = 0;
    }else{
        if (self.listModel.list.count >0) {
            row = [self.listModel.list count];
        }else{
            row = 1;
        }
    }
    return row;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = nil;
    if (indexPath.section == 0) {
        RepositoryTitleCell * tempcell =  [collectionView dequeueReusableCellWithReuseIdentifier:RepositoryBookTitleCellIdentifier forIndexPath:indexPath];
        
        cell = tempcell;
    }  else{
        if ([self.listModel.list count]  >0) {
            RepositoryCell * tempCell = [collectionView dequeueReusableCellWithReuseIdentifier:RepositoryBookCellIdentifer forIndexPath:indexPath];
            [tempCell setupRepositoryInfo:self.listModel.list[indexPath.item]];
            cell  = tempCell;
        }else{
            RepositoryEmptyCell * tempCell = [collectionView dequeueReusableCellWithReuseIdentifier:RepositoryBookEmptyCellIdentifer  forIndexPath:indexPath];
            
            cell  = tempCell;
            
        }
    }
    
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeZero;
   if (indexPath.section == 0) {
        size = CGSizeMake(IPHONE_WIDTH , FITSCALE(30));
    }else{
        if (self.listModel.list.count > 0) {
            size = CGSizeMake((IPHONE_WIDTH - 5*4)/3, 104 + 70);
            RepositoryModel *model =  self.listModel.list[indexPath.item];
            
        }else{
            size = CGSizeMake(IPHONE_WIDTH, self.view.frame.size.height- KscreeningHeaderHeight);
            
        }
      
    }
    return size;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *headerView = nil;
    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        RepositoryBookSectionView * sectionView  = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:RepositoryBookSectionViewIdentifier forIndexPath:indexPath];
        sectionView.backgroundColor = [UIColor whiteColor];
        if (self.selectedScreeningtName) {
            [sectionView setupButtonTitle:self.selectedScreeningtName withType:self.selectedScreeningtType];
        }
        sectionView.chooseBlock = ^(RepositoryBookType type, BOOL isOpen) {
            [self showTypeView:type withIsOpen: isOpen];
        };
        
        headerView  = sectionView;
        
    }
    return headerView;
}

- (void)showTypeView:(RepositoryBookType )type  withIsOpen:(BOOL)isOpen{
    [self contentOffsetCollectionView];
    if (type == RepositoryBookType_gard) {
        self.filterType = QueryBookFilterType_grade;
        if (!self.gradesModel) {
            [self requestQueryBookFilterDic];
        }else{
            [self gradeViewShowState:isOpen];
        }
    } else if (type == RepositoryBookType_subjects){
        self.filterType = QueryBookFilterType_subjects;
        
        if (!self.subjectsModel) {
            [self requestQueryBookFilterDic];
        }else{
            [self subjectsViewShowState:isOpen];
        }
    }else if (type == RepositoryBookType_version){
        self.filterType = QueryBookFilterType_publishers;
        
        if (!self.publishersModel) {
            [self requestQueryBookFilterDic];
        }else{
            [self versionViewShowState:isOpen];
        }
    }
     
 
}
- (void)contentOffsetCollectionView{
    self.collectionView.mj_footer.hidden = YES;
//    CGFloat offsetY = FITSCALE(30) ;
//    [self.collectionView setContentOffset:CGPointMake(0, offsetY) animated: NO] ;
    
    self.collectionView.scrollEnabled = NO;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize size = CGSizeZero;
    if (section  == 0) {
        size = CGSizeZero;
    } else{
        size = (CGSize){IPHONE_WIDTH,KscreeningHeaderHeight};
    }
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets insets  = UIEdgeInsetsZero;
//    if (section == 0) {
        insets = UIEdgeInsetsZero;
//    }else
//        insets = UIEdgeInsetsMake(5, 5, 5, 5);
    return insets;
}

// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 1 && [self.listModel.list count] > 0) {
        [self gotoBookPreviewDetailVC:indexPath];
    }
 
}

- (void)gotoBookPreviewDetailVC:(NSIndexPath *)indexPath{
    
    RepositoryModel *model = self.listModel.list[indexPath.item];
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
    [self pushViewController:detail];
}

#pragma mark ---
- (void)gradeViewShowState:(BOOL)isShow{
    
    if (isShow) {
        
        if (self.gradesModel ) {
            self.screeningView.screeningType = RepositoryScreeningType_grade;
            self.screeningView.gradesModel = self.gradesModel;
            self.screeningView.rows = [self.gradesModel.grades count]+1;
            self.screeningView.selectedIndex = self.selectedGradeIndex;
            [self.screeningView updateTableView];
            [self.screeningView showView];
        }
        
    }else{
        
        [self.screeningView hideView];
        self.collectionView.scrollEnabled = YES;
    }
    
}


- (void)subjectsViewShowState:(BOOL)isShow{
    
    if (isShow) {
        
        
        self.screeningView.screeningType = RepositoryScreeningType_subjects;
        self.screeningView.subjectsModel = self.subjectsModel;
        self.screeningView.rows = [self.subjectsModel.subjects count]+1;
        self.screeningView.selectedIndex = self.selectedSubjuctsIndex;
        [self.screeningView updateTableView];
        [self.screeningView showView];
    }else{
        
        [self.screeningView hideView];
        self.collectionView.scrollEnabled = YES;
    }
}


- (void)versionViewShowState:(BOOL)isShow{
    
    if (isShow) {
        if (self.publishersModel  ) {
            
            
            self.screeningView.screeningType = RepositoryScreeningType_version;
            self.screeningView.rows = [self.publishersModel.publishers count]+1;
            self.screeningView.publishersModel = self.publishersModel;
            self.screeningView.selectedIndex = self.selectedVersionIndex;
            self.screeningView.publisherId = self.publisherId;
            [self.screeningView updateTableView];
            [self.screeningView showView];
        }
        
    }else{
        
        [self.screeningView hideView];
        self.collectionView.scrollEnabled = YES;
    }
}


- (void)selectedType:(RepositoryScreeningType)type withIndexItem:(id )item withIndex:(NSInteger)selectedIndex{
    self.isScrollPosition = YES;
    [self.screeningView hideView];
    self.collectionView.scrollEnabled = YES;
    NSString * name = @"";
    switch (type) {
        case RepositoryScreeningType_grade:
            if ([item isKindOfClass:[NSString class]]) {
                self.grade = nil;
                name =  item;
            }else{
                self.grade =  ((GradeModel *)item).grade;
                name = ((GradeModel *)item).gradeName;
            }
            
            self.selectedGradeIndex = selectedIndex;
            break;
        case RepositoryScreeningType_subjects:
            if ([item isKindOfClass:[NSString class]]) {
                self.subjectId = nil;
                name =  item;
            }else{
                self.subjectId =  ((SubjectModel *)item).subjectId;
                name = ((SubjectModel *)item).subjectName;
            }
            self.selectedSubjuctsIndex = selectedIndex;
            [self requestPublisherQueryBookFilterDic2];
            break;
        case RepositoryScreeningType_version:
            if ([item isKindOfClass:[NSString class]]) {
                self.publisherId = nil;
                name =  item;
            }else{
                self.publisherId = [NSString stringWithFormat:@"%@",((PublisherModel *)item).id];
                name = ((PublisherModel *)item).versionName;
            }
            self.selectedVersionIndex = selectedIndex;
            break;
       
        default:
            break;
    }
    self.selectedScreeningtName = name;
    self.selectedScreeningtType = type;
    self.currentPageNo = 0;
    self.listModel = nil;
    [self requestListBooks];
    
}


#pragma mark ---
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
