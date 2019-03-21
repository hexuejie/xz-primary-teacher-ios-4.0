//
//  NewClassDetailTeacherViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/8/3.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "NewClassDetailTeacherViewController.h"
#import "ClassDetailTeacherModel.h"
#import "SessionHelper.h"
#import "SessionModel.h"
#import "TeacherRowOneTypeCell.h"
#import "TeacherSectionCell.h"
#import "SubjectsListNewViewController.h"
#import "HomeworkReviewViewController.h"

NSString *const NewTeacherSectionCellIdentifier = @"TeacherSectionCellIdentifier";
NSString *const NewTeacherRowOneTypeCellIdentifier = @"TeacherRowOneTypeCellIdentifier";

@interface NewClassDetailTeacherViewController ()
@property(nonatomic, copy) NSString * classID;
@property(nonatomic, strong)NSString * className;
@property (nonatomic, assign) BOOL isFistRequest;//第一次加载 网络 第二次就不加载（待优化 ）
@property (nonatomic, assign)  BOOL isAdmin;//yes 表示我是该编辑的管理员 NO 不是管理员
@property (nonatomic, strong) NSMutableArray *statusArray;

@end

@implementation NewClassDetailTeacherViewController
- (instancetype)initWithClassId:(NSString *)classId withClassName:(NSString *)className isTeacherIdentity:(BOOL)isAdmin{
    
    if (self == [super init]) {
        self.classID = classId;
        self.className = className;
        self.isAdmin = isAdmin;
        self.isFistRequest = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
       WEAKSELF
    self.startedBlock = ^(NetRequest *request) {
        [weakSelf showHUDInfoByType:HUDInfoType_NormalShadeNo];
    };
    
     [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestTeachers) name:UPDATE_CLASS_TEACHER_LIST   object:nil];
    
    [self configView];
    [self requestTeachers];
}


- (void)updateRequestData{
    
    [self requestTeachers];
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
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TeacherSectionCell class]) bundle:nil] forCellReuseIdentifier:NewTeacherSectionCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TeacherRowOneTypeCell class]) bundle:nil] forCellReuseIdentifier:NewTeacherRowOneTypeCellIdentifier];
  
}
//折叠状态
-(NSMutableArray *)statusArray
{
    
    if (!_statusArray) {
        _statusArray = [NSMutableArray array];
    }
    
    NSInteger sections  =  [self.teachersModel.teachers count];
    
    if (_statusArray.count) {
        if (_statusArray.count > sections) {
            [_statusArray removeObjectsInRange:NSMakeRange(sections - 1, _statusArray.count - sections)];
        }else if (_statusArray.count < sections) {
            for (NSInteger i = sections - _statusArray.count; i <  sections; i++) {
                [_statusArray addObject:[NSNumber numberWithInteger:NO]];
            }
        }
    }else{
        for (NSInteger i = 0; i < sections; i++) {
            [_statusArray addObject:[NSNumber numberWithInteger:NO]];
        }
    }
    return _statusArray;
}

- (CGRect)getTableViewFrame{
    
    return CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - FITSCALE(44));
}

-(NSString *)titleForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    return @"教师";
    
}

//- (UIImage *)imageForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController{
//    
//    return [UIImage imageNamed:@"class_manage_teacher_nor"];
//}
//- (UIImage *)highlightedImageForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController{
//    
//    return [UIImage imageNamed:@"class_manage_teacher_selected"];
//}

#pragma mark ---

- (void)requestTeacherRemoveClazzTeacher:(NSString *)teacherId{
    
    
    NSDictionary * parameterDic = @{@"removeTeacherIds":teacherId,@"clazzId":self.classID};
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_TeacherRemoveClazzTeacher] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_TeacherRemoveClazzTeacher];
    
}
- (void)requestTeachers{
 
    NSDictionary * parameterDic = @{@"clazzId":self.classID};
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_QueryClazzTeachers] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_QueryClazzTeachers];
    
}
- (void)requestQuitClazz:(NSString *)clazzIds{
    
    NSDictionary * parameterDic = @{@"clazzIds":clazzIds};
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_TeacherQuitClazz] parameterDic:parameterDic  requestMethodType:RequestMethodType_POST requestTag:NetRequestType_TeacherQuitClazz];
}

- (void)setNetworkRequestStatusBlocks{
    
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag ==  NetRequestType_QueryClazzTeachers) {
            NSString * teacherId;
            strongSelf.hasLoadData = YES;
            if ([[SessionHelper sharedInstance] checkSession]) {
                teacherId =  [[SessionHelper sharedInstance] getAppSession].teacherId ;
            }
            
            NSMutableArray *temArray = [[NSMutableArray alloc]initWithArray: successInfoObj[@"teachers"]];
            
            for (int i = 0; i<[temArray count]; i++) {
                if ([teacherId isEqualToString:temArray[i][@"teacherId"]]) {
                    [temArray exchangeObjectAtIndex:0 withObjectAtIndex:i];
                }
            }
            successInfoObj = @{@"teachers":temArray};
            strongSelf.teachersModel =[[ClassDetailTeachersModel alloc] initWithDictionary:successInfoObj error:nil];
            
            strongSelf.isFistRequest = NO;
            [strongSelf updateTableView];
           
        }else if (request.tag == NetRequestType_TeacherQuitClazz){
            
            [strongSelf showPromptView:@"退出班级成功"];
        } else if(request.tag == NetRequestType_TeacherRemoveClazzTeacher){
            
            [strongSelf showPromptView:@"踢出教师成功"];
        }
    }];
}
- (void)showPromptView:(NSString *)content{
    
    [self showAlert:TNOperationState_OK content:content block:^(NSInteger index) {
      
        [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES ];
          [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_BINDINGCLASS object:nil];
        
    }];
    
}

#pragma mark ---
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [self.teachersModel.teachers count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([self.statusArray[section] boolValue] ) {
        if ((!self.isAdmin&&section != 0 )|| self.tableView.editing) {
            return 1;
        }else
            return 2;
    }else
        return 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return FITSCALE(70);
    }else if(indexPath.row == 1){
        
        return FITSCALE(50);
        
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell ;
    if (indexPath.row == 0) {
        TeacherSectionCell *sectionCell = [tableView dequeueReusableCellWithIdentifier:NewTeacherSectionCellIdentifier];
        sectionCell.indexPath = indexPath;
        [sectionCell setupCellInfo:self.teachersModel.teachers[indexPath.section] isAdmin:self.isAdmin];
        [sectionCell setupCellOpenState:[self.statusArray[indexPath.section] boolValue]];
        [sectionCell setupTableviewCellEdit:self.tableView.editing];
        sectionCell.btnBlock = ^(NSIndexPath *openIndex, BOOL isOpen) {
            [self resetLoadTableView:openIndex];
        };
        if (!self.isAdmin && indexPath.section != 0) {
            sectionCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell = sectionCell;
    }else if(indexPath.row ==1){
        ClassDetailTeacherModel *model = self.teachersModel.teachers[indexPath.section];
        NSString * teacherId;
        if ([[SessionHelper sharedInstance] checkSession]) {
            teacherId =  [[SessionHelper sharedInstance] getAppSession].teacherId ;
        }
         TeacherRowOneTypeCell *rowCell = [tableView dequeueReusableCellWithIdentifier:NewTeacherRowOneTypeCellIdentifier];
        rowCell.index = indexPath;
        BOOL oneself = NO;
        if ([model.teacherId isEqualToString:teacherId]) {
            oneself = YES;
        
        }else{
            oneself = NO;
        }
        
        rowCell.touchBlock = ^(TeacherRowOneTypeCellTouchType type, NSIndexPath *index) {
            switch (type) {
                
                case TeacherRowOneTypeCellTouchType_ChangeCourse:
                    [self gotoClassCourseVC:indexPath];
                    break;
                case TeacherRowOneTypeCellTouchType_KickedOut:
                    [self removeClassTeacher:indexPath];
                    break;
                case TeacherRowOneTypeCellTouchType_HomeworkReview:
                    [self gotoHomeworkReview];
                    break;
                default:
                    break;
            }
            
        };

        rowCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [rowCell setupCellIsAdmin:self.isAdmin withOneself:oneself];
        cell = rowCell ;
 
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        
        if (indexPath.section == 0) {
             [self resetLoadTableView:indexPath];
        }else{
          if (self.isAdmin) {
              [self resetLoadTableView:indexPath];
            }
        }
    }
 
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    CGFloat height ;
    if (section == 0 ||section == [self.teachersModel.teachers count] -1) {
        height = FITSCALE(7);
    }else{
        if ([self.statusArray[section] boolValue]) {
            height = FITSCALE(7);
        }else{
           height = FITSCALE(0.0001);
        }
        
    }
    UIImageView * footerView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, height)];
    
    CGFloat top = 8; // 顶端盖高度
    CGFloat bottom = 0; // 底端盖高度
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
    CGFloat height =  0.000001;
    if (section == 0||section == [self.teachersModel.teachers count] -1) {
         height = FITSCALE(7);
    }else{
        if ([self.statusArray[section] boolValue]) {
            height = FITSCALE(7);
        }else{
            height = FITSCALE(0.00001);
        }
    }
    
    return height;
}


- (void)resetLoadTableView:(NSIndexPath *)index{
    
    BOOL currentIsOpen = ((NSNumber *)self.statusArray[index.section]).boolValue;
    NSInteger sections  =  [self.teachersModel.teachers count];
    for (NSInteger i = 0; i < sections; i++) {
        [_statusArray replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:NO]];
    }
    [self.statusArray replaceObjectAtIndex:index.section withObject:[NSNumber numberWithBool:!currentIsOpen]];
    [self.tableView reloadData];
}

#pragma mark ---

//踢出班级
- (void)removeClassTeacher:(NSIndexPath *)index{
    ClassDetailTeacherModel *model = _teachersModel.teachers[index.section];
    
    
    NSString *content = [NSString stringWithFormat:@"您确定要将 %@ 从 %@ 踢出吗？",model.teacherName,self.className];
    
    MMPopupItemHandler itemHandler = ^(NSInteger index){
        [self requestTeacherRemoveClazzTeacher:model.teacherId];
    };
    NSArray * items =   @[MMItemMake(@"否", MMItemTypeHighlight, nil),
                          MMItemMake(@"是", MMItemTypeHighlight, itemHandler)];
    [self showNormalAlertTitle:@"踢出老师" content:content items:items block:itemHandler];
}
//修改科目
- (void)gotoClassCourseVC:(NSIndexPath *)index{
    
    ClassDetailTeacherModel *model = _teachersModel.teachers[index.section];
    model.classId = self.classID;
    
    SubjectsListNewViewController * courseVC = [[SubjectsListNewViewController alloc]initWithType:SubjectsListNewViewControllerFromeType_Change withChangeTeacher:model];
  
    [self pushViewController:courseVC];
    
}

//作业回顾
- (void)gotoHomeworkReview{

    HomeworkReviewViewController * homework = [[HomeworkReviewViewController alloc]init];
    [self pushViewController:homework];
  
}
- (BOOL)isViewWillDisappearHideHUD{
    return NO;
}


@end
