//
//  CartoonCollectionViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/9/18.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "CartoonCollectionViewController.h"
#import "RepositoryListModel.h"
#import "RepositoryCell.h"
#import "PlainFlowLayout.h"
#import "BookPreviewDetailViewController.h"
#import "JFBookPreviewViewController.h"
#import "BookBookPreDetailViewController.h"

NSString * const RepositoryCartoonCellIdentifier = @"RepositoryCartoonCellIdentifier";

@interface CartoonCollectionViewController ()
@property(nonatomic, copy) NSString * titleName;
@property(nonatomic, copy) NSString * gradeId;
@property(nonatomic, strong) RepositoryListModel *listModel;
@end

@implementation CartoonCollectionViewController
- (instancetype)initWithName:(NSString *)name withGradeId:(NSString *)gradeId{
    self = [super init];
    if (self) {
        self.titleName = name;
        self.gradeId = gradeId;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pageCount = 12;
    
}

- (void)updateData{
    WEAKSELF
    self.startedBlock = ^(NetRequest *request)
    {
        [weakSelf showHUDInfoByType:HUDInfoType_NormalShadeNo];
    };
    [self requestListBooks];
}
- (void)requestListBooks{
    
    NSDictionary * parameterDic =  @{@"pageIndex":@(self.currentPageNo),@"pageSize":@(self.pageCount),@"bookType":BookTypeCartoon,@"grade":self.gradeId};
    
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_ListBooks] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_ListBooks];
    
}
- (void)setNetworkRequestStatusBlocks{
    
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_ListBooks) {
            if (!strongSelf.listModel.list) {
                strongSelf.listModel = [[RepositoryListModel alloc]initWithDictionary:successInfoObj error:nil];
                strongSelf.hasLoadData = YES;
            }else{
                RepositoryListModel * tempModel  =  [[RepositoryListModel alloc]initWithDictionary:successInfoObj error:nil];
                
                [strongSelf.listModel.list addObjectsFromArray:tempModel.list];
                
            }
            
            strongSelf.currentPageNo ++;
            [strongSelf updateCollectionView];
        }
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)titleForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController{
    
    return  self.titleName;
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
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([RepositoryCell class]) bundle:nil] forCellWithReuseIdentifier:RepositoryCartoonCellIdentifier];
    
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionViewCellIdentifier"  ];
}

- (UICollectionViewLayout *)getCollectionViewLayout{
    UICollectionViewLayout * collectionViewLayout ;
    PlainFlowLayout * plainFlowLayout = [[PlainFlowLayout alloc]init];
    plainFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    plainFlowLayout.naviHeight = 0.0f;
    plainFlowLayout.minimumInteritemSpacing = 10.f;
    collectionViewLayout = plainFlowLayout;
    
    return collectionViewLayout;
}

#pragma mark ---

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    NSInteger section = 1;
    return  section;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger row = 0;
    row = [self.listModel.list count];
    
    return row;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = nil;
    
    RepositoryCell * tempCell = [collectionView dequeueReusableCellWithReuseIdentifier:RepositoryCartoonCellIdentifier forIndexPath:indexPath];
    [tempCell setupRepositoryInfo:self.listModel.list[indexPath.item]];
    cell  = tempCell;
    
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeZero;
    size = CGSizeMake((IPHONE_WIDTH-5*4)/3, FITSCALE(160));
    
    return size;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize size = (CGSize){IPHONE_WIDTH,20};
    
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets insets  = UIEdgeInsetsZero;
    insets = UIEdgeInsetsZero;
    
    return insets;
}

// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        [self gotoBookPreviewDetailVC:indexPath];
    }
    
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView * reusableView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"UICollectionViewCellIdentifier" forIndexPath: indexPath];
    }
    return reusableView;
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
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    NSLog(@"imageForEmptyDataSet:empty_placeholder");
    return [UIImage imageNamed:@"new_empty_list"];
}
- (NSString *)getDescriptionText{
    
    return @"未查询到相关书籍";
}

- (BOOL)isViewWillDisappearHideHUD{
    return NO;
}
@end

