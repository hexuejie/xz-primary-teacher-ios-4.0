
//
//  HomeworkUnitDetailViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/7/9.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "HomeworkUnitDetailViewController.h"
#import "HomeworkUnitDetailsModel.h"
#import "HomeworkUnitDetailVoiceCell.h"
#import "HomeworkUnitDetailChooseCell.h"
#import "HomeworkUnitDetailSectionCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "ZFPlayer.h"
NSString * const HomeworkUnitDetailVoiceCellIdentifier = @"HomeworkUnitDetailVoiceCellIdentifier";
NSString * const HomeworkUnitDetailChooseCellIdentifier = @"HomeworkUnitDetailChooseCellIdentifier";
NSString * const HomeworkUnitDetailSectionCellIdentifier = @"HomeworkUnitDetailSectionCellIdentifier";
@interface HomeworkUnitDetailViewController ()<ZFPlayerDelegate>
@property(nonatomic, strong) NSString * homeworkId;
@property(nonatomic, strong) NSString * studentId;
@property(nonatomic, strong) NSString * homeworkTypeId;
@property(nonatomic, strong) NSString * unitName;
@property(nonatomic, strong) HomeworkUnitDetailsModel * models;
@property(nonatomic, strong) NSString * typeTitle;
@property (nonatomic, strong) ZFPlayerView        *playerView;
@property(nonatomic, strong) NSIndexPath * selectedIndexPath;
@end

@implementation HomeworkUnitDetailViewController
- (instancetype)initWithStudentId:(NSString *)studentId withHomeworkId:(NSString *)homeworkId withHomeworkTypeId:(NSString *)homeworkTypeId withUnitName:(NSString *)unitName withType:(NSString *) typeTitle{
    self = [super init];
    if (self) {
        self.homeworkTypeId = homeworkTypeId;
        self.homeworkId = homeworkId;
        self.studentId = studentId;
        self.unitName = unitName;
        self.typeTitle = typeTitle;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationItemTitle:@"作业详情"];
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, FITSCALE(50))];
    footerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView =footerView;
}

- (void)registerCell{

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeworkUnitDetailVoiceCell class]) bundle:nil] forCellReuseIdentifier:HomeworkUnitDetailVoiceCellIdentifier];
    
     [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeworkUnitDetailSectionCell class]) bundle:nil] forCellReuseIdentifier:HomeworkUnitDetailSectionCellIdentifier];
    
     [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeworkUnitDetailChooseCell class]) bundle:nil] forCellReuseIdentifier:HomeworkUnitDetailChooseCellIdentifier];
}
- (void)getNormalTableViewNetworkData{
    
    [self requestQueryStudentHomeworkTypeQuestScore];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1 + [self.models.questScores count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    CGFloat height = 0;
    if (indexPath.section ==  0) {
        height = [tableView fd_heightForCellWithIdentifier:HomeworkUnitDetailSectionCellIdentifier configuration:^(id cell) {
            [self configSectionCell:cell indexPath:indexPath];
        }];
    }else{
//        HomeworkUnitDetailModel * tempModel = self.models.questScores[indexPath.section - 1];
        if ([self.models.voiceType boolValue] ) {
            height = [tableView fd_heightForCellWithIdentifier:HomeworkUnitDetailVoiceCellIdentifier configuration:^(id cell) {
                [self configVoiceCell:cell indexPath: indexPath];
            }];
        }else{
            height = [tableView fd_heightForCellWithIdentifier:HomeworkUnitDetailChooseCellIdentifier configuration:^(id cell) {
                [self configChooseCell:cell indexPath: indexPath];
            }];
        }
    }
    return height;
}

- (void)configSectionCell:(HomeworkUnitDetailSectionCell *)tempCell indexPath:(NSIndexPath *)indexPath{
    tempCell.fd_enforceFrameLayout = NO; // Enable to use "-sizeThatFits:"
    [tempCell setupUnitName:self.unitName withQuestionNumber:[self.models.questScores count] withType:self.typeTitle];
    
}

- (void)configVoiceCell:(HomeworkUnitDetailVoiceCell *)tempCell indexPath:(NSIndexPath *)indexPath{
    tempCell.fd_enforceFrameLayout = NO; // Enable to use "-sizeThatFits:"
    HomeworkUnitDetailModel * tempModel = self.models.questScores[indexPath.section - 1];
    [tempCell setupDetailModel:tempModel];
    
}

- (void)configChooseCell:(HomeworkUnitDetailChooseCell *)tempCell indexPath:(NSIndexPath *)indexPath{
    tempCell.fd_enforceFrameLayout = NO; // Enable to use "-sizeThatFits:"
    HomeworkUnitDetailModel * tempModel = self.models.questScores[indexPath.section - 1];
    [tempCell setupDetailModel:tempModel];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell * cell =  nil;
    if (indexPath.section == 0) {
        
        HomeworkUnitDetailSectionCell * tempCell = [tableView dequeueReusableCellWithIdentifier:HomeworkUnitDetailSectionCellIdentifier];
        [self configSectionCell:tempCell indexPath:indexPath];
        tempCell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell = tempCell;
        
    }else{
    
//       HomeworkUnitDetailModel * tempModel = self.models.questScores[indexPath.section - 1];
        if ([self.models.voiceType boolValue] ) {
            HomeworkUnitDetailVoiceCell * tempCell = [tableView dequeueReusableCellWithIdentifier:HomeworkUnitDetailVoiceCellIdentifier];
            
            tempCell.indexPath = indexPath;
            tempCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            //除开点击当前点击的播放的语音 其它的暂停播放的语音 重置
//            if ([self.playerView getCurrentPlayerIndex] && [self.playerView getCurrentPlayerIndex] != indexPath) {
//                [tempCell resetVoiceView];
//            }
            if (self.selectedIndexPath && self.selectedIndexPath.section != indexPath.section ) {
                [tempCell resetVoiceView];
            }
            WEAKSELF
            tempCell.playIndexPathBlock = ^(BOOL playBtnSelected, HomeworkUnitDetailVoiceCell *cell, NSIndexPath *indexPath) {
                if (playBtnSelected) {
                    //当前点击的播放的语音是上次播放的 且为暂停状态
                    if ([weakSelf.playerView getCurrentPlayerIndex] && [weakSelf.playerView getCurrentPlayerIndex] == indexPath &&weakSelf.playerView.isPauseByUser) {
                        [weakSelf.playerView play];
                    }else{
                        weakSelf.selectedIndexPath = indexPath;
                        //先重置其它语音 关闭正在播放的音乐
                        [weakSelf updateTableView];
                        
                        
                        HomeworkUnitDetailModel * tempModel = self.models.questScores[indexPath.section - 1];
                        // 取出字典中的第一视频URL
                        NSURL *videoURL = [NSURL URLWithString: tempModel.voice ];
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
                        [weakSelf.playerView playerControlView:nil playerModel:playerModel playerView:cell];
                        // 下载功能
                        weakSelf.playerView.hasDownload = NO;
                        // 自动播放
                        [weakSelf.playerView autoPlayTheVideo];
                  
           
                    }
                    
                }else{
                    weakSelf.playerView.isPauseByUser = YES;
                    [weakSelf.playerView pause];
                }
            };
            
            [self configVoiceCell:tempCell indexPath:indexPath];
            
             cell = tempCell;
        }else{
            HomeworkUnitDetailChooseCell * tempCell = [tableView dequeueReusableCellWithIdentifier:HomeworkUnitDetailChooseCellIdentifier];
            tempCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [self configChooseCell:tempCell indexPath:indexPath];
            cell = tempCell;
        }
    
    }
    
    return cell;
}
- (void)zf_playerItemPlayerComplete{
    ////
    HomeworkUnitDetailVoiceCell * tempCell = [self.tableView dequeueReusableCellWithIdentifier:HomeworkUnitDetailVoiceCellIdentifier];
    tempCell.playBtn.selected = NO;
    self.playerView.isPauseByUser = NO;
}
#pragma mark ---
- (void)requestQueryStudentHomeworkTypeQuestScore{

    NSDictionary * parameterDic =@{@"studentId":self.studentId,
                                    @"homeworkId":self.homeworkId,
                                   @"homeworkTypeId":self.homeworkTypeId};
    
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_QueryStudentHomeworkTypeQuestScore] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_QueryStudentHomeworkTypeQuestScore];
    
}

- (void)setNetworkRequestStatusBlocks{

    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
       STRONGSELF
        if (request.tag == NetRequestType_QueryStudentHomeworkTypeQuestScore) {
            strongSelf.models = [[HomeworkUnitDetailsModel alloc]initWithDictionary:successInfoObj error:nil];
          
        }
          [strongSelf updateTableView];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
@end
