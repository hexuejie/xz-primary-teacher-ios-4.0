

//
//  HWReportViewController.m
//  TeacherPro
//
//  Created by DCQ on 2018/7/13.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "HWReportViewController.h"

#import "HWBookInfoCell.h"
#import "HWReportHeaderView.h"
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
NSString * const  HWBookInfoCellIdentifier = @"HWBookInfoCellIdentifier";
NSString * const  HWReportFooterCellIdentifier = @"HWReportFooterCellIdentifier";
NSString * const  HWReportZXLXTypesCellIdentifier = @"HWReportZXLXTypesCellIdentifier";
NSString * const  HWReportZXLXTypeUnitCellIdentifier = @"HWReportZXLXTypeUnitCelllIdentifier";
NSString * const  HWReportZXLXUnitTypeCellIdentifier = @"HWReportZXLXUnitTypeCellIdentifier";
NSString * const  HWReportZXLXUnitTypeUnitCellIdentifier = @"HWReportZXLXUnitTypeUnitCellIdentifier";
NSString * const  HWReportZXLXSubUnitTypeCellIdentifier = @"HWReportZXLXSubUnitTypeCellIdentifier";
NSString * const  HWZXLXVocabularyReportCellIdentifier = @"HWZXLXVocabularyReportCellIdentifier";
NSString * const  HWZXLXHearReportCellIdentifier = @"HWZXLXHearReportCellIdentifier";
NSString * const  HWZXLXVoiceReportCellIdentifier = @"HWZXLXVoiceReportCellIdentifier";
NSString * const  HWCartoonReportCellIdentifier = @"HWCartoonReportCellIdentifier";
NSString * const  HWReportZXLXTypeDetailCellIdentifier = @"HWReportZXLXTypeDetailCellIdentifier";
NSString * const  HWMathKHLXReportCellIdentifier = @"HWMathKHLXReportCellIdentifier";
NSString * const  HWJFBookReportCellIdentifier = @"HWJFBookReportCellIdentifier";
NSString * const  HWYWDDReportCellIdentifier = @"HWYWDDReportCellIdentifier";

NSString * const  HWReportTextCellIdentifier = @"HWReportTextCellIdentifier";
NSString * const  HWReportVoiceCellIdentifier = @"HWReportVoiceCellIdentifier";
NSString * const  HWReportImgVCellIdentifier = @"HWReportImgVCellIdentifier";

@interface HWReportViewController ()<SDPhotoBrowserDelegate>{
    CGFloat _gradientProgress;
}

@property(nonatomic, copy) NSString * homeworkId;


/** 项 */
@property (nonatomic, strong) NSMutableArray<MultilayerItem *> *Items;

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
@end

@implementation HWReportViewController
- (instancetype)initWithHomeworkId:(NSString *)homeworkId{
    self = [super init];
    if (self) {
        self.homeworkId = homeworkId;
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
    
//    UIImage *barBackBtnImg = [[UIImage imageNamed:@"back_white"] imageWithRenderingMode:UIImageRenderingModeAutomatic]   ;
//    
//    [[UINavigationBar appearance] setBackIndicatorImage:barBackBtnImg];
//    
//    [[UINavigationBar appearance]setBackIndicatorTransitionMaskImage:barBackBtnImg];
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    
}

- (UIImage *)getButtonItem{
    return  [[UIImage imageNamed:@"back_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [super  customizeNavigationInterface];
    [self pause];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent ;
    [self navUIBarBackground:0];
    [self customizeNavigationInterface];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    [self customizeNavigationInterface];
    [self setNavigationItemTitle:@"作业报告"];
    [self setupHeaderView];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}
- (void)playbackFinished{
    
    self.playerFinished = YES;
    self.playerState = NO;
    [self.playBtn.imageView.layer removeAnimationForKey:@"opacityForever_Animation"];
    [self.playTitleLabel setText: @"点击播放"];
}
- (void)getNetworkData{
    
    NSDictionary * parameterDic = @{@"homeworkId":self.homeworkId};
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_QueryHomeworkReport] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_QueryHomeworkReport];
}

- (void)setNetworkRequestStatusBlocks{
    WEAKSELF
    [self setSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_QueryHomeworkReport) {
            NSLog(@"%@=-==",successInfoObj);
            [strongSelf  confightTableViewData:successInfoObj];
            [strongSelf  setupRowCount];
            [strongSelf confightHeaderViewData:successInfoObj];
            [strongSelf updateTableView];
        }
    }];
}
- (void)setupHeaderView{
    HWReportHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([HWReportHeaderView class]) owner:nil options:nil].firstObject;
    headerView.frame = CGRectMake(0, 0, self.view.frame.size.width,NavigationBar_Height+180);
    self.tableView.tableHeaderView = headerView;
    
}
- (void)confightHeaderViewData:(NSDictionary * )successInfoObj{
    
    HWReportHeaderView *headerView = (HWReportHeaderView *)self.tableView.tableHeaderView;
    NSMutableDictionary * headerDic =[NSMutableDictionary dictionary];
    [headerDic addEntriesFromDictionary: @{@"text":successInfoObj[@"text"],
                                           @"studentCount":successInfoObj[@"studentCount"],
                                           @"subjectName":successInfoObj[@"subjectName"],
                                           @"subjectId":successInfoObj[@"subjectId"],
                                           @"finishedCount":successInfoObj[@"finishedCount"],
                                           @"feedbackName":successInfoObj[@"feedbackName"],
                                           @"feedback":successInfoObj[@"feedback"],
                                           @"gradeName":successInfoObj[@"gradeName"],
                                           @"endTime":successInfoObj[@"endTime"],
                                           @"clazzName":successInfoObj[@"clazzName"]
                                           }];
    if (successInfoObj[@"sound"]) {
        [headerDic addEntriesFromDictionary:@{@"sound":successInfoObj[@"sound"]}];
    }
    if (successInfoObj[@"photos"]) {
        [headerDic addEntriesFromDictionary:@{@"photos":successInfoObj[@"photos"]}];
    }
    
    [headerView setupHeaderData:headerDic];
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

- (void)registerCell{
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HWBookInfoCell class]) bundle:nil] forCellReuseIdentifier:HWBookInfoCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HWReportFooterCell class]) bundle:nil] forCellReuseIdentifier:HWReportFooterCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HWReportZXLXTypesCell class]) bundle:nil] forCellReuseIdentifier:HWReportZXLXTypesCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HWReportZXLXTypeUnitCell class]) bundle:nil] forCellReuseIdentifier:HWReportZXLXTypeUnitCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HWReportZXLXUnitTypeCell class]) bundle:nil] forCellReuseIdentifier:HWReportZXLXUnitTypeCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HWReportZXLXUnitTypeUnitCell class]) bundle:nil] forCellReuseIdentifier:HWReportZXLXUnitTypeUnitCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HWReportZXLXSubUnitTypeCell class]) bundle:nil] forCellReuseIdentifier:HWReportZXLXSubUnitTypeCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HWZXLXHearReportCell class]) bundle:nil] forCellReuseIdentifier:HWZXLXHearReportCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HWZXLXVocabularyReportCell class]) bundle:nil] forCellReuseIdentifier:HWZXLXVocabularyReportCellIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HWZXLXVoiceReportCell class]) bundle:nil] forCellReuseIdentifier:HWZXLXVoiceReportCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HWCartoonReportCell class]) bundle:nil] forCellReuseIdentifier:HWCartoonReportCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HWReportZXLXTypeDetailCell class]) bundle:nil] forCellReuseIdentifier:HWReportZXLXTypeDetailCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HWMathKHLXReportCell class]) bundle:nil] forCellReuseIdentifier:HWMathKHLXReportCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HWJFBookReportCell class]) bundle:nil] forCellReuseIdentifier:HWJFBookReportCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HWYWDDReportCell class]) bundle:nil] forCellReuseIdentifier:HWYWDDReportCellIdentifier];
    
     [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HWReportTextCell class]) bundle:nil] forCellReuseIdentifier:HWReportTextCellIdentifier];
     [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HWReportVoiceCell class]) bundle:nil] forCellReuseIdentifier:HWReportVoiceCellIdentifier];
     [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HWReportImgVCell class]) bundle:nil] forCellReuseIdentifier:HWReportImgVCellIdentifier];
 
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (!self.hwReportDetaiModel) {
        return 0;
    }else
        return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger  rows =  0;
    if (section == 0) {
        rows = 1;
        if (self.hwReportDetaiModel[@"sound"]) {
            rows = rows + 1;
        }
        if (self.hwReportDetaiModel[@"photos"]) {
          rows = rows + 1;
        }
 
    }else  if (section == 1) {
        rows = self.latestShowItems.count;
    }
    return  rows;
}

//获得字符串的高度
-(float) heightForString:(NSString *)value fontSize:(UIFont *)font andWidth:(float)width
{
    
    CGRect sizeToFit = [value boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:font, NSParagraphStyleAttributeName:[self getparaStyle] } context:nil];
    return sizeToFit.size.height;
}
- (NSMutableParagraphStyle *)getparaStyle{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    
    paraStyle.alignment = NSTextAlignmentLeft;
    
    paraStyle.lineSpacing = UILABEL_LINE_SPACE;
    
    paraStyle.hyphenationFactor = 1.0;
    
    paraStyle.firstLineHeadIndent = 0.0;
    
    paraStyle.paragraphSpacingBefore = 0.0;
    
    paraStyle.headIndent = 0;
    
    paraStyle.tailIndent = 0;
    return paraStyle;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            height = [self heightForString:self.hwReportDetaiModel[@"text"]  fontSize:fontSize_13 andWidth:self.view.frame.size.width - 16*2 ] + 20;
        }else if (indexPath.row == 1){
            height = 44;
        }else if (indexPath.row == 2){
            height = 44;
        }
      
    }else if(indexPath.section == 1){
        height = [self getHeightForRowAtIndexPath:indexPath];
    }
    return height;
}
- (CGFloat )getHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
     CGFloat height = 0;
    MultilayerItem * item = self.latestShowItems[indexPath.row];
    switch (item.index) {
        case 0:
        {
            if ([item.data isKindOfClass:[NSDictionary class]]) {
                height  = 140;
            }else{
                //书本间隔
                height = 10;
            }
            
        }
            break;
        case 1:
            if (item.data[@"bookType"] && [item.data[@"bookType"] isEqualToString:BookTypeCartoon]) {
                height = 40;
            }else if (item.data[@"bookType"] &&([item.data[@"bookType"] isEqualToString:@"Book"]||[item.data[@"bookType"] isEqualToString:@"JFBook"])) {
                height = 40;
            }
            
            break;
        case 2:
        {
            if (item.data[@"hwtype"] && [item.data[@"hwtype"] isEqualToString:@"khlx"]) {
                height = 90;
            }else  if (item.data[@"hwtype"] && [item.data[@"hwtype"] isEqualToString:@"zxlx"]){
                height = 40;
            }else  if (item.data[@"hwtype"] && [item.data[@"hwtype"] isEqualToString:@"jfHomework"]){
                height = 40;
            }else  if (item.data[@"hwtype"] && [item.data[@"hwtype"] isEqualToString:@"offline"]){
                //英语在线练习 的 其它作业类型
                height = 90;
            }else if (item.data[@"hwtype"]  && [item.data[@"hwtype"] isEqualToString:@"ywdd"]){
                height = 90;
            }else if (item.data[@"hwtype"]  && [item.data[@"hwtype"] isEqualToString:BookTypeCartoon]){
                height = 90;
            }
            
        }
            break;
        case 3:
            
            if ([item.data isKindOfClass:[NSString class]] &&([item.data isEqualToString:@"other"] ||[item.data isEqualToString:@"zxlx"])){
                height = 50;
            }else if (item.data[@"hwtype"] && [item.data[@"hwtype"] isEqualToString:@"zxlx"]){
                height = 44;
            }else  if (item.data[@"hwtype"] && [item.data[@"hwtype"] isEqualToString:@"jfHomework"]){
                height = 90;
            }else if (item.data[@"detail"]  && [item.data[@"detail"] isEqualToString: @"jfHomeworkDetail"]){
                height = 50;
            }
            break;
        case 4:
            height = 40;
            break;
        case 5:{
            
            height = 30;
            
        }
            break;
        case 6:
        {
            if (item.data[@"hasScoreLevel"] &&[item.data[@"hasScoreLevel"] boolValue]){
                height = 120;
                
            }else{
                height = 110;
            }
            
        }
            break;
        default:
            break;
    }
    return height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = nil;
    if (indexPath.section == 0) {
       cell =  [self getTableView:tableView firstSectionCellAtIndexPath:indexPath];
    }else if (indexPath.section == 1){
       cell = [self getTableView:tableView secondSectionCellAtIndexPath:indexPath];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    CGFloat footerHeight =  0.0001;
    footerHeight = FITSCALE(7);
    return footerHeight;
}

- ( UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView * footerView = [[UIView alloc]init];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}
- (UITableViewCell *)getTableView:(UITableView *)tableView firstSectionCellAtIndexPath:(NSIndexPath *)indexPath{
        UITableViewCell * cell = nil;
    if (indexPath.row == 0) {
        HWReportTextCell * tempCell = [tableView dequeueReusableCellWithIdentifier:HWReportTextCellIdentifier];
        [tempCell setupText:self.hwReportDetaiModel[@"text"]];
        cell = tempCell;
    }else if (indexPath.row == 1){
        if (self.hwReportDetaiModel[@"sound"]) {
            HWReportVoiceCell  * tempCell = [tableView dequeueReusableCellWithIdentifier:HWReportVoiceCellIdentifier ];
            tempCell.playblock = ^(UIButton *btn, UILabel*playTitleLabel) {
                 self.playBtn = btn;
                  self.playTitleLabel =  playTitleLabel;
                if (self.playerState) {
                    [self pause];
                 
                }else{
                    [self playVoice];
                    
                }
                
            };
            cell = tempCell;
        }else if (self.hwReportDetaiModel[@"photos"] && !self.hwReportDetaiModel[@"sound"] ) {
            HWReportImgVCell  * tempCell = [tableView dequeueReusableCellWithIdentifier:HWReportImgVCellIdentifier ];
            [tempCell setupImVUrls:  self.hwReportDetaiModel[@"photos"]];
            cell = tempCell;
        }
        
    }else if (indexPath.row == 2){
        
        HWReportImgVCell  * tempCell = [tableView dequeueReusableCellWithIdentifier:HWReportImgVCellIdentifier ];
        [tempCell setupImVUrls:  self.hwReportDetaiModel[@"photos"]];
        cell = tempCell;
    }
    return cell;
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

- (UITableViewCell *)getTableView:(UITableView *)tableView secondSectionCellAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = nil;
    MultilayerItem * item = self.latestShowItems[indexPath.row];
    switch (item.index) {
        case 0: // 第一层 书本
        {
            if ([item.data isKindOfClass:[NSDictionary class]]) {
                 cell = [self confightBookCellTableView:tableView withIndexPath:indexPath];
            }else{
                //书本间隔
                cell = [self confightFooterCellTableView:tableView withIndexPath:indexPath];
            }
        }
            break;
        case 1: //第二层 书本下的分类
        {
            if (item.data[@"bookType"] &&([item.data[@"bookType"] isEqualToString:@"Book"]||[item.data[@"bookType"] isEqualToString:@"JFBook"])) {
                cell = [self confightHWReportZXLXTypesCellTableView:tableView withIndexPath:indexPath];
            }else if (item.data[@"bookType"] && [item.data[@"bookType"] isEqualToString:BookTypeCartoon]) {
                cell = [self confightHWReportZXLXTypesCellTableView:tableView withIndexPath:indexPath];
            }
        }
            break;
        case 2:  //第三层 书本下的分类的单元
        {
            //课后练习
            if (item.data[@"hwtype"] && [item.data[@"hwtype"] isEqualToString:@"khlx"]) {
                cell = [self confightKHLXCell:tableView withIndexPath:indexPath];
            }else  if (item.data[@"hwtype"] && [item.data[@"hwtype"] isEqualToString:@"zxlx"]){
                cell = [self confightHWReportZXLXTypeUnitCellTableView:tableView withIndexPath:indexPath];
            }else  if (item.data[@"hwtype"] && [item.data[@"hwtype"] isEqualToString:@"jfHomework"]){
                cell = [self confightHWReportZXLXTypeUnitCellTableView:tableView withIndexPath:indexPath];
            }else  if (item.data[@"hwtype"] && [item.data[@"hwtype"] isEqualToString:@"offline"]){
                //英语在线练习 的 其它作业类型
                cell = [self confightHWZXLXVoiceReportCellTableView:tableView withIndexPath:indexPath];
                
            }else if (item.data[@"hwtype"]  && [item.data[@"hwtype"] isEqualToString:@"ywdd"]){
                cell = [self confightYWDDCell:tableView withIndexPath:indexPath];
            }else if (item.data[@"hwtype"]  && [item.data[@"hwtype"] isEqualToString:BookTypeCartoon]){
                cell = [self confightCartoonCell:tableView withIndexPath:indexPath];
            }
            
        }
            break;
        case 3: //第四层 书本下的分类的单元下分类
        {
            if ([item.data isKindOfClass:[NSString class]] &&([item.data isEqualToString:@"other"] ||[item.data isEqualToString:@"zxlx"])){
                cell = [self confightHWZXLXTypeDetailCellTableView:tableView withIndexPath:indexPath];
            }
            else if (item.data[@"hwtype"] && [item.data[@"hwtype"] isEqualToString:@"zxlx"]){
                cell = [self confightHWReportZXLXUnitTypeCellTableView:tableView withIndexPath:indexPath];
            }else  if (item.data[@"hwtype"] && [item.data[@"hwtype"] isEqualToString:@"jfHomework"]){
                cell = [self confightJFBookCell:tableView withIndexPath:indexPath];
            }else if (item.data[@"detail"]  && [item.data[@"detail"] isEqualToString: @"jfHomeworkDetail"]){
                cell = [self confightHWZXLXTypeDetailCellTableView:tableView withIndexPath:indexPath];
            }
        }
            break;
        case 4://第五层 书本下的分类的单元下分类下的单元
            cell = [self confightHWReportZXLXUnitTypeUnitCellTableView:tableView withIndexPath:indexPath];
            break;
        case 5://第六层 书本下的分类的单元下分类下的单元下分类
           
                cell = [self confightHWReportZXLXSubUnitTypeCellTableView:tableView withIndexPath:indexPath];
           
            break;
        case 6: //第六层 书本下的分类的单元下分类下的单元下分类下的内容
        {
            
            if (item.data[@"hasScoreLevel"] &&[item.data[@"hasScoreLevel"] boolValue]) {
                //听写
                cell = [self confightHWReportZXLXHearReportCellTableView:tableView withIndexPath:indexPath];
                
            }else{
                //词汇
                cell = [self  confightHWZXLXVocabularyCellTableView:tableView withIndexPath:indexPath];
                
            }
        }
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark --- 书本 cell
- (UITableViewCell *)confightBookCellTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath{
    HWBookInfoCell  * tempCell = [tableView dequeueReusableCellWithIdentifier:HWBookInfoCellIdentifier];
    MultilayerItem * item = self.latestShowItems[indexPath.row];
    [tempCell setupInfo:item.data];
    return tempCell;
}
- (UITableViewCell *)confightFooterCellTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath{
    HWReportFooterCell  * tempCell = [tableView dequeueReusableCellWithIdentifier:HWReportFooterCellIdentifier];
    
    return tempCell;
}
#pragma mark --在线练习-cell


- (UITableViewCell *)confightHWReportZXLXTypesCellTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath{
    HWReportZXLXTypesCell  * tempCell = [tableView dequeueReusableCellWithIdentifier:HWReportZXLXTypesCellIdentifier];
    MultilayerItem * item = self.latestShowItems[indexPath.row];
    [tempCell setupInfo:item.data];
    return tempCell;
}

- (UITableViewCell *)confightHWReportZXLXTypeUnitCellTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath{
    HWReportZXLXTypeUnitCell  * tempCell = [tableView dequeueReusableCellWithIdentifier:HWReportZXLXTypeUnitCellIdentifier];
    MultilayerItem * item = self.latestShowItems[indexPath.row];
    [tempCell setupInfo:item.data];
    return tempCell;
}
- (UITableViewCell *)confightHWReportZXLXUnitTypeCellTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath{
    HWReportZXLXUnitTypeCell  * tempCell = [tableView dequeueReusableCellWithIdentifier:HWReportZXLXUnitTypeCellIdentifier];
    MultilayerItem * item = self.latestShowItems[indexPath.row];
    [tempCell setupInfo:item.data];
    return tempCell;
}
- (UITableViewCell *)confightHWReportZXLXUnitTypeUnitCellTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath{
    HWReportZXLXUnitTypeUnitCell  * tempCell = [tableView dequeueReusableCellWithIdentifier:HWReportZXLXUnitTypeUnitCellIdentifier];
    MultilayerItem * item = self.latestShowItems[indexPath.row];
    [tempCell setupInfo:item.data];
    return tempCell;
}


- (UITableViewCell *)confightHWReportZXLXSubUnitTypeCellTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath{
    HWReportZXLXSubUnitTypeCell  * tempCell = [tableView dequeueReusableCellWithIdentifier:HWReportZXLXSubUnitTypeCellIdentifier];
    MultilayerItem * item = self.latestShowItems[indexPath.row];
    [tempCell setupInfo:item.data];
    return tempCell;
}

//听说统计
- (UITableViewCell *)confightHWReportZXLXHearReportCellTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath{
    HWZXLXHearReportCell * tempCell = [tableView dequeueReusableCellWithIdentifier:HWZXLXHearReportCellIdentifier];
    MultilayerItem * item = self.latestShowItems[indexPath.row];
    [tempCell setupInfo:item.data];
    return tempCell;
}
//词汇 统计
- (UITableViewCell *)confightHWZXLXVocabularyCellTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath{
    HWZXLXVocabularyReportCell  * tempCell = [tableView dequeueReusableCellWithIdentifier:HWZXLXVocabularyReportCellIdentifier];
    MultilayerItem * item = self.latestShowItems[indexPath.row];
    [tempCell setupInfo:item.data];
    return tempCell;
}

//查看类型详情
- (UITableViewCell *)confightHWZXLXTypeDetailCellTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath{
    HWReportZXLXTypeDetailCell  * tempCell = [tableView dequeueReusableCellWithIdentifier:HWReportZXLXTypeDetailCellIdentifier];
    MultilayerItem * item = self.latestShowItems[indexPath.row];
    if (item.index == 3 && [item.data isKindOfClass:[NSString class]] &&([item.data isEqualToString:@"other"] ||[item.data isEqualToString:@"zxlx"])){
        [tempCell setupBtnTitle:@"查看详情"];
    }else if (item.index == 3 && item.data[@"detail"] && [item.data[@"detail"] isEqualToString:@"jfHomeworkDetail"]) {
        [tempCell setupBtnTitle:@"查看更多"];
    }
    tempCell.indexPath = indexPath;
    tempCell.btnBlock = ^(NSIndexPath *indexPath) {
        MultilayerItem * item = self.latestShowItems[indexPath.row];
        if (item.index ==  3  && [item.data isKindOfClass:[NSString class]] &&([item.data isEqualToString:@"other"] ||[item.data isEqualToString:@"zxlx"])) {
            [self gotoHWReportZXLXUnit:item.data];
        }else if (item.index == 3 && item.data[@"detail"] && [item.data[@"detail"] isEqualToString:@"jfHomeworkDetail"]){
            NSString * bookId = item.data[@"bookId"];
            NSString * bookHomeworkId =  item.data[@"bookHomeworkId"];
            [self gotoAssistantsVCBookId:bookId withBookHomeworkId:bookHomeworkId];
        }
    };
    return tempCell;
}


#pragma mark --- 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            if (self.hwReportDetaiModel[@"sound"]) {
                HWReportVoiceCell * voiceCell = [tableView cellForRowAtIndexPath:indexPath];
                self.playBtn = [voiceCell getPlayBtn];
                self.playTitleLabel = [voiceCell getPlayTitleLabel];
                if (self.playerState) {
                    [self pause];
                }else{
                   [self playVoice];
                }
            }else if (self.hwReportDetaiModel[@"photos"] && !self.hwReportDetaiModel[@"sound"] ) {
                HWReportImgVCell * imgVCell = [tableView cellForRowAtIndexPath:indexPath];
                [self showImg:[imgVCell.contentView viewWithTag:989898]];
            }
        }else if (indexPath.row == 2){
            HWReportImgVCell * imgVCell = [tableView cellForRowAtIndexPath:indexPath];
 
            [self showImg:[imgVCell.contentView viewWithTag:989898]];
        }
    }else if (indexPath.section == 1){
        MultilayerItem * item = self.latestShowItems[indexPath.row];
        if (item.index == 3 && [item.data isKindOfClass:[NSString class]]) {
            [self gotoHWReportZXLXUnit:item.data];
            [self pause];
        }else if(item.index ==  3 ){
            
            if (item.data[@"hwtype"] && [item.data[@"hwtype"] isEqualToString:@"jfHomework"]) {
                
                NSString * bookId = item.data[@"bookId"];
                NSString * bookHomeworkId =  item.data[@"bookHomeworkId"];
                NSString * homeworkTypeId = item.data[@"homeworkTypeId"];
                [self gotoAssistantsVCBookId:bookId withBookHomeworkId:bookHomeworkId withHomeworkTypeId:homeworkTypeId];
                [self pause];
            }else if ( item.data[@"hwtype"] && [item.data[@"detail"] isEqualToString:@"jfHomeworkDetail"]){
                NSString * bookId = item.data[@"bookId"];
                NSString * bookHomeworkId =  item.data[@"bookHomeworkId"];
                [self gotoAssistantsVCBookId:bookId withBookHomeworkId:bookHomeworkId];
                [self pause];
            }
        }else if (item.index == 2 ){
            if ( [item.data[@"hwtype"] isEqualToString:@"khlx"]) {
                  [self gotoHWReportKHXTDetailVC:item.data];
                  [self pause];
            }else if (item.data[@"hwtype"]  && [item.data[@"hwtype"] isEqualToString:@"ywdd"]){
                [self gotoReportStudentHomeworkTypeId:item.data[@"homeworkTypeId"] withType:@"ywdd" withBookId:@""];
                [self pause];
            }else if (item.data[@"hwtype"]  && [item.data[@"hwtype"] isEqualToString:BookTypeCartoon]){
                 [self gotoReportStudentHomeworkTypeId:item.data[@"homeworkTypeId"] withType:BookTypeCartoon withBookId:item.data[@"bookId"]];
                [self pause];
            }
            
        }
    }
   
}


#pragma mark --- 离线作业 cell
- (UITableViewCell * )confightHWZXLXVoiceReportCellTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath{
    
    HWZXLXVoiceReportCell * tempCell = [tableView dequeueReusableCellWithIdentifier:HWZXLXVoiceReportCellIdentifier];
    MultilayerItem * item = self.latestShowItems[indexPath.row];
    [tempCell setupInfo:item.data];
    return tempCell;
}
#pragma mark ----- 绘本 cell

- (UITableViewCell *)confightCartoonCell:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath{
    
    HWCartoonReportCell * tempCell = [tableView dequeueReusableCellWithIdentifier:HWCartoonReportCellIdentifier];
    MultilayerItem * item = self.latestShowItems[indexPath.row];
    [tempCell setupInfo:item.data];
    return tempCell;
}
#pragma mark --------教辅
- (UITableViewCell *)confightJFBookCell :(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath{
    HWJFBookReportCell * tempCell = [tableView dequeueReusableCellWithIdentifier:HWJFBookReportCellIdentifier];
    MultilayerItem * item = self.latestShowItems[indexPath.row];
    [tempCell setupInfo:item.data];
    return tempCell;
    
}
#pragma  mark --- 语文点读
- (UITableViewCell *)confightYWDDCell :(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath{
    HWYWDDReportCell * tempCell = [tableView dequeueReusableCellWithIdentifier:HWYWDDReportCellIdentifier];
    MultilayerItem * item = self.latestShowItems[indexPath.row];
    [tempCell setupInfo:item.data];
    return tempCell;
    
}

#pragma mark --------  课后练习
- (UITableViewCell *)confightKHLXCell:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath{
    
    HWMathKHLXReportCell * tempCell = [tableView dequeueReusableCellWithIdentifier:HWMathKHLXReportCellIdentifier];
    MultilayerItem * item = self.latestShowItems[indexPath.row];
    [tempCell setupInfo:item.data];
    return tempCell;
}

#pragma mark --------
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
//    NSLog(@"=---> %lf", offsetY);
//    if (offsetY) {
//        CGFloat progress = offsetY ;
//        CGFloat headerHeight =  NavigationBar_Height;
//        CGFloat gradientProgress = MIN(1, MAX(0, progress  / headerHeight));
//        gradientProgress = gradientProgress * gradientProgress * gradientProgress * gradientProgress;
//        if (gradientProgress != _gradientProgress) {
//            _gradientProgress = gradientProgress;
//            self.hbd_barAlpha = _gradientProgress;
//            [self hbd_setNeedsUpdateNavigationBar];
//        }
//    }
    
}

#pragma mark ----   多层级


#pragma mark - < 添加可以展示的选项 >

- (void)setupRowCount
{
    // 清空当前所有展示项
    [self.latestShowItems removeAllObjects];
    
    // 重新添加需要展示项, 并设置层级, 初始化0
    [self setupRouCountWithMenuItems:self.Items index:0];
}

/**
 将需要展示的选项添加到latestShowMenuItems中, 此方法使用递归添加所有需要展示的层级到latestShowMenuItems中
 
 @param menuItems 需要添加到latestShowMenuItems中的数据
 @param index 层级, 即当前添加的数据属于第几层
 */
- (void)setupRouCountWithMenuItems:(NSArray<MultilayerItem *> *)menuItems index:(NSInteger)index
{
    for (int i = 0; i < menuItems.count; i++) {
        MultilayerItem *item = menuItems[i];
        // 设置层级
        item.index = index;
        // 将选项添加到数组中
        [self.latestShowItems addObject:item];
        // 判断该选项的是否能展开, 并且已经需要展开
        if (item.isCanUnfold && item.isUnfold) {
            // 当需要展开子集的时候, 添加子集到数组, 并设置子集层级
            [self setupRouCountWithMenuItems:item.subs index:index + 1];
        }
    }
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
        //教辅
        if ([bookArray[i][@"bookType"] isEqualToString:@"JFBook"]) {
            tempItem.subs = [self getJFBookTypes:bookArray[i][@"homeworkTypes"] withBookId:bookArray[i][@"bookId"] withBookHomeworkId:bookArray[i][@"bookHomeworkId"]];
        }else  if ( [bookArray[i][@"bookType"] isEqualToString:@"Book"]) {
            //教材
            
            if([bookArray[i][@"subject"]  isEqualToString:@"003"]){
                tempItem.subs = [self  getEnSecondSubs:bookArray[i][@"homeworkTypes"]];
                
            }else  if([bookArray[i][@"subject"]  isEqualToString:@"002"]){
                //数学
                tempItem.subs = [self getMathSecondSubs:bookArray[i][@"homeworkTypes"]];
            }else if ([bookArray[i][@"subject"]  isEqualToString:@"001"]){
                //语文
                tempItem.subs = [self getYWSecondTSubs:bookArray[i][@"homeworkTypes"]];
            }
            
        }else if ( [bookInfo[@"bookType"] isEqualToString:BookTypeCartoon]) {
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

#pragma mark --- 数学
- (NSArray <MultilayerItem *>*)getMathSecondSubs:(NSArray * )homeworkTypes{
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
        if ([homeworkInfo[@"practiceType"] isEqualToString:@"khlx"]) {
             tempItem.subs = [self getKHLXThreeSubs: homeworkInfo[@"units"]];
        }
        [tempArray addObject:tempItem];
        
    };
    return tempArray;
}
#pragma mark ---  课后习题
- (NSArray <MultilayerItem *>*)getKHLXThreeSubs:(NSArray * )homeworkUnits{
    
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
        //        questionCount = 1;//题数
        //        unitId = //单元id
        //        unitName //单元名字
        
        tempItem.data = @{@"unitName":unitInfo[@"unitName"],
                          @"unitId":unitInfo[@"unitId"],
                          @"finishStudentCount":unitInfo[@"finishStudentCount"],
                          @"homeworkTypeId":unitInfo[@"homeworkTypeId"],
                          @"questionCount":unitInfo[@"questionCount"],
                          @"studentCount":self.studentCount,
                          @"hwtype":@"khlx"
                          };
        
        [tempArray addObject:tempItem];
    }
    return tempArray;
}
#pragma mark ---- 语文
- (NSArray <MultilayerItem *>*)getYWSecondTSubs:(NSArray * )homeworkTypes{
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
        if ([homeworkInfo[@"practiceType"] isEqualToString:@"khlx"]) {
            if (homeworkInfo[@"units"]) {
                tempItem.subs = [self getKHLXThreeSubs: homeworkInfo[@"units"]];
            }else{
                 tempItem.subs =  nil;
            }
            
        }else if ([homeworkInfo[@"practiceType"] isEqualToString:@"ywdd"]) {
            if (homeworkInfo[@"units"]) {
                 tempItem.subs = [self getYWDDThreeSubs:homeworkInfo[@"units"]];
            }else{
                tempItem.subs =  nil;
            }
            
        }
       
        [tempArray addObject:tempItem];
        
    };
    return tempArray;
}
- (NSArray <MultilayerItem *>*)getYWDDThreeSubs:(NSArray * )homeworkUnits{
    NSMutableArray * tempArray = [NSMutableArray array];
    for (int i  = 0; i < [homeworkUnits count]; i++) {
        MultilayerItem * tempItem = [[MultilayerItem alloc]init];
        tempItem.index = 2;
        tempItem.isUnfold = NO;
        tempItem.isCanUnfold = NO;
        NSDictionary *homeworkInfo  = homeworkUnits[i];
        NSMutableDictionary * tempDic = [NSMutableDictionary dictionary];
        [tempDic addEntriesFromDictionary:@{@"unitName":homeworkInfo[@"unitName"],
                                            @"unitId":homeworkInfo[@"unitId"],
                                            @"finishStudentCount":homeworkInfo[@"finishStudentCount"],
                                            @"homeworkTypeId":homeworkInfo[@"homeworkTypeId"],
                                            @"studentCount":self.studentCount,
                                            @"hwtype":@"ywdd"
                                            }];
        if (homeworkInfo[@"nameNo"]) {
           [tempDic addEntriesFromDictionary:@{@"nameNo":homeworkInfo[@"nameNo"]}];
        }
        tempItem.data = tempDic;
       
        [tempArray addObject:tempItem];
    };
    return tempArray;
}
#pragma mark ---  教辅
- (NSArray <MultilayerItem *>*)getJFBookTypes:(NSArray * )homeworkTypes withBookId:(NSString *)bookId withBookHomeworkId:(NSString *)bookHomeworkId{
    NSMutableArray * tempArray = [NSMutableArray array];
    for (int i  = 0; i < [homeworkTypes count]; i++) {
        MultilayerItem * tempItem = [[MultilayerItem alloc]init];
        tempItem.index = 1;
        tempItem.isUnfold = YES;
        tempItem.isCanUnfold = YES;
        NSDictionary *homeworkInfo  = homeworkTypes[i];
        tempItem.data = @{@"title":homeworkInfo[@"title"],
                          @"practiceType":homeworkInfo[@"practiceType"],
                          @"bookType":@"JFBook"
                          };
        tempItem.subs = [self getJFBookThreeSubs:homeworkInfo[@"units"] withBookId:bookId withBookHomeworkId:bookHomeworkId];
        [tempArray addObject:tempItem];
        
        
    };
    
     return tempArray;
}
- (NSArray <MultilayerItem *>*)getJFBookThreeSubs:(NSArray * )homeworkUnits withBookId:(NSString *)bookId withBookHomeworkId:(NSString *)bookHomeworkId{
     NSMutableArray * tempArray = [NSMutableArray array];
    for (int i  = 0; i < [homeworkUnits count]; i++) {
        MultilayerItem * tempItem = [[MultilayerItem alloc]init];
        tempItem.index = 2;
        tempItem.isUnfold = YES;
        tempItem.isCanUnfold = YES;
        NSDictionary *unitInfo  = homeworkUnits[i];
        tempItem.data = @{@"unitName":unitInfo[@"unitName"],
                          @"unitId":unitInfo[@"unitId"],
                          @"homeworkTypeId":unitInfo[@"homeworkTypeId"],
                          @"hwtype":@"jfHomework"
                          };
        tempItem.subs = [self getJFBookFourSubs:unitInfo[@"questions"] withBookId:bookId withBookHomeworkId:bookHomeworkId];
        [tempArray addObject:tempItem];
    }
    return tempArray;
}
- (NSArray <MultilayerItem *>*)getJFBookFourSubs:(NSArray * )questions withBookId:(NSString *)bookId withBookHomeworkId:(NSString * )bookHomeworkId {
    
    NSMutableArray * tempArray = [NSMutableArray array];
#warning   教辅 最大显示题数
  
    NSInteger questionsMax = 5;
    for (int i  = 0; i < [questions count] && i< questionsMax; i++) {
        MultilayerItem * tempItem = [[MultilayerItem alloc]init];
        tempItem.index = 3;
        tempItem.isUnfold = NO;
        tempItem.isCanUnfold = NO;
        NSDictionary *questionsInfo  = questions[i];
        tempItem.data = @{@"questionNum":questionsInfo[@"questionNum"],
                          @"doubtStudentCount":questionsInfo[@"doubtStudentCount"],
                          @"homeworkTypeId":questionsInfo[@"homeworkTypeId"],
                          @"bookId":bookId,
                          @"bookHomeworkId":bookHomeworkId,
                          @"studentCount":self.studentCount,
                          @"hwtype":@"jfHomework"
                          };
      
        [tempArray addObject:tempItem];
    }
    //
    if ([questions count] >questionsMax) {
        MultilayerItem * bottomItem = [[MultilayerItem alloc]init];
        bottomItem.index = 3;
        bottomItem.isUnfold = NO;
        bottomItem.data = @{@"detail":@"jfHomeworkDetail",
                            @"bookId":bookId,
                            @"bookHomeworkId":bookHomeworkId
                            };
        [tempArray addObject:bottomItem];
    }
    return tempArray;
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
        [dic addEntriesFromDictionary:@{@"unitName":[NSString stringWithFormat:@"%@",unitInfo[@"unitName"]],
                                        @"finishStudentCount":[NSString stringWithFormat:@"%@",unitInfo[@"finishStudentCount"]],
                                        @"homeworkTypeId":[NSString stringWithFormat:@"%@",unitInfo[@"homeworkTypeId"]],
                                        @"nameNo":[NSString stringWithFormat:@"%@",unitInfo[@"count"]],
                                        @"studentCount":[NSString stringWithFormat:@"%@",self.studentCount],
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

