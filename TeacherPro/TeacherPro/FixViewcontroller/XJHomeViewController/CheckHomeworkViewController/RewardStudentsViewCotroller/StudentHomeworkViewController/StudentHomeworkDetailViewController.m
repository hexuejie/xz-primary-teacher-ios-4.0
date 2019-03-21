//
//  StudentHomeworkDetailViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/7/9.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "StudentHomeworkDetailViewController.h"
#import "HomeworkUnitDetailViewController.h"
#import "StudentHomeworkUnitSectionCell.h"
#import "StudentHomeworkStudentInfoCell.h"
#import "StudentHomeworkSectionHeaderCell.h"
#import "StudentHomeworkImgCell.h"
#import "PlaybackControlCell.h"

#import "StudentHomeworkPictureBooksCell.h"
#import "StudentHomeworkDetailModel.h"
#import "SDAutoLayout.h"
#import "ZFPlayer.h"
#import "StudentNoFeedbackCell.h"
#import "StudentHomeworkBookUnitSctionCell.h"
#import "StudentHomeworkUnitTitleCell.h"
#import "StudentHomeworkChapterCell.h"
#import "StudentHomeworkKHLXInfoCell.h"
#import "ProUtils.h"
#import "StudentKHLXHomeworkDetailVC.h"
#import "UIViewController+HBD.h"
#import "HWBookInfoCell.h"
#import "StudentHomeworkJFInfoCell.h"
#import "JFHomeNoItemViewController.h"
#import "HWReportCartoonVC.h"


NSString * const StudentHomeworkUnitSectionCellIdentifier = @"StudentHomeworkUnitSectionCellIdentifier";
NSString * const StudentHomeworkStudentInfoCellIdentifier = @"StudentHomeworkStudentInfoCellIdentifier";
NSString * const StudentHomeworkSectionHeaderCellIdentifier = @"StudentHomeworkSectionHeaderCellIdentifier";
NSString * const StudentHomeworkImgCellIdentifier = @"StudentHomeworkImgCellIdentifier";
NSString * const StudentHomeworkPlaybackControlCellIdentifier = @"StudentHomeworkPlaybackControlCellIdentifier";
NSString * const StudentHomeworkBookInfoCellIdentifier = @"StudentHomeworkBookInfoCellIdentifier";
NSString * const StudentHomeworkPictureBooksCellIdentifier = @"StudentHomeworkPictureBooksCellIdentifier";
NSString * const StudentHomeworkNoFeedbackCellIdentifier = @"StudentHomeworkNoFeedbackCellIdentifier";
NSString * const StudentHomeworkBookUnitSctionCellIdentifier = @"StudentHomeworkBookUnitSctionCellIdentifier";
NSString * const StudentHomeworkUnitTitleCellIdentifier = @"StudentHomeworkUnitTitleCellIdentifier";
NSString * const StudentHomeworkChapterCellIdentifier = @"StudentHomeworkChapterCellIdentifier";
NSString * const StudentHomeworkKHLXInfoCellIdentifier = @"StudentHomeworkKHLXInfoCellIdentifier";
NSString * const StudentHomeworkJFInfoCellIdentifier = @"StudentHomeworkJFInfoCellIdentifier";
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~/
//书本练习展示类型

//书本 信息
NSString *   BOOKINFO = @"BOOKINFO";

//绘本单元
NSString *   CartoonUnit = @"CartoonUnit";

//书本在线单元
NSString *   BookZxlxSection = @"BookZxlxSection";

//书本在线课后练习单元
NSString *   BookKHLXSection = @"BookKHLXSection";
//书本其它单元
NSString *   BookOtherSection = @"BookOtherSection";

//在线练习单元
NSString *   zxlxUnit = @"zxlxUnit";
//在线练习章节
NSString *   zxlxChapter = @"zxlxChapter";
//在线练习单词
NSString *   wordInfo = @"wordInfo";
//在线练习听写内容
NSString *   listenAndTalkInfo = @"listenAndTalkInfo";

//类型
NSString *   cellTypeKey = @"cellTypeKey";


#define  kSectionDefault    5
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~/
@interface StudentHomeworkDetailViewController ()<StudentHomeworkStudentInfoCellDelegate,ZFPlayerDelegate>{
    CGFloat _gradientProgress;
}
@property(nonatomic, copy) NSString * homeworkId;
@property(nonatomic, copy) NSString * studentId;
@property(nonatomic, copy) NSString * studentName;
@property(nonatomic, strong) StudentHomeworkDetailModel * model;
@property(nonatomic, strong)   NSDictionary* practiceTypes ;//教材教辅字段类型
@property(nonatomic, strong)   NSDictionary* cartoonTypes  ;//绘本类型字段
@property(nonatomic, strong)   NSMutableArray*  bookSectionUnits;
@property(nonatomic,strong) NSDictionary * unityIconDic;//字段对应的图片
@property (nonatomic, strong) ZFPlayerView        *playerView;
@property (nonatomic, assign) BOOL  isCheck;

@end

@implementation StudentHomeworkDetailViewController

- (instancetype)initWithStudent:(NSString *)studentId withStudentName:(NSString *)studentName withHomeworkId:(NSString *)homeworkId withHomeworkState:(BOOL)isCheck{
    
    self = [super init];
    if (self) {
        self.studentId = studentId;
        self.homeworkId = homeworkId;
        self.studentName = studentName;
        self.isCheck = isCheck;
    }
    return self;
}

- (instancetype)initWithStudent:(NSString *)studentId withStudentName:(NSString *)studentName withHomeworkId:(NSString *)homeworkId withHomeworkState:(BOOL)isCheck withStudentList:(NSArray *)studentList withCurrenntIndex:(NSInteger)currenntIndex{
    self = [super init];
    if (self) {
        self.studentList = studentList;
        self.isCheck = isCheck;
        self.homeworkId = homeworkId;
        self.studentId = studentId;
        self.studentName = studentName;
        self.currenntIndex = currenntIndex;
    }
    
    return self;
}

/// 自定义导航条
- (void)customizeNavigationInterface {
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:17 weight:UIFontWeightMedium]}];
    [[UINavigationBar appearance] setTintColor:project_main_blue];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [[UINavigationBar appearance]setShadowImage:[self createImageWithColor:tn_border_color withFrame:CGRectMake(0, 0, IPHONE_WIDTH, 0.1f)]];
    [[UIApplication sharedApplication]  setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [super  customizeNavigationInterface];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillAppear:(BOOL)animated{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent ;
    [self navUIBarBackground:0];
}


- (UIImage *)getButtonItem{
    return  [[UIImage imageNamed:@"back_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self customizeNavigationInterface];
    [self setNavigationItemTitle:@"作业详情"];
    [self setupData];
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, FITSCALE(50))];
    footerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView =footerView;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = project_background_gray;
}

- (void)setupData{
    
    self.practiceTypes = [ProUtils getHomworkDetailPracticeTypes];
    
    self.cartoonTypes = [ProUtils getHomworkDetailCartoonTypes];
    
    self.unityIconDic = [ProUtils getZXLXUnitIconDic];
    
    
}
- (void)getNormalTableViewNetworkData{
    
    [self requestStudentHomeworkScore];
}
- (void)registerCell{
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([StudentHomeworkStudentInfoCell class]) bundle:nil] forCellReuseIdentifier:StudentHomeworkStudentInfoCellIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PlaybackControlCell class]) bundle:nil] forCellReuseIdentifier:StudentHomeworkPlaybackControlCellIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([StudentHomeworkSectionHeaderCell class]) bundle:nil] forCellReuseIdentifier:StudentHomeworkSectionHeaderCellIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([StudentHomeworkUnitSectionCell class]) bundle:nil] forCellReuseIdentifier:StudentHomeworkUnitSectionCellIdentifier];
    
    
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([StudentHomeworkPictureBooksCell class]) bundle:nil] forCellReuseIdentifier:StudentHomeworkPictureBooksCellIdentifier];
    
    //    [self.tableView registerNib: [UINib nibWithNibName:NSStringFromClass([ReleaseBookworkCell class]) bundle:nil] forCellReuseIdentifier:StudentHomeworkBookworkCellIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HWBookInfoCell class]) bundle:nil] forCellReuseIdentifier:StudentHomeworkBookInfoCellIdentifier];
    
    [self.tableView registerClass: [StudentHomeworkImgCell class] forCellReuseIdentifier:StudentHomeworkImgCellIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([StudentNoFeedbackCell class]) bundle:nil] forCellReuseIdentifier:StudentHomeworkNoFeedbackCellIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([StudentHomeworkBookUnitSctionCell class]) bundle:nil] forCellReuseIdentifier:StudentHomeworkBookUnitSctionCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([StudentHomeworkUnitTitleCell class]) bundle:nil] forCellReuseIdentifier:StudentHomeworkUnitTitleCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([StudentHomeworkChapterCell class]) bundle:nil] forCellReuseIdentifier:StudentHomeworkChapterCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([StudentHomeworkKHLXInfoCell class]) bundle:nil] forCellReuseIdentifier:StudentHomeworkKHLXInfoCellIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([StudentHomeworkJFInfoCell class]) bundle:nil] forCellReuseIdentifier:StudentHomeworkJFInfoCellIdentifier];
    
}





- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    NSInteger  section = kSectionDefault;
    if ([self.bookSectionUnits count] >0) {
        section  = [self.bookSectionUnits count] + kSectionDefault ;
    }
    return   section  ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger  row = 2;
    if (section == 0) {
        row = 1;
    }else if (section ==1){
        if ([self.model.homeworkFeedback isEqualToString:@"photo"] || [self.model.homeworkFeedback isEqualToString:@"sound"]) {
            
            row = 2;
        }
        else{
            row =0;
        }
        
    }else  if(section == 2){
        if ([self.bookSectionUnits count] >0) {
            row = 0;
//             row = 1;
        }else{
            row = 0;
        }
        
    }else if(section == 3){
        if ([self.model.hasKhlxHomeworks boolValue]) {
            row = 1;
        }else{
            row = 0;
        }
        
    }else if(section == 4){
        
        if ([self.model.hasJFHomeworks boolValue]) {
            row = 1;
        }else{
            row = 0;
        }
        
    } else {
        NSInteger bookSection = section - kSectionDefault;
        NSDictionary * sectionInfo = self.bookSectionUnits[bookSection];
        if ([sectionInfo[cellTypeKey] isEqualToString:BookKHLXSection]) {
            row = 1;
        }else if ([sectionInfo[cellTypeKey] isEqualToString:CartoonUnit]) {
            row = 1;
        }else  if ([sectionInfo[cellTypeKey] isEqualToString:BookZxlxSection]) {
            NSArray * tempArray =  sectionInfo[@"detail"] ;
            row = 1 + [tempArray count];
        }else if([sectionInfo[cellTypeKey] isEqualToString:BookOtherSection]){
            NSArray * tempArray =  sectionInfo[@"detail"] ;
            row = 1 + [tempArray count];
        }else if ([sectionInfo[cellTypeKey] isEqualToString:BOOKINFO]){
            
            row = 1;
        }
        
        
    }
    return row;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat height = 0;
    if(indexPath.section == 0){
        height = 140 + NavigationBar_Height;
    }else if (indexPath.section == 1){
        if(indexPath.row == 0){
            height = FITSCALE(30);
        }else if (indexPath.row == 1){
            
            if ([self.model.studentFeedback isEqualToString:@"photo"] ||[self.model.studentFeedback isEqualToString:@"sound"]) {
                if ([self.model.feedbackPhotos count] > 0) {
                    height =  [ tableView cellHeightForIndexPath:indexPath model:self.model keyPath:@"model" cellClass:[StudentHomeworkImgCell class] contentViewWidth:[self cellContentViewWith]] ;
                }else if ([self.model.feedbackSound length] >0){
                    
                    height = FITSCALE(44);
                }
            } else{
                
                height = FITSCALE(44);
            }
            
        }
    }else  if(indexPath.section == 2){
        
//        height = FITSCALE(30);
        height = 0.00001;
    }else if(indexPath.section == 3){
        
        if ([self.model.hasKhlxHomeworks boolValue]) {
            height = FITSCALE(50);
        }else{
            height = FITSCALE(0);
        }
        
    }else if( indexPath.section == 4){
        if ([self.model.hasJFHomeworks boolValue]) {
            height = FITSCALE(50);
        }else{
            height = FITSCALE(0);
        }
    } else {
        NSInteger section = indexPath. section - kSectionDefault;
        NSDictionary * sectionInfo = self.bookSectionUnits[section];
        
        //书本信息
        if ([sectionInfo[cellTypeKey] isEqualToString:BOOKINFO]) {
            height = FITSCALE(130);
        }else {
            //选的类型
            
            if ([sectionInfo[cellTypeKey] isEqualToString:CartoonUnit]) {
                height = FITSCALE(60);
            }else  if ([sectionInfo[cellTypeKey] isEqualToString:BookZxlxSection]) {
                
                if (indexPath.row ==0) {
                    height = FITSCALE(50);
                }else {
                    NSInteger tempRow = indexPath.row-1;
                    NSArray * tempArray =  sectionInfo[@"detail"] ;
                    if ([tempArray[tempRow][cellTypeKey] isEqualToString:zxlxUnit]) {
                        height = FITSCALE(44);
                    }else  if ([tempArray[tempRow ][cellTypeKey] isEqualToString:zxlxChapter]) {
                        height = FITSCALE(30);
                    }else  if ([tempArray[tempRow][cellTypeKey] isEqualToString:wordInfo]) {
                        height = FITSCALE(44);
                    }else  if ([tempArray[tempRow][cellTypeKey] isEqualToString:listenAndTalkInfo]) {
                        height = FITSCALE(44);
                    }
                }
            }else if([sectionInfo[cellTypeKey] isEqualToString:BookOtherSection]){
                if (indexPath.row == 0) {
                    height = FITSCALE(50);
                }else
                    height = FITSCALE(44);
            }
            
        }
        
        
    }
    return height;
}

- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    if (self.tableView.editing) {
        width = width - FITSCALE(20);
    }
    
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat headerHeight = 0.00000001;
    if(section == 2){
        if ([self.bookSectionUnits count] >0) {
            headerHeight = FITSCALE(7);
        }
        
    }else if(section == 3){
        if ([self.model.hasKhlxHomeworks boolValue]) {
            headerHeight = FITSCALE(4);
        }
    }else if( section == 4){
        if ([self.model.hasJFHomeworks boolValue]) {
            headerHeight = FITSCALE(4);
        }
    }else if (section ==5){
        headerHeight = 0.00000001;
    }else if (section >5){
        NSInteger  tempSection =  section - kSectionDefault;
        
        NSDictionary * sectionInfo = self.bookSectionUnits[tempSection];
        if ([sectionInfo[cellTypeKey] isEqualToString:CartoonUnit]){
            headerHeight = FITSCALE(0.000001);
        }else{
            headerHeight = FITSCALE(7);
        }
    }
    return headerHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    CGFloat footerHeight =  0.0001;
    if (section  > 4){
        
        NSInteger  tempSection =  section - kSectionDefault;
        NSDictionary * sectionInfo = self.bookSectionUnits[tempSection];
        //书本信息
        if ([sectionInfo[cellTypeKey] isEqualToString:BOOKINFO]){
            footerHeight = FITSCALE(7);
      
        }
        
    }
    
    return footerHeight;
}

- ( UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView * footerView = [[UIView alloc]init];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}
- ( UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headerView = [UIView  new];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = nil;
    if (indexPath.section ==  0) {
        StudentHomeworkStudentInfoCell * tempCell  = [tableView dequeueReusableCellWithIdentifier:StudentHomeworkStudentInfoCellIdentifier];
        NSString * coin = @"";
        if (self.model.coin) {
            if ([self.model.coin integerValue] == 0) {
                coin = @"";
            }else{
                coin = [NSString stringWithFormat:@"奖励：%@学豆",self.model.coin];
            }
        }
        
        if (!self.isCheck) {
            //            coin = [NSString stringWithFormat:@"奖励：0学豆"];
            coin = @"";
        }
        if (self.model) {
            [tempCell setupStuentName:self.studentName withCoin:coin withResults:self.model withStudentList:self.studentList withCurrenntIndex:self.currenntIndex];
        }
        tempCell.currentPage = self.currenntIndex;
        tempCell.delegate = self;
        cell = tempCell;
    }else if(indexPath.section == 1){
        
        cell = [self confightBackInfoTableView:tableView withIndexPath:indexPath ];
        
    }else if(indexPath.section == 2){
        StudentHomeworkSectionHeaderCell * headerCell = [tableView dequeueReusableCellWithIdentifier:StudentHomeworkSectionHeaderCellIdentifier];
        [headerCell setupName:@"书本作业"];
        cell = headerCell;
        
        
    }else if(indexPath.section == 3){
        
        cell = [self configthKHLXTableView:tableView withIndexPath:indexPath];
        
    }else if(indexPath.section == 4){
        
        cell = [self configthJFTableView:tableView withIndexPath:indexPath];
        
    }else{
        NSInteger  section = indexPath. section - kSectionDefault;
        
        NSDictionary * sectionInfo = self.bookSectionUnits[section];
        
        //书本信息
        if ([sectionInfo[cellTypeKey] isEqualToString:BOOKINFO]) {
            
            HWBookInfoCell * tempCell  = [tableView dequeueReusableCellWithIdentifier:StudentHomeworkBookInfoCellIdentifier];
            [tempCell setupInfo:sectionInfo];
            
            cell = tempCell;
            
        }else {
            
            if ([sectionInfo[cellTypeKey] isEqualToString:CartoonUnit]) {
                
                cell = [self configthCartoonUnitTableView:tableView withIndexPath:indexPath withSectionInfo:sectionInfo];
                
            }else  if ([sectionInfo[cellTypeKey] isEqualToString:BookZxlxSection]) {
                
                cell = [self configthZXLXTableView:tableView withIndexPath:indexPath withSectionInfo:sectionInfo];
            } else if([sectionInfo[cellTypeKey] isEqualToString:BookOtherSection]){
                
                cell = [self configthOhterTableView:tableView withIndexPath:indexPath withSectionInfo:sectionInfo];
            }
            
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//反馈 图片音频其它信息
- (UITableViewCell *)confightBackInfoTableView:(UITableView *)tableView  withIndexPath:(NSIndexPath *)indexPath  {
    UITableViewCell * cell = nil;
    if (indexPath.row == 0) {
        StudentHomeworkSectionHeaderCell * headerCell = [tableView dequeueReusableCellWithIdentifier:StudentHomeworkSectionHeaderCellIdentifier];
        NSString * headerName = @"反馈情况";
        
        [headerCell setupName: headerName];
        cell = headerCell;
    }else if (indexPath.row == 1){
        
        if ([self.model.feedbackPhotos count] >0) {
            //图片反馈
            StudentHomeworkImgCell * tempCell  = [tableView dequeueReusableCellWithIdentifier:StudentHomeworkImgCellIdentifier];
            tempCell.model = self.model;
            cell = tempCell;
            
        }else if ([self.model.feedbackSound length] >0){
            
            //录音反馈
            PlaybackControlCell * tempCell = [tableView dequeueReusableCellWithIdentifier:StudentHomeworkPlaybackControlCellIdentifier];
            tempCell.indexPath = indexPath;
            [tempCell resetVoiceView];
            WEAKSELF
            tempCell.playIndexPathBlock = ^(BOOL playBtnSelected, PlaybackControlCell *cell, NSIndexPath *indexPath) {
                STRONGSELF
                if (playBtnSelected) {
                    //当前点击的播放的语音是上次播放的 且为暂停状态
                    if (strongSelf.playerView &&[strongSelf.playerView getCurrentPlayerIndex] && [strongSelf.playerView getCurrentPlayerIndex] == indexPath &&strongSelf.playerView.isPauseByUser) {
                        [strongSelf.playerView play];
                    }else{
                        // 取出字典中的第一视频URL
                        NSURL *videoURL = [NSURL URLWithString:strongSelf.model.feedbackSound ];
                        ZFPlayerModel *playerModel = [[ZFPlayerModel alloc] init];
                        //        playerModel.title            = model.title;
                        playerModel.videoURL         =  videoURL;
                        //        playerModel.placeholderImageURLString = model.coverForFeed;
                        playerModel.scrollView       = weakSelf.tableView;
                        playerModel.indexPath        = indexPath;
                        // 赋值分辨率字典
                        //        playerModel.resolutionDic    = dic;
                        // player的父视图tag
                        playerModel.fatherViewTag    = cell.fatherView.tag;
                        
                        // 设置播放控制层和model
                        [strongSelf.playerView playerControlView:nil playerModel:playerModel playerView:cell];
                        // 下载功能
                        strongSelf.playerView.hasDownload = NO;
                        // 自动播放
                        [strongSelf.playerView autoPlayTheVideo];
                        
                    }
                }else{
                    [strongSelf.playerView pause];
                }
            };
            
            cell = tempCell;
        }else{
            
            StudentNoFeedbackCell * tempCell = [tableView dequeueReusableCellWithIdentifier:StudentHomeworkNoFeedbackCellIdentifier];
            
            cell = tempCell;
        }
    }
    return cell;
}
//课后习题

- (UITableViewCell *)configthKHLXTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath  {
    UITableViewCell * cell = nil;
    StudentHomeworkKHLXInfoCell * tempCell = [tableView dequeueReusableCellWithIdentifier:StudentHomeworkKHLXInfoCellIdentifier];
    [tempCell setupRightNumber:self.model.rightQuestCount andWrongNumber:self.model.errorQuestCount];
    tempCell.detailBlock = ^{
        [self gotoKHLXVC];
    };
    cell = tempCell;
    return cell;
}

//教辅
- (UITableViewCell *)configthJFTableView:(UITableView *)tableView  withIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = nil;
    StudentHomeworkJFInfoCell * tempCell = [tableView dequeueReusableCellWithIdentifier:StudentHomeworkJFInfoCellIdentifier];
    
    [tempCell setupInfoCell: self.model.unknowQuestions];
    tempCell.jfDetailBlock = ^{
        [self gotoUnOnlineAssistantsQuestionVC];
    };
    cell = tempCell;
    return cell;
}
//绘本
- (UITableViewCell *)configthCartoonUnitTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath  withSectionInfo:(NSDictionary *)sectionInfo{
    
    NSString * title = self.cartoonTypes[sectionInfo[@"title"]];
    NSString * imageName = self.unityIconDic[sectionInfo[@"title"]];
    //绘本
    StudentHomeworkPictureBooksCell * tempCell  = [tableView dequeueReusableCellWithIdentifier:StudentHomeworkPictureBooksCellIdentifier];
    if ([sectionInfo[@"title"] isEqualToString:@"hbxt"] || [sectionInfo[@"title"] isEqualToString:@"hbpy"]) {
        [tempCell setupShowScore:sectionInfo[@"detail"] withTitle:title withImgName:imageName];
    }else{
        [tempCell setupScore:sectionInfo[@"detail"] withTitle:title withImgName:imageName];
    }
    
    if ([sectionInfo[@"title"] isEqualToString:@"hbpy"]) {
        [tempCell setupArrowImgV:YES];
    }else{
        [tempCell setupArrowImgV:NO];
    }
    return  tempCell;
}

- (UITableViewCell *)configthZXLXTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath  withSectionInfo:(NSDictionary *)sectionInfo{
    UITableViewCell * cell = nil;
    if (indexPath.row == 0) {
        //在线练习类型 cell
        StudentHomeworkBookUnitSctionCell * headerCell = [tableView dequeueReusableCellWithIdentifier:StudentHomeworkBookUnitSctionCellIdentifier];
        NSString * key =  sectionInfo[@"title"];
        NSString * name =  self.practiceTypes [key];
        [headerCell setupTitle:name];
        cell = headerCell;
    }else{
        //单元 块 内容cell
        
        NSArray * tempArray =  sectionInfo[@"detail"] ;
        NSDictionary *detailInfo = tempArray[indexPath.row - 1];
        if ([detailInfo[cellTypeKey] isEqualToString:zxlxUnit]) {
            //在线练习类型  单元标题
            StudentHomeworkUnitTitleCell * headerCell = [tableView dequeueReusableCellWithIdentifier:StudentHomeworkUnitTitleCellIdentifier];
            [headerCell setupUnitTitle:detailInfo[@"title"]];
            cell = headerCell;
        }else  if ([detailInfo[cellTypeKey] isEqualToString:zxlxChapter]) {
            //在线练习类型 单元章节
            StudentHomeworkChapterCell * headerCell = [tableView dequeueReusableCellWithIdentifier:StudentHomeworkChapterCellIdentifier];
            [headerCell setupChapterTitle:detailInfo[@"title"]];
            cell = headerCell;
        }else{
            
            NSString * key =  sectionInfo[@"title"];
            NSString * name = @"";
            name =  self.practiceTypes [key];
            
            //教材教辅
            StudentHomeworkUnitSectionCell * tempCell = [tableView dequeueReusableCellWithIdentifier:StudentHomeworkUnitSectionCellIdentifier];
            tempCell.index = indexPath;
            
            NSString * imageName = @"";
            if ([key isEqualToString:@"ldkw"]) {
                imageName = @"homework_ldkw_icon";
            }
            if ([key isEqualToString:@"tkwly"]) {
                imageName = @"homework_tkwly_icon";
            }
            if ([key isEqualToString:@"dctx"]) {
                imageName = @"homework_dctx_icon";
            }
            if ([key isEqualToString:@"zxlx"]) {
                NSString * key = detailInfo[@"typeEn"];
                if ( key) {
                    imageName = self.unityIconDic[key];
                }
                
            }
            [tempCell setupUnitSectionInfo:detailInfo withImageName:imageName withType:key];
            tempCell.unitDetailBlock = ^(NSIndexPath *index) {
                
                [self selectedIndexPath:index];
            };
            cell = tempCell;
            
        }
        
    }
    return cell;
}


- (UITableViewCell *)configthOhterTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath  withSectionInfo:(NSDictionary *)sectionInfo{
    UITableViewCell * cell = nil;
    if (indexPath.row == 0) {
        StudentHomeworkBookUnitSctionCell * headerCell = [tableView dequeueReusableCellWithIdentifier:StudentHomeworkBookUnitSctionCellIdentifier];
        NSString * key =  sectionInfo[@"title"];
        NSString * name =  self.practiceTypes [key];
        [headerCell setupTitle:name];
        cell = headerCell;
    }else{
        
        NSArray * tempArray =  sectionInfo[@"detail"] ;
        NSDictionary *detailInfo = tempArray[indexPath.row - 1];
        NSString * key =  sectionInfo[@"title"];
        NSString * name = @"";
        name =  self.practiceTypes [key];
        
        //教材教辅
        StudentHomeworkUnitSectionCell * tempCell = [tableView dequeueReusableCellWithIdentifier:StudentHomeworkUnitSectionCellIdentifier];
        tempCell.index = indexPath;
        
        NSString * imageName = @"";
        if ([key isEqualToString:@"ldkw"]) {
            imageName = @"homework_ldkw_icon";
        }
        if ([key isEqualToString:@"tkwly"]) {
            imageName = @"homework_tkwly_icon";
        }
        if ([key isEqualToString:@"dctx"]) {
            imageName = @"homework_dctx_icon";
        }
        if ([key isEqualToString:@"zxlx"]) {
            NSString * key = detailInfo[@"typeEn"];
            if ( key) {
                imageName = self.unityIconDic[key];
            }
            
        }
        [tempCell setupUnitSectionInfo:detailInfo withImageName:imageName withType:key];
        tempCell.unitDetailBlock = ^(NSIndexPath *index) {
            
            [self selectedIndexPath:index];
        };
        cell = tempCell;
        
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self selectedIndexPath:indexPath];
    
}

- (void)selectedIndexPath:(NSIndexPath *)indexPath{
    
    //点击的cell
    if (indexPath.section > 3 ) {
        NSInteger section = indexPath.section - kSectionDefault;
        NSDictionary * sectionInfo = self.bookSectionUnits[section];
        if ( indexPath.row != 0) {
            [self gotoZXLX:sectionInfo withIndexPath:indexPath];
        }else{
            
            [self gotoCartoonUnit:sectionInfo];
        }
        
    }else if(indexPath.section == 3){
        
        [self  gotoKHLXVC];
    }else if (indexPath.section == 4){
        [self gotoUnOnlineAssistantsQuestionVC];
    }
    
}
- (void)gotoZXLX:(NSDictionary *)sectionInfo withIndexPath:(NSIndexPath *)indexPath{
    
    
    if ([sectionInfo[cellTypeKey] isEqualToString:BookZxlxSection]) {
        //单元 块 内容cell
        NSArray * tempArray =  sectionInfo[@"detail"] ;
        NSDictionary *detailInfo = tempArray[indexPath.row - 1];
        if (![detailInfo[cellTypeKey] isEqualToString:zxlxUnit] && ![detailInfo[cellTypeKey] isEqualToString:zxlxChapter]) {
            if ( [detailInfo[@"score"] integerValue]>=0) {
                [self gotoHomeworkDetail:detailInfo];
            }
            
        }
        
    }
}
- (void)gotoCartoonUnit:(NSDictionary *)sectionInfo{
    if ([sectionInfo[cellTypeKey] isEqualToString:CartoonUnit]) {
        
        if ([sectionInfo[@"title"] isEqualToString:@"hbpy"] && [sectionInfo[@"detail"] integerValue] >= 0){
            NSString * bookId = sectionInfo[@"bookId"];
            [self gotoHBPYViewController:bookId];
        }
    }
    
}
#pragma mark ----
- (void)gotoHomeworkDetail:(NSDictionary *)detailInfo{
    
    //    NSInteger section = index.section - 3;
    //
    //    NSArray * sectionArray = self.bookSectionUnits[section];
    //
    //    NSArray * detailArray= sectionArray.firstObject[@"detail"];
    //    NSDictionary *detailInfo = detailArray[index.row - 1];
    
    HomeworkUnitDetailViewController * detail = [[HomeworkUnitDetailViewController alloc]initWithStudentId:self.studentId withHomeworkId:self.homeworkId withHomeworkTypeId:detailInfo[@"homeworkTypeId"] withUnitName: detailInfo[@"unitName"] withType:detailInfo[@"typeCn"]];
    [self pushViewController:detail];
}
- (void)gotoUnOnlineAssistantsQuestionVC  {
    
    JFHomeNoItemViewController * vc = [[JFHomeNoItemViewController alloc]initWithBookId:@"" withHomeworkId:self.homeworkId withStudentId:self.studentId];
    [self pushViewController:vc];
}


- (void)gotoKHLXVC{
    
    StudentKHLXHomeworkDetailVC * khlxDetail = [[StudentKHLXHomeworkDetailVC alloc]initWithStudentName:self.studentName withStudentId:self.studentId withHomeworkId:self.homeworkId ];
    [self pushViewController:khlxDetail];
}
//绘本配音详情
- (void)gotoHBPYViewController:(NSString *)bookId{
    
    HWReportCartoonVC * cartoonVC = [[HWReportCartoonVC alloc]initWithStudentId:self.studentId withBookId:bookId];
    [self pushViewController:cartoonVC];
}
#pragma mark ---
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestStudentHomeworkScore{
    if (!self.studentId || !self.homeworkId) {
        return;
    }
    NSDictionary *parameterDic = @{@"studentId":self.studentId,
                                   @"homeworkId":self.homeworkId
                                   };
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_QueryStudentHomeworkScore] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_QueryStudentHomeworkScore];
}

- (void)setNetworkRequestStatusBlocks{
    
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_QueryStudentHomeworkScore) {
            
            strongSelf.model = [[StudentHomeworkDetailModel alloc]initWithDictionary:successInfoObj error:nil];
            
            //            [weakSelf resetData];
            [strongSelf resetHomeworkListData];
            
        }
        
    }];
}

- (NSMutableArray *)bookSectionUnits{
    
    if (!_bookSectionUnits) {
        _bookSectionUnits = [[NSMutableArray alloc]init];
    }
    return _bookSectionUnits;
}



- (void)resetHomeworkListData{
    
    
    if (self.bookSectionUnits) {
        [self.bookSectionUnits removeAllObjects];
    }
    
    for (NSDictionary * dic in self.model.bookHomeworks) {
        
        //存储书本信息 是一个字典类型
        
        //存书本 教材 绘本 信息
        NSMutableDictionary * bookMutableDic = [[NSMutableDictionary alloc]init];
        
        [bookMutableDic addEntriesFromDictionary:@{@"bookName":dic[@"bookName"],
                                                   
                                                   @"coverImage":dic[@"coverImage"],
                                                   
                                                   }];
        
        if ( dic[@"bookType"] ) {
            [bookMutableDic addEntriesFromDictionary:@{@"bookType":  dic[@"bookType"]}];
        }
        if ( dic[@"bookTypeName"]) {
            [bookMutableDic addEntriesFromDictionary:@{@"bookTypeName": dic[@"bookTypeName"]}];
        }
        if (dic[@"workTotal"]) {
            
            [bookMutableDic addEntriesFromDictionary:@{@"workTotal":dic[@"workTotal"]}];
        }
        if (dic[@"subject"]) {
            [bookMutableDic addEntriesFromDictionary:@{@"subject":dic[@"subject"]}];
            
        }
        if (dic[@"subjectName"]) {
            [bookMutableDic addEntriesFromDictionary:@{@"subjectName":dic[@"subjectName"]}];
        }
        
        
        
        [bookMutableDic setObject:BOOKINFO forKey:cellTypeKey];
        
        
        [self.bookSectionUnits addObject:bookMutableDic];
        
        
        if ([dic[@"bookType"] isEqualToString:@"Book"]){
            if (dic[@"zxlx"]) {
                NSArray * array = dic[@"zxlx"];
                [self  confightZXLX:array];
            }
            //找出教辅单元
            for (NSString * key in dic) {
                //教材
                if ([self.practiceTypes.allKeys containsObject:key]) {
                    if ([key isEqualToString:@"zxlx"]) {
//                        NSArray * array = dic[key];
//                        [self  confightZXLX:array];
                        
                    }else{
                        //除开在线练习的数据 和课后练习
                        NSDictionary * fistObject =  @{@"title":key,
                                                       @"detail": dic[key],
                                                       @"bookType":@"Book",
                                                       cellTypeKey:BookOtherSection
                                                       };
                        [self.bookSectionUnits addObject:fistObject];
                        /**
                         把布置的书本作业 用一个数组 包装一下 用于区分 书本 和作业单元项
                         **/
                    }
                }
            }
            
        }else  if ([dic[@"bookType"] isEqualToString:BookTypeCartoon]) {
            ///找出绘本单元
            NSArray * cartoonHomework = dic[@"cartoonHomework"];
            for (NSDictionary * tempDic in cartoonHomework) {
                NSString * key = tempDic[@"type"];
                NSDictionary * fistObject =  @{@"title":key,
                                               @"detail": tempDic[@"score"],
                                               @"bookType":BookTypeCartoon,
                                               @"bookId":dic[@"bookId"],
                                               cellTypeKey:CartoonUnit
                                               };
                //存储绘本单元信息
                [self.bookSectionUnits addObject:fistObject];
            }
        }
    }
    [self updateTableView];
    NSLog(@"%@===",self.bookSectionUnits);
}

- (void)confightZXLX:(NSArray *)array{
    
    
    NSDictionary *zxlxDic = array.firstObject;
    
    NSMutableArray * zxkxArray = [[NSMutableArray alloc]init];
    //单元标题
    NSString * unitName = zxlxDic[@"unitName"];
    //存单元标题
    [zxkxArray addObject:@{@"title":unitName,
                           cellTypeKey:zxlxUnit
                           }];
    
    //单词
    for (NSDictionary * tempDic in zxlxDic[@"words"]) {
        
        //章节名
        NSString * chapterName = tempDic[@"sectionName"];
        [zxkxArray addObject:@{@"title":chapterName,
                               cellTypeKey:zxlxChapter}];
        
        
        NSArray * sectionWords = tempDic[@"appType"];
        
        NSMutableArray * mutableWords = [NSMutableArray array];
        for (NSDictionary * tempDic in sectionWords) {
            NSMutableDictionary * mutableDic = [[NSMutableDictionary alloc]init];
            
            [mutableDic addEntriesFromDictionary:tempDic];
            [mutableDic addEntriesFromDictionary:@{cellTypeKey:wordInfo}];
            [mutableWords addObject:mutableDic];
            
            mutableDic = nil;
        }
        [zxkxArray addObjectsFromArray:mutableWords];
        mutableWords  = nil;
        
    }
    //听写
    for (NSDictionary * tempDic in zxlxDic[@"listenAndTalk"]) {
        
        //章节名
        NSString * chapterName = tempDic[@"sectionName"];
        [zxkxArray addObject:@{@"title":chapterName,
                               cellTypeKey:zxlxChapter}];
        
        NSArray * sectionListens = tempDic[@"appType"];
        
        NSMutableArray * mutableListens = [NSMutableArray array];
        for (NSDictionary * tempDic in sectionListens) {
            NSMutableDictionary * mutableDic = [[NSMutableDictionary alloc]init];
            
            [mutableDic addEntriesFromDictionary:tempDic];
            [mutableDic addEntriesFromDictionary:@{cellTypeKey:listenAndTalkInfo}];
            [mutableListens addObject:mutableDic];
            
            mutableDic = nil;
        }
        
        [zxkxArray addObjectsFromArray:mutableListens];
        mutableListens = nil;
    }
    
    NSDictionary * fistObject =  @{@"title":@"zxlx",
                                   @"detail":zxkxArray,
                                   @"bookType":@"Book",
                                   cellTypeKey:BookZxlxSection
                                   };
    [self.bookSectionUnits addObject:fistObject];
    
    /**
     把布置的书本作业 用一个数组 包装一下 用于区分 书本 和作业单元项
     **/
}
#pragma mark ---delegate

- (void)leftButtonAction:(NSInteger)currentPage{
    if (!self.studentList) {
        return ;
    }
    NSInteger tempCurrentPage = currentPage;
    tempCurrentPage--;
    if(tempCurrentPage >= 0){
        [self.playerView resetPlayer];
        self.currenntIndex = tempCurrentPage;
        self.studentId = self.studentList[tempCurrentPage][@"studentId"];
        self.model = nil;
        self.studentName = self.studentList[tempCurrentPage][@"studentName"];
        [self requestStudentHomeworkScore];
        
    }else{
        [self showAlert:TNOperationState_Unknow content:@"已经是第一位学生信息"];
    }
    
}

- (void)rightButtonAction:(NSInteger)currentPage{
    if (!self.studentList) {
        return ;
    }
    NSInteger tempCurrentPage = currentPage;
    tempCurrentPage++;
    if(tempCurrentPage < [self.studentList count]){
        [self.playerView resetPlayer];
        self.currenntIndex = tempCurrentPage;
        self.studentId = self.studentList[tempCurrentPage][@"studentId"];
        self.model = nil;
        self.studentName = self.studentList[tempCurrentPage][@"studentName"];
        [self requestStudentHomeworkScore];
        
    }else{
        [self showAlert:TNOperationState_Unknow content:@"已经是最后一位学生信息"];
    }
    
    
}


- (ZFPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [ZFPlayerView sharedPlayerView];
        _playerView.delegate = self;
        // 当cell播放视频由全屏变为小屏时候，不回到中间位置
        _playerView.cellPlayerOnCenter = NO;
        _playerView.hidden = YES;
        // 当cell划出屏幕的时候停止播放
        _playerView.stopPlayWhileCellNotVisable = YES;
        ZFPlayerShared.isLockScreen = YES;
        //（可选设置）可以设置视频的填充模式，默认为（等比例填充，直到一个维度到达区域边界）
        // _playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
        // 静音
        // _playerView.mute = YES;
    }
    return _playerView;
}
- (void)zf_playerItemStatusFailed:(NSError *)error{
    NSString * content = @"语音播放失败！请稍后再试";
    [self showAlert:TNOperationState_Fail content:content block:nil];
    
}
// 页面消失时候
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.playerView resetPlayer];
}
- (void)dealloc{
    
    self.bookSectionUnits = nil;
    self.playerView =  nil;
}
#pragma mark --------
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    //    NSLog(@"=---> %lf", offsetY);
//    if (offsetY) {
//        CGFloat progress = offsetY ;
//        CGFloat headerHeight =   NavigationBar_Height;
//        CGFloat gradientProgress = MIN(1, MAX(0, progress  / headerHeight));
//        gradientProgress = gradientProgress * gradientProgress * gradientProgress * gradientProgress;
//        if (gradientProgress != _gradientProgress) {
//            _gradientProgress = gradientProgress;
//            self.hbd_barAlpha = _gradientProgress;
//            [self hbd_setNeedsUpdateNavigationBar];
//        }
//    }
    
}
- (BOOL)getNavBarBgHidden{
    
    return YES;
}

- (UIRectEdge)getViewRect{
    
    return UIRectEdgeAll;
}



@end


