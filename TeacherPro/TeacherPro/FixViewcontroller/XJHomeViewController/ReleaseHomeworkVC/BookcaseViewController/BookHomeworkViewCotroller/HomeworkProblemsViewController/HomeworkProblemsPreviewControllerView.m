//
//  HomeworkProblemsPreviewControllerView.m
//  TeacherPro
//
//  Created by DCQ on 2018/1/19.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "HomeworkProblemsPreviewControllerView.h"
#import "HomeworkProblemsDetailListModel.h"
#import "HomeworkProblemsDetailBottomView.h"
#import "HomeworkProblemsDetailHeaderSectionView.h"
#import "HomeworkProblemsTopicContentCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "YYCache.h"
#import "ProUtils.h"

 
NSString * const HomeworkProblemsPreviewTopicContentCellIdentifier = @"HomeworkProblemsPreviewTopicContentCellIdentifier";

#define   kPreviewBottomViewHeight  FITSCALE(50)

@interface HomeworkProblemsPreviewControllerView ()

@property(nonatomic, strong) NSMutableArray *selectedIndexArray;
//@property(nonatomic, strong) HomeworkProblemsDetailListModel *listModel;
@property(nonatomic, strong) NSArray *listModel;
@property(nonatomic, strong) HomeworkProblemsDetailBottomView * bottomView;
@property(nonatomic, strong) NSMutableArray * previewArray;//每个元素是一个数组（第一个元素是内容 第二个元素在listModel 位置）
@property(nonatomic, strong) NSMutableDictionary *expectTimeDic ;
@property(nonatomic, strong) NSMutableDictionary *selectedIndexPathDic;
@property(nonatomic, strong) NSDictionary *previewDataDic;
@end

@implementation HomeworkProblemsPreviewControllerView
- (instancetype)initWithModel:(NSArray *)listModel withSelectedIndexPathArray:(NSMutableArray *)selectedIndexPathArray{
    self = [super init];
    if (self) {
        self.selectedIndexArray = selectedIndexPathArray;
        self.listModel = listModel;
    }
    return self;
}
- (instancetype)initWithPreviewData:(NSDictionary *)previewDataDic withSelectedIndexPathData:(NSMutableDictionary *)selectedIndexPathDic{
    
    self = [super init];
    if (self) {
        self.previewDataDic = previewDataDic;
        self.selectedIndexPathDic = selectedIndexPathDic;
    }
    return self;
}
- (NSMutableArray *)previewArray{
    if (!_previewArray) {
        _previewArray = [NSMutableArray array];
    }
    return _previewArray;
}
- (NSMutableDictionary *)expectTimeDic{
    if(!_expectTimeDic){
        _expectTimeDic = [NSMutableDictionary dictionary];
        
    }
    return _expectTimeDic;
}
- (void)viewDidLoad {
    [super viewDidLoad];
     [self showHUDInfoByType:HUDInfoType_Loading];
    [self.view addSubview:self.bottomView];
    self.bottomView.hidden = YES;
    [self setNavigationItemTitle:@"预览作业"];
    [self  setupNavigationRight];
    [self setupTableViewData];
    
}
- (void)setupTableViewData{
   
      dispatch_async(dispatch_get_global_queue(0,0), ^{ 
//          [self resetData];
           [self resetData2];
          dispatch_async(dispatch_get_main_queue(), ^{
              
              [self updateTableView];
              [self  configurationBottomView];
              self.bottomView.hidden = NO;
              [self hideHUD];
          });
    });
   
 
}
- (void)resetData{
  
    for (NSIndexPath *indexPath in self.selectedIndexArray) {
        NSDictionary * model = self.listModel[indexPath.section];
        NSDictionary * questionModel = model[@"questions"][indexPath.row];
        
        [self.previewArray addObject:@[questionModel,indexPath]];
    }
    if ([self.previewArray count] == [self.selectedIndexArray count]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self updateTableView];
            [self  configurationBottomView];
            self.bottomView.hidden = NO;
            [self hideHUD];
        });
    }
}
- (void)resetData2{
 
    for (int index = 0; index < [self.selectedIndexPathDic.allKeys count]; index ++) {
        NSString * unitId = self.selectedIndexPathDic.allKeys[index];
        NSArray * tempModelArray  = self.previewDataDic[unitId];
        NSArray *tempIndexArray = self.selectedIndexPathDic[unitId];
        for (NSIndexPath *indexPath in tempIndexArray) {
            NSDictionary * model = tempModelArray[indexPath.section];
            NSDictionary * questionModel = model[@"questions"][indexPath.row];
            [self.previewArray addObject:@[questionModel,indexPath]];
        }
    }
    
    
}
- (void)setupNavigationRight{
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"全部移除" forState:UIControlStateNormal];
 
    [rightBtn setFrame:CGRectMake(0, 0, 80, 44)];
    rightBtn.titleLabel.font = fontSize_14;
    [rightBtn addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView: rightBtn];
  
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
    [self.bottomView setupButtonActivation:YES];
    [self.bottomView setupButtonTitle:@"确定"];
    [self updateBottomView];
    WEAKSELF
    self.bottomView.sureBlock = ^{
//        [weakSelf saveHomework];
        [weakSelf saveHomework2];
    };
    
}
- (HomeworkProblemsDetailBottomView *)bottomView{
    
    if (!_bottomView) {
        _bottomView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([HomeworkProblemsDetailBottomView class]) owner:nil options:nil].firstObject;
        
    }
    return _bottomView;
}
- (void)registerCell{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeworkProblemsTopicContentCell  class]) bundle:nil] forCellReuseIdentifier:HomeworkProblemsPreviewTopicContentCellIdentifier];
 
}
- (CGRect)getTableViewFrame{
    CGRect tableViewFrame =  CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height - kPreviewBottomViewHeight);
    return tableViewFrame;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger section =  0;
    section = 1;
    
    return section;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
    
    NSInteger row = [self.previewArray count];
  
    return row;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    
//    HomeworkProblemsQuestionsModel * questionModel = self.previewArray[indexPath.row][0];
//    height = [questionModel.cellHeight floatValue];
    NSDictionary * questionModel = self.previewArray[indexPath.row][0];
    height = [questionModel[@"cellHeight"] floatValue];
    return height;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = nil;
    HomeworkProblemsTopicContentCell * tempCell = [tableView dequeueReusableCellWithIdentifier:HomeworkProblemsPreviewTopicContentCellIdentifier];
    [self configureCell:tempCell atIndexPath:indexPath];
    cell = tempCell;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)configureCell:(HomeworkProblemsTopicContentCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
//    HomeworkProblemsQuestionsModel * questionModel  = self.previewArray[indexPath.row][0];
//    [cell setupTopicModel:questionModel];
    NSDictionary * questionModel  = self.previewArray[indexPath.row][0];
    [cell setupTopicDic:questionModel];
    [cell setupBtnSelectedState:YES];
    cell.indexPath = indexPath;
    cell.buttonBlock = ^(BOOL btnSelected,NSIndexPath * indexPath) {
        [self chooseTopicIndexPath:indexPath];
    };
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headerView = [UIView new];
    return headerView;
}

- (void)selectedAllCancel{
//    [self.previewArray removeAllObjects];
//    [self.selectedIndexArray  removeAllObjects];
     [self.previewArray removeAllObjects];
    [self.selectedIndexPathDic removeAllObjects];
   
    [self backViewController];
}
- (void)backViewController{
    if ([self.detailDelegate  respondsToSelector:@selector(updateDetailList)]) {
        [self.detailDelegate updateDetailList];
    }
    [super backViewController];
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footerView = [UIView new];
    return footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = 0.0001;
    return height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}


- (void)chooseTopicIndexPath:(NSIndexPath *)indexPath{
    
    NSIndexPath * preViewIndexPath = self.previewArray[indexPath.row][1];
    
    for (int index = 0; index < [self.selectedIndexPathDic.allKeys count]; index ++) {
        NSString * unitId = self.selectedIndexPathDic.allKeys[index];
        NSMutableArray * tempIndexArray = self.selectedIndexPathDic[unitId];
        if ([tempIndexArray containsObject:preViewIndexPath]) {
            [tempIndexArray removeObject:preViewIndexPath];
        }
    }
    
//    if ([self.selectedIndexArray containsObject:preViewIndexPath]) {
//        [self.selectedIndexArray removeObject:preViewIndexPath];
//    }
    [self.previewArray removeObjectAtIndex:indexPath.row];
    
    if ([self.previewArray count] ==0 ) {
        [self selectedAllCancel];
    }
    [self updateTableViewSection:indexPath.section];
    
}

- (void)updateTableViewSection:(NSInteger)section{
    
    //去掉reloadSections 的时候怎么会有一个往下的动画
    [UIView performWithoutAnimation:^{
        // 刷新动画
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
    }];
    [self updateBottomView];
}

- (void)updateBottomView{
    NSString * number = @"";
    NSString * timer = @"";
    NSInteger totailNumber = 0;
    for (int index = 0; index < [self.selectedIndexPathDic.allValues count]; index++) {
        totailNumber = totailNumber + [self.selectedIndexPathDic.allValues[index] count];
    }
    
    if (totailNumber > 0) {
        number = [NSString stringWithFormat:@"%ld",[self.previewArray count]];
//        timer =  [self getSelectedTopicTotailTimer];
        timer =[self getSelectedTopicTotailTimer2];
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
    
    for (NSIndexPath *index in self.selectedIndexArray) {
       
//        HomeworkProblemsDetailModel * model  = self.listModel.unitQuestions [index.section];
        
           NSDictionary * model  = self.listModel[index.section];
        if (![self.expectTimeDic objectForKey:model[@"unitId"]] ) {
            totailDuration = 0;
        }
//        HomeworkProblemsQuestionsModel * questionsModel  = model.questions[index.row];
         NSDictionary * questionsModel  = model[@"questions"][index.row];
        if (questionsModel[@"questionDuration"]) {
            totailDuration = totailDuration + [questionsModel[@"questionDuration"] integerValue];
        }
         [self.expectTimeDic  setObject:@(totailDuration) forKey:model[@"unitId"]];
        
    }
  
    NSString * totalStr = [NSString stringWithFormat:@"%ld",totailDuration];
    totailTimer = [self timeFormatted:totalStr];
    return totailTimer;
}

- (NSString *)getSelectedTopicTotailTimer2{
    NSString * totailTimer = @"";
    NSInteger totailDuration = 0;
    for (int index = 0; index < [self.selectedIndexPathDic.allKeys count]; index ++) {
        NSString * unitId = self.selectedIndexPathDic.allKeys[index];
        NSArray * tempModelArray  = self.previewDataDic[unitId];
        NSArray *tempIndexArray = self.selectedIndexPathDic[unitId];
        for (NSIndexPath *indexPath in tempIndexArray) {
            NSDictionary * model  = tempModelArray[indexPath.section];
            if (![self.expectTimeDic objectForKey:model[@"unitId"]] ) {
                totailDuration = 0;
            }
            //        HomeworkProblemsQuestionsModel * questionsModel  = model.questions[index.row];
            NSDictionary * questionsModel  = model[@"questions"][indexPath.row];
            if (questionsModel[@"questionDuration"]) {
                totailDuration = totailDuration + [questionsModel[@"questionDuration"] integerValue];
            }
            [self.expectTimeDic  setObject:@(totailDuration) forKey:model[@"unitId"]];
        }
        
    }
   
    
    NSString * totalStr = [NSString stringWithFormat:@"%ld",totailDuration];
    totailTimer = [self timeFormatted:totalStr];
    return totailTimer;
}

#pragma mark =----
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

#pragma mark --

- (void)rightAction:(UIButton *)btn{
       [self selectedAllCancel];
}

- (void)saveHomework{
    
 
    NSMutableDictionary *submitDic = [NSMutableDictionary dictionary];
    
    for (NSArray * tempArray in self.previewArray) {
        NSIndexPath * indexPath = tempArray[1];
//        HomeworkProblemsDetailModel * model = self.listModel.unitQuestions[indexPath.section];
//        NSString * unitId = model.unitId;
//        HomeworkProblemsQuestionsModel * questionModel =  tempArray[0];
//        NSString * questionNum = questionModel.questionNum ;
        
        NSDictionary * model = self.listModel[indexPath.section];
        NSString * unitId = model[@"unitId" ];
        NSDictionary * questionModel =  tempArray[0];
        NSString * questionNum = questionModel[@"questionNum" ] ;
        if (!submitDic[unitId]) {
            NSMutableArray * questions = [NSMutableArray array];
            [questions addObject:questionNum];
            submitDic[unitId] = questions;
        }else{
            NSMutableArray * questions =submitDic[unitId];
            [questions addObject:questionNum];
            submitDic[unitId] = questions;
        }
        
    }
    NSMutableArray *array = [NSMutableArray array];
    NSInteger  questions = 0;
    for (NSString * key in submitDic.allKeys) {
        NSNumber*expectTime  = [self.expectTimeDic objectForKey:key];
        NSDictionary * tempItem = @{@"unitId":key,
                                    @"expectTime":expectTime,
                                    @"questions":submitDic[key]};
        questions =  [submitDic[key] count] + questions;
        [array addObject:tempItem];
    }
    NSArray * submitArray =  @[array,@(questions)];
    YYCache *cache = [YYCache cacheWithName:HOMEWORK_CONTENT_PATH];
    cache.memoryCache.shouldRemoveAllObjectsOnMemoryWarning = YES;
    cache.memoryCache.shouldRemoveAllObjectsWhenEnteringBackground = YES;
    [cache setObject:submitArray forKey:KHLX_PRACTICE_MEMORY_KEY];
    
    
    NSInteger index = [self.navigationController.viewControllers count] - 4;
    
    [self.navigationController popToViewController:self.navigationController.viewControllers[index] animated:YES];
}


- (void)saveHomework2{
    
    
    NSMutableDictionary *submitDic = [NSMutableDictionary dictionary];
    for (NSArray * tempArray in self.previewArray) {
//            for (int index = 0; index < [self.selectedIndexPathDic.allKeys count]; index ++) {
//                NSString * unitId = self.selectedIndexPathDic.allKeys[index];
//                NSArray * tempModelArray  = self.previewDataDic[unitId];
//                NSIndexPath * indexPath = tempArray[1];
        
//                NSDictionary * model = tempModelArray[indexPath.section];
        
                NSDictionary * questionModel =  tempArray[0];
                NSString * modelUnitId = questionModel[@"unitId" ];
                NSString * questionNum = questionModel[@"questionNum" ] ;
                if (!submitDic[modelUnitId]) {
                    NSMutableArray * questions = [NSMutableArray array];
                    [questions addObject:questionNum];
                    submitDic[modelUnitId] = questions;
                }else{
                    NSMutableArray * questions = submitDic[modelUnitId];
                    [questions addObject:questionNum];
                    submitDic[modelUnitId] = questions;
                }
                
//            }
        
            
        }
    
    NSMutableArray *array = [NSMutableArray array];
    NSInteger  questions = 0;
    for (NSString * key in submitDic.allKeys) {
        NSNumber*expectTime  = [self.expectTimeDic objectForKey:key];
        NSDictionary * tempItem = @{@"unitId":key,
                                    @"expectTime":expectTime,
                                    @"questions":submitDic[key]};
        questions =  [submitDic[key] count] + questions;
        [array addObject:tempItem];
    }
    NSArray * submitArray =  @[array,@(questions)];
    YYCache *cache = [YYCache cacheWithName:HOMEWORK_CONTENT_PATH];
    cache.memoryCache.shouldRemoveAllObjectsOnMemoryWarning = YES;
    cache.memoryCache.shouldRemoveAllObjectsWhenEnteringBackground = YES;
    [cache setObject:submitArray forKey:KHLX_PRACTICE_MEMORY_KEY];
    
    
    NSInteger index = [self.navigationController.viewControllers count] - 4;
    
    [self.navigationController popToViewController:self.navigationController.viewControllers[index] animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
