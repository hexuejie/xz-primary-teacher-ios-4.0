//
//  ClassManagementNewViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/8/2.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "ClassManagementNewViewController.h"
#import "ClassManageModel.h"
#import "ClassManagementListNewCell.h"
#import "CreateNewClassViewController.h"
#import "SearchNewClassViewController.h"
#import "YBPopupMenu.h"
#import "NewClassDetailViewController.h"
#import "ProUtils.h"
#import "ClassApplyRecordViewController.h"
#import "TNTabbarController.h"
#import "SessionModel.h"
#import "SessionHelper.h"
#import "UIView+add.h"

#define emptyPageBgViewTag  77777777
static NSString * const ClassManagementListNewCellIdentifier = @"ClassManagementListNewCellIdentifier";

@interface ClassManagementNewViewController ()<YBPopupMenuDelegate>
@property(nonatomic, strong) ClassManageListModel *adminModel;
@property(nonatomic, strong) ClassManageListModel *joinModel;
@property(nonatomic, assign) ClassManagementType  type;
@end

@implementation ClassManagementNewViewController
- (instancetype)initWithType:(ClassManagementType)type{
    
    self = [super init];
    if (self) {
        self.type = type;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationItemTitle:@"班级管理"];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = project_background_gray;
    //如果iOS的系统是11.0，会有这样一个宏定义“#define __IPHONE_11_0  110000”；如果系统版本低于11.0则没有这个宏定义

    [self setupTableFooterHeaderView];
    [self setupRightButton];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestBindingClass) name:UPDATE_BINDINGCLASS object:nil];
   
    
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return NO;
}


- (BOOL)getNavBarBgHidden{
    BOOL  yesOrNo = NO;
   
    return yesOrNo;
}

- (UIRectEdge)getViewRect{
    
    return UIRectEdgeNone;
}
- (void)setupTableFooterHeaderView{
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, FITSCALE(50))];
    footerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView =footerView;

}
- (CGRect)getTableViewFrame{
    
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height  );
    return frame;
}
- (BOOL )getShowBackItem{
    BOOL yesOrNo = NO;
    if (self.type == ClassManagementType_tab) {
        yesOrNo = NO;
    }else{
        yesOrNo = YES;
    }
    return yesOrNo;
}
- (void)viewWillAppear:(BOOL)animated{
    BOOL yesOrNo = NO;
    if (self.type == ClassManagementType_tab) {
        yesOrNo = NO;
    }else{
        yesOrNo = YES;
    }
    [self.tnTabbarController setIsTabbarHidden:yesOrNo];
    [super viewWillAppear:animated];
    
    UIView *uiBarBackground = self.navigationController.navigationBar.subviews.firstObject;
    [uiBarBackground setCornerRadius:0 withShadow:YES withOpacity:0];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.tnTabbarController setIsTabbarHidden:YES];
    
}


- (void)hiddentEmptyView{

    [self.view viewWithTag:emptyPageBgViewTag].hidden = YES;
    
}




/**
 *  返回占位图图片
 */
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    NSLog(@"imageForEmptyDataSet:empty_placeholder");
    return [UIImage imageNamed:@""];
}

- (void)showNoClassView{

    UIView * emptyPageBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    emptyPageBgView.tag = emptyPageBgViewTag;
    [self.view addSubview:emptyPageBgView];
    
   
    UIButton * createBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [createBtn setTitle:@"创建班级" forState:UIControlStateNormal];
    [createBtn setFrame:CGRectMake(40, 0, self.view.frame.size.width - 80 ,FITSCALE(40))];
    [createBtn setCenter:CGPointMake(self.view.center.x,self.view.center.y-FITSCALE(40)/2)];
    
    [createBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    createBtn.titleLabel.font = fontSize_14;
    [createBtn addTarget:self action:@selector(createNewClass) forControlEvents:UIControlEventTouchUpInside];
    
   [createBtn setBackgroundImage:[ProUtils createImageWithColor:UIColorFromRGB(0xF54967) withFrame:CGRectMake(0, 0, 1, 1)] forState:UIControlStateNormal];
    [emptyPageBgView addSubview:createBtn];
    
    createBtn.layer.masksToBounds  = YES;
    createBtn.layer.borderColor = [UIColor clearColor].CGColor;
    createBtn.layer.borderWidth = 1.0;
    createBtn.layer.cornerRadius = createBtn.frame.size.height/2;
    
    
    UIButton * joinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [joinBtn setTitle:@"加入班级" forState:UIControlStateNormal];
    [joinBtn setFrame:CGRectMake(40, CGRectGetMaxY(createBtn.frame)+20, self.view.frame.size.width - 80 , FITSCALE(40))];
    [joinBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    joinBtn.titleLabel.font = fontSize_14;
    [joinBtn addTarget:self action:@selector(joinNewClass) forControlEvents:UIControlEventTouchUpInside];
    [joinBtn setBackgroundImage:[ProUtils createImageWithColor:project_main_blue withFrame:CGRectMake(0, 0, 1, 1)] forState:UIControlStateNormal];
    [emptyPageBgView addSubview:joinBtn];
    [self.view addSubview:emptyPageBgView];
    joinBtn.layer.masksToBounds  = YES;
    joinBtn.layer.borderColor = [UIColor clearColor].CGColor;
    joinBtn.layer.borderWidth = 1.0;
    joinBtn.layer.cornerRadius = createBtn.frame.size.height/2;
    
    
    
    UIButton * applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [applyBtn setTitle:@"申请记录" forState:UIControlStateNormal];
    [applyBtn setFrame:CGRectMake(40, CGRectGetMaxY(joinBtn.frame)+20, self.view.frame.size.width - 80 ,  FITSCALE(40))];
    [applyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    applyBtn.titleLabel.font = fontSize_14;
    [applyBtn addTarget:self action:@selector(applyRecordAction) forControlEvents:UIControlEventTouchUpInside];
    [applyBtn setBackgroundImage:[ProUtils createImageWithColor:UIColorFromRGB(0x68D171) withFrame:CGRectMake(0, 0, 1, 1)] forState:UIControlStateNormal];
    [emptyPageBgView addSubview:applyBtn];

    applyBtn.layer.masksToBounds  = YES;
    applyBtn.layer.borderColor = [UIColor clearColor].CGColor;
    applyBtn.layer.borderWidth = 1.0;
    applyBtn.layer.cornerRadius = createBtn.frame.size.height/2;
    
    UILabel * emptyTitle = [[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMinY(createBtn.frame)-50, self.view.frame.size.width, 40)];
    emptyTitle.text = @"您尚未创建班级或加入班级~！";
    emptyTitle.textColor = project_main_blue;
    emptyTitle.font = fontSize_14;
    emptyTitle.textAlignment = NSTextAlignmentCenter;
    [emptyPageBgView addSubview:emptyTitle];
 
    UIImage * emptyImg = [UIImage imageNamed:@"new_empty_list"];
    CGFloat emptyWidth = 130;
     CGFloat emptyHeigth = emptyWidth*333/364;
    UIImageView * emptyImageView = [[UIImageView alloc]initWithImage:emptyImg];
    emptyImageView.frame = CGRectMake(self.view.center.x - emptyWidth/2,CGRectGetMinY(emptyTitle.frame)-emptyHeigth-10, emptyWidth,emptyHeigth);
    [emptyPageBgView addSubview:emptyImageView];
    
 
    
}
- (void)getNormalTableViewNetworkData{

    [self requestBindingClass];
}
- (void)setupRightButton{

    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
 
    [rightBtn setImage:[UIImage imageNamed:@"new_add_icon"] forState:UIControlStateNormal];
 
    [rightBtn addTarget:self action:@selector(manageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, FITSCALE(-10));
    [rightBtn setFrame:CGRectMake(0,0, 60, 44)];
//    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    rightBtn.backgroundColor = [UIColor clearColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
}

- (void)manageBtnAction:(UIButton *)sender{
 
    NSArray * items = @[@{@"title":@"     创建班级",@"img":@""},
                        @{@"title":@"     加入班级",@"img":@""},
                        @{@"title":@"     申请记录",@"img":@""},
                        ];
    
    NSMutableArray * menuItemTitles = [[NSMutableArray alloc]initWithCapacity:items.count];
    NSMutableArray * menuItemImgs = [[NSMutableArray alloc]initWithCapacity:items.count];
    
    for(int i =0;i< [items count]; i++)   {
        NSDictionary * dic= items[i];
        [menuItemTitles addObject: dic[@"title"]];
        [menuItemImgs    addObject: dic[@"img"]];
    }
    
    
    CGFloat menuW =  124;
    CGFloat x = sender.center.x;
    if (IOS11) {
        x = sender.center.x + self.view.frame.size.width - sender.frame.size.width;
    }
//    CGFloat y = CGRectGetMaxY(sender.frame)+15;
     CGFloat y =  NavigationBar_Height;
    WEAKSELF
    //推荐用这种写法
    [YBPopupMenu showAtPoint:CGPointMake(x,y)  titles:menuItemTitles icons:menuItemImgs menuWidth:menuW otherSettings:^(YBPopupMenu *popupMenu) {
        STRONGSELF
        popupMenu.dismissOnSelected = NO;
        popupMenu.isShowShadow = YES;
        popupMenu.delegate = strongSelf;
        popupMenu.offset = 10;
        popupMenu.type = YBPopupMenuTypeDark;
        popupMenu.fontSize =  15 ;
        popupMenu.rectCorner = UIRectCornerBottomLeft | UIRectCornerBottomRight|UIRectCornerTopLeft|UIRectCornerTopRight;
        popupMenu.backColor = HexRGB(0x666666);
        popupMenu.textColor = UIColorFromRGB(0xffffff);
        
    }];

}
- (UITableViewStyle )getTableViewStyle{
    
    return UITableViewStyleGrouped;
}
- (void)registerCell{

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ClassManagementListNewCell class]) bundle:nil] forCellReuseIdentifier:ClassManagementListNewCellIdentifier];
}
- (void)requestBindingClass{
    self.adminModel =  nil;
    self.joinModel = nil;
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_QueryTeacherBindClazzs] parameterDic:@{@"groupByGrade":@"false"} requestMethodType:RequestMethodType_POST requestTag:NetRequestType_QueryTeacherBindClazzs];
}

-  (void)setNetworkRequestStatusBlocks{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_QueryTeacherBindClazzs) {
       
            NSMutableArray * manageList = [NSMutableArray array];
            NSMutableArray * joinList = [NSMutableArray array];
            
            for (NSDictionary * dic in successInfoObj[@"clazzList"]) {
                //adminTeacher : Integer - 是否是班级管理员 0=不是 1=是
                if ([dic[@"adminTeacher"] integerValue] == 1) {
                    [manageList addObject:dic];
                }else{
                    [joinList addObject:dic];
                }
            }
            if ([manageList  count] > 0) {
                NSDictionary * manageDic = @{@"clazzList":manageList};
                strongSelf.adminModel = [[ClassManageListModel alloc]initWithDictionary:manageDic error:nil];
                
            }
            if ([joinList count] >0) {
                NSDictionary * joinDic = @{@"clazzList":joinList};
                strongSelf.joinModel = [[ClassManageListModel alloc]initWithDictionary:joinDic error:nil];
            }
            
            [strongSelf updateTableView];
            
            if (manageList.count == 0 && joinList.count == 0) {
                SessionModel *sesstion = [[SessionHelper sharedInstance] getAppSession];
                sesstion.hasClazz = @(0);
                [[SessionHelper sharedInstance]saveCacheSession:sesstion];
                [strongSelf showNoClassView];
            }else{
                SessionModel *sesstion = [[SessionHelper sharedInstance] getAppSession];
                sesstion.hasClazz = @(1);
                [[SessionHelper sharedInstance]saveCacheSession:sesstion];
                [strongSelf hiddentEmptyView];
            }
            
          
        } 
        
    }];
}



#pragma mark ---

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger row = 0;
    if (section == 0) {
        row = [self.adminModel.clazzList count];
    }else if (section == 1){
        row = [self.joinModel.clazzList count];
    }
    return row ;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headerView = [UIView new];
    headerView.backgroundColor = [UIColor clearColor];

    return headerView;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footerView = [UIView new];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell ;
    
    ClassManageModel * model ;
    if (indexPath.section == 0) {
        model = self.adminModel.clazzList[indexPath.row];
    }else if (indexPath.section == 1) {
        model = self.joinModel.clazzList[indexPath.row];
    }
    
    ClassManagementListNewCell * tempCell = [tableView dequeueReusableCellWithIdentifier:ClassManagementListNewCellIdentifier];
    [tempCell setupClassInfo:model];
    cell = tempCell;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString * title = @"";
    NSString * classID = @"";
  
    BOOL  isAdmin = NO;
    ClassManageModel *model = nil;
    if (indexPath.section == 0) {
      model  = self.adminModel.clazzList[indexPath.row];
      isAdmin = YES;
    }else if (indexPath.section == 1){
      model  = self.joinModel.clazzList[indexPath.row];
      isAdmin = NO;
    }
      title =[NSString stringWithFormat:@"%@ %@",model.gradeName,model.clazzName];
    classID = model.clazzId;
    
    NewClassDetailViewController * classDetail = [[NewClassDetailViewController alloc]initWithTitle:title withClassId:classID withType:NewClassDetailVCFromeType_ClasssList isTeacherIdentity:isAdmin];
    UIView *uiBarBackground = classDetail.navigationController.navigationBar.subviews.firstObject;
    [uiBarBackground setCornerRadius:0 withShadow:YES withOpacity:0];
    [self pushViewController:classDetail];
}


#pragma makr --- ybPopupMenuDelegate
- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu{
    [ybPopupMenu dismiss];
    switch (index) {
        case 0:
            //创建班级
            [self createNewClass];
            break;
        case 1:
            //加入班级
            [self joinNewClass];
            break;
        case 2:
            //申请记录
            [self applyRecordAction];
            break;
        default:
            break;
    }
    
}

- (void)createNewClass{

    CreateNewClassViewController * createVC = [[CreateNewClassViewController alloc]init];
    UIView *uiBarBackground = createVC.navigationController.navigationBar.subviews.firstObject;
    [uiBarBackground setCornerRadius:0 withShadow:YES withOpacity:0];
    [self pushViewController:createVC];
}

- (void)joinNewClass{

    SearchNewClassViewController * searchVC = [[SearchNewClassViewController alloc]init];
    UIView *uiBarBackground = searchVC.navigationController.navigationBar.subviews.firstObject;
    [uiBarBackground setCornerRadius:0 withShadow:YES withOpacity:0];
    [self pushViewController:searchVC];
}

- (void)applyRecordAction{

    ClassApplyRecordViewController * applyRecordVC = [[ClassApplyRecordViewController alloc]init];
    UIView *uiBarBackground = applyRecordVC.navigationController.navigationBar.subviews.firstObject;
    [uiBarBackground setCornerRadius:0 withShadow:YES withOpacity:0];
    [self pushViewController:applyRecordVC];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
