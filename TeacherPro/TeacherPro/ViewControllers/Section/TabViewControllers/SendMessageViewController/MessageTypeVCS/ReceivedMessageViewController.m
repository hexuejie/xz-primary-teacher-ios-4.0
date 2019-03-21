
//
//  receivedMessageViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/6/24.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "ReceivedMessageViewController.h"
#import "ProUtils.h"
#import "NotifyRecvsModel.h"

#import "ReceiveMessageTimeLineCell.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "UIView+SDAutoLayout.h"
#import "ZFPlayer.h"
 

NSString * const ReceiveMessageCellIdentifier =  @"ReceiveMessageCellIdentifier";
@interface ReceivedMessageViewController ()<ZFPlayerDelegate>
@property (nonatomic, strong) NotifyRecvsModel * notifymodels;
@property (nonatomic, strong) ZFPlayerView        *playerView;

@end

@implementation ReceivedMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationItemTitle:@"收到消息"];
    self.view.backgroundColor =  project_background_gray;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self navUIBarBackground:0];
}

- (NSString *)getDescriptionText{
    NSString * descriptionText = @"暂无消息";
    return descriptionText;
}

- (void)getNormalTableViewNetworkData
{
   NSDictionary * successInfoObj  = [[NSUserDefaults standardUserDefaults] objectForKey:NEWS_TYPE_RECEIVED_MESSAGE];

    if (!successInfoObj||[successInfoObj[@"notifyRecvs"] count] == 0) {
          [self requestNotificationRecv:@"0"];
    }else{
        
        self.notifymodels = [[NotifyRecvsModel alloc]initWithDictionary:[self efficacyDataDic:successInfoObj] error:nil];
       
        [self updateTableView];
        [self requestNotificationRecv:@"1"];
    }
  
}

//效验数据
- (NSDictionary *)efficacyDataDic:(NSDictionary *)successInfoObj{
    
    NSMutableArray * notifyRecvsValues = [NSMutableArray array];
    for (id obj in successInfoObj[@"notifyRecvs"] ) {
        
        if ([obj isKindOfClass:[NSDictionary class]] ) {
            [notifyRecvsValues addObject:obj];
        }else{
            NSLog(@"==%@==数据格式不对=obj",obj);
        }
    }
    NSDictionary * notifyRecvsDic = @{@"notifyRecvs":notifyRecvsValues};
    return notifyRecvsDic;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)getListArray{
    
    return self.notifymodels.notifyRecvs;
}


- (void)rightAction:(UIButton *)button{
    
    [super rightAction:button];
    [self.tableView reloadData];
}
- (void)registerCell{
     [self.tableView registerClass:[ReceiveMessageTimeLineCell class]  forCellReuseIdentifier:ReceiveMessageCellIdentifier];
}
#pragma mark ----DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    

    return [self.notifymodels.notifyRecvs count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NotifyRecvModel * model = self.notifymodels.notifyRecvs[indexPath.section];
 
  
    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[ReceiveMessageTimeLineCell class] contentViewWidth:[self cellContentViewWith]];
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
    UITableViewCell * cell = nil;
    
    ReceiveMessageTimeLineCell  *tempCell = [tableView dequeueReusableCellWithIdentifier:ReceiveMessageCellIdentifier];
    tempCell.indexPath = indexPath;
    tempCell.model = self.notifymodels.notifyRecvs[indexPath.section];
    
    //除开点击当前点击的播放的语音 其它的暂停播放的语音 重置
    if ([self.playerView getCurrentPlayerIndex] && [self.playerView getCurrentPlayerIndex] != indexPath) {
           [tempCell.voiceView resetVoiceView];
    }
 
    WEAKSELF
    [tempCell setMoreButtonClickedBlock:^(NSIndexPath *indexPath) {
        
        NotifyRecvModel * model = weakSelf.notifymodels.notifyRecvs [indexPath.section];
        if (model.isOpening) {
            model.isOpening = nil;
        }else{
            model.isOpening = [NSNumber numberWithInt:0];
        }
        
        [weakSelf.tableView reloadData];
    }];
    
 
    
    __block ReceiveMessageTimeLineCell *playCell     = tempCell;
 
    
    [tempCell setPlayButtonClickedBlock:^(NSIndexPath * indexPath, BOOL playBtnSelected,ReceiveMessageTimeLineCell * cellView){
        
        if (playBtnSelected) {
            //当前点击的播放的语音是上次播放的 且为暂停状态
            if ([weakSelf.playerView getCurrentPlayerIndex] && [weakSelf.playerView getCurrentPlayerIndex] == indexPath &&weakSelf.playerView.isPauseByUser) {
                [weakSelf.playerView play];
            }else{
                //播放新语音
                NotifyRecvModel * model = weakSelf.notifymodels.notifyRecvs[indexPath.section];
                //   URL
                NSURL *videoURL = [NSURL URLWithString: model.voice];
                
                ZFPlayerModel *playerModel = [[ZFPlayerModel alloc] init];
                //        playerModel.title            = model.title;
                playerModel.videoURL         = videoURL;
                //        playerModel.placeholderImageURLString = model.coverForFeed;
                playerModel.scrollView       = weakSelf.tableView;
                playerModel.indexPath        = indexPath;
                // 赋值分辨率字典
                //        playerModel.resolutionDic    = dic;
                // player的父视图tag
                playerModel.fatherViewTag    = playCell.fatherView.tag;
                
                // 设置播放控制层和model
                [weakSelf.playerView playerControlView:nil playerModel:playerModel playerView:cellView.voiceView];
                // 下载功能
                weakSelf.playerView.hasDownload = NO;
                // 自动播放
                [weakSelf.playerView autoPlayTheVideo];
                
                //重置其它语音
                [weakSelf updateTableView];
            }
            
        }else{
            weakSelf.playerView.isPauseByUser = YES;
            [weakSelf.playerView pause];
        }
        
    }];
    
    ////// 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅 //////
    
    [tempCell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    
    cell = tempCell;
 
    return cell;
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

#pragma mark ---

- (void)deleteMessage {
    
    NSString * tempRecvId = [self getSelectedRecvId];
    
    NSDictionary * parameterDic = @{@"recvIds":tempRecvId};
    [self  sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_DeleteTeacherNotify] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_DeleteTeacherNotify];
}
- (NSString *)getSelectedRecvId{
    
    NSString * recvIds = @"";
    for (NSIndexPath * index in self.selectedIndexArray) {
        NotifyRecvModel * model = self.notifymodels.notifyRecvs[index.section];
        if (recvIds.length ==0) {
            recvIds = [NSString stringWithFormat:@"%@",model.recvId];
        }else{
            recvIds =[recvIds stringByAppendingString:[NSString stringWithFormat:@",%@",model.recvId]];
        }
    }
    return recvIds;
}

- (void)requestNotificationRecv:(NSString *)pullMode{
    
    
    NSString * pageIndex = [NSString stringWithFormat:@"%zd",self.currentPageNo];
    NSString * pageSize = [NSString stringWithFormat:@"%zd",self.pageCount];
    NSDictionary * parameterDic = @{@"pullMode":pullMode,
                                    @"types":@"00",
                                    @"pageIndex":pageIndex,
                                    @"pageSize": pageSize};

 
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_ListTeacherNotificationRecv] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_ListTeacherNotificationRecv];
}

- (void)setNetworkRequestStatusBlocks{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        
          NSString * userdefaultsKey = NEWS_TYPE_RECEIVED_MESSAGE;
        if (request.tag ==  NetRequestType_ListTeacherNotificationRecv) {
            
 
            
            if (strongSelf.currentPageNo == 0 && ![[NSUserDefaults standardUserDefaults] objectForKey:userdefaultsKey]) {
                strongSelf.notifymodels = nil;
            }
           
            if ([successInfoObj[@"notifyRecvs"] count] > 0) {
                
                if ([[NSUserDefaults standardUserDefaults] objectForKey:userdefaultsKey]) {
                    NSDictionary * oldNotifyRecvs = [[NSUserDefaults standardUserDefaults] objectForKey:userdefaultsKey];
                    NSDictionary * rightOldNotifyRecvs = [strongSelf efficacyDataDic:oldNotifyRecvs];
                    NSArray * addNotifyRecvs =  successInfoObj[@"notifyRecvs"];
                    NSMutableArray * notifyRecvs = [[NSMutableArray alloc]init];
                    [notifyRecvs addObjectsFromArray:addNotifyRecvs];
                    [notifyRecvs addObjectsFromArray:rightOldNotifyRecvs[@"notifyRecvs"]];
                    NSDictionary *  newNotifyRecvsDic = @{@"notifyRecvs":notifyRecvs};
                    [[NSUserDefaults standardUserDefaults] setObject:newNotifyRecvsDic forKey:userdefaultsKey];
                   strongSelf.notifymodels = [[NotifyRecvsModel alloc]initWithDictionary:newNotifyRecvsDic error:nil];
                }else{
                    
                     [[NSUserDefaults standardUserDefaults] setObject:successInfoObj forKey:userdefaultsKey];
                     strongSelf.notifymodels = [[NotifyRecvsModel alloc]initWithDictionary:successInfoObj error:nil];
                }
                
            }
 
             if ([[[NSUserDefaults standardUserDefaults] objectForKey:userdefaultsKey][@"notifyRecvs"] count] > 0) {
                 strongSelf.navigationItem.rightBarButtonItem.customView.hidden = NO;
             }
            [strongSelf updateTableView];
            
            
        }else if (request.tag == NetRequestType_DeleteTeacherNotify){
            
            NSArray * tempArray =[NSArray arrayWithArray: strongSelf.notifymodels.notifyRecvs];
            NSArray * oldTotalArray = [[NSUserDefaults standardUserDefaults] objectForKey:userdefaultsKey][@"notifyRecvs"];
            
            NSMutableArray * oldTotalTempArray = [[NSMutableArray alloc]initWithArray: oldTotalArray];
            
            for (NSIndexPath * index in strongSelf.selectedIndexArray) {
                NotifyRecvModel * model = tempArray[index.section];
                [strongSelf.notifymodels.notifyRecvs removeObject:model];
                NSDictionary *tempDic = oldTotalArray[index.section];
                [oldTotalTempArray removeObject:tempDic];
             
            }
            
            [[NSUserDefaults standardUserDefaults] setObject:@{@"notifyRecvs":oldTotalTempArray}  forKey:userdefaultsKey];
            
            if ([strongSelf.selectedIndexArray count] > 0) {
                [strongSelf.selectedIndexArray removeAllObjects];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf exitEdit];
                [strongSelf updateTableView];
                if (strongSelf.updateMessageList) {
                    strongSelf.updateMessageList();
                }
                if (strongSelf.notifymodels.notifyRecvs.count == 0) {
                    [strongSelf.view viewWithTag:bottomTag].hidden = YES;
                    strongSelf.navigationItem.rightBarButtonItem.customView.hidden = YES;
                }
            });
            
        }
        
      
        
    }];
}

- (ZFPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [ZFPlayerView sharedPlayerView];
        _playerView.delegate = self;
        // 当cell播放视频由全屏变为小屏时候，不回到中间位置
        _playerView.cellPlayerOnCenter = NO;
        
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
    
    return [self.notifymodels.notifyRecvs count];
}

@end
