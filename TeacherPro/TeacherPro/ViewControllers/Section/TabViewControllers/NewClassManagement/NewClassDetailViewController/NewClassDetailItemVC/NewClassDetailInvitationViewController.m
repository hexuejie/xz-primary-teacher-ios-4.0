
//
//  NewClassDetailInvitationViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/8/3.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "NewClassDetailInvitationViewController.h"
#import "QueryJoiningTeacherModel.h"
#import "InvitationJoinTeacherCell.h"

static  NSString * const InvitationJoinTeacherCellIdentifier = @"InvitationJoinTeacherCellIdentifier";
@interface NewClassDetailInvitationViewController ()
@property(nonatomic, copy) NSString * clazzId;
@property(nonatomic, strong) QueryJoiningTeacherModel * models;
@end

@implementation NewClassDetailInvitationViewController
- (instancetype)initWithClassId:(NSString *)clazzId{
    self = [super init];
    if (self) {
        self.clazzId = clazzId;
    }
    return self;
}

- (NSString *)getDescriptionText{
    
    return @"本班暂无邀请信息！";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configView];
 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestJoiningTeachers) name:UPDATE_INVITATION_CLASS_LIST object:nil];
    WEAKSELF
    self.startedBlock = ^(NetRequest *request) {
        [weakSelf showHUDInfoByType:HUDInfoType_NormalShadeNo];
    };
}

- (void)updateRequestData{
    
     [self requestJoiningTeachers];
}
- (void)configView{
    
    self.view.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = project_background_gray;
    
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, FITSCALE(50))];
    footerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView =footerView;
}

- (void)registerCell{

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([InvitationJoinTeacherCell class]) bundle:nil] forCellReuseIdentifier:InvitationJoinTeacherCellIdentifier];
    
}

- (CGRect)getTableViewFrame{
    
    return CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height  - FITSCALE(44) );
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)titleForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    return @"邀请加入";
    
}
//- (UIImage *)imageForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController{
//    
//    return [UIImage imageNamed:@"class_new_detail_uninvitation"];
//}
//- (UIImage *)highlightedImageForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController{
//    
//    return [UIImage imageNamed:@"class_new_detail_invitation"];
//}

#pragma mark ---
- (void)requestJoiningTeachers{
    NSDictionary * parameterDic = @{@"clazzId":self.clazzId};
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_QueryClazzJoiningTeachers] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_QueryClazzJoiningTeachers];
}

-(void)setNetworkRequestStatusBlocks{

    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_QueryClazzJoiningTeachers) {
            strongSelf.hasLoadData = YES;
            strongSelf.models = [[QueryJoiningTeacherModel alloc]initWithDictionary:successInfoObj error:nil];
            
            [strongSelf updateTableView];
        }
        
    }];
}

#pragma mark --

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [self.models.teachers count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger row = 1;
     return row;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat rowHeight = FITSCALE(70);
   
    return rowHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell ;
    InvitationJoinTeacherCell * tempCell = [tableView dequeueReusableCellWithIdentifier:InvitationJoinTeacherCellIdentifier];
    [tempCell setupTeacherInfo:self.models.teachers[indexPath.section]];
    cell = tempCell;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    CGFloat height = FITSCALE(0.0001);
    if (  section == [self.models.teachers count] -1 ) {
        height =  FITSCALE(7);
    }
    UIImageView * footerView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, height)];
    
    CGFloat top = 8; // 顶端盖高度
    CGFloat bottom = 0 ; // 底端盖高度
    CGFloat left = 25; // 左端盖宽度
    CGFloat right = 25; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    
    UIImage * image = [UIImage imageNamed:@"new_bottom_shadow"]  ;
    // 指定为拉伸模式，伸缩后重新赋值
    image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    
    footerView.image = image;
    
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    CGFloat height = FITSCALE(0.0001);
    if (  section == [self.models.teachers count] -1 ) {
        height =  FITSCALE(7);
    }
    return height;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = FITSCALE(0.0001);
    
    return height;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section  {
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, FITSCALE(0))];
    headerView.backgroundColor = [UIColor clearColor];
    return  headerView;
    
}
- (BOOL)isViewWillDisappearHideHUD{
    return NO;
}
@end
