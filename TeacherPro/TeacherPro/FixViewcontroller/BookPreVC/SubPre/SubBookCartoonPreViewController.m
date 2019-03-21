//
//  SubBookCartoonPreViewController.m
//  TeacherPro
//
//  Created by 何学杰 on 2018/12/5.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "SubBookCartoonPreViewController.h"
#import "XJRepositoryTipsView.h"

@interface SubBookCartoonPreViewController ()
@end

@implementation SubBookCartoonPreViewController

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
    
//    [self requestQueryBook];
    self.unityIconDic = [ProUtils getHomworkDetailUnitIconDic];
    [self setNavigationItemTitle:@"预览"];
    [self.view addSubview:self.mongoliaView];
    [self.view addSubview:self.circleView];
    
    self.collectionView.bounces = YES;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = project_background_gray;
    self.collectionView.frame = CGRectMake(0, 0, IPHONE_WIDTH, self.view.frame.size.height-64);
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
    
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BookPreviewDetailTypeCell class]) bundle:nil] forCellWithReuseIdentifier:@"BookPreviewDetailTypeCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BookPreviewDetailTitleCell class]) bundle:nil] forCellWithReuseIdentifier:@"BookPreviewDetailTitleCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BookPreCartoonHeader class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BookPreCartoonHeader"];
    
    [self.collectionView registerClass:[UICollectionReusableView class]  forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionElementKindSectionFooter" ];
    [self.collectionView registerClass:[UICollectionReusableView class]  forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionElementKindheader" ];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CartoonProfilePreviewCell class]) bundle:nil] forCellWithReuseIdentifier:@"CartoonProfilePreviewCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CartoonPreviewDirectoryPlayCell  class]) bundle:nil] forCellWithReuseIdentifier:@"CartoonPreviewDirectoryPlayCell"];
}

#pragma mark --- 请求接口
- (void)requestQueryBook{
    
    NSDictionary *parameterDic =nil;
    if (self.bookId) {
        parameterDic  = @{@"bookId":self.bookId,@"getUnit":@"true",@"bookType":BookTypeCartoon};
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
            
            strongSelf.playCartoonBookArray = pagesArray;
            PreviewPictureBookAudioViewController * previewPBAVC = [[PreviewPictureBookAudioViewController alloc]initWithName:strongSelf.detailModel.book.name withData:strongSelf.playCartoonBookArray];
            [strongSelf pushViewController:previewPBAVC];
        }
        
    }];
}

- (void)requestQueryCartoonPages:(NSString *)bookId{
    
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_QueryCartoonPages] parameterDic:@{@"bookId":bookId} requestMethodType:RequestMethodType_POST requestTag:NetRequestType_QueryCartoonPages];
}

- (void)screeningCartoon:(NSArray *)pagesArray{
    if (pagesArray.count > 0) {
        for (int i = 0; i <[pagesArray  count]; i++) {
            NSDictionary *pageDic = pagesArray[i];
            NSArray * sentences = pageDic[@"sentences"];
            for (int j = 0; j< [sentences count]; j++) {
                NSDictionary * sectenceDic = sentences[j];
                NSString * audioUrl = sectenceDic[@"voice"];
                //翻译
                NSString * cn = sectenceDic[@"cn"];
                //原文
                NSString * en = sectenceDic[@"en"];
                //url 音频播放地址  page 当前页   number 当前页的第几局
                NSDictionary * dic =  @{@"page":@(i+1),@"nubmer":@(j+1),@"url":audioUrl,@"cn":cn,@"en":en};
                [self.cartoonBookDownloadUrlArray addObject:dic];
                
            }
            [self.cartoonBookImgArray addObject:pageDic[@"image"]];
            if (!sentences ||(sentences && sentences== 0)) {
                NSString * content = [NSString stringWithFormat:@"第%zd页,音频资源下载失败",i+1];
                [self showAlert:TNOperationState_Fail content:content];
                return ;
            }
        }
    }
    if ([self.cartoonBookDownloadUrlArray count]>0) {
        
        self.currentDownPage = 0;
        NSString *urlSr = self.cartoonBookDownloadUrlArray.firstObject[@"url"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.circleView.progress = 0;
            self.circleView.hidden = NO;
            self.mongoliaView.hidden = NO;
        });
        [self downLoadAudio:urlSr];
    }
}

#pragma mark --- delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 4;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
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
        return 0;
    }else{
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    if (indexPath.section == 0) {

    }else if (indexPath.section == 1) {
        CartoonProfilePreviewCell * tempCell =  [collectionView dequeueReusableCellWithReuseIdentifier:@"CartoonProfilePreviewCell" forIndexPath:indexPath];
        [tempCell setupDetailName:self.detailModel.book.intro];
        cell = tempCell;
    }else if (indexPath.section == 2) {
        CartoonPreviewDirectoryPlayCell * tempCell =  [collectionView dequeueReusableCellWithReuseIdentifier:@"CartoonPreviewDirectoryPlayCell" forIndexPath:indexPath];
        [tempCell setupImageUrl:self.detailModel.book.coverImage];
        cell = tempCell;
    }else if (indexPath.section == 3){// 绘本下面的项  可布置类型
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize itemSize =  CGSizeZero;
    if (indexPath.section == 0) {
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
            [self.detailModel.book.intro isEqualToString:@""]   ) {
            headerView.titlelLabel.text = @"";
        }
        headerView.titlelLabel.text = @"简介";
    }else if (indexPath.section == 2 ) {
        if (self.detailModel.book.coverImage == nil    ) {
            headerView.titlelLabel.text = @"";
        }
        headerView.titlelLabel.text = @"绘本预览";
    }else if(indexPath.section == 3 && [self.detailModel.book.practiceTypes count] >0) {

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

        }else if (section == 1 &&
                  self.detailModel.book.intro != nil &&
                  ![self.detailModel.book.intro isEqualToString:@""]){
            itemSize = (CGSize){IPHONE_WIDTH,40};
        }else if (section == 2 && self.detailModel.book.coverImage != nil) {
            itemSize = (CGSize){IPHONE_WIDTH,40};
        }else if(section == 3 && [self.detailModel.book.practiceTypes count] >0){
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
    if (indexPath.section == 2 &&[self.detailModel.book.bookType isEqualToString:BookTypeCartoon]) {
        [self requestQueryCartoonPages:self.bookId];
    }
}

- (void)gotoReleaseHomework{
    BookHomeworkViewController * bookHomeworkVC = [[BookHomeworkViewController alloc]initWithBookId:self.bookId withBookType:BookTypeCartoon withClear:YES];//备注
    [self pushViewController:bookHomeworkVC];
}

- (void)gotoPictureBookAudioVC{
    PreviewPictureBookAudioViewController * previewPBAVC = [[PreviewPictureBookAudioViewController alloc]initWithName:self.detailModel.book.name withData:self.playCartoonBookArray];
    [self pushViewController:previewPBAVC];
}

#pragma mark --- 下载
- (void)downLoadAudio:(NSString *)audioURLStr{
    
    WEAKSELF
    //    strongSelf.downIndex ++;
    [[HSDownloadManager sharedInstance] download:audioURLStr progress:^(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    } state:^(DownloadState state,NSString *url) {
        STRONGSELF
        if (state == DownloadStateCompleted) {
            
            for (int i = 0; i< [strongSelf.cartoonBookDownloadUrlArray count]; i++) {
                NSDictionary * dic = strongSelf.cartoonBookDownloadUrlArray[i];
                if ([url isEqualToString:dic[@"url"]]) {
                    [strongSelf setupDownloadIndex: i+1 withDownFilePath:[[HSDownloadManager sharedInstance] getFileAudioPath:url]];
                    if (i == [strongSelf.cartoonBookDownloadUrlArray count]-1) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [strongSelf gotoPictureBookAudioVC];
                            strongSelf.circleView.progress = 1.00;
                            strongSelf.circleView.hidden = YES;
                            self.mongoliaView.hidden = YES;
                        });
                        
                    }else{
                        
                        float download = (float)(i+1)/(float)[strongSelf.cartoonBookDownloadUrlArray count];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            strongSelf.circleView.progress = download;
                            strongSelf.circleView.hidden = NO;
                            self.mongoliaView.hidden = NO;
                        });
                        
                        [strongSelf downLoadAudio:strongSelf.cartoonBookDownloadUrlArray[i+1][@"url"]];
                        
                    }
                }
                
            }
        }
    }];
    
}

- (void)setupDownloadIndex:(NSInteger )downloadIndex withDownFilePath:(NSString *)filePath{
    
    WEAKSELF
    STRONGSELF
    if (downloadIndex -1 == 0) {
        strongSelf.currentDownPage ++;
        NSDictionary * currentDic= strongSelf.cartoonBookDownloadUrlArray[downloadIndex -1];
        NSMutableDictionary * tempDic =  [[NSMutableDictionary alloc]initWithDictionary:currentDic];
        //修改为本地播放地址
        [tempDic setObject:filePath forKey:@"url"];
        
        NSMutableArray * tempArray =  [[NSMutableArray alloc]initWithObjects:tempDic, nil];
        NSDictionary * pageDic = @{@"image":strongSelf.cartoonBookImgArray[downloadIndex -1],@"section":tempArray};
        [strongSelf.playCartoonBookArray addObject: pageDic];
        
    }else{
        //
        NSDictionary * currentDic = strongSelf.cartoonBookDownloadUrlArray[downloadIndex -1];
        //前一条
        NSDictionary * preDic= strongSelf.cartoonBookDownloadUrlArray[downloadIndex -2];
        NSMutableDictionary * tempDic =  [[NSMutableDictionary alloc]initWithDictionary:currentDic];
        //修改为本地播放地址
        [tempDic setObject:filePath forKey:@"url"];
        //在同一页
        if ( [currentDic[@"page"] integerValue] == [preDic[@"page"] integerValue]) {
            
            NSMutableDictionary * pageDic  = [NSMutableDictionary dictionary];
            
            [pageDic addEntriesFromDictionary: strongSelf.playCartoonBookArray[[currentDic[@"page"] integerValue]-1]];
            
            NSMutableArray *currentPageArray =[[NSMutableArray alloc]initWithArray: pageDic[@"section"]];
            [currentPageArray addObject:tempDic];
            [pageDic setObject:currentPageArray forKey:@"section"];
            NSInteger index = [currentDic[@"page"] integerValue]-1;
            [strongSelf.playCartoonBookArray replaceObjectAtIndex:index  withObject:pageDic];
            
        }else{
            strongSelf.currentDownPage ++;
            NSMutableArray *currentPageArray = [NSMutableArray array];
            [currentPageArray addObject:tempDic];
            
            NSDictionary * pageDic = @{@"image":strongSelf.cartoonBookImgArray[strongSelf.currentDownPage -1],@"section":currentPageArray};
            [strongSelf.playCartoonBookArray addObject: pageDic];
            
        }
        
    }
    
    //下载完成后 进行下一个任务
    if ( downloadIndex < strongSelf.cartoonBookDownloadUrlArray.count) {
        
        
    }else{
        
    }
    
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
