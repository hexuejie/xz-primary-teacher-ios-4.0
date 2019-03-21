//
//  RepositoryViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/9/5.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "RepositoryViewController.h"
#import "RespositoryHeaderTagView.h"
#import "RespositoryMenuView.h"
#import "JFBookPreviewViewController.h"
#import "BookBookPreDetailViewController.h"
#import "BookHomeworkViewController.h"
#import "PhonicsHomeworkViewController.h"
#import "AssistantsHomeworkViewController.h"

NSString * const ReposityoryCellIdentifier = @"ReposityoryCellIdentifier";
NSString * const RepositoryBannerCellIdentifier = @"RepositoryBannerCellIdentifier";
NSString * const RepositorySectionViewIdentifier = @"RepositorySectionViewIdentifier";
NSString * const RepositoryTitleCellIdentifier = @"RepositoryTitleCellIdentifier";
NSString * const RepositoryEmptyCellIdentifier = @"RepositoryEmptyCellIdentifier";

@interface RepositoryViewController ()<RespositoryHeaderTagViewDelegate,RespositoryMenuViewDelegate>

@property (nonatomic, strong) RespositoryHeaderTagView *tagView;
@property (nonatomic, strong) RespositoryMenuView *muneView;
@end

@implementation RepositoryViewController
- (instancetype)initWithFromHome:(BOOL)isHome{
    self = [super init];
    if(self){
        self.isHome = isHome;
    }
    return self;
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self navUIBarBackground:0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.automaticallyAdjustsScrollViewInsets = YES;
    self.pageCount = 12;
    [self requestListBooks];
    self.selectedScreeningtType = -1;
    
    
    CGFloat collectionHeight = 40 +44+64;
    
    [self.view addSubview:self.tagView];
    self.collectionView.frame = CGRectMake(0, 40, kScreenWidth, kScreenHeight-collectionHeight);
//    self.view.backgroundColor = [UIColor greenColor];
    self.tagView.tagLabel.text = @"全部";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationCenterRefesh) name:@"UPDATE_BOOKCASE" object:nil];
    
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)notificationCenterRefesh{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.currentPageNo = 0;
        [self.listModel.list removeAllObjects];
        [self requestListBooks];
    });
}

- (RespositoryHeaderTagView *)tagView{
    
    if (!_tagView) {
        _tagView = [[RespositoryHeaderTagView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        _tagView.backgroundColor = HexRGB(0xF6F6F8);
        _tagView.delegate = self;
        if ([self.bookType isEqualToString:BookTypePhonics]) {
            _tagView.queryButton.hidden = YES;
        }
    }
    return _tagView;
}

- (RespositoryMenuView *)muneView{
    
    if (!_muneView) {
        _muneView = [[RespositoryMenuView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _muneView.delegate = self;
    }
    return _muneView;
}

- (void)eespositoryHeaderClick:(RespositoryHeaderTagView *)tagView{
    self.muneView.bookQueryModel = _bookQueryModel;
    self.muneView.cartoonQueryModel = _cartoonQueryModel;
    [[UIApplication sharedApplication].keyWindow addSubview:self.muneView];
    [self.muneView beginShowMenuView];
}

- (void)respositoryMenuViewClose:(RespositoryMenuView *)tagView{
    [self.muneView removeFromSuperview];
}


- (BOOL)isAddRefreshFooter{
    return YES;
}

- (void)registerCell{
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([RepositoryCell class]) bundle:nil] forCellWithReuseIdentifier:ReposityoryCellIdentifier];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([RepositoryEmptyCell class]) bundle:nil] forCellWithReuseIdentifier:RepositoryEmptyCellIdentifier];
}

- (UICollectionViewLayout *)getCollectionViewLayout{
    UICollectionViewLayout * collectionViewLayout ;
    PlainFlowLayout * plainFlowLayout = [[PlainFlowLayout alloc]init];
    plainFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    plainFlowLayout.naviHeight = 0.0f;
    collectionViewLayout = plainFlowLayout;
    
    return collectionViewLayout;
}


- (void)getLoadMoreCollectionViewNetworkData{
   [self requestListBooks];
}

- (NSInteger )getNetworkCollectionViewDataCount{
    return [self.listModel.list count];
}

- (void)setBookQueryModel:(BookQueryModel *)bookQueryModel{
    _bookQueryModel = bookQueryModel;
    if (_bookQueryModel != nil) {
        self.muneView.bookQueryModel = _bookQueryModel;
    }
}

- (void)setCartoonQueryModel:(CartoonQueryModel *)cartoonQueryModel{
    _cartoonQueryModel = cartoonQueryModel;
    if (_cartoonQueryModel != nil) {
        self.muneView.cartoonQueryModel = _cartoonQueryModel;
    }
}

- (void)respositoryMenuViewFinish:(RespositoryMenuView *)tagView{
    
    self.grade = [NSString stringWithFormat:@"%ld",tagView.gradeModel.grade];
    
    if ([self.bookType isEqualToString:BookTypeBook] ) {
        
        self.publisherId = tagView.publisherModel.publisherId;
    }else if([self.bookType isEqualToString:BookTypeCartoon]){
        
        self.level = tagView.levelModel.level;
    }
    self.currentPageNo = 0;
    [self.listModel.list removeAllObjects];
    [self requestListBooks];
    
    NSString *tagString ;
    if (tagView.gradeModel.gradeName) {
        tagString = [NSString stringWithFormat:@"%@",tagView.gradeModel.gradeName];
    }
    if (self.publisherId&& ![self.publisherId isEqualToString:@""]) {
        if (tagString == nil) {
            tagString = [NSString stringWithFormat:@"%@",tagView.publisherModel.publisherName];
        }else{
            tagString = [NSString stringWithFormat:@"%@/%@",tagString,tagView.publisherModel.publisherName];
        }
    }
    if (self.level&& ![self.level isEqualToString:@""]) {
        if (tagString == nil) {
            tagString = [NSString stringWithFormat:@"级别%@",self.level];
        }else{
            tagString = [NSString stringWithFormat:@"%@/级别%@",tagString,self.level];
        }
    }
    if (tagString == nil) {
        tagString  = @"全部";
    }
    self.tagView.tagLabel.text = tagString;
}
#pragma mark ---
- (void)requestListBooks{
    
    NSMutableDictionary * parameterDic =[NSMutableDictionary dictionary];
    [parameterDic addEntriesFromDictionary: @{@"pageIndex":@(self.currentPageNo),
                                              @"pageSize":@(self.pageCount)
                                              }];
    [parameterDic addEntriesFromDictionary: @{
//                                              @"bookType":@"Phonics",
                                              @"subjectId":@"003"
                                              }];/////////  Phonics自然拼图  默认是Book
////    [parameterDic addEntriesFromDictionary: @{@"grade":@"3",
////                                              }];
    
    if (self.grade && ![self.grade isEqualToString:@""] && ![self.grade isEqualToString:@"0"]) {
        if ([self.bookType isEqualToString:BookTypeBook]) {
            [parameterDic addEntriesFromDictionary: @{@"grade":self.grade,
                                                      }];
        }
    }
    if (self.level) {
        [parameterDic addEntriesFromDictionary: @{@"level":self.level,
                                                  }];
    }
    if (self.bookType) {
        [parameterDic addEntriesFromDictionary: @{@"bookType":self.bookType,
                                                  }];
    }
    
    if (self.publisherId&& ![self.publisherId isEqualToString:@""]) {
        [parameterDic addEntriesFromDictionary: @{@"publisherId":self.publisherId,
                                                  }];
    }
    
    //书本列表请求
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_ListBooks] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_ListBooks];
    
}
- (void)requestQueryBookFilterDic{
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_QueryBookFilterDic] parameterDic:nil requestMethodType:RequestMethodType_POST requestTag:NetRequestType_QueryBookFilterDic];
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
//                [strongSelf.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
            }
            strongSelf.collectionView.mj_footer.hidden = NO;
        }else if (request.tag == NetRequestType_QueryBookFilterDic){
        
//            [strongSelf confitgFilterDic:successInfoObj];
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

#pragma mark ---
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.listModel == nil) {
        return 0;
    }
    if (self.listModel.list.count >0) {
        return [self.listModel.list count];
    }else{
        return 1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.listModel.list count]  >0) {
        RepositoryCell * tempCell = [collectionView dequeueReusableCellWithReuseIdentifier:ReposityoryCellIdentifier forIndexPath:indexPath];
        [tempCell setupRepositoryInfo:self.listModel.list[indexPath.item]];
        return tempCell;
    }else{
        RepositoryEmptyCell * tempCell = [collectionView dequeueReusableCellWithReuseIdentifier:RepositoryEmptyCellIdentifier forIndexPath:indexPath];
        
        return tempCell;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.listModel.list.count > 0) {
        RepositoryModel *model = self.listModel.list[indexPath.item];
        if (![model.bookType isEqualToString:BookTypeCartoon]) {
            return CGSizeMake((IPHONE_WIDTH - 5*4)/3,193);
        }
        return CGSizeMake((IPHONE_WIDTH - 5*4)/3,186);
    }else{
        return CGSizeMake(IPHONE_WIDTH, self.view.frame.size.height- 64);
    }
}

- (void)contentOffsetCollectionView{
    self.collectionView.mj_footer.hidden = YES;
    CGFloat imgH = 0;
    CGFloat  btnH = 0;
    CGFloat  bannerH = imgH+btnH +5;
    [self.collectionView setContentOffset:CGPointMake(0, bannerH) animated: NO] ;
    self.collectionView.scrollEnabled = NO;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(14, 5, 5, 5);;
}

// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.listModel.list count]  >0){
        [self gotoBookPreviewDetailVC:indexPath];
    }
}

- (void)gotoBookPreviewDetailVC:(NSIndexPath *)indexPath{
    
    RepositoryModel *model = self.listModel.list[indexPath.item];
    BOOL existsState = NO;
    if ([model.hasInBookShelf integerValue] == 1) {
        existsState = YES;
        if ([model.bookType isEqualToString:BookTypeBookJF]) {
            AssistantsHomeworkViewController * bookHomeworkVC = [[AssistantsHomeworkViewController alloc]initWithBookId:model.id];
            [self pushViewController:bookHomeworkVC];
        }else if ([model.courseType isEqualToString:@"phonics_textbook"]) {
            PhonicsHomeworkViewController * bookHomeworkVC = [[PhonicsHomeworkViewController alloc]initWithBookId:model.id];
            [self pushViewController:bookHomeworkVC];
        }
        
        else{
            BookHomeworkViewController * bookHomeworkVC = [[BookHomeworkViewController alloc]initWithBookId:model.id withBookType:model.bookType withClear:YES];
            [self pushViewController:bookHomeworkVC];
        }
        return;
    }
  
    BookPreviewDetailViewController * detail;
    if ([model.bookType isEqualToString:BookTypeBookJF]) {
        detail = [[JFBookPreviewViewController alloc]initWithBookId:model.id withExistsBookcase:existsState];
    }else if([model.bookType isEqualToString:BookTypeCartoon]){
        detail = [[BookPreviewDetailViewController alloc]initWithBookId:model.id withExistsBookcase:existsState];
        
    }else if([model.bookType isEqualToString:BookTypeBook]){
        detail = [[BookBookPreDetailViewController alloc]initWithBookId:model.id withExistsBookcase:existsState];
    }
    detail.courseType = model.courseType;
    detail.isFromHome = self.isHome;
  
    detail.indexPath = indexPath;
    detail.selectedBlock = ^(NSIndexPath *indexPath) {
        RepositoryModel *model = self.listModel.list[indexPath.item];
        model.hasInBookShelf = @(1);
        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    };
    [self pushViewController:detail];
}

#pragma mark ---

- (void)hiddScreeningView{
    
      self.collectionView.scrollEnabled = YES;
}
- (void)gotoBookVC{
    RepositoryBookViewController * bookVC = [[RepositoryBookViewController alloc]init];
    bookVC.subjectsModel = self.subjectsModel;
    bookVC.publishersModel = self.publishersModel;
    bookVC.gradesModel = self.gradesModel;
    [self pushViewController:bookVC];
    
}

- (void)gotoTeachingAssistantsVC{
    
    RepostioryAssistantsViewController * assistantsVC = [[RepostioryAssistantsViewController alloc]init];
    assistantsVC.subjectsModel = self.subjectsModel;
 
    assistantsVC.gradesModel = self.gradesModel;
    [self pushViewController:assistantsVC];
}
- (void)gotoCartoonVC{
    
    RepositoryCartoonViewController * cartoonVC = [[RepositoryCartoonViewController alloc]init];
    [self pushViewController:cartoonVC];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

