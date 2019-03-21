//
//  BookBookPreDetailViewController.m
//  TeacherPro
//
//  Created by 何学杰 on 2018/12/4.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "BookBookPreDetailViewController.h"
#import "BookPreviewDirectoryHeaderView.h"
#import "SubBookBookPreViewController.h"
#import "XJRepositoryTipsView.h"
#import "PhonicsHomeworkViewController.h"

@interface BookBookPreDetailViewController ()

@end

@implementation BookBookPreDetailViewController

- (instancetype)initWithBookId:(NSString *)bookId withExistsBookcase:(BOOL)isExists{
    self = [super init];
    if (self) {
        self.bookId = bookId;
        self.isExists = isExists;
        [self uploadeView];
    }
    return self;
}
- (instancetype)initWithFromHomeBookId:(NSString *)bookId  withExistsBookcase:(BOOL)isExists{
    self = [super init];
    if(self){
        self.bookId = bookId;
        self.isExists = isExists;
        [self uploadeView];
    }
    return self;
}
- (NSString *)getDescriptionText{
    return @"暂无数据~";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.unityIconDic = [ProUtils getHomworkDetailUnitIconDic];
    
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.mongoliaView];
    [self.view addSubview:self.circleView];
    [self configCollectionView];
    
    self.collectionView.bounces = YES;
    self.collectionView.frame = CGRectMake(0, 0, IPHONE_WIDTH, self.view.frame.size.height-70);
    
//    [self requestQueryBook];
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
            [strongSelf updateCollectionView];
            [strongSelf uploadeView];
            [strongSelf.collectionView reloadData];
        }else if(request.tag == NetRequestType_TeacherAddBookToBookShelf){
            strongSelf.isExists =  YES;
//            [strongSelf showAlert:TNOperationState_OK content:@"书本添加成功" block:^(NSInteger index) {
                [strongSelf gotoBookcaseVC];
//            }];
            
            [strongSelf.collectionView reloadData];
            [strongSelf uploadeView];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_BOOKCASE" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_HOME_BOOKCASE_LIST" object:nil];
            NSLog(@"加入成功");
        }
    }];
}

- (void)gotoBookcaseVC{
    UIWindow *firstWindow = [UIApplication.sharedApplication.windows firstObject];
    XJRepositoryTipsView *noticeView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XJRepositoryTipsView class]) owner:nil options:nil].firstObject;
    noticeView.frame =  CGRectMake((kScreenWidth-148)/2, (kScreenHeight-113)/2, 148, 113);
//    noticeView.image = [UIImage imageNamed:@"6DE32DA4-BCC4-475A-9B9D-9F3D30E63D8A"];
    noticeView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    noticeView.layer.cornerRadius = 6.0;
    noticeView.layer.masksToBounds = YES;
    [firstWindow addSubview:noticeView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [noticeView removeFromSuperview];
    });
    
    
    [self uploadeView];
    [self.bottomView.addButton removeTarget:nil
                       action:NULL
             forControlEvents:UIControlEventAllEvents];
    [self.bottomView.addButton addTarget:self action:@selector(gotoReleaseHomework) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark --- delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    NSInteger section = 0;
    if (!self.detailModel.book) {
        section = 0;
    }else{
        
        if ([self.detailModel.book.bookType isEqualToString:BookTypeBook]) {//教材  包含：自然拼图
            return 3;
        }
    }
    return section;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1) {
        return self.detailModel.book.practiceTypes.count;
    }else{
        return [self.detailModel.book.bookUnits count];
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = nil;
    if (indexPath.section == 0) {
        //绘本预览头部
        BookPreviewDetailTitleCell * tempCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BookPreviewDetailTitleCell" forIndexPath:indexPath];
        [tempCell setupPreviewDetailInfo:self.detailModel.book];
//        if (self.isExists) {
//            tempCell.intoImageView.hidden = NO;
//        }else{
            tempCell.intoImageView.hidden = YES;
//        }
        cell = tempCell;
    }else if (indexPath.section == 1) {
        BookPreviewDetailTypeCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BookPreviewDetailTypeCell" forIndexPath:indexPath];
        [cell setupDetailType:self.detailModel.book.practiceTypes[indexPath.item] withImgDic: self.unityIconDic];
        return cell;
        
    }
    else if (indexPath.section >= 2){
        
        BookUnitModel * model = self.detailModel.book.bookUnits[indexPath.row];
        BookPreviewDirectoryCell * tempCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BookPreviewDirectoryCell" forIndexPath:indexPath];
//        BookUnitModel *children = model.children[indexPath.row];
        [tempCell setupDirectoryInfo:model];
        return tempCell;
        
    }
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize itemSize =  CGSizeZero;
    if (indexPath.section == 0) {
        itemSize = CGSizeMake(IPHONE_WIDTH, 140);
    }else if(indexPath.section == 1 ){
        
        itemSize = CGSizeMake(IPHONE_WIDTH, 48);
    }else if(indexPath.section >= 2){
        
        itemSize = CGSizeMake(IPHONE_WIDTH, 40);
    }
    return itemSize;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    BookPreviewDirectoryHeaderView * sectionView  = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"BookPreviewDirectoryHeaderView" forIndexPath:indexPath];
    if (indexPath.section == 1 && [self.detailModel.book.practiceTypes count] >0){
        sectionView.titleLabel.text = @"可布置作业类型";
    }else if (indexPath.section == 2){
        sectionView.titleLabel.text = @"目录";
    }else{
        sectionView.titleLabel.text = @"";
    }
    return sectionView;
}
    
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize itemSize = CGSizeZero;
    if (section == 0){
        itemSize = (CGSize){IPHONE_WIDTH,1};
    }else if (section == 1 && [self.detailModel.book.practiceTypes count] >0){
        itemSize = (CGSize){IPHONE_WIDTH,46};
    }else if(section == 2){
        itemSize = (CGSize){IPHONE_WIDTH,46};
    }
    return itemSize;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{

    return CGSizeZero;
}

#pragma mark --- click
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 0 && self.isExists) {
//        SubBookBookPreViewController *subBookVC = [SubBookBookPreViewController new];
//        subBookVC.detailModel = self.detailModel;
//        subBookVC.bookId = self.bookId;
//        [self pushViewController:subBookVC];
//    }
}

- (void)gotoReleaseHomework{
    if ([self.courseType isEqualToString:@"phonics_textbook"]) {
        PhonicsHomeworkViewController * bookHomeworkVC = [[PhonicsHomeworkViewController alloc]initWithBookId:self.bookId];
        [self pushViewController:bookHomeworkVC];
        return;
    }
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
