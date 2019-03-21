//
//  StudentsFeedbackViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/7/9.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "StudentsFeedbackViewController.h"
#import "FeedbackStudentNameCell.h"
#import "PlaybackControlCell.h"
#import "FeedbackImageCell.h"
#import "StudentHomeworkFeedbacksModel.h"
#import "SDAutoLayout.h"
#import "ZFPlayer.h"
#import "StudentNoFeedbackCell.h"
#import "UIImageView+WebCache.h"

@class XLPagerTabStripViewController;
NSString * const FeedbackPlaybackControlCellIdentifier = @"FeedbackPlaybackControlCellIdentifier";
NSString * const FeedbackImageCellIdentifier = @"FeedbackImageCellIdentifier";
NSString * const FeedbackStudentNameCellIdentifier = @"FeedbackStudentNameCellIdentifier";
NSString * const StudentNoFeedbackCellIdentifier = @"StudentNoFeedbackCellIdentifier";
@interface StudentsFeedbackViewController ()<ZFPlayerDelegate>
@property(nonatomic, copy)NSString * homeworkId;
@property(nonatomic, strong) StudentHomeworkFeedbacksModel * models;
@property (nonatomic, strong) ZFPlayerView        *playerView;
@property (nonatomic, assign) StudentFeedbackType type;
@end

@implementation StudentsFeedbackViewController
- (instancetype)initWithHomeworkId:(NSString *)homeworkId withStudentFeedbackType:(StudentFeedbackType)type{
    self = [super init];
    if (self) {
        self.homeworkId = homeworkId;
        self.type = type;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, FITSCALE(50))];
    footerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView =footerView;
    
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, FITSCALE(7))];
    footerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = headerView;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = project_background_gray;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self navUIBarBackground:0];
}
- (void)getNormalTableViewNetworkData{

    [self requestFeedback];
 
}
- (void)registerCell{

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PlaybackControlCell class]) bundle:nil] forCellReuseIdentifier:FeedbackPlaybackControlCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FeedbackStudentNameCell class]) bundle:nil] forCellReuseIdentifier:FeedbackStudentNameCellIdentifier];
    [self.tableView registerClass: [FeedbackImageCell class] forCellReuseIdentifier:FeedbackImageCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([StudentNoFeedbackCell class]) bundle:nil] forCellReuseIdentifier:StudentNoFeedbackCellIdentifier];
 
}


-(NSString *)titleForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    NSString * str = @"";
    if (self.type == StudentFeedbackType_unFeedback) {
        str = @"未反馈";
    }else if (self.type == StudentFeedbackType_feedback){
         str = @"已反馈";
    }
    return str;
    
}
#pragma mark 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return [self.models.feedbacks count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    StudentFeedbackModel * model = self.models.feedbacks[section];
    NSInteger row = 1;
    if([model.homeworkFeedback isEqualToString:@"photo"]){
        //        FeedbackStudentNameCell
        if ([model.feedbackPhotos count] > 0) {
            row = 2;
        }
    }
    return row;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    CGFloat height = 0;
    if (indexPath.row == 0) {
        height = 55;
    }else{
        height = 100;
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell * cell = nil;
    if (indexPath.row == 0) {
        FeedbackStudentNameCell * tempCell = [tableView dequeueReusableCellWithIdentifier:FeedbackStudentNameCellIdentifier];
          StudentFeedbackModel * model = self.models.feedbacks[indexPath.section];
        tempCell.haedLogoImage.backgroundColor = [UIColor redColor];
        
        NSString * avatar = model.avatar;
        NSString * sex = model.sex;
        NSString * placeholderImgName = @"";
        if ([sex isEqualToString:@"female"]) {
            placeholderImgName =  @"student_wuman";
        }else if ([sex isEqualToString:@"male"]){
            placeholderImgName =  @"student_man";
        }else{
            placeholderImgName =  @"student_wuman";
        }
        [tempCell.haedLogoImage  sd_setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:  [UIImage imageNamed:placeholderImgName]];

        
        //录音反馈
        if ([model.homeworkFeedback isEqualToString:@"sound"] )  {
            if (model.feedbackSound) {
                tempCell.audioPlayer.hidden = NO;
                tempCell.audioPlayer.tag = indexPath.section;

                tempCell.audioPlayer.selected = NO;
                
                [tempCell.audioPlayer addTarget:self action:@selector(audioPlayerClick:) forControlEvents:UIControlEventTouchUpInside];
                //除开点击当前点击的播放的语音 其它的暂停播放的语音 重置
                if ([self.playerView getCurrentPlayerIndex] && [self.playerView getCurrentPlayerIndex] != indexPath) {
                    tempCell.audioPlayer.selected = NO;
                }
                
                cell = tempCell;
            }
        }
        NSString * studentName = [NSString stringWithFormat:@"%@",model.studentName];
        [tempCell setupStudentName:studentName];
        cell = tempCell;
    }else if(indexPath.row == 1) {
        
        FeedbackImageCell * tempCell = [tableView dequeueReusableCellWithIdentifier:FeedbackImageCellIdentifier];
        StudentFeedbackModel * model = self.models.feedbacks[indexPath.section];
        tempCell.model = model;
        //            CheckHomeworkDetailImageCell
        cell = tempCell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark request
- (void)audioPlayerClick:(UIButton *)button{
    button.selected = !button.selected;
    BOOL playBtnSelected = button.selected;
    if (playBtnSelected) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:button.tag];
        //当前点击的播放的语音是上次播放的 且为暂停状态
        if ([self.playerView getCurrentPlayerIndex] && [self.playerView getCurrentPlayerIndex] == indexPath &&self.playerView.isPauseByUser) {
            [self.playerView play];
        }else{
            
            StudentFeedbackModel * model = self.models.feedbacks[button.tag];
            
            // 取出字典中的第一视频URL
            NSURL *videoURL = [NSURL URLWithString:model.feedbackSound ];
            ZFPlayerModel *playerModel = [[ZFPlayerModel alloc] init];
            
            playerModel.videoURL         =  videoURL;
            
            playerModel.scrollView       = self.tableView;
            playerModel.indexPath        = indexPath;
            self.tableView.tag = 99;
            playerModel.fatherViewTag    = self.tableView.tag;
            
            // 设置播放控制层和model
            [self.playerView playerControlView:nil playerModel:playerModel playerView:button.superview];
            self.playerView.hasDownload = NO;
            [self.playerView autoPlayTheVideo];
            //重置其它语音
            //                            [weakSelf updateTableView];
        }
        button.selected = YES;
    }else{
        button.selected = NO;
        [self.playerView pause];
    }
}


- (void)requestFeedback{

    NSDictionary * parameterDic = @{@"homeworkId": self.homeworkId};
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_QueryHomeworkStudentFeedbacks] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_QueryHomeworkStudentFeedbacks];
}
- (void)setNetworkRequestStatusBlocks{

    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag ==  NetRequestType_QueryHomeworkStudentFeedbacks) {
            if (self.type == StudentFeedbackType_unFeedback) {
                NSMutableArray * feedbacks = [NSMutableArray array];
                for (int i = 0; i< [successInfoObj[@"feedbacks"] count]; i++) {
                    NSArray * tempFeedBacks = successInfoObj[@"feedbacks"];
                    NSDictionary * dic = tempFeedBacks[i];
                    if ((!dic[@"feedbackPhotos"] || [dic[@"feedbackPhotos"] count] ==0 ) &&  (!dic[@"feedbackSound"]||[dic[@"feedbackSound"] length] ==0 )  ) {
                        [feedbacks addObject:dic];
                    }
                    
                }
                strongSelf.models = [[StudentHomeworkFeedbacksModel alloc]initWithDictionary:@{@"feedbacks":feedbacks} error:nil];
            }else if (self.type == StudentFeedbackType_feedback){
                
                NSMutableArray * feedbacks = [NSMutableArray array];
                for (int i = 0; i< [successInfoObj[@"feedbacks"] count]; i++) {
                    NSArray * tempFeedBacks = successInfoObj[@"feedbacks"];
                    NSDictionary * dic = tempFeedBacks[i];
                    if ((dic[@"feedbackPhotos"] && [dic[@"feedbackPhotos"] count] >0 ) ||  (dic[@"feedbackSound"]&& [dic[@"feedbackSound"] length] > 0 )  ) {
                        [feedbacks addObject:dic];
                    }
                    
                }
                strongSelf.models = [[StudentHomeworkFeedbacksModel alloc]initWithDictionary:@{@"feedbacks":feedbacks} error:nil];
              
                
            }
         
            [strongSelf updateTableView];
        }
        
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

- (void)zf_playerItemPlayerComplete{
    [self.tableView reloadData];
}
- (void)zf_playerItemStatusFailed:(NSError *)error{
    NSString * content = @"语音播放失败！请稍后再试";
    [self showAlert:TNOperationState_Fail content:content block:nil];
    
}
// 页面消失时候
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.playerView resetPlayer];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}


@end
