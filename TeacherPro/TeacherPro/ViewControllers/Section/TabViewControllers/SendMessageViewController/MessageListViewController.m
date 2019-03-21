//
//  MessageListViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/6/21.
//  Copyright © 2017年 ZNXZ. All rights reserved.
// 消息

#import "MessageListViewController.h"
#import "MessageListCell.h"
#import "WriteMessageViewController.h"
#import "ReceivedMessageViewController.h"
#import "ApplyMessageViewController.h"
#import "HomeworkMessageViewController.h"
#import "SenderMessageListViewController.h"
#import "SystemMessageViewController.h"
#import "NotifySummarysModel.h"
#import "TNTabbarController.h"


NSString * const MessageListCellIdentifier = @"MessageListCellIdentifier";
@interface MessageListViewController()
@property (nonatomic, strong) NSArray * messageListArray;
@property (nonatomic, strong) NSDictionary * notifyInfo;
@property (nonatomic, strong) NSIndexPath * selectedIndex;
@property (nonatomic, assign) NSInteger   clearNumber;
@property (nonatomic, assign) MessageListType type;
@end
@implementation MessageListViewController
- (instancetype)initWithType:(MessageListType)type{
    self = [super init];
    if (self) {
        self.type = type;
    }
    return self;
}
- (void)viewDidLoad{
   
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestTeacherNotify) name:@"UPDATE_MESSAGEE_LIST" object:nil];
    [self setNavigationItemTitle:@"消息"];
    self.view.backgroundColor =  HexRGB(0xF6F6F8);
    self.tableView.backgroundColor = [UIColor clearColor];
//    [self initWriteMessageButton];
    [self setupRightItem];
    [self requestTeacherNotify];
    
}


- (void)setupRightItem{
    NSString * titleNormal = @"写消息";
 
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:titleNormal forState:UIControlStateNormal];
    [rightBtn setTitleColor:HexRGB(0x4D4D4D) forState:UIControlStateNormal];
    [rightBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    
    [rightBtn setFrame:CGRectMake(0, 0,70, 44)];
    rightBtn.titleLabel.font = systemFontSize(16);
    [rightBtn addTarget:self action:@selector(writeAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
 
}
- (CGRect)getTableViewFrame{
    
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    return frame;
}
- (void)viewWillAppear:(BOOL)animated{
    BOOL YesOrNo = NO;
    if (self.type == MessageListType_Tab) {
        YesOrNo = NO;
    }else if (self.type == MessageListType_Preson){
        
        YesOrNo = YES;
    }
    
    [super viewWillAppear:animated];
    [self.tnTabbarController setIsTabbarHidden:NO];
    
//    UIView *uiBarBackground = self.navigationController.navigationBar.subviews.firstObject;
    [self navUIBarBackground:0];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.tnTabbarController setIsTabbarHidden:YES];
    
}
- (void)registerCell{

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MessageListCell class]) bundle:nil] forCellReuseIdentifier:MessageListCellIdentifier];
    NSArray * oneSection = @[@{@"icon":@"received_message_icon",@"title":@"收到消息"} ,@{@"icon":@"send_message_icon",@"title":@"已发消息"}];
    NSArray * twoSection = @[@{@"icon":@"homework_message_icon",@"title":@"作业消息"} ,@{@"icon":@"system_message_icon",@"title":@"系统消息"}];
    NSArray * threeSection = @[@{@"icon":@"apply_message_icon",@"title":@"申请消息"} ,@{@"icon":@"invitation_message_icon",@"title":@"邀请消息"}];
    self.messageListArray = @[oneSection, twoSection,threeSection];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [self.messageListArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.messageListArray[section] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MessageListCell  *messageCell = [ tableView dequeueReusableCellWithIdentifier:MessageListCellIdentifier];
    NSArray * sectionArray = self.messageListArray[indexPath.section];
    [messageCell setupMessageCellInfo:sectionArray[indexPath.row]];
    messageCell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *key =@"";
    //消息类型(00：老师消息、01：作业消息、02：系统通知、03：奖励通知、04：邀请通知、05：申请消息)
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                key = @"00";
            }
        }
            break;
        case 1:
        {
            if (indexPath.row == 0) {
                 key = @"01";
            }else if (indexPath.row == 1) {
                 key = @"02";
            }
        }
            break;
        case 2:
        {
            if (indexPath.row == 0) {
                 key = @"05";
            }else if (indexPath.row == 1) {
                 key = @"04";
            }
        }
            break;
            
        default:
            break;
    }
    if (self.notifyInfo) {
        if (indexPath.section == 0&&indexPath.row ==1) {
          [messageCell setupNewMessageNumber:0 withNotifyNumber:self.notifyInfo[@"send"]];
        }else{
            NSDictionary * dic = self.notifyInfo[@"receive"][key];
            if (self.selectedIndex &&[self.selectedIndex compare: indexPath] == NSOrderedSame  ){
                 [messageCell setupNewMessageNumber:0 withNotifyNumber:dic[@"notifyCount"]];
            }else{
                 [messageCell setupNewMessageNumber:[dic[@"unreadNotifyCount"] integerValue] withNotifyNumber:dic[@"notifyCount"]];
            }
        }
    }
    return messageCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 8;
}
- ( UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;{

    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH,  8)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.selectedIndex = indexPath;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//    [self updateTableView];
    
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
                [self gotoReceivedVC];
            
            }else if (indexPath.row == 1){
                [self gotoSendMsgVC];
            }
            break;
        case 1:
            if (indexPath.row == 0) {
                [self gotoHomeworkVC];
            }else if (indexPath.row == 1){
                [self gotoSystemVC];
            }
            break;
        case 2:
            if (indexPath.row == 0) {
                [self gotoApplyMessageVC];
            }else if (indexPath.row == 1){
                [self gotoInvitationMessageVC];
            }
            break;
        default:
            break;
    }
}

#pragma mark ---
- (void)initWriteMessageButton{

    UIButton * writeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
   
    [writeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [writeBtn setFrame:CGRectMake(self.view.frame.size.width -100, self.view.frame.size.height - 100, 80, 80)];
  
//    [writeBtn setImage:[UIImage imageNamed:@"write_message_button_icon.png"] forState:UIControlStateNormal];
     [writeBtn setBackgroundImage:[UIImage imageNamed:@"write_message_button_icon.png"]   forState:UIControlStateNormal];
    [writeBtn addTarget:self action:@selector(writeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:writeBtn];
    [writeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(80);
        make.trailing.mas_equalTo(self.tableView.mas_trailing).mas_offset(-20);
        make.bottom.mas_equalTo (self.tableView.mas_bottom).mas_offset(-20);
    }];
}

#pragma mark ----
//写消息
- (void)writeAction{

    WriteMessageViewController * writeMessageVC = [[WriteMessageViewController alloc]init];
    
    writeMessageVC.sucessSendBlock = ^{
        self.selectedIndex = nil;
        [self requestTeacherNotify];
    };
//    UIView *uiBarBackground = self.navigationController.navigationBar.subviews.firstObject;
    
    [self pushViewController:writeMessageVC];
}

//收到消息
- (void)gotoReceivedVC{

    ReceivedMessageViewController * receivedMessageVC = [[ReceivedMessageViewController alloc]init];
    receivedMessageVC.updateMessageList = ^{
        [self requestTeacherNotify];
    };
    [self pushViewController:receivedMessageVC];
}


//申请消息
- (void)gotoApplyMessageVC{

    ApplyMessageViewController * applyMessageVC = [[ApplyMessageViewController alloc]initWithType:ApplyMessageViewControllerType_apply];
    applyMessageVC.updateMessageList = ^{
        [self requestTeacherNotify];
    };
    [self pushViewController:applyMessageVC];
}

//邀请消息
- (void)gotoInvitationMessageVC{
    
    ApplyMessageViewController * applyMessageVC = [[ApplyMessageViewController alloc]initWithType:ApplyMessageViewControllerType_invitation];
    applyMessageVC.updateMessageList = ^{
        [self requestTeacherNotify];
    };
    [self pushViewController:applyMessageVC];
}

- (void)gotoHomeworkVC{

    HomeworkMessageViewController *homeworkMsgVC = [[HomeworkMessageViewController alloc]init];
    homeworkMsgVC.updateMessageList = ^{
        [self requestTeacherNotify];
    };
    [self pushViewController:homeworkMsgVC];
}

- (void)gotoSendMsgVC{

    SenderMessageListViewController * senderMsgListVC = [[SenderMessageListViewController alloc]init];
    senderMsgListVC.updateMessageList = ^{
        [self requestTeacherNotify];
    };
    [self pushViewController:senderMsgListVC];
   
}

- (void)gotoSystemVC{

    SystemMessageViewController * systemVC = [[SystemMessageViewController alloc]init];
    systemVC.updateMessageList = ^{
        [self requestTeacherNotify];
    };
    [self pushViewController:systemVC];
}

#pragma mark ---

- (void)requestTeacherNotify{
    
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_TeacherNotifySummary] parameterDic:nil requestMethodType:RequestMethodType_POST requestTag:NetRequestType_TeacherNotifySummary];
    
}

- (void)setNetworkRequestStatusBlocks{

    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_TeacherNotifySummary) {
            strongSelf.notifyInfo = successInfoObj;
        }
        
        [strongSelf updateTableView];
    }];
}

- (BOOL )getShowBackItem{
    BOOL YesOrNo = NO;
    if (self.type == MessageListType_Preson) {
        YesOrNo = YES;
    }else if (self.type == MessageListType_Tab){
        YesOrNo = NO;
    }
    return YesOrNo;
}

- (BOOL)isShowTabarController{
    BOOL YesOrNo = NO;
    if (self.type == MessageListType_Preson) {
        YesOrNo = NO;
    }else if (self.type == MessageListType_Tab){
        YesOrNo = YES;
    }
    return YesOrNo;
 
}
@end
