//
//  SenderMessageListViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/6/28.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//
//已发送消息
#import "SenderMessageListViewController.h"

#import "ProUtils.h"
#import "TeacherSendsModel.h"
#import "SendMessageTimeLineCell.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "UIView+SDAutoLayout.h"
#import "ZFPlayer.h"



#define  bottomHeight   FITSCALE(54)
 


NSString * const SendMessageTimeLineCellIdentifier =  @"SendMessageTimeLineCellIdentifier";
@interface SenderMessageListViewController ()<ZFPlayerDelegate>
@property (nonatomic, strong) TeacherSendsModel * models;
@property (nonatomic, strong) ZFPlayerView        *playerView;

@property (nonatomic, strong) SendMessageTimeLineCell  *playplayCell;
@property (nonatomic, strong) NSMutableDictionary  *allCellsDictionary;
@end

@implementation SenderMessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationItemTitle:@"已发消息"];
    self.view.backgroundColor =  project_background_gray;
    self.tableView.backgroundColor = [UIColor clearColor];
  
    [self navUIBarBackground:0];
}

- (NSString *)getDescriptionText{
    NSString * descriptionText = @"暂无消息";
    
    return descriptionText;
}

- (void)getNormalTableViewNetworkData{
    
    NSDictionary * successInfoObj  = [[NSUserDefaults standardUserDefaults] objectForKey:NEWS_TYPE_RECEIVED_MESSAGE];
    
    if (!successInfoObj) {
       
    }else{
//        self.notifymodels = [[NotifyRecvsModel alloc]initWithDictionary:successInfoObj error:nil];
        [self updateTableView];
         
    }
    [self requestListTeacherNotificationSend];
   
}

- (void)rightAction:(UIButton *)button{
    
    [super rightAction:button];
    [self.tableView reloadData];
}
- (void)registerCell{
    [self.tableView registerClass:[SendMessageTimeLineCell class]  forCellReuseIdentifier:SendMessageTimeLineCellIdentifier];
}



- (NSArray *)getListArray{
    return self.models.notifySends;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    return [self.models.notifySends count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NotifySendsModel * model = self.models.notifySends[indexPath.section];
    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[SendMessageTimeLineCell class] contentViewWidth:[self cellContentViewWith]];
}

- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    if (self.tableView.editing) {
        
        width = width - FITSCALE(40);
    }
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *tagtag = [NSString stringWithFormat:@"%ld",indexPath.section];
    SendMessageTimeLineCell  *tempCell = self.allCellsDictionary[tagtag];
    if (!tempCell) {
        tempCell = [[SendMessageTimeLineCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SendMessageTimeLineCellIdentifier];
        [self.allCellsDictionary setObject:tempCell forKey:tagtag];
    }
     NSLog(@"tagtag  %@",tagtag);
    tempCell.indexPath = indexPath;
    NotifySendsModel * model = self.models.notifySends[indexPath.section];
    tempCell.model = model;
    //除开点击当前点击的播放的语音 其它的暂停播放的语音 重置
    if ([self.playerView getCurrentPlayerIndex] && [self.playerView getCurrentPlayerIndex] != indexPath && self.playplayCell != tempCell) {
        [tempCell.voiceView resetVoiceView];
    }

    WEAKSELF
    [tempCell setMoreButtonClickedBlock:^(NSIndexPath *indexPath) {
        
        NotifySendsModel * model = weakSelf.models.notifySends[indexPath.section];
        if (model.isOpening) {
            model.isOpening = nil;
        }else{
            model.isOpening = [NSNumber numberWithInt:0];
        }
        [weakSelf.tableView reloadData];
    }];
    
    __block SendMessageTimeLineCell *playCell     = tempCell;
    [tempCell setPlayButtonClickedBlock:^(NSIndexPath * indexPath, BOOL playBtnSelected,SendMessageTimeLineCell * cellView){
        
        if (playBtnSelected) {
            
            //当前点击的播放的语音是上次播放的 且为暂停状态
            if ([weakSelf.playerView getCurrentPlayerIndex] && [weakSelf.playerView getCurrentPlayerIndex] == indexPath &&weakSelf.playerView.isPauseByUser) {
                [weakSelf.playerView play];
            }else{
            
                NotifySendsModel * model = weakSelf.models.notifySends[indexPath.section];
                NSURL *videoURL = [NSURL URLWithString: model.voice];
                
                ZFPlayerModel *playerModel = [[ZFPlayerModel alloc] init];
                playerModel.videoURL         = videoURL;
                playerModel.indexPath        = indexPath;
                playerModel.fatherViewTag    = playCell.fatherView.tag;
                
                [weakSelf.playerView resetPlayer];
                [weakSelf.playerView playerControlView:nil playerModel:playerModel playerView:cellView.voiceView];
                weakSelf.playerView.hasDownload = NO;
                [weakSelf.playerView autoPlayTheVideo];
                
                [weakSelf.playplayCell.voiceView resetVoiceView];
                weakSelf.playplayCell = playCell;
//                //重置其它语音
//                [weakSelf updateTableView];
            }
            cellView.voiceView.playButton.selected = YES;
        }else{
            
            cellView.voiceView.playButton.selected = NO;
            weakSelf.playerView.isPauseByUser = YES;
            [weakSelf.playerView pause];
        }
        
    }];
    [tempCell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    return tempCell;
}
- (void)zf_playerItemPlayerComplete{
   
    self.playerView.isPauseByUser = NO;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return  FITSCALE(11);
    }else
        return  FITSCALE(0);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
     
    return FITSCALE(7);
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIImageView * footV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, FITSCALE (7))];
    [footV setImage:[UIImage imageNamed:@"speack_line"]];
    return footV;
}

- ( UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;{
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH,  FITSCALE(20))];
    view.backgroundColor = [UIColor clearColor];
    return view;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ---
- (void)deleteMessage {
    
    NSString * tempRecvId = [self getSelectedRecvId];
    
    NSDictionary * parameterDic = @{@"sendIds":tempRecvId};
    [self  sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_DeleteTeacherSendNotify] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_DeleteTeacherSendNotify];
}
- (NSString *)getSelectedRecvId{
    
    NSString * recvIds = @"";
    for (NSIndexPath * index in self.selectedIndexArray) {
        NotifySendsModel * model = self.models.notifySends[index.section];
        if (recvIds.length ==0) {
            recvIds = [NSString stringWithFormat:@"%@",model.notifyId];
        }else{
            recvIds =[recvIds stringByAppendingString:[NSString stringWithFormat:@",%@",model.notifyId]];
        }
    }
    return recvIds;
}

- (void)requestListTeacherNotificationSend{
    NSString * pageIndex = [NSString stringWithFormat:@"%zd",self.currentPageNo];
    NSString * pageCount = [NSString  stringWithFormat:@"%zd",self.pageCount];
    NSDictionary * parameterDic = @{@"pageIndex":pageIndex,
                                    @"pageSize":pageCount,
                                    };
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_ListTeacherNotificationSend] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_ListTeacherNotificationSend];
}

- (void)setNetworkRequestStatusBlocks{
    
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
//         NSString * userdefaultsKey = NEWS_TYPE_SENDER_MESSAGE;
        
        if (request.tag == NetRequestType_ListTeacherNotificationSend) {
            if (strongSelf.currentPageNo == 0) {
                strongSelf.models = nil;
            }
            if (!strongSelf.models.notifySends) {
                strongSelf.models = [[TeacherSendsModel alloc]initWithDictionary:successInfoObj error:nil];
                if ([strongSelf.models.notifySends count] > 0) {
                    strongSelf.navigationItem.rightBarButtonItem.customView.hidden = NO;
                    strongSelf.currentPageNo++;
                }
                 
            }else{
                TeacherSendsModel * tempModel = [[TeacherSendsModel alloc]initWithDictionary:successInfoObj error:nil];
                if ([tempModel.notifySends count] > 0) {
                    
                     [strongSelf.models.notifySends addObjectsFromArray:tempModel.notifySends];
                    
                }
                strongSelf.currentPageNo++;
            }
            
            [strongSelf updateTableView];
        
        }else if (request.tag == NetRequestType_DeleteTeacherSendNotify){
            NSArray * tempArray =[NSArray arrayWithArray: strongSelf.models.notifySends];
            
            for (NSIndexPath * index in strongSelf.selectedIndexArray) {
                NotifySendsModel * model = tempArray[index.section];
                [strongSelf.models.notifySends removeObject:model];
                
            }
            
            if ([strongSelf.selectedIndexArray count] > 0) {
                [strongSelf.selectedIndexArray removeAllObjects];
            }
            [strongSelf exitEdit];
            [strongSelf updateTableView];
 
            if (strongSelf.updateMessageList) {
                strongSelf.updateMessageList();
            }
            if (strongSelf.models.notifySends.count == 0) {
                 [strongSelf.view viewWithTag:bottomTag].hidden = YES;
                 strongSelf.navigationItem.rightBarButtonItem.customView.hidden = YES;
            }
            
        }
        
        
        
    }];
}

- (NSMutableDictionary *)allCellsDictionary{
    if (!_allCellsDictionary) {
        _allCellsDictionary = [NSMutableDictionary new];
    }
    return _allCellsDictionary;
}
- (ZFPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [ZFPlayerView sharedPlayerView];
        _playerView.delegate = self;
        // 当cell划出屏幕的时候停止播放
        _playerView.stopPlayWhileCellNotVisable = NO;
         ZFPlayerShared.isLockScreen = YES;
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


#pragma mark 

- (void)getLoadMoreTableViewNetworkData{

    [self getNormalTableViewNetworkData];
}

//下拉刷新调用方法
- (void)drogDownRefresh{
    
    self.currentPageNo = 0;
    [self getNormalTableViewNetworkData];
}

- (NSInteger)getNetworkTableViewDataCount{

    return [self.models.notifySends count];
}

- (void)dealloc{
    self.playerView = nil;
}
@end
