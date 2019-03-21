//
//  SearchNewClassViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/8/2.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "SearchNewClassViewController.h"
#import "JoinClassSearchView.h"
#import "ProUtils.h"
#import "QueryTeacherClass.h"
#import "JoinSearchNewClassListCell.h"
#import "SubjectsListNewViewController.h"
#import "ClassDetailTeacherModel.h"
#import "SessionHelper.h"
#import "SessionModel.h"
#import "IQKeyboardManager.h"
static NSString * const JoinSearchNewClassListCellIdentifier = @"JoinSearchNewClassListCellIdentifier";
@interface SearchNewClassViewController ()
 
@property(nonatomic, strong) QueryTeacherClasss *adminModel;
@property(nonatomic, strong) QueryTeacherClasss *joinModel;
@property(nonatomic, copy)  NSString * searchPhoneOrCoding;
@end

@implementation SearchNewClassViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [IQKeyboardManager sharedManager].toolbarDoneBarButtonItemText = @"搜索";
    
}

- (void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
    [IQKeyboardManager sharedManager].toolbarDoneBarButtonItemText = @"完成";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isNetReqeustEmptyData = YES;
    // Do any additional setup after loading the view.
    [self setNavigationItemTitle:@"加入班级"];

    [self setupSearchBar];
    [self configTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestPhoneQueryTeacherBindClazz) name:UPDATE_SEARCH_CLASS_LIST object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillHide)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:nil];
    
}
- (void)removeNotification{
   [[NSNotificationCenter defaultCenter] removeObserver:UPDATE_SEARCH_CLASS_LIST ];
//   [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardWillHideNotification];
    
}

//- (void)keyboardWillHide{
//
//    [self requestPhoneQueryTeacherBindClazz];
//}
- (void)requestPhoneQueryTeacherBindClazz{
 
    [self requestPhoneQueryTeacherBindClazzs:self.searchPhoneOrCoding];
}
- (void)registerCell{

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JoinSearchNewClassListCell class]) bundle:nil] forCellReuseIdentifier:JoinSearchNewClassListCellIdentifier];
}
- (void)configTableView{
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = project_background_gray;
    
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, FITSCALE(50))];
    footerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView =footerView;
}

- (void)setupSearchBar{

 
    JoinClassSearchView * searchHeader = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([JoinClassSearchView class]) owner:nil options:nil][0];
     
    searchHeader.backgroundColor = [UIColor whiteColor];
    searchHeader.searchBlock  = ^(NSString *phoneOrCoding) {
//        if([ProUtils checkMobilePhone:phone]){
//            [self showAlert:TNOperationState_Fail content:[ProUtils checkMobilePhone:phone]];
//            return;
//        }
//        if ([phoneOrCoding isEqualToString:[[SessionHelper sharedInstance] getAppSession].phone]) {
//            [self showAlert:TNOperationState_Fail content:@"Sorry,不能搜索自己哦"];
//            return;
//        }
        [self requestPhoneQueryTeacherBindClazzs:phoneOrCoding];
    };
//    WEAKSELF
//    searchHeader.inputPhoneBlock = ^(NSString *phoneOrCoding) {
//        weakSelf.searchPhoneOrCoding = phoneOrCoding;
//    };
    
    [self.view addSubview:searchHeader];
    [searchHeader mas_updateConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view.mas_leading);
        make.trailing.mas_equalTo(self.view.mas_trailing);
        make.top.mas_equalTo(self.view.mas_top).offset(FITSCALE(14));
        make.height.mas_equalTo(@(FITSCALE(50)));
        
    }];
}

//返回列表frame 子类重写
- (CGRect)getTableViewFrame{
    
    return CGRectMake(0,FITSCALE(50)+14, self.view.frame.size.width, self.view.frame.size.height - FITSCALE(50) -14);
}

- (void)requestPhoneQueryTeacherBindClazzs:(NSString *)phoneOrCoding{
    
    self.searchPhoneOrCoding = phoneOrCoding;
    if (!self.searchPhoneOrCoding) {
        return;
    }
    NSDictionary * parameterDic;
    if (phoneOrCoding.length <11) {
        parameterDic = @{@"inviteCode":phoneOrCoding};
    }else{
      parameterDic = @{@"phone":phoneOrCoding};
     }
    
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_QueryTeacherClazzByPhone] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_QueryTeacherClazzByPhone];
}


- (void)setNetworkRequestStatusBlocks{
    
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_QueryTeacherClazzByPhone) {
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
                strongSelf.adminModel = [[QueryTeacherClasss alloc]initWithDictionary:manageDic error:nil];
                
            }
            if ([joinList count] >0) {
                NSDictionary * joinDic = @{@"clazzList":joinList};
                strongSelf.joinModel = [[QueryTeacherClasss alloc]initWithDictionary:joinDic error:nil];
            }
            
            if ([manageList count]== 0 && [joinList count] == 0) {
                [strongSelf showAlert:TNOperationState_Fail content:@"该教师名下没有班级"];
            }
            
            [strongSelf updateTableView];
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
    CGFloat height = FITSCALE(60);
    return height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return FITSCALE(0.00001);
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
    CGFloat headherHeight= FITSCALE(0);
    if (section == 0) {
        headherHeight =  FITSCALE(7);
    }else if (section == 1){
        
        headherHeight = FITSCALE(7);
    }
    return headherHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell ;
    QueryTeacherClass * model ;
    if (indexPath.section == 0) {
        model = self.adminModel.clazzList[indexPath.row];
    }else if (indexPath.section == 1) {
        model = self.joinModel.clazzList[indexPath.row];
    }
    
    JoinSearchNewClassListCell * tempCell = [tableView dequeueReusableCellWithIdentifier:JoinSearchNewClassListCellIdentifier];
    [tempCell setupClassInfo:model];
    cell = tempCell;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    QueryTeacherClass * model ;
    if (indexPath.section == 0) {
        model = self.adminModel.clazzList[indexPath.row];
    }else if (indexPath.section == 1) {
        model = self.joinModel.clazzList[indexPath.row];
    }
    
    if ([model.isApply integerValue] == 0 && [model.isJoin integerValue] == 0) {
    
        [self gotoApplyJoinClass:model];
        
    }
}

- (void)gotoApplyJoinClass:(QueryTeacherClass *)queryModel{

    ClassDetailTeacherModel * model = [[ClassDetailTeacherModel alloc]init];
    model.className = queryModel.clazzName;
    model.classId = queryModel.clazzId;
    model.teacherName = [[SessionHelper sharedInstance]getAppSession].name;
    model.phone = [[SessionHelper sharedInstance] getAppSession].phone;
    model.sex = [[SessionHelper sharedInstance]getAppSession].sex  ;
    model.avatar = [[SessionHelper sharedInstance]getAppSession].thumbnail;
    SubjectsListNewViewController * subjectsVC  = [[SubjectsListNewViewController alloc]initWithType:SubjectsListNewViewControllerFromeType_Join withChangeTeacher:model];
    [self pushViewController:subjectsVC];
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
