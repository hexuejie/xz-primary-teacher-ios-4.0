//
//  SystemMessageViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/6/28.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//
//系统消息
#import "SystemMessageViewController.h"

#import "ProUtils.h"
#import "NotifyRecvsModel.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "SystemMessageNewCell.h"
#import "UITableView+SDAutoTableViewCellHeight.h"


NSString * const SystemMessageNewCellIdentifier = @"SystemMessageNewCellIdentifier";
@interface SystemMessageViewController ()
@property(nonatomic, strong) NotifyRecvsModel * notifymodels;
@end

@implementation SystemMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationItemTitle:@"系统消息"];

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
    
    NSDictionary * successInfoObj  = [[NSUserDefaults standardUserDefaults] objectForKey:NEWS_TYPE_SYSTEM_MESSAGE];
    if (!successInfoObj||[successInfoObj[@"notifyRecvs"] count] == 0) {
        [self requestNotificationRecv:@"0"];
    }else{
       self.notifymodels = [[NotifyRecvsModel alloc]initWithDictionary:[self efficacyDataDic:successInfoObj] error:nil];
        
        [self updateTableView];
       [self requestNotificationRecv:@"1"];
        
    }
    
    // do nothing
    
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
- (void)registerCell{
  
    [self.tableView registerClass:[SystemMessageNewCell class] forCellReuseIdentifier:SystemMessageNewCellIdentifier];
    
    
}

- (NSArray *)getListArray{

    return self.notifymodels.notifyRecvs;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger sections = [self.notifymodels.notifyRecvs count];
    
    NSLog(@"%zd===",sections);
    return sections;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height =  0;

    
     NotifyRecvModel * model = self.notifymodels.notifyRecvs[indexPath.section];
     height = [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"notifyModel" cellClass:[SystemMessageNewCell class] contentViewWidth:[self cellContentViewWith]];
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
    UITableViewCell * cell = nil;
    SystemMessageNewCell *tempCell = [tableView dequeueReusableCellWithIdentifier:SystemMessageNewCellIdentifier];
    tempCell.notifyModel = self.notifymodels.notifyRecvs[indexPath.section];
    tempCell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell = tempCell;
    return cell;
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
- ( UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;{
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH,  FITSCALE(20))];
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
                                    @"types":@"02",
                                    @"pageIndex":pageIndex,
                                    @"pageSize": pageSize};
//    NSDictionary * parameterDic = @{@"pullMode":@"0",@"types":@"02"};
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_ListTeacherNotificationRecv] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_ListTeacherNotificationRecv];
}

- (void)setNetworkRequestStatusBlocks{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
            NSString * userdefaultsKey = NEWS_TYPE_SYSTEM_MESSAGE;
        if (request.tag ==  NetRequestType_ListTeacherNotificationRecv) {
            

            if (strongSelf.currentPageNo == 0 && ![[NSUserDefaults standardUserDefaults] objectForKey:userdefaultsKey]) {
                 strongSelf.notifymodels = nil;
            }
        
            if ([successInfoObj[@"notifyRecvs"] count] > 0) {
                //新增消息
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
                    //第一次加载消息缓存
                    [[NSUserDefaults standardUserDefaults] setObject:successInfoObj forKey:userdefaultsKey];
                    strongSelf.notifymodels = [[NotifyRecvsModel alloc]initWithDictionary:successInfoObj error:nil];
                }
                
            }
            //消息列表有数据 显示编辑
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
                
                [oldTotalTempArray removeObject: tempDic];
                
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
