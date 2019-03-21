
//
//  BookPreviewDetailViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/9/5.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BookPreviewDetailViewController.h"
#import "SubBookCartoonPreViewController.h"

NSString * const BookPreviewDirectoryTwoCellIdentifier = @"BookPreviewDirectoryTwoCellIdentifier";
NSString * const BookPreviewDetailTitleCellIdentifier = @"BookPreviewDetailTitleCellIdentifier";
NSString * const BookPreviewDetailTypeCellIdentifier = @"BookPreviewDetailTypeCellIdentifier";


NSString * const CartoonPreviewDirectoryPlayCellIdentifier = @"CartoonPreviewDirectoryPlayCellIdentifier";
NSString * const CartoonProfilePreviewCellIdentifier = @"CartoonProfilePreviewCellIdentifier";

@interface BookPreviewDetailViewController ()
@end

@implementation BookPreviewDetailViewController

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


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self navUIBarBackground:8];
}

- (void)uploadeView{

    [self.bottomView.addButton removeTarget:nil
                                     action:NULL
                           forControlEvents:UIControlEventAllEvents];
    if (self.isExists) {
        
        [self setNavigationItemTitle:@"书本作业"];
        [self.bottomView.addButton setTitle:@"去布置" forState:UIControlStateNormal];
        [self.bottomView.addButton addTarget:self action:@selector(gotoReleaseHomework) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [self.bottomView.addButton setTitle:@"加入书架" forState:UIControlStateNormal];
        [self.bottomView.addButton addTarget:self action:@selector(requestAddBookcase) forControlEvents:UIControlEventTouchUpInside];
        [self setNavigationItemTitle:@"书本预览"];
    }
    
    self.bottomView.hidden = NO;
    self.collectionView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - bottomViewHeight);
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self requestQueryBook];
    self.unityIconDic = [ProUtils getHomworkDetailUnitIconDic];
  
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.mongoliaView];
    [self.view addSubview:self.circleView];
    
   
    [self uploadeView];
     self.collectionView.bounces = YES;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = project_background_gray;
    
}

//蒙层
- (UIView *)mongoliaView{
    if (!_mongoliaView) {
        _mongoliaView = [[UIView alloc] initWithFrame:self.view.frame];
        _mongoliaView.alpha = 0.5;
        _mongoliaView.hidden = YES;
        _mongoliaView.backgroundColor = [UIColor blackColor];
    }
    return _mongoliaView;
}
- (HWCircleView *)circleView{
    if (!_circleView) {
        _circleView = [[HWCircleView alloc] initWithFrame:CGRectMake(0,0, 150, 150)];
        _circleView.hidden = YES;
       _circleView.center = self.view.center;
    }
    return _circleView;
}

- (void)registerCell{
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BookPreviewDirectoryCell class]) bundle:nil] forCellWithReuseIdentifier:BookPreviewDirectoryTwoCellIdentifier];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BookPreviewDetailTypeCell class]) bundle:nil] forCellWithReuseIdentifier:BookPreviewDetailTypeCellIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BookPreviewDetailTitleCell class]) bundle:nil] forCellWithReuseIdentifier:BookPreviewDetailTitleCellIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BookPreCartoonHeader class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BookPreCartoonHeader"];
    
    [self.collectionView registerClass:[UICollectionReusableView class]  forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionElementKindSectionFooter" ];
    [self.collectionView registerClass:[UICollectionReusableView class]  forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionElementKindheader" ];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CartoonProfilePreviewCell class]) bundle:nil] forCellWithReuseIdentifier:CartoonProfilePreviewCellIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CartoonPreviewDirectoryPlayCell  class]) bundle:nil] forCellWithReuseIdentifier:CartoonPreviewDirectoryPlayCellIdentifier];
}

- (UIView *)bottomView{
    if (!_bottomView) {
        
        _bottomView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ReleaseAddBookworkCell class]) owner:nil options:nil].firstObject;
        _bottomView.frame = CGRectMake(0, self.view.frame.size.height -bottomViewHeight -44 ,self.view.frame.size.width, bottomViewHeight);
        _bottomView.backgroundColor = [UIColor whiteColor];
        [_bottomView.addButton setTitle:@"布置作业" forState:UIControlStateNormal];
        _bottomView.delegate = self;
        
        if (kScreenWidth == 375&&kScreenHeight>667){
            _bottomView.frame = CGRectMake(0, self.view.frame.size.height -bottomViewHeight -44-18,self.view.frame.size.width, bottomViewHeight);
        }
        [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.equalTo(self.view);
            make.bottom.equalTo(_bottomView.mas_top);
        }];
    }
    return _bottomView;
}

#pragma mark --- 请求接口
- (void)requestQueryBook{

    NSDictionary *parameterDic =nil;
    if (self.bookId) {
        parameterDic  = @{@"bookId":self.bookId,@"getUnit":@"true",@"bookType":BookTypeCartoon};
    }
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_QueryBookById] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_QueryBookById];
}
- (void)requestAddBookcase{
    if (self.isExists) {
        return;
    }
    NSDictionary *parameterDic =nil;
    if (self.bookId) {
        parameterDic  = @{@"bookId":self.bookId,@"getUnit":@"true",@"bookType":BookTypeCartoon};
    }
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_TeacherAddBookToBookShelf] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_TeacherAddBookToBookShelf];
    
}
- (void)requestQueryCartoonPages:(NSString *)bookId{
//    bookId = @"cd0e85e8-ea65-4b3f-ae55-679d00049894";
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_QueryCartoonPages] parameterDic:@{@"bookId":bookId} requestMethodType:RequestMethodType_POST requestTag:NetRequestType_QueryCartoonPages];
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
            [strongSelf uploadeView];
            
            [strongSelf.collectionView reloadData];
           
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
            NSLog(@"加入成功");
        }else if (request.tag == NetRequestType_QueryCartoonPages) {
            NSArray * pagesArray = successInfoObj[@"pages"];
           
//            [strongSelf.cartoonBookDownloadUrlArray  removeAllObjects];
//            [strongSelf.playCartoonBookArray removeAllObjects];
//            [strongSelf.cartoonBookImgArray removeAllObjects];
//            [strongSelf screeningCartoon:pagesArray];
            
            strongSelf.playCartoonBookArray = pagesArray;
            PreviewPictureBookAudioViewController * previewPBAVC = [[PreviewPictureBookAudioViewController alloc]initWithName:strongSelf.detailModel.book.name withData:strongSelf.playCartoonBookArray];
            [strongSelf pushViewController:previewPBAVC];
            
        }
    }];
}

- (void)gotoBookcaseVC{
 
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_BOOKCASE" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_HOME_BOOKCASE_LIST" object:nil];
}
#pragma mark --- delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (self.detailModel == nil) {
        return 0;
    }
    return 4;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1){///简介
        if (self.detailModel.book.intro == nil ||
            [self.detailModel.book.intro isEqualToString:@""]   || self.isExists) {
            return 0;
        }
        return 1;
    }else if (section == 2){///预览
        if (self.detailModel.book.coverImage == nil     || self.isExists) {
            return 0;
        }
        return 1;
    }else  if (section == 3){///绘本后面的项
        return [self.detailModel.book.practiceTypes count];
    }else{
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = nil;
    if (indexPath.section == 0) {
    //绘本预览头部
        BookPreviewDetailTitleCell * tempCell = [collectionView dequeueReusableCellWithReuseIdentifier:BookPreviewDetailTitleCellIdentifier forIndexPath:indexPath];
        [tempCell setupPreviewDetailInfo:self.detailModel.book];
        if (self.isExists) {
            tempCell.intoImageView.hidden = NO;
        }else{
            tempCell.intoImageView.hidden = YES;
        }
        cell = tempCell;
    }else if (indexPath.section == 1) {
        CartoonProfilePreviewCell * tempCell =  [collectionView dequeueReusableCellWithReuseIdentifier:CartoonProfilePreviewCellIdentifier forIndexPath:indexPath];
        [tempCell setupDetailName:self.detailModel.book.intro];
        cell = tempCell;
    }else if (indexPath.section == 2) {
        CartoonPreviewDirectoryPlayCell * tempCell =  [collectionView dequeueReusableCellWithReuseIdentifier:CartoonPreviewDirectoryPlayCellIdentifier forIndexPath:indexPath];
        [tempCell setupImageUrl:self.detailModel.book.coverImage];
        cell = tempCell;
    }else if (indexPath.section == 3){// 绘本下面的项  可布置类型
        
        BookPreviewDetailTypeCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:BookPreviewDetailTypeCellIdentifier forIndexPath:indexPath];
        [cell setupDetailType:self.detailModel.book.practiceTypes[indexPath.item] withImgDic: self.unityIconDic];
        return cell;
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize itemSize =  CGSizeZero;
    if (indexPath.section == 0) {
        itemSize = CGSizeMake(IPHONE_WIDTH, 140);
    }else if (indexPath.section == 1) {// 绘本intro 高度计算
        if (self.detailModel.book.intro == nil ||
            [self.detailModel.book.intro isEqualToString:@""]      || self.isExists) {
            return CGSizeMake(IPHONE_WIDTH, 0);
        }
        CGFloat infoTextHeight = [ProUtils heightForString:self.detailModel.book.intro andWidth:IPHONE_WIDTH-16];
        itemSize = CGSizeMake(IPHONE_WIDTH, infoTextHeight + 16);
        
    }else if(indexPath.section == 2){
        
        if (self.detailModel.book.coverImage == nil       || self.isExists) {
            return CGSizeMake(IPHONE_WIDTH, 0);
        }
        itemSize = CGSizeMake(IPHONE_WIDTH, IPHONE_WIDTH*0.56 +16);
        
    }else if(indexPath.section == 3){
        itemSize = CGSizeMake(IPHONE_WIDTH, 48);
    }
    return itemSize;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    BookPreCartoonHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"BookPreCartoonHeader" forIndexPath:indexPath];
    headerView.titlelLabel.text = @"";
    if (indexPath.section == 0){
    }else if (indexPath.section == 1){
        if (self.detailModel.book.intro == nil ||
            [self.detailModel.book.intro isEqualToString:@""]      || self.isExists) {
            headerView.titlelLabel.text = @"";
        }
        headerView.titlelLabel.text = @"简介";
    }else if (indexPath.section == 2 ) {
        if (self.detailModel.book.coverImage == nil       || self.isExists) {
            headerView.titlelLabel.text = @"";
        }
        headerView.titlelLabel.text = @"绘本预览";
    }else if(indexPath.section == 3 && [self.detailModel.book.practiceTypes count] >0) {
        headerView.titlelLabel.text = @"可布置作业类型";
    }
    return headerView;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize itemSize = CGSizeZero;
    if (self.isExists &&(section == 1||section == 2)) {
        return itemSize;
    }else{
        if (section == 0){
            itemSize = (CGSize){IPHONE_WIDTH,0.01};
        }else if (section == 1 &&
                  self.detailModel.book.intro != nil &&
                  ![self.detailModel.book.intro isEqualToString:@""]){
            itemSize = (CGSize){IPHONE_WIDTH,40};
        }else if (section == 2 && self.detailModel.book.coverImage != nil) {
            itemSize = (CGSize){IPHONE_WIDTH,40};
        }else if(section == 3 && [self.detailModel.book.practiceTypes count] >0){
            itemSize = (CGSize){IPHONE_WIDTH,40};
        }
    }
    return itemSize;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{

    return CGSizeZero;
}

#pragma mark --- click
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && self.isExists) {
        SubBookCartoonPreViewController *subBookVC = [SubBookCartoonPreViewController new];
        subBookVC.detailModel = self.detailModel;
        subBookVC.bookId = self.bookId;
        [self pushViewController:subBookVC];
    }else
     if (indexPath.section == 2 &&[self.detailModel.book.bookType isEqualToString:BookTypeCartoon]) {
        [self requestQueryCartoonPages:self.bookId];
    }
}

- (void)gotoReleaseHomework{
    BookHomeworkViewController * bookHomeworkVC = [[BookHomeworkViewController alloc]initWithBookId:self.bookId withBookType:BookTypeCartoon withClear:YES];
    [self pushViewController:bookHomeworkVC];
}

- (NSMutableArray *)playCartoonBookArray{
    
    if (!_playCartoonBookArray) {
        _playCartoonBookArray = [[NSMutableArray alloc]init];
    }
    return _playCartoonBookArray;
}

- (NSMutableArray *)cartoonBookImgArray{
    if (!_cartoonBookImgArray) {
        _cartoonBookImgArray = [[NSMutableArray alloc]init];
    }
    return _cartoonBookImgArray;
}
- (NSMutableArray *)cartoonBookDownloadUrlArray{
    
    if (!_cartoonBookDownloadUrlArray ) {
        _cartoonBookDownloadUrlArray = [[NSMutableArray alloc]init];
    }
    return _cartoonBookDownloadUrlArray;
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
