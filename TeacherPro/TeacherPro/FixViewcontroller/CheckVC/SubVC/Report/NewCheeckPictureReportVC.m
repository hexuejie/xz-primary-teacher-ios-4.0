//
//  NewCheeckPictureReportVC.m
//  TeacherPro
//
//  Created by 何学杰 on 2019/1/3.
//  Copyright © 2019 ZNXZ. All rights reserved.
//

#import "NewCheeckPictureReportVC.h"

#import "NewReportListonPriceTableView.h"
#import "HWBookInfoCell.h"
#import "UIViewController+HBD.h"
#import "MultilayerItem.h"
#import "HWReportFooterCell.h"
#import "HWReportZXLXTypesCell.h"
#import "HWReportZXLXTypeUnitCell.h"
#import "HWReportZXLXUnitTypeCell.h"
#import "HWReportZXLXUnitTypeUnitCell.h"
#import "HWReportZXLXSubUnitTypeCell.h"
#import "HWZXLXVocabularyReportCell.h"
#import "HWZXLXHearReportCell.h"
#import "HWZXLXVoiceReportCell.h"
#import "HWCartoonReportCell.h"
#import "HWReportZXLXTypeDetailCell.h"
#import "HWReportZXLXUnitDetailVC.h"
#import "HWMathKHLXReportCell.h"
#import "HWJFBookReportCell.h"
#import "HWYWDDReportCell.h"
#import "JFHomeworkQuestionViewController.h"
#import "JFHomeworkCheckTopicDetailViewController.h"
#import "HWReportTextCell.h"
#import "HWReportVoiceCell.h"
#import "HWReportImgVCell.h"
#import "SDPhotoBrowser.h"
#import "HWReportStudentListVC.h"
#import "HomeworkDetailKHLXListViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "NewCheckPictureTableViewCell.h"
#import "NewCheckPictureHeaderView.h"
#import "NewCheckPictureLastTableViewCell.h"
#import "CheckDetialRangDetialView.h"
#import "NewReportPicturePriceTableView.h"
#import "NewReportPictureProblemTableView.h"

@interface NewCheeckPictureReportVC ()<SDPhotoBrowserDelegate>{
    CGFloat _gradientProgress;
}

@property(nonatomic, copy) NSString * homeworkId;

/** 项 */
@property (nonatomic, strong) NSMutableArray *Items;
@property (nonatomic, strong) NSDictionary *allDicItems;



/** 当前需要展示的数据 */
@property (nonatomic, strong) NSMutableArray<MultilayerItem *> *latestShowItems;

/** 以前需要展示的数据 */
@property (nonatomic, strong) NSMutableArray<MultilayerItem *> *oldShowItems;
@property(nonatomic, strong) NSNumber * studentCount;
@property(nonatomic, strong) NSDictionary * hwReportDetaiModel;

@property(nonatomic, strong)  AVPlayer * player;
@property(nonatomic, assign)  BOOL playerState;//是否点击播放
@property(nonatomic, assign)  BOOL playerFinished;//是否播放完成
@property(nonatomic, strong)   UIButton * playBtn;
@property(nonatomic, strong)   UILabel  * playTitleLabel;

@property(nonatomic, strong) CheckDetialRangDetialView *helpDetialView;
@property(nonatomic, strong) NewCheckPictureHeaderView *headerView;
@end

@implementation NewCheeckPictureReportVC

- (instancetype)initWithHomeworkId:(NSString *)homeworkId{
    self = [super init];
    if (self) {
        self.homeworkId = homeworkId;
    }
    return self;
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self pause];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationItemTitle:@""];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = nil;
    [self setupHeaderView];
    [self registerCell];
    self.tableView.backgroundColor = HexRGB(0xFCFCFC);
    self.tableView.allowsSelection = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];

    
    [self  getNetworkData];
    
}
- (void)playbackFinished{
    
    self.playerFinished = YES;
    self.playerState = NO;
    [self.playBtn.imageView.layer removeAnimationForKey:@"opacityForever_Animation"];
    [self.playTitleLabel setText: @"点击播放"];
}
#pragma mark - request请求
- (void)getNetworkData{
    
    NSDictionary * parameterDic = @{@"homeworkId":self.homeworkId};
    [self sendHeaderRequest:@"QueryPhonicsHomeworkReport" parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_QueryHomeworkReport];
}

- (void)setNetworkRequestStatusBlocks{
    WEAKSELF
    [self setSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_QueryHomeworkReport) {
            NSLog(@"%@=-==",successInfoObj);
            
            weakSelf.allDicItems = successInfoObj;
            weakSelf.Items = successInfoObj[@"bookHomeworkTypes"];
            
            strongSelf.headerView.titleLabel.text = weakSelf.allDicItems[@"clazzName"];
            [strongSelf updateTableView];
        }
    }];
}
- (void)setupHeaderView{
    _headerView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([NewCheckPictureHeaderView class]) owner:nil options:nil].firstObject;
    [_headerView.backButton addTarget:self action:@selector(backViewController) forControlEvents:UIControlEventTouchUpInside];
    _headerView.frame = CGRectMake(0, 0, self.view.frame.size.width,216);
    [_headerView.helpButton addTarget:self action:@selector(helpButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_headerView];
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 230)];
}


- (CheckDetialRangDetialView *)helpDetialView {
    if (!_helpDetialView) {
        
        _helpDetialView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CheckDetialRangDetialView class]) owner:nil options:nil].firstObject;
        _helpDetialView.allImageView.image = [UIImage imageNamed:@"08E57BB4-D49D-4165-9AA2-523108766974.jpeg"];
        _helpDetialView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
        _helpDetialView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    }
    return _helpDetialView;
}

- (void)registerCell{

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NewCheckPictureTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"NewCheckPictureTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NewCheckPictureLastTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"NewCheckPictureLastTableViewCell"];
}

#pragma mark - delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([self.allDicItems[@"cartoonHomeworkTypes"] count]>0) {//cartoonHomeworkTypes
        return 2;
    }else
        return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return  self.Items.count;
    }else if ([self.allDicItems[@"cartoonHomeworkTypes"] count]>0){
        return 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 220;
    if (indexPath.section == 1&& [self.allDicItems[@"cartoonHomeworkTypes"] count] == 1) {
        NSDictionary *tempdic = [self.allDicItems[@"cartoonHomeworkTypes"] firstObject];
        if ([@"hbpy"isEqualToString:tempdic[@"typeId"]]) {
            height = height-143;
        }else{
            height = height-44;
        }
    }
    return height;
}
//NewReportListonPriceTableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        NSDictionary *tempSectionDic = self.Items[indexPath.row];
        
        NewCheckPictureTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"NewCheckPictureTableViewCell" forIndexPath:indexPath];
        cell.rankButton.tag = indexPath.row;
        [cell.rankButton addTarget:self action:@selector(rangButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.dataDic = tempSectionDic;
        [cell configUI:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if ([self.allDicItems[@"cartoonHomeworkTypes"] count]>0){
        
        NewCheckPictureLastTableViewCell  *cell =  [tableView dequeueReusableCellWithIdentifier:@"NewCheckPictureLastTableViewCell" forIndexPath:indexPath];
        cell.dataArray = self.allDicItems[@"cartoonHomeworkTypes"];
        [cell.rangButton addTarget:self action:@selector(pictureRangButtonClick) forControlEvents:UIControlEventTouchUpInside];
        UITapGestureRecognizer *circleViewtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(circleViewtapClick:)];
        [cell.circleView addGestureRecognizer:circleViewtap];
        [cell configUI:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return [UITableViewCell new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}

#pragma mark --- 点击cell
- (void)circleViewtapClick:(UITapGestureRecognizer *)circleViewtap{
    CGPoint point = [circleViewtap locationInView:circleViewtap.view];
    NSInteger tagtag = 101;
    if (point.x<46) {
        tagtag = 101;
    }else if (point.x<46*2+38 && 46+38<point.x) {
        tagtag = 102;
    }else if (point.x<46*3+38*2 && 46*2+38*2<point.x) {
        tagtag = 103;
    }else{
        return;
    }
    
    NewReportPictureProblemTableView *priceVC = [[NewReportPictureProblemTableView alloc]initWithHomeworkId:self.homeworkId];
    priceVC.chooseTag = tagtag;
    [self pushViewController:priceVC];

}

- (void)rangButtonClick:(UIButton *)button{
    NewReportListonPriceTableView *priceVC = [[NewReportListonPriceTableView alloc]initWithHomeworkId:self.homeworkId];
    [self pushViewController:priceVC];
}
- (void)pictureRangButtonClick{
    NewReportPicturePriceTableView *priceVC = [[NewReportPicturePriceTableView alloc]initWithHomeworkId:self.homeworkId];
    [self pushViewController:priceVC];
}

- (void)helpButtonClick{
    
    UIWindow *firstWindow = [UIApplication.sharedApplication.windows firstObject];
    [firstWindow addSubview: self.helpDetialView];
}

- (BOOL )getShowBackItem{
    return YES;
}
- (BOOL)getNavBarBgHidden{
    return YES;
}

- (UIRectEdge)getViewRect{
    return UIRectEdgeAll;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section == 0) {
//        if (indexPath.row == 1) {
//            if (self.hwReportDetaiModel[@"sound"]) {
//                HWReportVoiceCell * voiceCell = [tableView cellForRowAtIndexPath:indexPath];
//                self.playBtn = [voiceCell getPlayBtn];
//                self.playTitleLabel = [voiceCell getPlayTitleLabel];
//                if (self.playerState) {
//                    [self pause];
//                }else{
//                    [self playVoice];
//                }
//            }else if (self.hwReportDetaiModel[@"photos"] && !self.hwReportDetaiModel[@"sound"] ) {
//                HWReportImgVCell * imgVCell = [tableView cellForRowAtIndexPath:indexPath];
//                [self showImg:[imgVCell.contentView viewWithTag:989898]];
//            }
//        }else if (indexPath.row == 2){
//            HWReportImgVCell * imgVCell = [tableView cellForRowAtIndexPath:indexPath];
//
//            [self showImg:[imgVCell.contentView viewWithTag:989898]];
//        }
//    }else if (indexPath.section == 1){
//        MultilayerItem * item = self.latestShowItems[indexPath.row];
//        if (item.index == 3 && [item.data isKindOfClass:[NSString class]]) {
//            [self gotoHWReportZXLXUnit:item.data];
//            [self pause];
//        }else if(item.index ==  3 ){
//
//            if (item.data[@"hwtype"] && [item.data[@"hwtype"] isEqualToString:@"jfHomework"]) {
//
//                NSString * bookId = item.data[@"bookId"];
//                NSString * bookHomeworkId =  item.data[@"bookHomeworkId"];
//                NSString * homeworkTypeId = item.data[@"homeworkTypeId"];
//                [self gotoAssistantsVCBookId:bookId withBookHomeworkId:bookHomeworkId withHomeworkTypeId:homeworkTypeId];
//                [self pause];
//            }else if ( item.data[@"hwtype"] && [item.data[@"detail"] isEqualToString:@"jfHomeworkDetail"]){
//                NSString * bookId = item.data[@"bookId"];
//                NSString * bookHomeworkId =  item.data[@"bookHomeworkId"];
//                [self gotoAssistantsVCBookId:bookId withBookHomeworkId:bookHomeworkId];
//                [self pause];
//            }
//        }else if (item.index == 2 ){
//            if ( [item.data[@"hwtype"] isEqualToString:@"khlx"]) {
//                [self gotoHWReportKHXTDetailVC:item.data];
//                [self pause];
//            }else if (item.data[@"hwtype"]  && [item.data[@"hwtype"] isEqualToString:@"ywdd"]){
//                [self gotoReportStudentHomeworkTypeId:item.data[@"homeworkTypeId"] withType:@"ywdd" withBookId:@""];
//                [self pause];
//            }else if (item.data[@"hwtype"]  && [item.data[@"hwtype"] isEqualToString:BookTypeCartoon]){
//                [self gotoReportStudentHomeworkTypeId:item.data[@"homeworkTypeId"] withType:BookTypeCartoon withBookId:item.data[@"bookId"]];
//                [self pause];
//            }
//
//        }
//    }
}

#pragma mark - < 懒加载 >
- (NSMutableArray<MultilayerItem *> *)latestShowItems
{
    if (!_latestShowItems) {
        self.latestShowItems = [[NSMutableArray alloc] init];
    }
    return _latestShowItems;
}
- (NSMutableArray<MultilayerItem *> *)Items{
    if (!_Items) {
        _Items = [NSMutableArray array];
    }
    return _Items;
}

#pragma mark --配置数据 ui
- (void)confightTableViewData:(NSDictionary *)successInfoObj{
    self.hwReportDetaiModel = successInfoObj;
    NSArray * bookArray = successInfoObj[@"bookHomeworks"];
    self.studentCount = successInfoObj[@"studentCount"];
    for (int i = 0 ; i < [bookArray count]; i++) {
        
        MultilayerItem * tempItem = [[MultilayerItem alloc]init];
        NSDictionary * bookInfo = [self getBookInfo: bookArray[i]];
        tempItem.data = bookInfo;
        tempItem.index = 0;
        tempItem.isUnfold = YES;
        tempItem.isCanUnfold = YES;
        if ( [bookInfo[@"bookType"] isEqualToString:BookTypeCartoon]) {
            //绘本
            tempItem.subs = [self getEnCartoonTypes:bookArray[i][@"homeworkTypes"] withBookId:bookArray[i][@"bookId"]];
        }
        
        
        [self.Items addObject:tempItem];
        
        MultilayerItem * bottomItem = [[MultilayerItem alloc]init];
        bottomItem.isCanUnfold = NO;
        bottomItem.index = 0;
        bottomItem.data = @"书本作业间距";
        
        [self.Items addObject:bottomItem];
        
    }
    
    
}
//书本信息
- (NSDictionary *)getBookInfo:(NSDictionary *)dic{
    NSMutableDictionary * bookInfo = [NSMutableDictionary dictionary];
    ///书名
    if (dic[@"bookName"]) {
        [bookInfo addEntriesFromDictionary:@{@"bookName":dic[@"bookName"]}];
    }
    //书本类型
    if (dic[@"bookTypeName"]) {
        [bookInfo addEntriesFromDictionary:@{@"bookTypeName":dic[@"bookTypeName"]}];
    }
    //图片
    if (dic[@"coverImage"]) {
        [bookInfo addEntriesFromDictionary:@{@"coverImage":dic[@"coverImage"]}];
    }
    //科目
    if (dic[@"subjectName"]) {
        [bookInfo addEntriesFromDictionary:@{@"subjectName":dic[@"subjectName"]}];
    }
    //练习数
    if (dic[@"workTotal"]) {
        [bookInfo addEntriesFromDictionary:@{@"workTotal":dic[@"workTotal"]}];
    }
    //书本类型 简写
    if (dic[@"bookType"]) {
        [bookInfo addEntriesFromDictionary:@{@"bookType":dic[@"bookType"]}];
    }
    //书本id
    if (dic[@"bookId"]) {
        [bookInfo addEntriesFromDictionary:@{@"bookId":dic[@"bookId"]}];
    }
    //科目 简写
    if (dic[@"subject"]) {
        [bookInfo addEntriesFromDictionary:@{@"subject":dic[@"subject"]}];
    }
    
    return bookInfo;
}

#pragma mark === 永久闪烁的动画 ======
-(CABasicAnimation *)opacityForever_Animation:(float)time
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];//必须写opacity才行。
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0.0f];//这是透明度。
    animation.autoreverses = YES;
    animation.duration = time;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];///没有的话是均匀的动画。
    return animation;
}

#pragma mark -- 英语绘本
- (NSArray <MultilayerItem *>*)getEnCartoonTypes:(NSArray * )homeworkTypes withBookId:(NSString *)bookId{
    NSMutableArray * tempArray = [NSMutableArray array];
    
    for (int i  = 0; i < [homeworkTypes count]; i++) {
        MultilayerItem * tempItem = [[MultilayerItem alloc]init];
        tempItem.index = 1;
        tempItem.isUnfold = YES;
        tempItem.isCanUnfold = YES;
        NSDictionary * homeworkInfo = homeworkTypes[i];
        tempItem.data =@{
                         @"title":homeworkInfo[@"title"],
                         @"practiceType":homeworkInfo[@"practiceType"],
                         @"bookType":BookTypeCartoon
                         };
        tempItem.subs = [self getEnCartoonThreeSubs:homeworkInfo[@"cartoonItems"] withBookId:bookId];
        [tempArray addObject:tempItem];
    };
    return tempArray;
}
- (NSArray <MultilayerItem *>*)getEnCartoonThreeSubs:(NSArray * )cartoonItems withBookId:(NSString *)bookId{
    NSMutableArray * tempArray = [NSMutableArray array];
    for (int i  = 0; i < [cartoonItems count]; i++) {
        MultilayerItem * tempItem = [[MultilayerItem alloc]init];
        tempItem.index = 2;
        tempItem.isUnfold = NO;
        tempItem.isCanUnfold = NO;
        NSDictionary * cartoonInfo  = cartoonItems[i];
        tempItem.data = @{
                          @"finishStudentCount":cartoonInfo[@"finishStudentCount"],
                          @"typeCn":cartoonInfo[@"typeCn"],
                          @"typeName":cartoonInfo[@"typeName"],
                          @"studentCount":self.studentCount,
                          @"type":cartoonInfo[@"type"],
                          @"homeworkTypeId":cartoonInfo[@"homeworkTypeId"],
                          @"hwtype":BookTypeCartoon,
                          @"bookId":bookId
                          };
        
        [tempArray addObject:tempItem];
    }
    return tempArray;
}
#pragma  mark --英语教材

// 英语 书本题目类型
- (NSArray <MultilayerItem *>*)getEnSecondSubs:(NSArray * )homeworkTypes{
    NSMutableArray * tempArray = [NSMutableArray array];
    for (int i  = 0; i < [homeworkTypes count]; i++) {
        MultilayerItem * tempItem = [[MultilayerItem alloc]init];
        tempItem.index = 1;
        tempItem.isUnfold = YES;
        tempItem.isCanUnfold = YES;
        NSDictionary *homeworkInfo  = homeworkTypes[i];
        tempItem.data = @{@"title":homeworkInfo[@"title"],
                          @"practiceType":homeworkInfo[@"practiceType"],
                          @"bookType":@"Book"
                          };
        if ([homeworkInfo[@"practiceType"] isEqualToString:@"zxlx"]) {
            //在线
            tempItem.subs = [self getEnZXLXThreeSubs:homeworkInfo[@"units"]];
        }else{
            //离线
            tempItem.subs = [self getEnOtherThreeSubs:homeworkInfo[@"units"] withPracticeType:homeworkInfo[@"practiceType"]] ;
        }
        
        [tempArray addObject:tempItem];
    }
    return tempArray;
}

#pragma mark   英语教材 其它类型
- (NSArray <MultilayerItem *>*)getEnOtherThreeSubs:(NSArray * )homeworkUnits withPracticeType:(NSString *)practiceType{
    NSMutableArray * tempArray = [NSMutableArray array];
    for (int i  = 0; i < [homeworkUnits count]; i++) {
        MultilayerItem * tempItem = [[MultilayerItem alloc]init];
        tempItem.index = 2;
        tempItem.isUnfold = NO;
        tempItem.isCanUnfold = NO;
        NSDictionary *unitInfo  = homeworkUnits[i];
        //        count = 1; //变数
        //        finishStudentCount  //完成人数
        //        homeworkTypeId //作业id
        //        nameNo = 1;//题号
        //        unitId = //单元id
        //        unitName //单元名字
        
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic addEntriesFromDictionary:@{@"unitName":unitInfo[@"unitName"],
                                        @"finishStudentCount":unitInfo[@"finishStudentCount"],
                                        @"homeworkTypeId":unitInfo[@"homeworkTypeId"],
                                        @"nameNo":unitInfo[@"nameNo"],
                                        @"studentCount":self.studentCount,
                                        @"practiceType":practiceType,
                                        @"hwtype":@"offline"
                                        }];
        if (unitInfo[@"wordCount"]) {
            [dic addEntriesFromDictionary:@{@"wordCount":unitInfo[@"wordCount"]}];
        }
        tempItem.data = dic;
        
        [tempArray addObject:tempItem];
    }
    return tempArray;
    
}
//- (NSArray <MultilayerItem *>*)getEnOtherFourWordsSubs:{}
#pragma mark --- 在线练习
// 单元
- (NSArray <MultilayerItem *>*)getEnZXLXThreeSubs:(NSArray * )homeworkUnits{
    NSMutableArray * tempArray = [NSMutableArray array];
    for (int i  = 0; i < [homeworkUnits count]; i++) {
        MultilayerItem * tempItem = [[MultilayerItem alloc]init];
        tempItem.index = 2;
        tempItem.isUnfold = YES;
        tempItem.isCanUnfold = YES;
        NSDictionary *unitInfo  = homeworkUnits[i];
        tempItem.data = @{@"unitName":unitInfo[@"unitName"],@"hwtype":@"zxlx"};
        
        tempItem.subs = [self getEnZXLXFourWordsSubs:unitInfo[@"words"] withListenAndTalk:unitInfo[@"listenAndTalk"]];
        [tempArray addObject:tempItem];
    }
    return tempArray;
}

//  单元下的词汇类型
- (NSArray <MultilayerItem *>*)getEnZXLXFourWordsSubs:(NSArray * )unitsWordsTypes withListenAndTalk:(NSArray *)unitsListenAndTalkTypes{
    NSMutableArray * tempArray = [NSMutableArray array];
    //词汇
    MultilayerItem * wordsItem = [[MultilayerItem alloc]init];
    wordsItem.index = 3;
    wordsItem.isUnfold = YES;
    wordsItem.isCanUnfold = YES;
    wordsItem.subs = [self getEnZXLXFiveWordsUnitSubs:unitsWordsTypes];
    wordsItem.data = @{@"type":@"词汇练习",@"hwtype":@"zxlx"};
    if (unitsWordsTypes && [unitsWordsTypes count] >0) {
        [tempArray addObject:wordsItem];
        
        MultilayerItem * bottomItem = [[MultilayerItem alloc]init];
        bottomItem.index = 3;
        bottomItem.isUnfold = YES;
        bottomItem.isCanUnfold = YES;
        bottomItem.data = @"zxlx";
        [tempArray addObject:bottomItem];
        
    }
    
    
    
    //听说
    MultilayerItem * listenAndTalkItem = [[MultilayerItem alloc]init];
    listenAndTalkItem.index = 3;
    listenAndTalkItem.isUnfold = YES;
    listenAndTalkItem.isCanUnfold = YES;
    listenAndTalkItem.subs = [self getEnZXLXFiveListenAndTalkUnitSubs:unitsListenAndTalkTypes];
    listenAndTalkItem.data = @{@"type":@"听说练习",@"hwtype":@"zxlx"};
    if (unitsListenAndTalkTypes && [unitsListenAndTalkTypes count] >0) {
        [tempArray addObject:listenAndTalkItem];
        
        MultilayerItem * bottomItem = [[MultilayerItem alloc]init];
        bottomItem.index = 3;
        bottomItem.isUnfold = YES;
        bottomItem.isCanUnfold = YES;
        bottomItem.data = @"other";
        [tempArray addObject:bottomItem];
    }
    return tempArray;
}
// 词汇下单元
- (NSArray <MultilayerItem *>*)getEnZXLXFiveWordsUnitSubs:(NSArray * )unitsWords{
    NSMutableArray * tempArray = [NSMutableArray array];
    for (NSDictionary *tempDic in unitsWords) {
        //词汇
        MultilayerItem * wordsItem = [[MultilayerItem alloc]init];
        wordsItem.index = 4;
        wordsItem.isUnfold = YES;
        wordsItem.isCanUnfold = YES;
        wordsItem.data = @{@"sectionName":tempDic[@"sectionName"]};
        
        wordsItem.subs = [self getEnZXLXSixWordsSubs:tempDic[@"appTypes"]];
        [tempArray addObject:wordsItem];
    }
    
    return tempArray;
    
}
//词汇练习下的听说类型下分类
- (NSArray <MultilayerItem *>*)getEnZXLXFiveListenAndTalkUnitSubs:(NSArray * )unitsListenAndTalk{
    NSMutableArray * tempArray = [NSMutableArray array];
    for (NSDictionary *tempDic in unitsListenAndTalk) {
        //词汇
        MultilayerItem * listenAndTalkItem = [[MultilayerItem alloc]init];
        listenAndTalkItem.index = 4;
        listenAndTalkItem.isUnfold = YES;
        listenAndTalkItem.isCanUnfold = YES;
        listenAndTalkItem.data = @{@"sectionName":tempDic[@"sectionName"]};
        listenAndTalkItem.subs = [self getEnZXLXSixListenAndTalkSubs:tempDic[@"appTypes"]];
        [tempArray addObject:listenAndTalkItem];
    }
    
    return tempArray;
    
}
//词汇练习下的单词类型下分类
- (NSArray <MultilayerItem *>*)getEnZXLXSixWordsSubs:(NSArray * )unitsWordsTypes{
    NSMutableArray * tempArray = [NSMutableArray array];
    for (NSDictionary *tempDic in unitsWordsTypes) {
        //词汇
        MultilayerItem * listenAndTalkItem = [[MultilayerItem alloc]init];
        listenAndTalkItem.index = 5;
        listenAndTalkItem.isUnfold = YES;
        listenAndTalkItem.isCanUnfold = YES;
        listenAndTalkItem.data = @{@"title":tempDic[@"title"]};
        listenAndTalkItem.subs = [self getEnZXLXSevenWordsSubs:tempDic[@"items"]];
        [tempArray addObject:listenAndTalkItem];
    }
    
    
    return tempArray;
}

//词汇练习下的听说类型下分类
- (NSArray <MultilayerItem *>*)getEnZXLXSixListenAndTalkSubs:(NSArray * )unitsListenAndTalkTypes{
    
    NSMutableArray * tempArray = [NSMutableArray array];
    for (NSDictionary *tempDic in unitsListenAndTalkTypes) {
        //听说
        MultilayerItem * listenAndTalkItem  = [[MultilayerItem alloc]init];
        listenAndTalkItem .index = 5;
        listenAndTalkItem .isUnfold = YES;
        listenAndTalkItem.isCanUnfold = YES;
        listenAndTalkItem.data = @{@"title":tempDic[@"title"]};
        listenAndTalkItem.subs = [self getEnZXLXSevenListenAndTalkSubs:tempDic[@"items"]];
        [tempArray addObject:listenAndTalkItem];
    }
    
    return tempArray;
}
// 拼写  意识 分类
- (NSArray <MultilayerItem *>*)getEnZXLXSevenWordsSubs:(NSArray * )wordsTypeTypes{
    NSMutableArray * tempArray = [NSMutableArray array];
    for (NSDictionary *tempDic in wordsTypeTypes) {
        //词汇
        MultilayerItem * wordsItem = [[MultilayerItem alloc]init];
        wordsItem.index = 6;
        wordsItem.isUnfold = NO;
        //        "typeEn" //类型简写
        //        "homeworkTypeId"://类型id
        //        "typeCn"//类型名称
        //        "logo"://类型icon
        //        "hasScoreLevel"//是否有成绩 用于区分是否 听写
        //        "correctRate": //完成比例
        //        "masteLevel"://掌握程度
        //        "finishStudentCount" //完成学生数
        NSMutableDictionary * itemDic = [NSMutableDictionary dictionary];
        [itemDic addEntriesFromDictionary:@{@"typeEn":tempDic[@"typeEn"],
                                            @"homeworkTypeId":tempDic[@"homeworkTypeId"],
                                            @"typeCn":tempDic[@"typeCn"],
                                            @"finishStudentCount":tempDic[@"finishStudentCount"],
                                            @"hasScoreLevel":tempDic[@"hasScoreLevel"]
                                            }];
        if (tempDic[@"correctRate"]) {
            [itemDic addEntriesFromDictionary:@{ @"correctRate":tempDic[@"correctRate"]}];
        }
        if (tempDic[@"levels"]) {
            [itemDic addEntriesFromDictionary:@{@"levels":tempDic[@"levels"]}];
        }
        if (tempDic[@"logo"]) {
            [itemDic addEntriesFromDictionary:@{@"logo":tempDic[@"logo"]}];
        }
        if (tempDic[@"masteLevel"]) {
            [itemDic addEntriesFromDictionary:@{@"masteLevel":tempDic[@"masteLevel"]}];
        }
        
        wordsItem.data = tempDic;
        
        [tempArray addObject:wordsItem];
    }
    
    return tempArray;
}

// 听说 分类
- (NSArray <MultilayerItem *>*)getEnZXLXSevenListenAndTalkSubs:(NSArray * )listenAndTalkTypeTypes{
    NSMutableArray * tempArray = [NSMutableArray array];
    for (NSDictionary *tempDic in listenAndTalkTypeTypes) {
        //词汇
        MultilayerItem * wordsItem = [[MultilayerItem alloc]init];
        wordsItem.index = 6;
        wordsItem.isUnfold = NO;
        //        "typeEn" //类型简写
        //        "homeworkTypeId"://类型id
        //        "typeCn"//类型名称
        //        "logo"://类型icon
        //        "hasScoreLevel"//是否有成绩
        //        "levels": //各成绩分组完成集合   键值队{precent 完成比例 ，studentCount 学生数 }
        //
        //        "finishStudentCount" //完成学生数
        wordsItem.data = @{@"typeEn":tempDic[@"typeEn"],
                           @"homeworkTypeId":tempDic[@"homeworkTypeId"],
                           @"typeCn":tempDic[@"typeCn"],
                           @"logo":tempDic[@"logo"],
                           
                           @"levels":tempDic[@"levels"],
                           @"finishStudentCount":tempDic[@"finishStudentCount"],
                           @"hasScoreLevel":tempDic[@"hasScoreLevel"]
                           };
        
        [tempArray addObject:wordsItem];
    }
    
    
    return tempArray;
}

#pragma mark --- 播放语音
- (void)playVoice{
    
    NSString * soundStr = self.hwReportDetaiModel[@"sound"];
    NSURL * url  = [NSURL URLWithString:soundStr];
    AVPlayerItem * songItem = [[AVPlayerItem alloc]initWithURL:url];
    if (self.player) {
        if (self.playerFinished) {
            [self currentItemRemoveObserver];
            [self.player replaceCurrentItemWithPlayerItem:songItem];
            [songItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
            self.playerFinished = NO;
        }else{
            [self.player play];
            self.playerState  = YES;
        }
        
    }else{
        self.player = [[AVPlayer alloc]initWithPlayerItem:songItem];
        [songItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    }
    [self.playBtn.imageView.layer addAnimation:[self opacityForever_Animation:1] forKey:@"opacityForever_Animation"];
    [self.playTitleLabel setText: @"播放中..."];
    
}
- (void)pause{
    if (self.player) {
        [self.player pause];
        self.playerState  = NO;
        [self.playBtn.imageView.layer removeAnimationForKey:@"opacityForever_Animation"];
        [self.playTitleLabel setText: @"点击播放"];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"status"]) {
        switch (self.player.status) {
            case AVPlayerStatusUnknown:{
                NSLog(@"KVO：未知状态，此时不能播放");
                NSString * content = @"未知状态，此时不能播放";
                [self showAlert:TNOperationState_Fail content:content block:nil];
                
            }
                break;
            case AVPlayerStatusReadyToPlay:{
                [self hideHUD];
                NSLog(@"KVO：准备完毕，可以播放");
                [self.player play];
                self.playerState = YES;
            }
                break;
            case AVPlayerStatusFailed:
                NSLog(@"KVO：加载失败，网络或者服务器出现问题");
            {
                [self hideHUD];
                NSString * content = @"语音播放失败！请稍后再试";
                [self showAlert:TNOperationState_Fail content:content block:nil];
                
            }
                break;
            default:
                break;
        }
    }
}

-(void)currentItemRemoveObserver
{
    [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    
    //    [self.player removeTimeObserver:_timer];
}



#pragma mark -- 查看图片
- (void)showImg:(UIView *)containerView{
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.currentImageIndex = 0;
    browser.sourceImagesContainerView = containerView;
    browser.imageCount = [self.hwReportDetaiModel[@"photos"]  count];
    browser.delegate = self;
    [browser show];
}

#pragma mark - SDPhotoBrowserDelegate

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *imageName = self.hwReportDetaiModel[@"photos"][index];
    //    NSURL *url = [[NSBundle mainBundle] URLForResource:imageName withExtension:nil];
    NSURL * url = [NSURL URLWithString:imageName];
    return url;
}

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    
    return nil;
}

#pragma mark -----
- (void)gotoHWReportZXLXUnit:(NSString *)type{
    HWReportZXLXUnitDetailStyle style = HWReportZXLXUnitDetailStyle_normal;
    NSString * titleStr = @"";
    if ([type isEqualToString:@"zxlx"]) {
        style = HWReportZXLXUnitDetailStyle_words;
        titleStr = @"词汇练习";
    }else if ([type isEqualToString:@"other"]){
        style = HWReportZXLXUnitDetailStyle_listenAndTalk;
        titleStr = @"听说练习";
    }
    HWReportZXLXUnitDetailVC * detailVC = [[HWReportZXLXUnitDetailVC  alloc]initWithStyle:style withDic:self.hwReportDetaiModel withTitle:titleStr];
    [self pushViewController:detailVC];
}
#pragma mark ---
// 查课后练习
- (void)gotoHWReportKHXTDetailVC:(NSDictionary *)itemDic{
    
    HomeworkDetailKHLXListViewController * khlxListVC = [[HomeworkDetailKHLXListViewController alloc]initWithHomeworkId:self.homeworkId withHomeworkTypeId:itemDic[@"homeworkTypeId"] withStyle:HomeworkDetailKHLXListVCStyle_report];
    [self pushViewController:khlxListVC];
}

// 查看书本 所有教辅信息
- (void) gotoAssistantsVCBookId:(NSString *)bookId withBookHomeworkId:(NSString *)bookHomeworkId{
    
    JFHomeworkQuestionViewController * questionVC = [[JFHomeworkQuestionViewController alloc]initWithHomeworkId:self.homeworkId withBookId:bookId withBookHomeworkId:bookHomeworkId];
    [self pushViewController:questionVC];
    
}
// 查看 单个  教辅信息
- (void) gotoAssistantsVCBookId:(NSString *)bookId withBookHomeworkId:(NSString *)bookHomeworkId withHomeworkTypeId:(NSString *)homeworkTypeId{
    
    JFHomeworkQuestionViewController * questionVC = [[JFHomeworkQuestionViewController alloc]initWithHomeworkId:self.homeworkId withBookId:bookId withBookHomeworkId:bookHomeworkId withHomeworkTypeId:homeworkTypeId];
    [self pushViewController:questionVC];
    
}

// 学生列表
- (void)gotoReportStudentHomeworkTypeId:(NSString *)homeworkTypeId withType:(NSString *)type withBookId:(NSString *)bookId{
    HWReportStudentListVCStyle  style = 0;
    if ([type isEqualToString:@"ywdd"]) {
        style = HWReportStudentListVCStyle_ywdd;
    }else if ([type isEqualToString:BookTypeCartoon]){
        style = HWReportStudentListVCStyle_cartoon;
    }
    HWReportStudentListVC * studentListVC = [[HWReportStudentListVC alloc]initWithHomeworkId:self.homeworkId withHomeworkTypeId:homeworkTypeId withStyle:style withBookId:bookId];
    [self pushViewController:studentListVC];
    
}

//- (void)confightHeaderViewData:(NSDictionary * )successInfoObj{
//
//    HWReportHeaderView *headerView = (HWReportHeaderView *)self.tableView.tableHeaderView;
//    NSMutableDictionary * headerDic =[NSMutableDictionary dictionary];
//    [headerDic addEntriesFromDictionary: @{@"text":successInfoObj[@"text"],
//                                           @"studentCount":successInfoObj[@"studentCount"],
//                                           @"subjectName":successInfoObj[@"subjectName"],
//                                           @"subjectId":successInfoObj[@"subjectId"],
//                                           @"finishedCount":successInfoObj[@"finishedCount"],
//                                           @"feedbackName":successInfoObj[@"feedbackName"],
//                                           @"feedback":successInfoObj[@"feedback"],
//                                           @"gradeName":successInfoObj[@"gradeName"],
//                                           @"endTime":successInfoObj[@"endTime"],
//                                           @"clazzName":successInfoObj[@"clazzName"]
//                                           }];
//    if (successInfoObj[@"sound"]) {
//        [headerDic addEntriesFromDictionary:@{@"sound":successInfoObj[@"sound"]}];
//    }
//    if (successInfoObj[@"photos"]) {
//        [headerDic addEntriesFromDictionary:@{@"photos":successInfoObj[@"photos"]}];
//    }
//
//    [headerView setupHeaderData:headerDic];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
