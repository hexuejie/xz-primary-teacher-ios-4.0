//
//  TeachingAssistantsDetailViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/11/3.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//
//作业详情
#import "TeachingAssistantsDetailViewController.h"
#import "TeachingAssistantsDetailBottomView.h"
#import "UIImageView+WebCache.h"
#import "TeachingAssistantsDetailCell.h"
#import "TeachingAssistantsHomeworkListViewController.h"
#import "AssistantsDetailModel.h"
#import "ProUtils.h"
#import "BookPreviewModel.h"
#import "UIViewController+BackButtonHandler.h"
#import "ReleaseHomeworkViewController.h"

NSString * const  TeachingAssistantsDetailCellIdentifier = @"TeachingAssistantsDetailCellIdentifier";


@interface TeachingAssistantsDetailViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate,TeachingAssistantsHomeworkDelegate>
@property(nonatomic, strong) TeachingAssistantsDetailBottomView * bottomView;
@property(nonatomic, copy) NSString  * bookId;
@property(nonatomic, copy) NSString  * unitId;
@property(nonatomic, copy) NSString * bookName;
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong)  AssistantsDetailModel * detailModel;
@property(nonatomic, strong) NSMutableArray * jfHomeworkDataArray;
@property(nonatomic, assign) NSInteger  questionNumber;//布置的题目总数
@property(nonatomic, strong) BookPreviewDetailModel * detailBook;
@property(nonatomic, assign) NSInteger dataSaveIndex;//  题目数据保存  下标  -1 没有修改是新增的数据
@property(nonatomic, strong) NSMutableArray *questionSelectedAreaArray;
@property(nonatomic, assign) NSInteger  seletedPage;//选择的作业所在页数
@property(nonatomic, strong) UILabel *pageLabel;

 
@end

@implementation TeachingAssistantsDetailViewController
- (instancetype)initWithBookId:(NSString *)bookId withUnitId:(NSString *)unitId   withBookName: (NSString *)bookName withBookInfo:(BookPreviewDetailModel *)detailModel{
    if (self == [ super init]) {
        self.unitId = unitId;
        self.bookName = bookName;
        self.bookId = bookId;
        self.detailBook = detailModel;
    }
    return self;
}


- (NSMutableArray *)jfHomeworkDataArray{
    if (!_jfHomeworkDataArray) {
        _jfHomeworkDataArray = [NSMutableArray array];
    }
    return _jfHomeworkDataArray;
}


- (NSMutableArray *)questionSelectedAreaArray{
    if (!_questionSelectedAreaArray) {
        _questionSelectedAreaArray = [NSMutableArray array];
    }
    return _questionSelectedAreaArray;
}

- (TeachingAssistantsDetailBottomView *)bottomView{
    
    if (!_bottomView) {
        
        _bottomView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([TeachingAssistantsDetailBottomView class]) owner:nil options:nil].firstObject;
        
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,  self.view.frame.size.width, 0.5)];
        lineView.backgroundColor = project_line_gray;
        [_bottomView addSubview:lineView];
    }
    return _bottomView;
}
-(UICollectionView *)collectionView{
    
    if (!_collectionView) {
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(-10, 0, self.view.frame.size.width + 20, self.view.frame.size.height- FITSCALE(50)) collectionViewLayout:[self getLayout]];
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
    self.questionNumber = 0;
    self.dataSaveIndex = -1;
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

- (void)requestTeacherQueryJFBookUnitContent{
    [self showHUDInfoByType:HUDInfoType_Loading];
    NSDictionary * dic = nil;
    if (self.unitId) {
        dic = @{@"unitId":self.unitId};
    }
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_TeacherQueryJFBookUnitContent] parameterDic:dic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_TeacherQueryJFBookUnitContent];
    
}

- (void)setNetworkRequestStatusBlocks{
    
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_TeacherQueryJFBookUnitContent) {
            strongSelf.detailModel =  [[AssistantsDetailModel  alloc]initWithDictionary:successInfoObj error:nil];
            for (int i = 0;i< [strongSelf.detailModel.pages count];i++) {
                [strongSelf.questionSelectedAreaArray addObject:[NSMutableArray array]];
            }
            NSString * page = [NSString stringWithFormat:@"1/%ld",[strongSelf.detailModel.pages count]];
            [strongSelf confightPageLabel:page];
            [strongSelf.collectionView reloadData];
        }
    }];
}

- (void)configCollectionView {
    
    [self.collectionView registerClass: [TeachingAssistantsDetailCell class] forCellWithReuseIdentifier:TeachingAssistantsDetailCellIdentifier];
    
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
    WEAKSELF
    self.bottomView.sureBlock = ^{
        [weakSelf  gotoBookHomeworkVC];
    };
    [self.bottomView setupTitleNumber:@"0" withType:@"练习"];
}

- (void)gotoBookHomeworkVC{
    
    
    NSString * content = [self getHomeworkAssistants];
    NSDictionary * userInfo = @{@"content":content};
   NSInteger index =  self.navigationController.viewControllers.count - 4;
    if (index >= 0) {
        UIViewController * vc =  self.navigationController.viewControllers[index];
        if ([vc isKindOfClass:[ReleaseHomeworkViewController class]]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:BOOK_HOMEWORK_ADD_NEW object:nil userInfo:userInfo];
            [self.navigationController popToViewController:vc animated:YES];
        }else{
            ReleaseHomeworkViewController * gotoHomeworkVC = [[ReleaseHomeworkViewController alloc]initWithData:userInfo];
            [self.navigationController pushViewController:gotoHomeworkVC animated:YES];
            
        }
    } else{
        ReleaseHomeworkViewController * gotoHomeworkVC = [[ReleaseHomeworkViewController alloc]initWithData:userInfo];
        [self.navigationController pushViewController:gotoHomeworkVC animated:YES];
     
    }
    [self clearChooseTopicParsing];
    
}
- (NSString *)getHomeworkAssistants{
    
    NSDictionary * contentDic = [self getAssistantsContentData];
    
    NSString * content = [ProUtils dictionaryToJson:contentDic];
    return  content;
    
}

- (NSDictionary *)getAssistantsContentData{
    NSDictionary * contentDic = nil;
    if (self.jfHomeworkDataArray.count > 0) {
        NSMutableArray * tempArray = [NSMutableArray array];
        NSString * unitId = @"";
        for (NSDictionary * dic in  self.jfHomeworkDataArray) {
            for (NSDictionary * tempDic in dic[@"questions"]) {
                [tempArray addObject:tempDic];
            }
            unitId = dic[@"unitId"];
        }
        NSDictionary * jfHomeworkDic = @{@"unitId":unitId,@"questions":tempArray};
         contentDic = @{@"bookId":self.bookId,@"jfHomework":@[jfHomeworkDic],@"bookImg":self.detailBook.coverImage,@"name":self.detailBook.name,@"subjectName":self.detailBook.subjectName,@"bookTypeName":self.detailBook.bookTypeName,@"bookType":self.detailBook.bookType,@"workTotal":@(self.questionNumber)};
    }
    return contentDic;
}
#pragma mark --- 点击每道题出发事件
- (void)gotoItemVCWithUnitId:(NSString *)unitId withQuestionNum:(NSString *)questionNum withPage:(NSInteger)page{
    //解决多页显示一题只显示当前页点中区域 其它页不显示的  bug
    NSString * selectedQuestionNum  = [self getBigQuestionNum:questionNum];
    [self.questionSelectedAreaArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj containsObject:selectedQuestionNum]) {
            NSMutableArray *array  = obj;
             [array addObject:selectedQuestionNum];
        }
    }];
//    for (int page = 0; page < [self.questionSelectedAreaArray count]; page++) {
//
//        if (![self.questionSelectedAreaArray[page]  containsObject:selectedQuestionNum]) {
//          NSMutableArray * array  = self.questionSelectedAreaArray[page];
//            [array addObject:selectedQuestionNum];
//        }
//    }
    
//    if (![self.questionSelectedAreaArray[page] containsObject:selectedQuestionNum]) {
//
//       NSMutableArray * array  = self.questionSelectedAreaArray[page];
//       [array addObject:selectedQuestionNum];
//    }
    
 
   NSArray *  selectedQuestionNumArray  = [self setupVerifyCurrentSelectedData:questionNum];
    
    TeachingAssistantsHomeworkListViewController * listVC = [[TeachingAssistantsHomeworkListViewController alloc]initWithBookId:self.bookId withBookName:self.bookName withUnitId:unitId withQuestionNum:questionNum  withSelectedData:selectedQuestionNumArray];
    listVC.delegate = self;
    [self pushViewController:listVC];
}
// 当前选择的题目是否存在 存在 获取存在数据的下标 同时选择的保存题号 数组返回
-(NSArray *)setupVerifyCurrentSelectedData:(NSString *)questionNum{
    
    self.dataSaveIndex = -1;
    NSMutableArray * tempArray = [NSMutableArray array];
    //获取
    for (int i = 0; i<[self.jfHomeworkDataArray count]; i++) {
        NSDictionary * tempDic = self.jfHomeworkDataArray[i];
        for (NSDictionary* questionsDic in tempDic[@"questions"] ) {
            NSString * saveQuestionNum = [self  getBigQuestionNum:questionsDic[@"questionNum"]];
            NSString * selectedQuestionNum  = [self getBigQuestionNum:questionNum];
            if ([selectedQuestionNum isEqualToString:saveQuestionNum]) {
                self.dataSaveIndex = i;
                [tempArray addObject: questionsDic[@"questionNum"]];
            }
            
           
        }
    }
    return tempArray;
}
//获取 父标题号
- (NSString *)getBigQuestionNum:(NSString *)questionNum{
    NSString * tempQuestionNum = @"";
    if ([questionNum containsString:@"."]) {
        tempQuestionNum = [questionNum componentsSeparatedByString:@"."][0];
    }else{
        tempQuestionNum = questionNum;
    }
    return tempQuestionNum;
}

#pragma mark - UICollectionViewDataSource && Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger  rows = [self.detailModel.pages count];
    return rows;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  
    UICollectionViewCell * cell = nil;
    TeachingAssistantsDetailCell * tempCell = [collectionView dequeueReusableCellWithReuseIdentifier:TeachingAssistantsDetailCellIdentifier forIndexPath:indexPath];
    WEAKSELF
    tempCell.singleTapGestureBlock = ^(NSString * unitId, NSString *questionNum,NSIndexPath * indexPath){
        weakSelf.seletedPage = indexPath.row;
        [self gotoItemVCWithUnitId:unitId withQuestionNum:questionNum withPage:indexPath.row];
    };
    tempCell.indexPath = indexPath;
    AssistantsPagesModel * pagesModel = self.detailModel.pages[indexPath.item];
    tempCell.currentPage = [pagesModel.page intValue];
    [tempCell setupModel:self.detailModel withSelectedData:self.questionSelectedAreaArray];
    cell = tempCell;
    return cell;
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
//    if (currentIndex < 3 && _currentIndex != currentIndex) {
//        _currentIndex = currentIndex;
//        [self refreshNaviBarAndBottomBarState];
//    }
    
}

#pragma mark ----TeachingAssistantsHomeworkDelegate

- (void)chooseAssistantsHomewrok:(NSDictionary *)dic withAllQuestions:(NSInteger)allQuestions withQuestionNum:(NSString *)questionNum{
     [self confightAssistantsHomeworkData:dic withAllQuestions:(NSInteger)allQuestions withQuestionNumber:questionNum];
      [self setupBottomView];
    
}
//设置底部练习数

- (void)setupBottomView{
    BOOL enabled = NO;
    if (self.questionNumber == 0) {
        enabled = NO;
    }else{
        enabled = YES;
    }
    [self.bottomView setupButtonActivation:enabled];
    [self.bottomView setupTitleNumber:[NSString stringWithFormat:@"%ld",self.questionNumber] withType:@"练习"];
}

//配置教辅数据
- (void)confightAssistantsHomeworkData:(NSDictionary *)dic withAllQuestions:(NSInteger)allQuestions withQuestionNumber:(NSString * ) questionNum{
    
    if (dic) {
        [self changeOrSaveData:dic withAllQuestions:allQuestions];
    }else {
        //该题没有选择作业时  清空选择的区域 单页清除 （bug 在一题多页显示会出现）
//        if ([self.questionSelectedAreaArray[self.seletedPage] containsObject:[self getBigQuestionNum:questionNum]]) {
//             [self.questionSelectedAreaArray[self.seletedPage] removeObject:[self getBigQuestionNum:questionNum]];
//             //删除数据
//            [self deleteSaveDataQuestions:allQuestions];
//        }
         //该题没有选择作业时  清空选择的题区域
        //解决多页显示一题只清除当前页面点中区域 其它页选中不清除 bug
        [self.questionSelectedAreaArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj containsObject:[self getBigQuestionNum:questionNum]]) {
                NSMutableArray *array  = obj;
                [array removeObject:[self getBigQuestionNum:questionNum]];
                //删除数据
                [self deleteSaveDataQuestions:allQuestions];
            }
        }];
    }
   
    [self.collectionView reloadData];
}
//保存数据
- (void)changeOrSaveData:(NSDictionary *)dic withAllQuestions:(NSInteger )allQuestions{
    if (self.jfHomeworkDataArray.count > 0 ) {
        if ([self isValidationInclude]) {
            NSDictionary * tempDic = self.jfHomeworkDataArray[self.dataSaveIndex];
            [self.jfHomeworkDataArray replaceObjectAtIndex:self.dataSaveIndex  withObject:dic];
            NSInteger tempNumber = [tempDic[@"questions"] count];
            self.questionNumber  = self.questionNumber -tempNumber  + allQuestions;
            self.dataSaveIndex = -1;
            
        }else{
            [self.jfHomeworkDataArray addObject:dic];
            self.questionNumber = self.questionNumber + allQuestions;
        }
        
    }else{
        [self.jfHomeworkDataArray addObject:dic];
        self.questionNumber = self.questionNumber + allQuestions;
    }
}

//删除保存的数据
- (void)deleteSaveDataQuestions:(NSInteger )allQuestions{
    if (self.jfHomeworkDataArray.count > 0 ) {
        if ([self isValidationInclude]) {
            NSDictionary * tempDic = self.jfHomeworkDataArray[self.dataSaveIndex];
            [self.jfHomeworkDataArray removeObjectAtIndex:self.dataSaveIndex ];
            NSInteger tempNumber = [tempDic[@"questions"] count];
            self.questionNumber  = self.questionNumber -tempNumber  + allQuestions;
            self.dataSaveIndex = -1;
        }
    }
    
}
//数据存在
- (BOOL)isValidationInclude{
    
    BOOL isChangeState = NO;
    NSMutableArray * tempArray = [NSMutableArray arrayWithArray:self.jfHomeworkDataArray];
    for (int index = 0; index< [tempArray count]; index++) {
        
        if (self.dataSaveIndex >-1 && self.dataSaveIndex == index ) {
            isChangeState = YES;
            break;
        }else{
            isChangeState = NO;
        }
    }
    return isChangeState;
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
  
}
- (void)backViewController{
    [self clearChooseTopicParsing];
    [super backViewController];
}

- (void)clearChooseTopicParsing{
      [[NSUserDefaults standardUserDefaults] removeObjectForKey:SAVE_JFHomework_Choose_Topic_Parsing];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 * 协议中的方法，获取返回按钮的点击事件
 */
- (BOOL)navigationShouldPopOnBackButton
{
    return NO;
    
}
@end
