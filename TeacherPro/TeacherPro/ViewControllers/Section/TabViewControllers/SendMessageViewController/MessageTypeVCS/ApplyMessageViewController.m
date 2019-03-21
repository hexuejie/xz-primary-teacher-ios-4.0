//
//  ApplyMessageViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/6/24.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "ApplyMessageViewController.h"
#import "ApplyMessageCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "ProUtils.h"
#import "NotifyRecvsModel.h"
#import "SessionHelper.h"
#import "SessionModel.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "ApplyNewMessageCell.h"


NSString * const ApplyMessageCellIdentifer = @"ApplyMessageCellIdentifier";
NSString * const ApplyNewMessageCellIdentifer = @"ApplyNewMessageCellIdentifier";
@interface ApplyMessageViewController ()
@property(nonatomic, assign) ApplyMessageViewControllerType  type;
@property(nonatomic, strong) NotifyRecvsModel * notifymodels;
@property(nonatomic, assign) NSInteger btnTag;
@property(nonatomic, strong) NSIndexPath *handleIndexPath;
@end

@implementation ApplyMessageViewController
- (instancetype)initWithType:(ApplyMessageViewControllerType )type{

    self = [super init];
    if (self) {
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString * title = @"";
    if (self.type == ApplyMessageViewControllerType_apply) {
        title = @"申请消息";
    }else if (self.type == ApplyMessageViewControllerType_invitation){
    
        title = @"邀请消息";
    }
    [self setNavigationItemTitle:title];

    self.view.backgroundColor =  project_background_gray;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self navUIBarBackground:0];
    
}
- (NSString *)getDescriptionText{
    NSString * descriptionText = @"";
    if (self.type == ApplyMessageViewControllerType_apply) {
        descriptionText = @"暂无申请消息";
    }else if (self.type == ApplyMessageViewControllerType_invitation){
        
        descriptionText = @"暂无邀请消息";
    }
    return descriptionText;
}

- (void)getNormalTableViewNetworkData
{
//    NSString * userdefaultsKey = @"";
//    if (self.type == ApplyMessageViewControllerType_apply) {
//        userdefaultsKey = NEWS_TYPE_APPLY_MESSAGE;
//    }else if (self.type == ApplyMessageViewControllerType_invitation){
//        userdefaultsKey = NEWS_TYPE_INVITATION_MESSAGE;
//    }
//      NSDictionary * successInfoObj  = [[NSUserDefaults standardUserDefaults] objectForKey:userdefaultsKey];
//    if (!successInfoObj) {
//        [self requestNotificationRecv:@"0"];
//    }else{
//        self.notifymodels = [[NotifyRecvsModel alloc]initWithDictionary:successInfoObj error:nil];
//        [self updateTableView];
//        [self requestNotificationRecv:@"1"];
//    }
    // do nothing
     [self requestNotificationRecv:@"1"];
}
- (void)registerCell{

//    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ApplyMessageCell class]) bundle:nil] forCellReuseIdentifier:ApplyMessageCellIdentifer];
    
    
    [self.tableView registerClass:[ApplyNewMessageCell  class] forCellReuseIdentifier:ApplyNewMessageCellIdentifer];
}
- (NSArray *)getListArray{

    return self.notifymodels.notifyRecvs;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [self.notifymodels.notifyRecvs count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
//    height = [tableView fd_heightForCellWithIdentifier:ApplyMessageCellIdentifer configuration:^(id cell) {
//        [self configureCell:cell atIndexPath:indexPath];
//    } ];
    
    NotifyRecvModel * model = self.notifymodels.notifyRecvs[indexPath.section];
    height = [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"notifyRecvModel" cellClass:[ApplyNewMessageCell class] contentViewWidth:[self cellContentViewWith]];
    return height;


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
 
    WEAKSELF
    ApplyNewMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:ApplyNewMessageCellIdentifer];
    cell.handleIndexPath = indexPath;
    cell.handleBlock = ^(NSInteger index, NSString *recvId, NSIndexPath *handleIndexPath) {
        STRONGSELF
        strongSelf.handleIndexPath = handleIndexPath;
        [self requestHandleNotify:index withRecvId:recvId];

    };

    cell.notifyRecvModel = self.notifymodels.notifyRecvs[indexPath.section];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return  FITSCALE(11);
    }else
        return  FITSCALE(0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return FITSCALE (7);
}
- ( UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH,  FITSCALE(11))];
    view.backgroundColor = [UIColor clearColor];
    
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    UIImageView * footV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, FITSCALE (7))];
    [footV setImage:[UIImage imageNamed:@"speack_line"]];
    return footV;
}

 
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark ---
- (void)requestNotificationRecv:(NSString *)pullMode{
    
    //04：邀请消息、05：申请消息
    NSString * types = @"";
    if (self.type == ApplyMessageViewControllerType_apply) {
        types = @"05";
    }else if (self.type == ApplyMessageViewControllerType_invitation){
    
        types = @"04";
    }
    NSString * pageIndex = [NSString stringWithFormat:@"%zd",self.currentPageNo];
    NSString * pageSize = [NSString stringWithFormat:@"%zd",self.pageCount];
    NSDictionary * parameterDic = @{@"pullMode":pullMode,
                                    @"types":types,
                                    @"pageIndex":pageIndex,
                                     @"pageSize": pageSize};
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_ListTeacherNotificationRecv] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_ListTeacherNotificationRecv];
}


//  处理通知
- (void)requestHandleNotify:(NSInteger )index withRecvId:(NSString *)recvId{
    self.btnTag = index;
    NSString * tempRecvId = recvId;
//     0=拒绝,1=接受
    NSString * handleStatus = [NSString stringWithFormat:@"%zd",index];
    NSDictionary * parameterDic = @{@"recvId":tempRecvId,@"handleStatus":handleStatus};
    [self  sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_TeacherHandleNotify] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_TeacherHandleNotify];
    
    
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
- (void)deleteMessage {

    NSString * tempRecvId = [self getSelectedRecvId];

    NSDictionary * parameterDic = @{@"recvIds":tempRecvId};
    [self  sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_DeleteTeacherNotify] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_DeleteTeacherNotify];
}
- (void)setNetworkRequestStatusBlocks{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
       STRONGSELF
         [strongSelf hideHUD ];
        
        NSString * userdefaultsKey = @"";
        if (strongSelf.type == ApplyMessageViewControllerType_apply) {
            userdefaultsKey = NEWS_TYPE_APPLY_MESSAGE;
        }else if (strongSelf.type == ApplyMessageViewControllerType_invitation){
            userdefaultsKey = NEWS_TYPE_INVITATION_MESSAGE;
        }
        if (request.tag == NetRequestType_TeacherHandleNotify) {
           
            NSString * type =@"";
            if (self.type == ApplyMessageViewControllerType_apply) {
                type = @"申请";
            }else if (self.type == ApplyMessageViewControllerType_invitation){
                
                type = @"邀请";
            }

            NSString * content = @"";
            if (strongSelf.btnTag == 0) {
                content =[NSString stringWithFormat:@"您拒绝了该%@",type];
            }else if (strongSelf.btnTag == 1){
                content = [NSString stringWithFormat:@"您同意了该%@",type];
                SessionModel *sesstion = [[SessionHelper sharedInstance] getAppSession];
                if (self.type == ApplyMessageViewControllerType_invitation && !sesstion.schoolId) {
                     [strongSelf requestQueryTeacherById];
                }
            }
            
            [strongSelf showAlert:TNOperationState_OK content:content block:nil];
            if (strongSelf.updateMessageList) {
                strongSelf.updateMessageList();
            }
            
            
            NSArray * tempArray =[NSArray arrayWithArray: strongSelf.notifymodels.notifyRecvs];
            
            
            NotifyRecvModel * model = tempArray[strongSelf.handleIndexPath.section];
            [strongSelf.notifymodels.notifyRecvs removeObject:model];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf updateTableView];
                 if (strongSelf.notifymodels.notifyRecvs.count == 0) {
                    [strongSelf.view viewWithTag:bottomTag].hidden = YES;
                    strongSelf.navigationItem.rightBarButtonItem.customView.hidden = YES;
                }
            });
            
        }else if (request.tag == NetRequestType_ListTeacherNotificationRecv){
            
            if (strongSelf.currentPageNo == 0) {
                strongSelf.notifymodels = nil;
            }
            
            if (!strongSelf.notifymodels.notifyRecvs) {
                strongSelf.notifymodels = [[NotifyRecvsModel alloc]initWithDictionary:successInfoObj error:nil];
                if ([strongSelf.notifymodels.notifyRecvs count] > 0) {
                    strongSelf.navigationItem.rightBarButtonItem.customView.hidden = NO;
                    strongSelf.currentPageNo ++ ;
                }
            }else{
            
                NotifyRecvsModel * tempModel =  [[NotifyRecvsModel alloc]initWithDictionary:successInfoObj error:nil];
                if ([tempModel.notifyRecvs count] >0) {
                    [strongSelf.notifymodels.notifyRecvs addObjectsFromArray:tempModel.notifyRecvs];
                }
                strongSelf.currentPageNo ++ ;
                
            }
            
//            if ([successInfoObj[@"notifyRecvs"] count] > 0) {
//                //新增消息
//                if ([[NSUserDefaults standardUserDefaults] objectForKey:userdefaultsKey]) {
//                    NSDictionary * oldNotifyRecvs = [[NSUserDefaults standardUserDefaults] objectForKey:userdefaultsKey];
//                    NSArray * addNotifyRecvs =  successInfoObj[@"notifyRecvs"];
//                    NSMutableArray * notifyRecvs = [[NSMutableArray alloc]init];
//                    [notifyRecvs addObjectsFromArray:addNotifyRecvs];
//                    [notifyRecvs addObject:oldNotifyRecvs[@"notifyRecvs"]];
//                    NSDictionary *  newNotifyRecvsDic = @{@"notifyRecvs":notifyRecvs};
//                    [[NSUserDefaults standardUserDefaults] setObject:newNotifyRecvsDic forKey:userdefaultsKey];
//                    strongSelf.notifymodels = [[NotifyRecvsModel alloc]initWithDictionary:newNotifyRecvsDic error:nil];
//                }else{
//                    //第一次加载消息缓存
//                    [[NSUserDefaults standardUserDefaults] setObject:successInfoObj forKey:userdefaultsKey];
//                    
//                    strongSelf.notifymodels = [[NotifyRecvsModel alloc]initWithDictionary:successInfoObj error:nil];
//                }
//                
//            }
//            //消息列表有数据 显示编辑
//            if ([[[NSUserDefaults standardUserDefaults] objectForKey:userdefaultsKey][@"notifyRecvs"] count] > 0) {
//                strongSelf.navigationItem.rightBarButtonItem.customView.hidden = NO;
//            }

           [strongSelf updateTableView];
        }else if (request.tag == NetRequestType_DeleteTeacherNotify){
            NSArray * tempArray =[NSArray arrayWithArray: strongSelf.notifymodels.notifyRecvs];
//            NSArray * oldTotalArray = [[NSUserDefaults standardUserDefaults] objectForKey:userdefaultsKey][@"notifyRecvs"];
//            NSMutableArray * oldTotalTempArray = [[NSMutableArray alloc]initWithArray: oldTotalArray];
            
            for (NSIndexPath * index in strongSelf.selectedIndexArray) {
                NotifyRecvModel * model = tempArray[index.section];
                [strongSelf.notifymodels.notifyRecvs removeObject:model];
//                NSDictionary *tempDic = oldTotalArray[index.section];
//                [oldTotalTempArray removeObject:tempDic];
 
                
            }
            
//            [[NSUserDefaults standardUserDefaults] setObject:@{@"notifyRecvs":oldTotalTempArray}  forKey:userdefaultsKey];

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

        }else if (request.tag == NetRequestType_QueryTeacherById){
        
         
            if (successInfoObj[@"teacher"]) {
                
                SessionModel *model = [[SessionModel alloc]initWithDictionary:successInfoObj[@"teacher" ]error:nil];
                [[SessionHelper sharedInstance] setAppSession:model];
                [[SessionHelper sharedInstance] saveCacheSession:model];
                
            }

        }
        
    }];
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


- (void)requestQueryTeacherById{
  
    [self  sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_QueryTeacherById] parameterDic:nil requestMethodType:RequestMethodType_POST requestTag:NetRequestType_QueryTeacherById];
    
}
@end
