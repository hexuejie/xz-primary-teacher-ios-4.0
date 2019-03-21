//
//  YWReadDetailViewController.m
//  TeacherPro
//
//  Created by DCQ on 2018/1/18.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "YWReadDetailViewController.h"
#import "TeachingAssistantsDetailCell.h"
#import "AssistantsDetailModel.h"
#import "YWDDDetailBottomView.h"
#import "BookPreviewModel.h"
#import "ProUtils.h"
#import "YYCache.h"

NSString * const  YWReadDetailCellIdentifier = @"YWReadDetailCellIdentifier";
@interface YWReadDetailViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>
@property(nonatomic, copy) NSString  * bookId;
@property(nonatomic, copy) NSString  * unitId;
@property(nonatomic, copy) NSString * bookName;
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) UILabel *pageLabel;//显示书页
@property(nonatomic, assign) NSInteger  seletedPage;//选择的作业所在页数
@property(nonatomic, strong)  AssistantsDetailModel * detailModel;
@property(nonatomic, strong) NSMutableArray *questionSelectedAreaArray;
@property(nonatomic, strong) YWDDDetailBottomView * bottomView;
@property(nonatomic, strong) BookPreviewDetailModel * detailBookModel;
@property(nonatomic, assign) NSInteger  questionNumber;//布置的题目总数
@property(nonatomic, strong) NSArray *cacheData;
@property(nonatomic, assign) NSInteger  playTime;//音频时长
@end

@implementation YWReadDetailViewController
- (instancetype)initWithBookId:(NSString *)bookId withUnitId:(NSString *)unitId  withBookName: (NSString *)bookName withBookInfo:(id)detailBookModel withCacheData:(NSArray *)cacheData {
    if (self == [super init]) {
        self.unitId = unitId;
        self.bookName = bookName;
        self.bookId = bookId;
        self.detailBookModel = detailBookModel;
        self.cacheData = cacheData;
    }
    return self;
}
- (NSMutableArray *)questionSelectedAreaArray{
    if (!_questionSelectedAreaArray) {
        _questionSelectedAreaArray = [NSMutableArray array];
    }
    return _questionSelectedAreaArray;
}

-(UICollectionView *)collectionView{
    
    if (!_collectionView) {
        
        _collectionView = [[UICollectionView alloc] initWithFrame:[self getCollectionViewRect] collectionViewLayout:[self getLayout]];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.scrollsToTop = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.contentOffset = CGPointMake(0, 0);
        _collectionView.contentSize = CGSizeMake(3 * (self.view.frame.size.width + 20), 0);
        
    }
    return _collectionView;
}
- (CGRect)getCollectionViewRect{
    CGRect rect = CGRectMake(-10, 0, self.view.frame.size.width + 20, self.view.frame.size.height- FITSCALE(50));
     return rect;
}
- (YWDDDetailBottomView *)bottomView{
    
    if (!_bottomView) {
        
        _bottomView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([YWDDDetailBottomView class]) owner:nil options:nil].firstObject;
        
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,  self.view.frame.size.width, 0.5)];
        lineView.backgroundColor = project_line_gray;
        [_bottomView addSubview:lineView];
    }
    return _bottomView;
}
- (UILabel *)pageLabel{
    if (!_pageLabel) {
        _pageLabel = [[UILabel  alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,0)];
    }
    return _pageLabel;
}

- (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1000, 0)];
    label.text = title;
    label.font = font;
    [label sizeToFit];
    return label.frame.size.width;
}


- (UICollectionViewFlowLayout *)getLayout{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(self.view.frame.size.width + 20, self.view.frame.size.height);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    return layout;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.seletedPage = 0;
    self.title = self.bookName;
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.bottomView];
    [self configurationBottomView];
    [self configCollectionView];
    [self requestTeacherQueryJFBookUnitContent];
    [self.view addSubview:self.pageLabel];
}
- (void)confightPageLabel:(NSString *)pageStr{
    CGFloat w = [self getWidthWithTitle:pageStr font:fontSize_14] +30;
    self.pageLabel.frame = CGRectMake(20, 0, w, 30);
    self.pageLabel.textColor = UIColorFromRGB(0x6b6b6b);
    _pageLabel.textAlignment = NSTextAlignmentCenter;
    _pageLabel.backgroundColor = [UIColor clearColor];
    _pageLabel.font = fontSize_14;
    self.pageLabel.layer.masksToBounds = YES;
    self.pageLabel.layer.cornerRadius = 30/2;
    self.pageLabel.text = pageStr;
}
- (void)configurationBottomView{
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        CGFloat bottomHeight = FITSCALE(50);
         CGFloat top = self.view.frame.size.height - bottomHeight;
        make.leading.mas_equalTo(self.view.mas_leading);
        make.trailing.mas_equalTo(self.view.mas_trailing);
        make.top.mas_equalTo(@(top));
        make.height.mas_equalTo(@(bottomHeight));
        
    }];
    [self.bottomView setupButtonActivation:NO];
    self.bottomView.hidden = ![self ShowBottomView];
    WEAKSELF
    self.bottomView.sureBlock = ^{
        [weakSelf  gotoBookHomeworkVC];
    };
    
}

- (BOOL)ShowBottomView{
    return YES;
}

- (void)requestTeacherQueryJFBookUnitContent{
    [self showHUDInfoByType:HUDInfoType_Loading];
    NSDictionary * dic = nil;
    if (self.unitId) {
        dic = @{@"unitId":self.unitId};
    }
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_TeacherQueryYuwenUnitContent] parameterDic:dic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_TeacherQueryYuwenUnitContent];
    
}

- (void)setNetworkRequestStatusBlocks{
    
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_TeacherQueryYuwenUnitContent) {
            strongSelf.detailModel =  [[AssistantsDetailModel  alloc]initWithDictionary:successInfoObj error:nil];
            for (int i = 0;i< [strongSelf.detailModel.pages count];i++) {
                [strongSelf.questionSelectedAreaArray addObject:[NSMutableArray array]];
            }
            NSString * page = [NSString stringWithFormat:@"1/%ld",[strongSelf.detailModel.pages count]];
            [strongSelf confightPageLabel:page];
            if ([strongSelf.cacheData isKindOfClass:[NSArray class]]) {
                [strongSelf validationCacheData];
            }
            [strongSelf.collectionView reloadData];
        }
    }];
}

- (void)validationCacheData{
    NSArray * sections = self.cacheData.firstObject[@"sections"];
    
    //点读没块 按页分类
    NSMutableArray * pagesArray =   [self getPageArray];
    for (int i = 0;i< [pagesArray count] ; i++) {
      NSMutableArray * readArray = pagesArray[i];
        for (int j = 0 ;j < [readArray count] ;j++) {
             NSDictionary * readObj  = readArray[j];
             NSString * readId = readObj[@"readId"];
         
            if ([sections containsObject:readId ]  ) {
                NSMutableArray *  readArray = self.questionSelectedAreaArray[i];
                //解决多页显示一题 重复计算的题目的bug
                if (![self validateReadId:readId withIsSave:self.questionSelectedAreaArray]) {
                    self.questionNumber++;
                    self.playTime =  self.playTime+ [readObj[@"playTime"] integerValue];
                }
                
                [readArray addObject:readId];
            }
        }
    }
    
     [self updateBottomView];
}

- (BOOL)validateReadId:(NSString *)readId withIsSave:(NSArray *)array{
    BOOL yesOrNo = NO;
   
        for (NSArray * tempArray in array) {
            for (id tempObj in tempArray) {
                if (tempObj) {
                    if ([tempObj isEqualToString:readId]) {
                        yesOrNo = YES;
                    }
                }
            }
        }
    
    return yesOrNo;
}
- (void)configCollectionView {
    
    [self.collectionView registerClass: [TeachingAssistantsDetailCell class] forCellWithReuseIdentifier:YWReadDetailCellIdentifier];
    
}
#pragma mark - UICollectionViewDataSource && Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger  rows = [self.detailModel.pages count];
    return rows;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell * cell = nil;
    TeachingAssistantsDetailCell * tempCell = [collectionView dequeueReusableCellWithReuseIdentifier:YWReadDetailCellIdentifier forIndexPath:indexPath];
    WEAKSELF
  
    tempCell.singleYWDDTapGestureBlock = ^(NSString *unitId, NSString *readId, NSIndexPath *indexPath) {
        if ([self isChangeSelectedItem]) {
            weakSelf.seletedPage = indexPath.row;
            [weakSelf selectedRead:readId  withPage:indexPath.row];
            [weakSelf.collectionView reloadData];
        }
    };
 
     [tempCell setupChangeSeleted:[self isChangeSelectedItem]];
    
    tempCell.indexPath = indexPath;
    AssistantsPagesModel * pagesModel = self.detailModel.pages[indexPath.item];
    tempCell.currentPage = [pagesModel.page intValue];
    [tempCell setupModel:self.detailModel withSelectedData:self.questionSelectedAreaArray];
    cell = tempCell;
    return cell;
}
- (BOOL)isChangeSelectedItem{
    return YES;
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[TeachingAssistantsDetailCell class]]) {
        [(TeachingAssistantsDetailCell *)cell recoverSubviews];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[TeachingAssistantsDetailCell class]]) {
        [(TeachingAssistantsDetailCell *)cell recoverSubviews];
    }
}



#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offSetWidth = scrollView.contentOffset.x;
    offSetWidth = offSetWidth +  ((self.view.frame.size.width + 20) * 0.5);
    
    NSInteger currentIndex = offSetWidth / (self.view.frame.size.width + 20);
    NSString * page = [NSString stringWithFormat:@"%ld/%ld",currentIndex+1,[self.detailModel.pages count]];
    [self confightPageLabel:page];
 
    
}
- (NSMutableArray *)getPageArray{
    //点读没块 按页分类
    NSMutableArray * pagesArray = [NSMutableArray array];
    for (int i = 0; i < [self.detailModel.pages count]; i++) {
        AssistantsPagesModel * pages = self.detailModel.pages[i];
        NSMutableArray * readIdArray = [NSMutableArray array];
        for (int j = 0;j< [self.detailModel.reads count] ; j++) {
            YWDDQuestionsModel * model = self.detailModel.reads[j];
            if([model.page isEqualToString:pages.page]){
                [readIdArray addObject:@{@"readId":model.id,@"playTime":model.playTime}];
            }
        }
        [pagesArray addObject:readIdArray];
    }
    
    return pagesArray;
}
- (void)selectedRead:(NSString *)readId  withPage:(NSInteger)page{
    //解决多页显示一题只显示当前页点中区域 其它页不显示的  bug
    NSString * selectedReadId  = readId;
    
    NSArray * pageArray = [self getPageArray];
    NSMutableArray * samePageReadId = [NSMutableArray array];
    for (int i = 0;i< [pageArray count] ;i++) {
        NSArray *  tempArray = pageArray[i];
        for (int j = 0;j < [tempArray count];j++) {
             NSDictionary * obj = tempArray[j];
            if ([readId isEqualToString:obj[@"readId"]]) {
                [samePageReadId addObject:@(i)];
            }
        }
    }
    
    __block BOOL isAdd = NO;
    [self.questionSelectedAreaArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        for (NSNumber * sections in samePageReadId) {
            if (idx == [sections integerValue]) {
                if (![obj containsObject:selectedReadId]) {
                    NSMutableArray *array  = obj;
                    [array addObject:selectedReadId];
                    isAdd = YES;
                }else{
                    NSMutableArray *array  = obj;
                    [array removeObject:readId];
                    [self deleteSaveData];
                }
            }
        }
   
       
    }];
    
    NSArray * reads = self.detailModel.reads;
    AssistantsPagesModel * pageModel = self.detailModel.pages[self.seletedPage];
    __block YWDDQuestionsModel * ywddModel = nil;
    [reads enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        YWDDQuestionsModel * tempObj = obj;
        if([pageModel.page isEqualToString:tempObj.page]){
             ywddModel = tempObj;
        }
    }];
    
    if (isAdd ) {
        self.questionNumber++;
        self.playTime = self.playTime + [ywddModel.playTime integerValue];
    }else{
        self.questionNumber--;
         self.playTime = self.playTime - [ywddModel.playTime integerValue];
    }

    [self updateBottomView];
}
- (void)updateBottomView{
    NSString * timer = [self timeFormatted:self.playTime ];
    [self setupBottomViewTimer:timer];
}
//毫秒转化为时间
- (NSString *)timeFormatted:(NSInteger )time
{
    NSString * str = @"";
    //毫秒
    NSInteger ms  = time  ;
     NSInteger totalSeconds = ms/1000;
 
    NSInteger minutes = (totalSeconds / 60) % 60;
    if (minutes < 1) {
        str = @"预计1分钟完成";
    }else if (minutes>60){
        str = @"预计1个小时以上完成";
    }else{
         str =[NSString stringWithFormat:@"预计%ld分钟完成",minutes];
    }
    
    return  str;
}
- (void)setupBottomViewTimer:(NSString *)timer{
    BOOL enabled = NO;
    if (self.questionNumber == 0) {
        enabled = NO;
    }else{
        enabled = YES;
    }
    [self.bottomView setupButtonActivation:enabled];
    NSString * questionStr = [NSString  stringWithFormat:@"%ld",self.questionNumber];
    
    [self.bottomView setupTitleNumber:questionStr withTimer:timer];
    
}
- (void)deleteSaveData{
    
    
}


- (void)gotoBookHomeworkVC{
    
 
    NSMutableArray *sections = [NSMutableArray array];
    [self.questionSelectedAreaArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![sections containsObject:obj]) {
                [sections addObject: obj];
            }
        }];
    }];
    NSDictionary * ywddDic ;
    NSInteger appCount = 0;
    if ([sections count] > 0) {
        ywddDic = @{@"unitId":self.unitId,@"sections":sections};
        appCount  = [sections count] +appCount;
    }
   
    NSArray * ywdArray = @[];
    if (ywddDic) {
        ywdArray = @[ywddDic,@(appCount)];
    }
    YYCache *cache = [YYCache cacheWithName:HOMEWORK_CONTENT_PATH];
    cache.memoryCache.shouldRemoveAllObjectsOnMemoryWarning = YES;
    cache.memoryCache.shouldRemoveAllObjectsWhenEnteringBackground = YES;
    [cache setObject:ywdArray forKey:YWDD_PRACTICE_MEMORY_KEY];
    
    
    NSInteger index = [self.navigationController.viewControllers count] - 3;
    
    [self.navigationController popToViewController:self.navigationController.viewControllers[index] animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
