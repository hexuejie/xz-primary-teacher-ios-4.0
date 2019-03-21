
//
//  HomeworkProblemsDetailViewController.m
//  TeacherPro
//
//  Created by DCQ on 2018/1/19.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "HomeworkProblemsDetailViewController.h"
#import "HomeworkProblemsPreviewControllerView.h"
#import "HomeworkProblemsDetailListModel.h"
#import "HomeworkProblemsDetailBottomView.h"
#import "HomeworkProblemsDetailHeaderSectionView.h"
#import "HomeworkProblemsTopicContentCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "ProUtils.h"
#import "HomeworkProblemsDetailUnitSwitchView.h"
#import "THScrollChooseView.h"
#import "YYCache.h"


NSString * const HomeworkProblemsDetailHeaderSectionViewIdentifier = @"HomeworkProblemsDetailHeaderSectionViewIdentifier";
 
NSString * const HomeworkProblemsTopicContentCellIdentifier = @"HomeworkProblemsTopicContentCellIdentifier";


#define   kBottomViewHeight  FITSCALE(50)
@interface HomeworkProblemsDetailViewController ()<HomeworkProblemsPreviewDelegate>
@property(nonatomic, strong) NSArray *unitIds;
@property(nonatomic, strong) NSArray *unitNames;
//@property(nonatomic, strong) HomeworkProblemsDetailListModel * listModel;
@property(nonatomic, strong) NSMutableArray *listModelArray;
@property(nonatomic, strong) HomeworkProblemsDetailBottomView * bottomView;
@property(nonatomic, strong) NSMutableArray * selectedIndexArray;
@property(nonatomic, strong) NSArray * oldCacheData;
@property(nonatomic, strong) HomeworkProblemsDetailUnitSwitchView *switchUnitView;
@property(nonatomic, assign) NSInteger selectedUnitIndex;
@property(nonatomic, assign) NSInteger expectTime;//总时间
@property(nonatomic, assign) NSInteger totalQuestionsItem;//总题数
@property(nonatomic, strong) NSMutableDictionary * unitSelectedItemDic ;//单元选择的题目位置
@property(nonatomic, strong) NSMutableDictionary * problemsPreviewDic;//所有选的题目所在的单元信息下的所有题目

@end

@implementation HomeworkProblemsDetailViewController
- (instancetype)initWithUnitIds:(NSArray *)unitIds withUnitNames:(NSArray *)unitNames withCacheData:(NSArray *)cacheData{
    self = [super init];
    if (self ) {
        self.unitIds =  unitIds;
        self.unitNames = unitNames;
        self.oldCacheData = cacheData;
    }
    return self;
}
- (NSMutableDictionary *)unitSelectedItemDic{
    if (!_unitSelectedItemDic) {
        _unitSelectedItemDic = [NSMutableDictionary dictionary];
    }
    return _unitSelectedItemDic;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationItemTitle:@"课后练习"];
    [self.view addSubview:self.bottomView];
    [self  configurationBottomView];
  
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.selectedUnitIndex = 0;
    [self initSwitchUnitView];
    self.pageCount = 20;
    [self requestListExerciseQuestionByUnit];
    
}
- (BOOL)isAddRefreshFooter{
    return YES;
}
- (NSInteger )getNetworkTableViewDataCount{
    
    return [self.listModelArray count];
}
- (void)getLoadMoreTableViewNetworkData{
    
    [self requestListExerciseQuestionByUnit];
}
- (void)initSwitchUnitView{
    [self.view addSubview:self.switchUnitView];
    [self.switchUnitView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.view.mas_top);
        make.height.mas_equalTo(@(44));
    }];
    self.switchUnitView.hidden = YES;
    UITapGestureRecognizer * tap =  [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showUnitAction)];
    [self.switchUnitView addGestureRecognizer:tap];
}


- (void)verifyAndConfigCache{
    //找出选择的单元id
    NSMutableArray * unitIdArray = [NSMutableArray array];
    NSMutableDictionary * questionsNumDic = [NSMutableDictionary dictionary];
    if (self.oldCacheData && [self.oldCacheData count] > 0) {
        NSArray * tempData = self.oldCacheData[0];
        for (NSDictionary * dic in tempData) {
            NSString * unitId  = dic[@"unitId"];
             NSArray * questions  =   dic[@"questions"];
            [unitIdArray addObject:unitId];
            [questionsNumDic setObject:questions forKey:unitId];
        }
    }
    
    //遍历找出与选择的单元id 相同的数据 并计算数据所在列表的位置
    for (int i = 0; i < [self.listModelArray count]; i++) {
//        HomeworkProblemsDetailModel *model = self.listModel.unitQuestions[i];
      NSDictionary *model = self.listModelArray[i];
        if ([unitIdArray containsObject:model[@"unitId"]]) {
            NSInteger section = i ;
            NSInteger row =  0;
            for (int j = 0; j< [model[@"questions"] count]; j++) {
//                 HomeworkProblemsQuestionsModel * questionModel = model.questions[j];
                NSDictionary * questionModel =model[@"questions"][j];
                 NSArray * questions = questionsNumDic[model[@"unitId"]];
                if ([questions containsObject:questionModel[@"questionNum"]]) {
                   row =  j;
                    [self setupCacheIndexPathRow:row section:section];
                }
            }
        }
        
    }
    
}
- (void)verifyAndConfigCache2{
    //找出选择的单元id
    NSMutableArray * unitIdArray = [NSMutableArray array];
    NSMutableDictionary * questionsNumDic = [NSMutableDictionary dictionary];
    if (self.oldCacheData && [self.oldCacheData count] > 0) {
        NSArray * tempData = self.oldCacheData[0];
        for (NSDictionary * dic in tempData) {
            NSString * unitId  = dic[@"unitId"];
            NSArray * questions  =   dic[@"questions"];
            [unitIdArray addObject:unitId];
            [questionsNumDic setObject:questions forKey:unitId];
        }
    }
    
     NSInteger section = 0 ;
    //遍历找出与选择的单元id 相同的数据 并计算数据所在列表的位置
    NSInteger unitIndex = 0;
    for (NSString * unitId in self.unitIds) {
        if ([unitIdArray containsObject:unitId]) {
            for (int i = 0; i < [self.listModelArray count]; i++) {
                NSDictionary *model = self.listModelArray[i];
                NSArray * questions = questionsNumDic[unitId];
                if ([questions containsObject:model[@"questionNum"]]) {
                    NSInteger row =  i;
                    [self setupCacheIndexPathRow:row section:section withUnitId:unitId];
                    [self updateCachePreviewData:unitId withUnitName:self.unitNames[unitIndex]];
                }
            }
        }
        unitIndex++;
    }
    
      self.selectedIndexArray = self.unitSelectedItemDic[self.unitIds[self.selectedUnitIndex]];
    
//    for (int i = 0; i < [self.listModelArray count]; i++) {
//        //        HomeworkProblemsDetailModel *model = self.listModel.unitQuestions[i];
//        NSDictionary *model = self.listModelArray[i];
//        NSString * tempUnitId = model[@"unitId"];
//        if ([unitIdArray containsObject:tempUnitId]) {
//             NSArray * questions = questionsNumDic[tempUnitId];
//              if ([questions containsObject:model[@"questionNum"]]) {
//                   NSInteger row =  i;
//                   [self setupCacheIndexPathRow:row section:section withUnitId:tempUnitId];
//                }
//            }
//    }
    
 
}
- (void)setupCacheIndexPathRow:(NSInteger) row section:(NSInteger )section withUnitId:(NSString *)unitId{
    
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    NSMutableArray *selectedIndexArray = self.unitSelectedItemDic[unitId];
    if (!selectedIndexArray) {
           selectedIndexArray = [NSMutableArray array];
    } 
    if(![selectedIndexArray containsObject:indexPath]){
        [selectedIndexArray addObject:indexPath];
    }
    [self.unitSelectedItemDic setObject:selectedIndexArray forKey:unitId];
    
  
 
}

- (void)updateCachePreviewData:(NSString *)unitId withUnitName:(NSString *)unitName{
    YYCache *cache = [YYCache cacheWithName:HOMEWORK_CONTENT_PATH];
 
    NSArray *tempListModelArray = nil;
    if ([cache objectForKey:UNIT_KHLX_PRACTICE_MEMORY_KEY]) {
        NSMutableDictionary * unitDic =  (NSMutableDictionary*)[cache objectForKey:UNIT_KHLX_PRACTICE_MEMORY_KEY];
        tempListModelArray  =[unitDic objectForKey: unitId];
        
    }
    if (!tempListModelArray) {
        return;
    }
    NSArray * listArray = @[@{@"expectTime":@(self.expectTime),@"unitName":unitName,@"totalQuestionsItem":@(self.totalQuestionsItem),@"unitId":unitId,@"questions":tempListModelArray}];
    [self.problemsPreviewDic setObject:listArray forKey:unitId];
    
}
- (void)setupCacheIndexPathRow:(NSInteger) row section:(NSInteger )section{
    
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:row inSection:section];
   
    
    if(![self.selectedIndexArray containsObject:indexPath]){
        [self.selectedIndexArray addObject:indexPath];
    }
 
    
}
- (UITableViewStyle )getTableViewStyle{

    return UITableViewStylePlain;
}
- (void)configurationBottomView{
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        CGFloat bottomHeight = FITSCALE(50);
        make.leading.mas_equalTo(self.view.mas_leading);
        make.trailing.mas_equalTo(self.view.mas_trailing);
        make.top.mas_equalTo(self.tableView.mas_bottom).offset(1);
        make.height.mas_equalTo(@(bottomHeight)); 
    }];
    [self.bottomView setupButtonActivation:NO];
       [self updateBottomView];
    WEAKSELF
    self.bottomView.sureBlock = ^{
        [weakSelf gotoPreviewCV];
    };
    
}
- (HomeworkProblemsDetailBottomView *)bottomView{
    
    if (!_bottomView) { 
        _bottomView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([HomeworkProblemsDetailBottomView class]) owner:nil options:nil].firstObject;
    
    }
    return _bottomView;
}
- (HomeworkProblemsDetailUnitSwitchView *)switchUnitView{
    if (!_switchUnitView) {
        _switchUnitView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([HomeworkProblemsDetailUnitSwitchView class]) owner:nil options:nil].firstObject;
    }
    return _switchUnitView;
}
- (NSMutableDictionary *)problemsPreviewDic{
    if (!_problemsPreviewDic) {
        _problemsPreviewDic = [NSMutableDictionary dictionary];
    }
    return _problemsPreviewDic;
}
//- (NSMutableArray *)selectedIndexArray{
//    if (!_selectedIndexArray) {
//        _selectedIndexArray = [[NSMutableArray alloc]init];
//    }
//    return _selectedIndexArray;
//}

 
- (CGRect)getTableViewFrame{
    CGFloat tableViewY = 0;
    if ([self.unitIds count]>1) {
        tableViewY = 50;
    }
    CGRect tableViewFrame =  CGRectMake(0, tableViewY, self.view.frame.size.width,self.view.frame.size.height - kBottomViewHeight - tableViewY);
    return tableViewFrame;
}

-(void)requestListExerciseQuestionByUnit{
//    NSString * parameterUnitId = [self.unitIds componentsJoinedByString:@","];
////    parameterUnitId = @"aec39a6a-6c76-4aba-8088-e1387b26c2e9,aec39a6a-6c76-4aba-8088-e1387b26c2e9";
//    NSDictionary * parameterDic = @{@"unitIds":parameterUnitId};
//    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_ListExerciseQuestionByUnit] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_ListExerciseQuestionByUnit];
    
  NSString * parameterUnitId = self.unitIds[self.selectedUnitIndex];
    NSDictionary * parameterDic = @{@"unitId":parameterUnitId,@"pageIndex":@(self.currentPageNo),@"pageSize":@(self.pageCount)};
  [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_QueryPageExerciseQuestionByUnit] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_QueryPageExerciseQuestionByUnit];

    
}

- (void)setNetworkRequestStatusBlocks{
    WEAKSELF
    [self setNetUploadSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
       
        if (request.tag == NetRequestType_ListExerciseQuestionByUnit) {
             [strongSelf showHUDInfoByType:HUDInfoType_Loading];
            dispatch_async(dispatch_get_global_queue(0,0), ^{ 
                NSArray * unitQuestions = successInfoObj[@"unitQuestions"];
                
                NSArray * newUnitQuestions = [strongSelf resetData:unitQuestions];
                strongSelf.listModelArray =[NSMutableArray array];
                [strongSelf.listModelArray addObjectsFromArray: newUnitQuestions];
                
 
                [strongSelf verifyAndConfigCache];
                dispatch_async(dispatch_get_main_queue(), ^{
                  
                    [strongSelf updateTableView];
                    [strongSelf updateBottomView];
                    [strongSelf hideHUD];
                });
           
            });
          
        }else if (request.tag == NetRequestType_QueryPageExerciseQuestionByUnit){
  
            
            [strongSelf showHUDInfoByType:HUDInfoType_Loading];
           
            dispatch_async(dispatch_get_global_queue(0,0), ^{
                
                NSArray * unitQuestions = successInfoObj[@"questions"];
                 id  questionCount = successInfoObj[@"questionCount"];
                strongSelf.totalQuestionsItem = [questionCount integerValue];
                strongSelf.expectTime =  [successInfoObj[@"expectTime"] integerValue];
                NSArray * newUnitQuestions = [strongSelf configurationQuestions:unitQuestions];
                
                if (!strongSelf.listModelArray) {
                    strongSelf.listModelArray = [NSMutableArray array];
                    [strongSelf.listModelArray addObjectsFromArray: newUnitQuestions];
                }else{
                    [strongSelf.listModelArray addObjectsFromArray:newUnitQuestions];
                }
                strongSelf.currentPageNo ++;
                
                [strongSelf cacheUnitDataDic];
//                [strongSelf verifyAndConfigCache];
                [strongSelf verifyAndConfigCache2];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [strongSelf updateTableView];
                    [strongSelf updateBottomView];
                    [strongSelf hideHUD];
                    [strongSelf  configurationSwitchView];
                });
            });
            
        }
        
     
    }];
}
- (void)cacheUnitDataDic{

    NSMutableDictionary *unitDic = nil;
   YYCache *cache = [YYCache cacheWithName:HOMEWORK_CONTENT_PATH];
    if ([cache objectForKey:UNIT_KHLX_PRACTICE_MEMORY_KEY]) {
        unitDic =  (NSMutableDictionary*)[cache objectForKey:UNIT_KHLX_PRACTICE_MEMORY_KEY];
        [unitDic setObject:self.listModelArray forKey:self.unitIds[self.selectedUnitIndex]];
    }else{
        unitDic = [NSMutableDictionary dictionary];
        [unitDic setObject:self.listModelArray forKey:self.unitIds[self.selectedUnitIndex]];
    }
  
    cache.memoryCache.shouldRemoveAllObjectsOnMemoryWarning = YES;
    cache.memoryCache.shouldRemoveAllObjectsWhenEnteringBackground = YES;
    [cache setObject: unitDic forKey:UNIT_KHLX_PRACTICE_MEMORY_KEY];
}
- (void)configurationSwitchView{
    
    self.switchUnitView.hidden = [self.unitIds count]> 1? NO:YES;
}

- (BOOL)requestEndHidHud{
    return NO;
}
- (NSMutableArray *)resetData:(NSArray *)unitQuestions{
    
    NSMutableArray * newUnitQuestions = [NSMutableArray array];
    for (NSDictionary *tempDic in unitQuestions) {
        NSMutableDictionary * newUnitQuestionsDic = [NSMutableDictionary dictionary];
        [newUnitQuestionsDic addEntriesFromDictionary:tempDic];
        NSArray * questions = tempDic[@"questions"];
       NSArray * newQuestions = [self configurationQuestions:questions];
        [newUnitQuestionsDic setObject:newQuestions forKey:@"questions"];
        [newUnitQuestions addObject:newUnitQuestionsDic];
    }
    return newUnitQuestions;
}

- (NSArray *)configurationQuestions:(NSArray *)questions{
    NSMutableArray * newQuestions =[NSMutableArray array];
    for (NSDictionary * questionsDic in questions) {
        NSMutableDictionary * newQuestionsDic = [NSMutableDictionary dictionary];
        [newQuestionsDic addEntriesFromDictionary:questionsDic];
        NSArray * questionStemArray = [self cellTopHtmlLayoutHeight:questionsDic[@"questionStem"] withTextFontSize:fontSize_14];
        CGFloat htmlH = [questionStemArray[1] floatValue];
        id questionStem = questionStemArray[0];
        
        NSArray * optionsStemArray = [self cellOptionsHeight:questionsDic[@"options"] withTextFOntSize:fontSize_14];
        
        CGFloat optionsH = [optionsStemArray[1] floatValue];
        id  options = optionsStemArray[0] ;
        CGFloat bottomH =  50;
        CGFloat spacing =  10+10+4+16;
        CGFloat height =  htmlH+ optionsH+ bottomH +spacing ;
        [newQuestionsDic setObject:@(height) forKey:@"cellHeight"];
        [newQuestionsDic setObject:options forKey:@"options"];
        [newQuestionsDic setObject:questionStem forKey:@"questionStem"];
        [newQuestions addObject:newQuestionsDic];
    }
    return newQuestions;
}
- (void)registerCell{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeworkProblemsTopicContentCell  class]) bundle:nil] forCellReuseIdentifier:HomeworkProblemsTopicContentCellIdentifier];
   [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeworkProblemsDetailHeaderSectionView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:HomeworkProblemsDetailHeaderSectionViewIdentifier];
}
#pragma mark ---
//秒转化为时间
- (NSString *)timeFormatted:(NSString *)time
{
    NSString * str = @"";
    //秒
    NSInteger totalSeconds  = [time integerValue];
    NSInteger minutes = (totalSeconds / 60) % 60;
    if (minutes < 1) {
        str = @"预计1分钟完成";
    }else if (minutes > 60){
        str = @"预计1个小时以上完成";
    }else{
        str = [NSString stringWithFormat:@"预计%ld分钟完成",minutes];
    }
    
    return  str;
}
#pragma mark ---

- (NSString *)getDescriptionText{
    return @"暂无题目布置~";
}
#pragma mark
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    NSInteger section =  [self.listModel.unitQuestions count];
//    NSInteger section = [self.listModelArray count];
    NSInteger  section =  1;
    return section;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    HomeworkProblemsDetailModel * model  = self.listModel.unitQuestions[section];
//    NSInteger row = [model.questions count];
    
//    NSDictionary * modelDic =  self.listModelArray[section];
//    NSInteger row = [modelDic[@"questions"] count];
    NSInteger row = [self.listModelArray count];
    return row;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
 
//    HomeworkProblemsDetailModel * detail = self.listModel.unitQuestions[indexPath.section];
//    HomeworkProblemsQuestionsModel * questionModel = detail.questions[indexPath.row];
//    height = [questionModel.cellHeight floatValue];
    
//     NSDictionary * modelDic =  self.listModelArray[indexPath.section];
//     NSDictionary * questionsModel =  modelDic[@"questions"][indexPath.row];
    NSDictionary * questionsModel =  self.listModelArray[indexPath.row];
     height = [questionsModel[@"cellHeight"] floatValue];
    return height;
}


NSInteger sortedCompare(id obj1, id obj2, void *context)
{
    
    return  [obj1 localizedCompare:obj2];
}

- (NSArray *)cellOptionsHeight:(NSDictionary *)contentDic withTextFOntSize:(UIFont *)font{
    CGFloat height = 0;
    CGFloat spacing = (26+10)*2;
    NSArray * allkeys = contentDic.allKeys;
    NSArray *sortedArray = [allkeys sortedArrayUsingFunction:sortedCompare context:NULL];
    __block NSString * options =@"";
    [sortedArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        options = [options stringByAppendingString:[NSString stringWithFormat:@"%@.%@<br><br>",obj,contentDic[obj]]];
    }];

    NSMutableAttributedString *attributes = [[NSMutableAttributedString alloc] init];
    [attributes appendAttributedString: [ProUtils strToAttriWithStr: options]];

    [attributes addAttribute:NSFontAttributeName value:font  range:NSMakeRange(0, attributes.length)];
 
    CGSize attSize = [attributes boundingRectWithSize:CGSizeMake(IPHONE_WIDTH - spacing , MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin  context:nil].size;
    height = attSize.height;
    return @[attributes,@(height)];
}

- (NSArray* )cellTopHtmlLayoutHeight:(NSString *)content withTextFontSize:(UIFont *)font
{
    
    CGFloat spacing = 26*2;
    NSMutableAttributedString *attributes = [[NSMutableAttributedString alloc] initWithAttributedString:[ProUtils strToAttriWithStr: content]];
    
    [attributes addAttribute:NSFontAttributeName value:font  range:NSMakeRange(0, attributes.length)];
    
    CGSize attSize = [attributes boundingRectWithSize:CGSizeMake(IPHONE_WIDTH - spacing , MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    
    return @[attributes,@(attSize.height)];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = nil;
    HomeworkProblemsTopicContentCell * tempCell = [tableView dequeueReusableCellWithIdentifier:HomeworkProblemsTopicContentCellIdentifier];
    [self configureCell:tempCell atIndexPath:indexPath];
    cell = tempCell;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)configureCell:(HomeworkProblemsTopicContentCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    cell.fd_enforceFrameLayout = NO; // Enable to use "-sizeThatFits:"
//    HomeworkProblemsDetailModel * model  = self.listModel.unitQuestions[indexPath.section];
//    HomeworkProblemsQuestionsModel * questionModel  = model.questions[indexPath.row];
//    [cell setupTopicModel:questionModel];
    
//    NSDictionary * modelDic =  self.listModelArray[indexPath.section];
//    NSDictionary * questionsModel =  modelDic[@"questions"][indexPath.row];
     NSDictionary * questionsModel =  self.listModelArray[indexPath.row];
    [cell setupTopicDic:questionsModel];
    cell.indexPath = indexPath;
    cell.buttonBlock = ^(BOOL btnSelected,NSIndexPath * indexPath) {
       [self chooseTopicIndexPath:indexPath];
    };
    //是否显示
    if ([self.selectedIndexArray containsObject:indexPath]) {
        [cell setupBtnSelectedState:YES];
    }else{
         [cell setupBtnSelectedState:NO];
    }
    
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
       UIView * headerView = nil;

    HomeworkProblemsDetailHeaderSectionView*  tempView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HomeworkProblemsDetailHeaderSectionViewIdentifier];
    tempView.section = section;
    tempView.btnBlock = ^(BOOL btnSelected, NSInteger section) {
        [self setupAllChooseOrNo:btnSelected withSection:section];
    };
 //    HomeworkProblemsDetailModel * model  = self.listModel.unitQuestions[section];
//    [tempView setupUnitModel:model];
//    NSDictionary * modelDic =  self.listModelArray[section];
    
    NSInteger  chooseNumber =  [self.selectedIndexArray count];
    NSDictionary * modelDic = @{@"expectTime":@(self.expectTime),@"unitName":self.unitNames[self.selectedUnitIndex],@"totalQuestionsItem":@(self.totalQuestionsItem),@"chooseNumber":@(chooseNumber)};
    [tempView setupUnitDic:modelDic];
    //显示btn是否选中
    if ([self  validateAllChoose:section]) {
        [tempView setupSelectedTotailBtnState:YES];
    }else{
        [tempView setupSelectedTotailBtnState:NO];
    }
    if (self.totalQuestionsItem > 0) {
        tempView.hidden = NO;
    }else{
        tempView.hidden = YES;
    }
    headerView = tempView;
    return headerView;
}
- (void)setupAllChooseOrNo:(BOOL)state withSection:(NSInteger)section{
 
//     NSDictionary * detailModel = self.listModelArray[section];
//    if (state) {
//        //全选
//        for (int i =0;i < [detailModel[@"questions"] count];i++) {
//            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:section];
//            if (![self.selectedIndexArray containsObject:indexPath]) {
//                [self.selectedIndexArray addObject:indexPath];
//            }
//        }
//
//    }else{
//        //取消
//        for (int i = 0;i < [detailModel[@"questions"] count];i++) {
//            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:section];
//            if ([self.selectedIndexArray containsObject:indexPath]) {
//                [self.selectedIndexArray removeObject:indexPath];
//            }
//        }
//    }
    
     self.selectedIndexArray = self.unitSelectedItemDic[self.unitIds[self.selectedUnitIndex]];
 
    if (! self.selectedIndexArray) {
        self.selectedIndexArray = [NSMutableArray array];
    }
    
    
    if (state) {
        //全选
        for (int i =0;i < [ self.listModelArray count];i++) {
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:section];
            
            if (![self.selectedIndexArray containsObject:indexPath]) {
                [self.selectedIndexArray addObject:indexPath];
            }
        }
        
    }else{
        //取消
        for (int i = 0;i < [ self.listModelArray count];i++) {
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:section];
            if ([self.selectedIndexArray containsObject:indexPath]) {
                [self.selectedIndexArray removeObject:indexPath];
            }
        }
    }
 
     [self updateUnitSelectedData];
     [self updateTableViewSection:section atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
     [self updatePreviewData];
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
     UIView * footerView = [UIView new];
    return footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = 0.0001;
 
//    if ([self.listModel.unitQuestions count]> 0) {
//        height = 80;
//    }
    if ([self.listModelArray count]> 0) {
        height = 80;
    }
    return height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self chooseTopicIndexPath:indexPath];
}
/*
// 图片消息的显示是被控制在一定范围内的(cell中已做了样式控制)、语音、撤回消息的显示样式是固定的，这些类的消息高度直接预估一个固定值就够用了
// 文本消息、群通知消息的高度主要依赖于文本内容的多少，要想效果好，还是要计算一下文本主体高度的（虽然还是有高度的计算工作，但在auto sizing机制下，仅需计算出对高度影响最大的文本的高度即可）
 */
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    CGFloat height = 0;
//    HomeworkProblemsDetailModel * detail = self.listModel.unitQuestions[indexPath.section];
//    HomeworkProblemsQuestionsModel * questionModel = detail.questions[indexPath.row];
//    CGFloat htmlH = [self cellTopHtmlLayoutHeight:questionModel.questionStem withTextFontSize:fontSize_14];
//    CGFloat optionsH = [self cellOptionsHeight:questionModel.options withTextFOntSize:fontSize_14];
//    CGFloat bottomH =  50;
//    CGFloat spacing =  10+10+4+16;
//    height =  htmlH+ optionsH+ bottomH +spacing ;
//    return height;
//
//}
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section NS_AVAILABLE_IOS(7_0){
//    CGFloat height = 0.0001;
//
//    if ([self.listModel.unitQuestions count]> 0) {
//        height = 80;
//    }
//    return height;
//
//}
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section NS_AVAILABLE_IOS(7_0){
//    return 0.0001;
//}
- (void)chooseTopicIndexPath:(NSIndexPath *)indexPath{
    
    self.selectedIndexArray = self.unitSelectedItemDic[self.unitIds[self.selectedUnitIndex]];
    
    if (! self.selectedIndexArray) {
        self.selectedIndexArray = [NSMutableArray array];
    }
    
    if (![self.selectedIndexArray containsObject:indexPath]) {
        [self.selectedIndexArray addObject:indexPath];
    }else{
        [self.selectedIndexArray removeObject:indexPath];
    }
    [self updateUnitSelectedData];
    [self updateTableViewSection:indexPath.section atIndexPath:indexPath];
    [self updatePreviewData];
    

    
}
- (void)updateUnitSelectedData{
     [self.unitSelectedItemDic setObject:self.selectedIndexArray forKey:  self.unitIds[self.selectedUnitIndex]] ;
}
- (void)updatePreviewData{
    
    YYCache *cache = [YYCache cacheWithName:HOMEWORK_CONTENT_PATH];
    NSArray *tempSelectedIndexArray = nil ;
    NSArray *tempListModelArray = nil;
    if ([cache objectForKey:UNIT_KHLX_PRACTICE_MEMORY_KEY]) {
        NSMutableDictionary * unitDic =  (NSMutableDictionary*)[cache objectForKey:UNIT_KHLX_PRACTICE_MEMORY_KEY];
       tempListModelArray  =[unitDic objectForKey: self.unitIds[self.selectedUnitIndex]];
        
    }
    if (!tempListModelArray) {
        return;
    }
   NSArray * listArray = @[@{@"expectTime":@(self.expectTime),@"unitName":self.unitNames[self.selectedUnitIndex],@"totalQuestionsItem":@(self.totalQuestionsItem),@"unitId":self.unitIds[self.selectedUnitIndex],@"questions":tempListModelArray}];
    [self.problemsPreviewDic setObject:listArray forKey:self.unitIds[self.selectedUnitIndex]];
}
- (void)updateTableViewSection:(NSInteger)section atIndexPath:(NSIndexPath *)indexPath{
    

    NSIndexPath * scrollIndexPath;
    if (indexPath) {
        scrollIndexPath = indexPath;
    }else{
       scrollIndexPath = [NSIndexPath  indexPathForRow:0 inSection:section];
    }
    UITableViewScrollPosition position ;
    if (scrollIndexPath.row == 0) {
        position = UITableViewScrollPositionNone;
    }else{
        position = UITableViewScrollPositionMiddle;
    }
//    CGFloat delay = 0.1 * (NSEC_PER_SEC);
//    NSInteger time = dispatch_time(DISPATCH_TIME_NOW, delay);
//
//    dispatch_after( time, dispatch_get_main_queue(), ^{
//         [self.tableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:position animated:NO];
//    });
//
//    //去掉reloadSections 的时候怎么会有一个往下的动画
//    [UIView performWithoutAnimation:^{
//        // 刷新动画
//        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
//
//    }];
    [self.tableView reloadData];
    [self updateBottomView];
}

- (void)updateBottomView{
    NSString * number = @"";
    NSString * timer = @"";
    
    NSInteger totailNumber = 0;
    for (int index = 0; index < [self.unitSelectedItemDic.allValues count]; index++) {
       totailNumber = totailNumber + [self.unitSelectedItemDic.allValues[index] count];
    }
    
    if (totailNumber > 0) {
        number = [NSString stringWithFormat:@"%ld",totailNumber];
        timer =  [self getSelectedTopicTotailTimer];
        [self.bottomView setupTitleNumber:number  withTimer:timer];
        [self.bottomView setupButtonActivation:YES];
    }else{
        number = @"请您选择题目";
        timer = @"";
        [self.bottomView setupNomarlTitle:number];
        [self.bottomView setupButtonActivation:NO];
    }
}
- (NSString *)getSelectedTopicTotailTimer{
    NSString * totailTimer = @"";
    NSInteger totailDuration = 0;
    
    YYCache *cache = [YYCache cacheWithName:HOMEWORK_CONTENT_PATH];
    NSMutableArray *tempSelectedIndexArray ;
    if ([cache objectForKey:UNIT_KHLX_PRACTICE_MEMORY_KEY]) {
        NSMutableDictionary * unitDic =  (NSMutableDictionary*)[cache objectForKey:UNIT_KHLX_PRACTICE_MEMORY_KEY];
      NSArray *tempListModelArray  =[unitDic objectForKey: self.unitIds[self.selectedUnitIndex]];
        
        for (NSString *key in self.unitSelectedItemDic.allKeys) {
           tempSelectedIndexArray = self.unitSelectedItemDic[key];
            for (NSIndexPath *indexPath in tempSelectedIndexArray) {
                NSDictionary * questionsModel =  tempListModelArray[indexPath.row];
                if (questionsModel[@"questionDuration"]) {
                    totailDuration = totailDuration + [questionsModel[@"questionDuration"] integerValue];
                }
            }
           
        }
      
    }
   
 
    
//    for (NSIndexPath *indexPath in self.selectedIndexArray) {
//        NSDictionary * questionsModel =  self.listModelArray[indexPath.row];
//        if (questionsModel[@"questionDuration"]) {
//              totailDuration = totailDuration + [questionsModel[@"questionDuration"] integerValue];
//        }
//
//    }
    
    NSString * totalStr = [NSString stringWithFormat:@"%ld",totailDuration];
    totailTimer = [self timeFormatted:totalStr];
    return totailTimer;
}


- (BOOL)validateAllChoose:(NSInteger )section{
    BOOL yesOrNo = NO;
    NSInteger  totailIdx = 0;
    for (NSIndexPath *index in self.selectedIndexArray) {
        if (index.section ==  section) {
            totailIdx ++;
        }
    }
//    HomeworkProblemsDetailModel * model = self.listModel.unitQuestions[section];
//    if ([self.selectedIndexArray count]>0 && totailIdx == [model.questions count]) {
//        yesOrNo = YES;
//    }
    
//    NSDictionary * model = self.listModelArray[section];
//    if ([self.selectedIndexArray count]>0 && totailIdx == [model[@"questions"] count]) {
//        yesOrNo = YES;
//    }
 
       if ([self.selectedIndexArray count]>0 && totailIdx == [self.listModelArray count]) {
           yesOrNo = YES;
        }
    return yesOrNo;
}

- (void)updateDetailList{
    
    self.selectedIndexArray = self.unitSelectedItemDic[self.unitIds[self.selectedUnitIndex]];
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath  indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    [self updateBottomView];
}
#pragma mark ---
- (void)gotoPreviewCV{
    
//    NSArray * listArray = @[@{@"expectTime":@(self.expectTime),@"unitName":self.unitNames[self.selectedUnitIndex],@"totalQuestionsItem":@(self.totalQuestionsItem),@"unitId":self.unitIds[self.selectedUnitIndex],@"questions":self.listModelArray }];
    
//    HomeworkProblemsPreviewControllerView * previewVC = [[HomeworkProblemsPreviewControllerView alloc]initWithModel:self.problemsPreviewArray withSelectedIndexPathArray:self.selectedIndexArray];
    
    HomeworkProblemsPreviewControllerView * previewVC = [[HomeworkProblemsPreviewControllerView alloc]initWithPreviewData:self.problemsPreviewDic withSelectedIndexPathData:self.unitSelectedItemDic];
    previewVC.detailDelegate = self;
    [self pushViewController:previewVC];
}

#pragma mark ---
- (void)showUnitAction{
    NSArray *questionArray = self.unitNames;
    NSString *defaultDesc = questionArray[self.selectedUnitIndex];
    THScrollChooseView *scrollChooseView = [[THScrollChooseView alloc] initWithQuestionArray:questionArray withDefaultDesc:defaultDesc];
    [scrollChooseView showView];
    WEAKSELF
    scrollChooseView.confirmBlock = ^(NSInteger selectedQuestion) {
        if (weakSelf.selectedUnitIndex != selectedQuestion) {
            weakSelf.selectedUnitIndex = selectedQuestion;
            self.selectedIndexArray = self.unitSelectedItemDic[self.unitIds[self.selectedUnitIndex]];
            [weakSelf switchUnit];
        }
    };
    
}
- (void)switchUnit{
    self.listModelArray = nil;
    self.currentPageNo = 0;
    [self requestListExerciseQuestionByUnit];
}
@end
