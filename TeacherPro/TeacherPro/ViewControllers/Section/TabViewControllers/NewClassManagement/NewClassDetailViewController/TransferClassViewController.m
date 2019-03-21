
//
//  TransferClassViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/8/4.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "TransferClassViewController.h"
#import "TeacherSectionCell.h"
#import "SessionHelper.h"
#import "SessionModel.h"
static NSString * const TransferClassViewControllerIdentifier = @"TransferClassViewControllerIdentifier";

@interface TransferClassViewController ()
@property(nonatomic, copy) NSString * classID;
@property(nonatomic, strong)NSString * className;
@end

@implementation TransferClassViewController
- (instancetype)initWithClassId:(NSString *)classId withClassName:(NSString *)className isTeacherIdentity:(BOOL)isAdmin{
    
    if (self == [super init]) {
        self.classID = classId;
        self.className = className;
        
   
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationItemTitle:@"转换班级"];
    
}
- (void)registerCell{
   [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TeacherSectionCell class]) bundle:nil] forCellReuseIdentifier:TransferClassViewControllerIdentifier];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
      return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell ;
    
    TeacherSectionCell *sectionCell = [tableView dequeueReusableCellWithIdentifier:TransferClassViewControllerIdentifier];
    sectionCell.indexPath = indexPath;
    [sectionCell setupCellInfo:self.teachersModel.teachers[indexPath.section] isAdmin:YES];
    if (indexPath.section == 0) {
        [sectionCell hiddenDetailArrow];
        sectionCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else{
        [sectionCell showDetailArrow];
    }
    
    sectionCell.btnBlock = ^(NSIndexPath *openIndex, BOOL isOpen) {
        if (openIndex.section != 0) {
            [self setupSelectedTeacherAdmin:openIndex];
        }
    };
    cell = sectionCell;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section != 0) {
        [self setupSelectedTeacherAdmin:indexPath];
    }
}


//设为管理员
- (void)setupSelectedTeacherAdmin:(NSIndexPath *)index{
    ClassDetailTeacherModel *model = self.teachersModel.teachers[index.section];
    
    NSString * content = [NSString stringWithFormat:@"您确定将自己的管理员权限转给 %@ 吗？",model.teacherName];
    NSString * title = @"设为管理员";
    
    [self showNormalAlertTitle:title content:content items:nil block:^(NSInteger index) {
        [self requestSetupAdmin:model];
    }];
}
- (void)requestSetupAdmin:(ClassDetailTeacherModel *)model{
    
    NSDictionary * prameterDic = @{@"desTeacherId":model.teacherId,@"clazzId":self.classID};
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_TeacherTransferAdminTeacher] parameterDic:prameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_TeacherTransferAdminTeacher];
}
- (void)setNetworkRequestStatusBlocks{
    
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag ==  NetRequestType_QueryClazzTeachers) {
            NSString * teacherId;
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
            [strongSelf updateTableView];
            
        } else if (request.tag == NetRequestType_TeacherTransferAdminTeacher){
            [super hideHUD];
           [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_CLASS_TEACHER_LIST object:nil];
             [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_BINDINGCLASS object:nil];
            if (strongSelf.transferBlock) {
                strongSelf.transferBlock();
            }
            [strongSelf backViewController];
            
        }
    }];
    
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
