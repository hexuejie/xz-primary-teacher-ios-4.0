//
//  SubJFBookPreViewController.m
//  TeacherPro
//
//  Created by 何学杰 on 2018/12/7.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "SubJFBookPreViewController.h"
#import "SubJFBookPreViewController.h"
#import "BookPreviewDirectoryHeaderView.h"
#import "AssistantsHomeworkViewController.h"

@interface SubJFBookPreViewController ()

@end

@implementation SubJFBookPreViewController

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

- (void)setDetailModel:(BookPreviewModel *)detailModel{
    _detailModel = detailModel;
    [self.collectionView reloadData];
}

- (NSString *)getDescriptionText{
    return @"暂无数据~";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self requestQueryBook];
    self.unityIconDic = [ProUtils getHomworkDetailUnitIconDic];
    [self setNavigationItemTitle:@"预览"];
 
    [self.view addSubview:self.mongoliaView];
    [self.view addSubview:self.circleView];
    [self configCollectionView];
    
    self.collectionView.bounces = YES;
    self.collectionView.frame = CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT-64);
}

- (void)configCollectionView{
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = project_background_gray;
}

- (void)registerCell{
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BookPreviewDirectoryCell class]) bundle:nil] forCellWithReuseIdentifier:@"BookPreviewDirectoryCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BookPreviewDirectoryCell class]) bundle:nil] forCellWithReuseIdentifier:@"BookPreviewDirectoryCell0"];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BookPreviewDetailTypeCell class]) bundle:nil] forCellWithReuseIdentifier:@"BookPreviewDetailTypeCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BookPreCartoonHeader class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BookPreCartoonHeader"];
    
    [self.collectionView registerClass:[UICollectionReusableView class]  forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionElementKindSectionFooter" ];
    [self.collectionView registerClass:[UICollectionReusableView class]  forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionElementKindheader" ];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BookPreviewDirectoryHeaderView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"BookPreviewDirectoryHeaderView"];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CartoonProfilePreviewCell class]) bundle:nil] forCellWithReuseIdentifier:@"CartoonProfilePreviewCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CartoonPreviewDirectoryPlayCell  class]) bundle:nil] forCellWithReuseIdentifier:@"CartoonPreviewDirectoryPlayCell"];
}

#pragma mark --- 请求接口
- (void)requestQueryBook{
    
    NSDictionary *parameterDic =nil;
    if (self.bookId) {
        parameterDic  = @{@"bookId":self.bookId,@"getUnit":@"true",@"bookType":BookTypeBookJF};
    }
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_QueryBookById] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_QueryBookById];
}

- (void)setNetworkRequestStatusBlocks{
    
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_QueryBookById) {
            strongSelf.detailModel = [[BookPreviewModel alloc]initWithDictionary:successInfoObj error:nil];
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
        
        if ([self.detailModel.book.bookType isEqualToString:BookTypeBookJF]){//教辅
            section = self.detailModel.book.bookUnits.count +1;
        }
    }
    return section;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    
    BookUnitModel * model = self.detailModel.book.bookUnits[section -1];
    if (model.children) {
        return [model.children count]+1;
    }else{
        return 1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
    }else{
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
    }
    return cell;
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize itemSize =  CGSizeMake(IPHONE_WIDTH, 34);
    if (indexPath.section == 0) {
        itemSize = CGSizeMake(IPHONE_WIDTH, 0.001);
    }else if(indexPath.row == 0){
        itemSize = CGSizeMake(IPHONE_WIDTH, 44);
    }
    return itemSize;
}


- (UICollectionReusableView *) confightDirectoryTitleHeaderView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind withIndexPath:(NSIndexPath *)indexPath withReuseIdentifier:(NSString *)reuseIdentifier{
    BookPreviewDirectoryHeaderView * sectionView  = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"BookPreviewDirectoryHeaderView" forIndexPath:indexPath];
    sectionView.titleLabel.text = @"";
    return sectionView;
}
//目录 标题
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
    
    return itemSize;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeMake(IPHONE_WIDTH, 46);;
    }
    return CGSizeZero;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && self.isExists) {
        SubJFBookPreViewController *subBookVC = [SubJFBookPreViewController new];
        subBookVC.bookId = self.bookId;
        subBookVC.detailModel = self.detailModel;
        [self pushViewController:subBookVC];
    }
}

- (void)gotoReleaseHomework{
    AssistantsHomeworkViewController * bookHomeworkVC = [[AssistantsHomeworkViewController alloc]initWithBookId:self.bookId];
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
