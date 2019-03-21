//
//  NewClassDetailStudentViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/8/3.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "NewClassDetailStudentViewController.h"
#import "ClassDetailStudentModel.h"
#import "NewClassDetailStudentOneRowCell.h"
#import "NewClassDetailStudentSecondRowCell.h"


NSString *const NewClassDetailStudentOneRowCellIdentifier    = @"NewClassDetailStudentOneRowCellIdentifier";
NSString *const NewClassDetailStudentSecondRowCellIdentifier    = @"NewClassDetailStudentSecondRowCellIdentifier";
@interface NewClassDetailStudentViewController ()
@property(nonatomic, copy) NSString * classID;
@property(nonatomic, strong)NSString * className;

@property (nonatomic, strong) NSMutableArray *statusArray;
@property (nonatomic, assign) BOOL isFistRequest;//第一次加载 网络 第一次就不加载（待优化 ）
@end

@implementation NewClassDetailStudentViewController
- (instancetype)initWithClassId:(NSString *)classId withClassName:(NSString *)className{
    
    if (self == [super init]) {
         self.isFistRequest = YES;
        self.classID = classId;
        self.className = className;
    }
    return self;
}

- (void)updateRequestData{
      [self requestStudents];
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
  
    [self configView];

     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestStudents) name:UPDATE_CLASS_STUDENT_LIST   object:nil];
    WEAKSELF
    self.startedBlock = ^(NetRequest *request) {
        [weakSelf showHUDInfoByType:HUDInfoType_NormalShadeNo];
    };
}
- (NSString *)getDescriptionText{
    
    return @"本班暂无学生！";
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
- (void)getNetworkData{
    
    if (self.isFistRequest) {
      
    }
    
}

- (void)registerCell{
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NewClassDetailStudentOneRowCell class ]) bundle:nil] forCellReuseIdentifier:NewClassDetailStudentOneRowCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NewClassDetailStudentSecondRowCell class]) bundle:nil] forCellReuseIdentifier:NewClassDetailStudentSecondRowCellIdentifier];
}
//返回列表frame 子类重写
- (CGRect)getTableViewFrame{
    
    return CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height  - FITSCALE(44) );
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSString *)titleForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    return @"学生";
    
}
//- (UIImage *)imageForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController{
//    
//    return [UIImage imageNamed:@"class_manage_stu_nor"];
//}
//- (UIImage *)highlightedImageForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController{
//    
//    return [UIImage imageNamed:@"class_manage_stu_selected"];
//}

- (void)requestStudents{
    
    NSDictionary * parameterDic = @{@"clazzId":self.classID};
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_ListStudentByClazzId] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_ListStudentByClazzId];
    
}
- (void)setNetworkRequestStatusBlocks{
    
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag ==  NetRequestType_ListStudentByClazzId) {
            strongSelf.hasLoadData = YES;
            strongSelf.studentsModel = [[ClassDetailStudentsModel alloc]initWithDictionary:successInfoObj error:nil];
            
            [strongSelf updateTableView];
         
            strongSelf.isFistRequest =  NO;
     
            
        }
    }];
}

//折叠状态
-(NSMutableArray *)statusArray
{
    
    if (!_statusArray) {
        _statusArray = [NSMutableArray array];
    }
    
    NSInteger sections  =  [self.studentsModel.students count];
    
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
#pragma mark ---
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [self.studentsModel.students count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger row = 0;
   
     if ([self.statusArray[section] boolValue] ) {
            row = 2;
        }else
            row = 1;
   
    return row;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return FITSCALE(70);
    }else
        return FITSCALE(94);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell ;
    if (indexPath.row == 0) {
        NewClassDetailStudentOneRowCell *tempCell = [tableView dequeueReusableCellWithIdentifier:NewClassDetailStudentOneRowCellIdentifier];
        [tempCell setupCellInfo:self.studentsModel.students[indexPath.section]];
        [tempCell setupCellOpenState:[self.statusArray[indexPath.section] boolValue]];
 
        tempCell.indexPath = indexPath;
 
        tempCell.btnBlock = ^(NSIndexPath *openIndex, BOOL isOpen) {
            [self resetLoadTableView:indexPath];
        };
       
        cell = tempCell;
    }else if(indexPath.row ==1){
         NewClassDetailStudentSecondRowCell *tempCell = [tableView dequeueReusableCellWithIdentifier:NewClassDetailStudentSecondRowCellIdentifier];
         [tempCell setupCellInfo:self.studentsModel.students[indexPath.section]];
         tempCell.selectionStyle = UITableViewCellSelectionStyleNone;
         cell = tempCell;
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     if (indexPath.row == 0) {
       [self resetLoadTableView:indexPath];
    }
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    CGFloat height = FITSCALE(0.0001);
    if ([self.statusArray[section] boolValue] || section == [self.studentsModel.students count] -1 ) {
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
    if ([self.statusArray[section] boolValue] || section == [self.studentsModel.students count] -1 ) {
        height =  FITSCALE(7);
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = FITSCALE(0.0001);
    if ([self.statusArray[section] boolValue]) {
        height =  FITSCALE(0.0001);
    }
    return height;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section  {
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, FITSCALE(0))];
    headerView.backgroundColor = [UIColor clearColor];
    return  headerView;
    
}
- (void)resetLoadTableView:(NSIndexPath *)index{
    
    BOOL currentIsOpen = ((NSNumber *)self.statusArray[index.section]).boolValue;
    NSInteger sections  =  [self.studentsModel.students count];
    for (NSInteger i = 0; i < sections; i++) {
        [_statusArray replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:NO]];
    }
    [self.statusArray replaceObjectAtIndex:index.section withObject:[NSNumber numberWithBool:!currentIsOpen]];
    
 
    [self.tableView reloadData];
}

- (BOOL)isViewWillDisappearHideHUD{
    return NO;
}
@end
