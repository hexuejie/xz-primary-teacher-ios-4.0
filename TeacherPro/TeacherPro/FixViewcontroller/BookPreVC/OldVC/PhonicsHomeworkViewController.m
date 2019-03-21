//
//  PhonicsHomeworkViewController.m
//  TeacherPro
//
//  Created by 何学杰 on 2019/1/7.
//  Copyright © 2019 ZNXZ. All rights reserved.
//

#import "PhonicsHomeworkViewController.h"
#import "BookPreviewModel.h"
#import "PhonicsHomeworkCollectionViewHeader.h"
#import "BookHomeworkAssistantsChildrenTitleCell.h"
#import "BookHomeworkAssistantsSectionView.h"
#import "BookHomeworkTitleCell.h"
#import "BookPreviewDetailViewController.h"
#import "TeachingAssistantsDetailViewController.h"
#import "JFBookPreviewViewController.h"
#import "BookBookPreDetailViewController.h"
#import "SubJFBookPreViewController.h"
#import "BookHomeworkSectionView.h"
#import "PhonicsHomeworkCollectionViewCell.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "SubBookBookPreViewController.h"
#import "ReleaseHomeworkViewController.h"

@interface PhonicsHomeworkViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic, copy) NSString * bookId;
@property(nonatomic, strong)   BookPreviewModel *detailModel;


@property (nonatomic ,strong) ChildrenUnitModel *selectedUnitModel;
@end

@implementation PhonicsHomeworkViewController
- (instancetype)initWithBookId:(NSString *)bookId  {
    self = [super init];
    if (self) {
        self.bookId = bookId;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestQueryBook];
    [self configTableView];
    [self registerCell];
    [self setNavigationItemTitle:@"自然拼读"];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.bottomView];
}
- (void)registerCell{
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([PhonicsHomeworkCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"PhonicsHomeworkCollectionViewCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([PhonicsHomeworkCollectionViewHeader class]) bundle:nil] forCellWithReuseIdentifier:@"PhonicsHomeworkCollectionViewHeader"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableView"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"collectionView"];
    
}
- (void)configTableView{
    UICollectionViewLeftAlignedLayout *collectionViewLayout = [[UICollectionViewLeftAlignedLayout alloc]init];
    
    collectionViewLayout.minimumLineSpacing = 0;//间距
    collectionViewLayout.minimumInteritemSpacing = 0;//行距
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-bottomViewHeight) collectionViewLayout: collectionViewLayout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.bounces = YES;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.collectionView];
}


#pragma mark ---
- (UIView *)bottomView{
    if (!_bottomView) {
        
        _bottomView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ReleaseAddBookworkCell class]) owner:nil options:nil].firstObject;
        _bottomView.frame = CGRectMake(0, self.view.frame.size.height -bottomViewHeight,self.view.frame.size.width, bottomViewHeight);
        [_bottomView.addButton removeTarget:nil
                                         action:NULL
                               forControlEvents:UIControlEventAllEvents];
        [_bottomView.addButton addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
        _bottomView.backgroundColor = [UIColor whiteColor];
        if (kScreenWidth == 375&&kScreenHeight>667){
            _bottomView.frame = CGRectMake(0, self.view.frame.size.height -bottomViewHeight-18,self.view.frame.size.width, bottomViewHeight);
        }
        [_bottomView.addButton setTitle:@"布置作业" forState:UIControlStateNormal];
//        _bottomView.delegate = self;
        
    }
    return _bottomView;
}

- (void)requestQueryBook{
    
    NSDictionary *parameterDic =nil;
    if (self.bookId  ) {
        parameterDic  = @{@"bookId":self.bookId,@"getUnit":@"true",@"bookType":@"Book"};
    }
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_QueryBookById] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_QueryBookById];
}

- (void)setNetworkRequestStatusBlocks{
    
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_QueryBookById) {
            strongSelf.detailModel = [[BookPreviewModel alloc]initWithDictionary:successInfoObj error:nil];
            dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            //子线程
            dispatch_async(globalQueue,^{
                
                dispatch_queue_t mainQueue = dispatch_get_main_queue();
                //异步返回主线程，根据获取的数据，更新UI
                dispatch_async(mainQueue, ^{
                    
                    [strongSelf.collectionView reloadData];
                
                });
            });
        }
    }];
}

#pragma mark ---
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.detailModel.book.bookUnits.count +1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    
    if (self.detailModel.book.bookUnits.count > section-1) {
        BookUnitModel *model = self.detailModel.book.bookUnits[section-1];
        return [model.children count];
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        PhonicsHomeworkCollectionViewHeader *tempCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhonicsHomeworkCollectionViewHeader" forIndexPath:indexPath];
        [tempCell  setupPreviewDetailInfo:self.detailModel.book];
        [tempCell.intoButton addTarget:self action:@selector(gotoBookPreviewDetailVC) forControlEvents:UIControlEventTouchUpInside];
        return tempCell;
    }else{
        PhonicsHomeworkCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhonicsHomeworkCollectionViewCell" forIndexPath:indexPath];
        if (self.detailModel.book.bookUnits.count >indexPath.section-1) {
            BookUnitModel *model = self.detailModel.book.bookUnits[indexPath.section-1];
            cell.model = model.children[indexPath.row];
            if (self.selectedUnitModel == cell.model) {
                cell.isSelected = YES;
            }else{
                cell.isSelected = NO;
            }
        }
        return cell;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return CGSizeMake(kScreenWidth, 155);
    }
    if (self.detailModel.book.bookUnits.count >indexPath.section-1) {
        BookUnitModel *model = self.detailModel.book.bookUnits[indexPath.section-1];
        if (model.children.count >indexPath.row) {
            ChildrenUnitModel *subModel = model.children[indexPath.row];
            
            NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:16]};
        CGRect rect = [subModel.unitName boundingRectWithSize:CGSizeMake(0, 30)options:NSStringDrawingUsesLineFragmentOrigin |  NSStringDrawingUsesFontLeading attributes:dic context:nil];
            return CGSizeMake(rect.size.width+30, 44);
        }
    }
    
    return CGSizeMake(0.01, 0.01);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{//55
    if([kind isEqualToString:UICollectionElementKindSectionHeader] && indexPath.section != 0)
    {
        if (self.detailModel.book.bookUnits.count >indexPath.section-1) {
            BookUnitModel *model = self.detailModel.book.bookUnits[indexPath.section-1];
            UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"UICollectionReusableView" forIndexPath:indexPath];
            headerView.backgroundColor = [UIColor whiteColor];
            UILabel *unitLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, kScreenWidth, 45)];
            [headerView addSubview:unitLabel];
            unitLabel.backgroundColor = [UIColor whiteColor];
            unitLabel.textColor = HexRGB(0x525B66);
            unitLabel.font = [UIFont systemFontOfSize:16];
            unitLabel.text = model.unitName;
            return headerView;
        }
    }
    return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"collectionView" forIndexPath:indexPath];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
        return 0.01;
    }
    return 14.0f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
        return 0.01;
    }
    return 24.0f;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeMake(kScreenWidth, 0.01);
    }
    return CGSizeMake(kScreenWidth, 45);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
        return UIEdgeInsetsMake(0, 0, 0, 0);;
    }
    return UIEdgeInsetsMake(5, 16, 5, 16);;
}

// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return;
    }
    for (int section = 0; section<self.detailModel.book.bookUnits.count; section++) {
        if (self.detailModel.book.bookUnits.count >section) {//i+1
            BookUnitModel *model = self.detailModel.book.bookUnits[section];
            
            for (int row = 0; row<model.children.count; row++) {
                if (model.children.count >row) {//i+1
                    if (indexPath.section == section +1
                        &&indexPath.row == row) {
                        PhonicsHomeworkCollectionViewCell * cell = [collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section +1]];
                        cell.isSelected = YES;
                        self.selectedUnitModel = cell.model;
                    }else{
                        PhonicsHomeworkCollectionViewCell * cell = [collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section +1]];
                        cell.isSelected = NO;
                    }
                }
            }
        }
    }
}

#pragma mark ---
- (void)gotoBookPreviewDetailVC{
    
    NSString * bookId = self.bookId;
    BOOL existsState = YES;
    NSString * bookType =  @"Book";
    SubBookBookPreViewController * detail = [[SubBookBookPreViewController alloc]initWithBookId:bookId withExistsBookcase:existsState];
    [self pushViewController:detail];
}

- (void)gotoTeachingAssistantsDetailVC:(NSIndexPath *)indexPath{
    
    
    BookUnitModel * model = self.detailModel.book.bookUnits[indexPath.section -1];
    NSString * unitId =  model.unitId;
    NSString * bookName =  self.detailModel.book.name;
    NSString * bookId = self.bookId;
    if (model.children) {
        BookUnitModel * childrenModel =  model.children[indexPath.row -1];
        unitId = childrenModel.unitId;
        
    }
    
    TeachingAssistantsDetailViewController * detail = [[TeachingAssistantsDetailViewController alloc]initWithBookId:bookId   withUnitId:unitId  withBookName: bookName withBookInfo:self.detailModel.book];
    [self pushViewController:detail];
}
//确定布置作业
- (void)sureAction:(id)sender{
    if (self.bottomView.addButton  != sender) {
        return;
    }
    NSString * content = @"";
    
    
    if( [self.detailModel.book.bookType isEqualToString:@"Book"]){
        if (!self.selectedUnitModel) {
            [SVProgressHelper dismissWithMsg:@"请选择需要布置的作业"];
            return  ;
        }
        content = [self getHomeworkBook];
    }
    
    NSDictionary * userInfo = @{@"content":content};
    
    BOOL popReleaseHomework = NO;
    for(UIViewController*temp in self.navigationController.viewControllers) {
        
        if([temp isKindOfClass:[ReleaseHomeworkViewController class]]){
            popReleaseHomework = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:BOOK_HOMEWORK_ADD_NEW object:nil userInfo:userInfo];
            [self.navigationController popToViewController:temp animated:YES];
        }
        
    }
    if (!popReleaseHomework) {
        [self  gotoDecorateHomework:userInfo];
    }
    
}
- (void)gotoDecorateHomework:(NSDictionary *)userInfo{

    ReleaseHomeworkViewController * homeworkVC = [[ReleaseHomeworkViewController alloc]initWithData:userInfo];
    [self pushViewController:homeworkVC];
}

- (NSString *)getHomeworkBook{
    
    NSDictionary * contentDic = [self getBookContentData];
    NSString * content = [ProUtils dictionaryToJson:contentDic];
    return  content;
}
- (NSDictionary *)getBookContentData{
    
    NSArray * phonicsHomework = @[];
    NSInteger appCount  = 0;
    
    if (self.selectedUnitModel) {
        phonicsHomework= @[@{@"unitId":self.selectedUnitModel.unitId}];
        //        appCount =  [self.phonicsHomework.firstObject[@"appCount"] integerValue];
    }
    
    NSMutableDictionary * contentDic = [NSMutableDictionary dictionary];
    [contentDic addEntriesFromDictionary:@{@"bookId":self.bookId}];
    [contentDic addEntriesFromDictionary:@{@"phonicsHomework":phonicsHomework}];
    
    [contentDic addEntriesFromDictionary:@{@"bookImg":self.detailModel.book.coverImage}];
    [contentDic addEntriesFromDictionary:@{@"name":self.detailModel.book.name}];
    [contentDic addEntriesFromDictionary:@{@"subjectName":self.detailModel.book.subjectName}];
    [contentDic addEntriesFromDictionary:@{@"bookTypeName":self.detailModel.book.bookTypeName}];
    [contentDic addEntriesFromDictionary:@{@"bookType":self.detailModel.book.bookType}];
    [contentDic addEntriesFromDictionary:@{@"workTotal":@(1)}];
    
    return  contentDic;
}

-(void)dealloc{
    self.detailModel = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
