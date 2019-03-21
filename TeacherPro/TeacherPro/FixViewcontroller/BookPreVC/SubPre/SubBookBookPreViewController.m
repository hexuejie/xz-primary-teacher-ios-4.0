//
//  SubBookBookPreViewController.m
//  TeacherPro
//
//  Created by 何学杰 on 2018/12/6.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "SubBookBookPreViewController.h"
#import "BookPreviewDirectoryHeaderView.h"


@interface SubBookBookPreViewController ()

@end

@implementation SubBookBookPreViewController

- (instancetype)initWithBookId:(NSString *)bookId withExistsBookcase:(BOOL)isExists{
    self = [super init];
    if (self) {
        self.bookId = bookId;
        self.isExists = isExists;
     
    }
    return self;
}
- (instancetype)initWithFromHomeBookId:(NSString *)bookId  withExistsBookcase:(BOOL)isExists{
    self = [super init];
    if(self){
        self.bookId = bookId;
        self.isExists = isExists;
 
    }
    return self;
}
- (NSString *)getDescriptionText{
    return @"暂无数据~";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self requestQueryBook];
    self.unityIconDic = [ProUtils getHomworkDetailUnitIconDic];
    
    [self.view addSubview:self.mongoliaView];
    [self.view addSubview:self.circleView];
    [self configCollectionView];
    [self setNavigationItemTitle:@"预览"];
    
    self.isPhonics = 0;
    self.collectionView.bounces = YES;
    self.collectionView.frame = CGRectMake(0, 0, IPHONE_WIDTH, self.view.frame.size.height);
}

- (void)configCollectionView{
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = project_background_gray;
}

- (void)registerCell{
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BookPreviewDirectoryCell class]) bundle:nil] forCellWithReuseIdentifier:@"BookPreviewDirectoryCell"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BookPreviewDetailTypeCell class]) bundle:nil] forCellWithReuseIdentifier:@"BookPreviewDetailTypeCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BookPreviewDetailTitleCell class]) bundle:nil] forCellWithReuseIdentifier:@"BookPreviewDetailTitleCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BookPreCartoonHeader class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BookPreCartoonHeader"];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BookPreviewDirectoryHeaderView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BookPreviewDirectoryHeaderView"];
    
    [self.collectionView registerClass:[UICollectionReusableView class]  forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionElementKindSectionFooter" ];
    [self.collectionView registerClass:[UICollectionReusableView class]  forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionElementKindheader" ];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CartoonProfilePreviewCell class]) bundle:nil] forCellWithReuseIdentifier:@"CartoonProfilePreviewCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CartoonPreviewDirectoryPlayCell  class]) bundle:nil] forCellWithReuseIdentifier:@"CartoonPreviewDirectoryPlayCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BookPreviewDirectoryCell class]) bundle:nil] forCellWithReuseIdentifier:@"BookPreviewDirectoryCell0"];
}

#pragma mark --- 请求接口
- (void)requestQueryBook{
    
    NSDictionary *parameterDic =nil;
    if (self.bookId) {
        parameterDic  = @{@"bookId":self.bookId,@"getUnit":@"true",@"bookType":BookTypeBook};
    }
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_QueryBookById] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_QueryBookById];
}
- (void)requestAddBookcase{
    
    NSDictionary *parameterDic =nil;
    if (self.bookId) {
        parameterDic  = @{@"bookId":self.bookId,@"getUnit":@"true",@"bookType":BookTypeBook};
    }
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_TeacherAddBookToBookShelf] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_TeacherAddBookToBookShelf];
    
}

- (void)setNetworkRequestStatusBlocks{
    
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_QueryBookById) {
            strongSelf.detailModel = [[BookPreviewModel alloc]initWithDictionary:successInfoObj error:nil];
            if ([strongSelf.detailModel.book.courseType isEqualToString:@"phonics_textbook"]) {
                strongSelf.isPhonics = 1;
            }
            [strongSelf updateCollectionView];
            [strongSelf.collectionView reloadData];
        }
    }];
}

#pragma mark --- delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    NSInteger section = 0;
    if (!self.detailModel.book) {
        section = 0;
    }else{
        
        if ([self.detailModel.book.bookType isEqualToString:BookTypeBook]) {//教材  包含：自然拼图
            //            section = 2 + [self.detailModel.book.bookUnits count];
            if (self.isPhonics == YES) {
                return 1 + [self.detailModel.book.bookUnits count];
            }
            return 2;
        }
    }
    return section;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }else{
        BookUnitModel * model = self.detailModel.book.bookUnits[section -1];
        if (self.isPhonics == YES) {
            if (model.children) {
                return [model.children count]+1;
            }else{
                return 1;
            }
        }
        return [self.detailModel.book.bookUnits count];
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    UICollectionViewCell *cell = nil;
    UICollectionViewCell *cell = [[UICollectionViewCell alloc]init];
    if (indexPath.section == 0) {

    }
    else if (indexPath.section >= 1){
        
        if (self.isPhonics == YES) {
            
            BookUnitModel * model = self.detailModel.book.bookUnits[indexPath.section -1];
            if (indexPath.row == 0) {
                BookPreviewDirectoryCell * tempCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BookPreviewDirectoryCell0" forIndexPath:indexPath];
                [tempCell setupDirectoryInfo:model];
                cell = tempCell;
            }else {
                
                BookPreviewDirectoryCell * tempCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BookPreviewDirectoryCell" forIndexPath:indexPath];
                BookUnitModel *children = model.children[indexPath.row -1];
                [tempCell setupChildrenDirectoryInfo: children];
                cell = tempCell;
            }
            return cell;
        }else{
            
            BookUnitModel * model = self.detailModel.book.bookUnits[indexPath.row];
            BookPreviewDirectoryCell * tempCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BookPreviewDirectoryCell" forIndexPath:indexPath];
            //        BookUnitModel *children = model.children[indexPath.row];
            [tempCell setupDirectoryInfo:model];
            return tempCell;
        }
    }
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize itemSize =  CGSizeZero;
    if (indexPath.section == 0) {
        itemSize = CGSizeMake(IPHONE_WIDTH, 0.001);
    }else if(indexPath.section >= 1){
        if (self.isPhonics == YES) {
        
            if(indexPath.row == 0){
                itemSize = CGSizeMake(IPHONE_WIDTH, 44);
            }else{
                itemSize =  CGSizeMake(IPHONE_WIDTH, 34);
            }
        }else{
            itemSize = CGSizeMake(IPHONE_WIDTH, 40);
        }
    }
    return itemSize;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    BookPreviewDirectoryHeaderView * sectionView  = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"BookPreviewDirectoryHeaderView" forIndexPath:indexPath];
     if (indexPath.section == 0){
        sectionView.titleLabel.text = @"目录";
    }else{
        sectionView.titleLabel.text = @"";
    }
    return sectionView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize itemSize = CGSizeZero;
   if(section == 0){
        itemSize = (CGSize){IPHONE_WIDTH,46};
    }
    return itemSize;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    return CGSizeZero;
}

- (void)gotoReleaseHomework{
    BookHomeworkViewController * bookHomeworkVC = [[BookHomeworkViewController alloc]initWithBookId:self.bookId withBookType:BookTypeBook withClear:YES];
    [self pushViewController:bookHomeworkVC];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
    
    return edgeInsets;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat  spacing = 0.0f;
    
    return spacing;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat  spacing = 0.0f;
    
    return spacing;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
