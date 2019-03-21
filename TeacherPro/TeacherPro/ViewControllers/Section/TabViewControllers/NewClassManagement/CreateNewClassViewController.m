
//
//  CreateNewClassViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/8/2.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "CreateNewClassViewController.h"
#import "CreateNewClassNormalCell.h"
#import "CreateNewClassInvitationTeacherCell.h"
#import "GradeNewListViewController.h"


#import "ProUtils.h"
#import "SubjectsListNewViewController.h"
#import "ClassDetailTeacherModel.h"
#import "NewClassDetailViewController.h"
#import "SessionHelper.h"
#import "SessionModel.h"
#import "XXYActionSheetView.h"

#import <AddressBook/ABPerson.h>
#import <AddressBookUI/ABPersonViewController.h>
#import <AddressBookUI/ABPeoplePickerNavigationController.h>
#import <ContactsUI/ContactsUI.h>

static NSString * const  CreateNewClassNormalCellIdentifier  = @"CreateNewClassNormalCellIdentifier";
static NSString * const  CreateNewClassInvitationTeacherCellIdentifier  = @"CreateNewClassInvitationTeacherCellIdentifier";


@interface CreateNewClassViewController ()<UIActionSheetDelegate,ABPeoplePickerNavigationControllerDelegate,XXYActionSheetViewDelegate,CNContactPickerDelegate>

@property(nonatomic, strong) NSMutableArray * inviteTeacherArray;
@property(nonatomic, strong) NSDictionary * selectedGradeDic;//选择的年级
@property(nonatomic, strong) NSString * className;//创建的班级名
@property(nonatomic, strong) NSArray * selectedSubjectsArray;//选择的执教科目
@property(nonatomic, strong) NSArray * normalArray;
@property(nonatomic, copy) NSString *invitationPhone;
@property(nonatomic, strong) NSIndexPath *deleteInvitationIndex;
@end

@implementation CreateNewClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationItemTitle:@"创建班级"];
    
    [self configTableView];
    [self reloadTableView];
    [self initBottomView];
}

- (void)configTableView{

    self.tableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = project_background_gray;
    
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, FITSCALE(50))];
    footerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView =footerView;
}

- (void)initBottomView{

    CGFloat bottomHeight = FITSCALE(60);
    UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - bottomHeight, self.view.frame.size.width,  bottomHeight)];
   
    UIImage * tempImage =  [UIImage imageNamed:@"new_bottom_button_background"]  ;
    // 指定为拉伸模式，伸缩后重新赋值
    tempImage = [tempImage resizableImageWithCapInsets:UIEdgeInsetsMake(10, 15, 15, 10) resizingMode:UIImageResizingModeStretch];
    imageV.image = tempImage;
    imageV.backgroundColor = [UIColor clearColor];
    [self.view addSubview:imageV];
    
    
    
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - bottomHeight, self.view.frame.size.width,  bottomHeight)];
 
    [bottomView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:bottomView];
    
    
    
    CGFloat top = FITSCALE(8);
    
    UIImageView * backgroundView = [[UIImageView alloc]initWithFrame:CGRectMake(10, top, self.view.frame.size.width-20,  bottomHeight -top*2)];
//    backgroundView.backgroundColor = project_main_blue;
    backgroundView.image = [UIImage imageNamed:@"add_background_image"];
    backgroundView.layer.masksToBounds  = YES;
    backgroundView.layer.borderColor = [UIColor clearColor].CGColor;
    backgroundView.layer.borderWidth = 1.0;
    backgroundView.layer.cornerRadius =( bottomHeight - top*2) /2;
    [bottomView addSubview:backgroundView];
    
    
    UIButton * createBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [createBtn setTitle:@"确认" forState:UIControlStateNormal];
    [createBtn setFrame:CGRectMake(10, top, self.view.frame.size.width - 20, backgroundView.frame.size.height)];

    [createBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    createBtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    [createBtn addTarget:self action:@selector(createAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:createBtn];
    
 
    
}
- (void)reloadTableView{

    self.normalArray = @[@[@{@"img":@"class_managemant_name",@"title":@"班级名称"},
                           @{@"img":@"class_managemant_new_grand",@"title":@"选择年级"},
                           @{@"img":@"class_managemant_new_subjects",@"title":@"选择执教科目"}
                           ],
                         @[@{@"img":@"class_managemant_new_invitation",@"title":@"邀请老师"}]];
    
    
    [self updateTableView];
}
- (void)registerCell{

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CreateNewClassNormalCell class]) bundle:nil] forCellReuseIdentifier:CreateNewClassNormalCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CreateNewClassInvitationTeacherCell class]) bundle:nil] forCellReuseIdentifier:CreateNewClassInvitationTeacherCellIdentifier];
}
//返回列表frame 子类重写
- (CGRect)getTableViewFrame{
    
    return CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - FITSCALE(60));
}
- (NSMutableArray *)inviteTeacherArray{

    if (!_inviteTeacherArray) {
        _inviteTeacherArray = [[NSMutableArray alloc]init];
    }
    return _inviteTeacherArray;
}
#pragma mark ---

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger row = 0;
    if (section == 0) {
        row = [self.normalArray[section] count];
    }else if (section == 1){
    
        row = 1 + [self.inviteTeacherArray count];
        
    }
    return row ;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    return 48;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.001;
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
    
    if (indexPath.section == 0) {
        CreateNewClassNormalCell * tempCell = [tableView dequeueReusableCellWithIdentifier:CreateNewClassNormalCellIdentifier];
        NSDictionary * dic = self.normalArray[indexPath.section][indexPath.row];
        NSString * title = @"";
        if (indexPath.row == 0) {
            if (self.className) {
              title  = self.className;
            }else{
              title  = dic[@"title"];
            }
        }else if (indexPath.row == 1){
            if (self.selectedGradeDic) {
                title  = self.selectedGradeDic[@"gradeName"];
            }else{
                title  = dic[@"title"];
            }
        }else if (indexPath.row == 2){
            if (self.selectedSubjectsArray &&[self.selectedSubjectsArray count] > 0) {
                NSString * subjects = @"";
                for (NSDictionary * dic in self.selectedSubjectsArray) {
                    if (subjects.length == 0) {
                        subjects = dic[@"subjects"];
                    }else{
                        subjects = [subjects stringByAppendingFormat:@",%@", dic[@"subjects"]];
                    }
                }
                title  =  subjects;
            }else{
                title  = dic[@"title"];
            }
        }
       
        [tempCell setupTitle:title withIcon:dic[@"img"]];
        cell = tempCell;
    }else if (indexPath.section == 1){
    
        if (indexPath.row == 0) {
            CreateNewClassNormalCell * tempCell = [tableView dequeueReusableCellWithIdentifier:CreateNewClassNormalCellIdentifier];
              NSDictionary * dic = self.normalArray[indexPath.section][indexPath.row];
            [tempCell setupTitle:dic[@"title"] withIcon:dic[@"img"]];
            cell = tempCell;
        }else{
            CreateNewClassInvitationTeacherCell * tempCell = [tableView dequeueReusableCellWithIdentifier:CreateNewClassInvitationTeacherCellIdentifier];
            tempCell.index = indexPath;
            [tempCell setupInvitationInfo: self.inviteTeacherArray[indexPath.row -1]];
            WEAKSELF
            tempCell.deleteBlock = ^(NSIndexPath *index) {
                weakSelf.deleteInvitationIndex = index;
                [weakSelf deleteInvitationIndex:index]; 
            };
            tempCell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell = tempCell;
        }
    }
  
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0){
        switch (indexPath.row) {
            case 0:
                [self gotoCrateClass];
                break;
            case 1:
                [self gotoGradeNewListViewController];
                break;
            case 2:
                [self gotoCreateSubjects];
                break;
                
            default:
                break;
        }
    }else if (indexPath.section == 1){
       
        if (indexPath.row == 0) {
            [self gotoInvitation];
        }
        
    }
}

- (void)gotoCrateClass{
    
    NSString * title = @"创建班级";
    NSString * content =@"*班级名称为1-5个中文、英文、数字组成";
    NSString * placeholder= @"请输入班级名称";
    [self showAlertCreateInputTitle:title content:content items:nil placeholder:placeholder handler:^(NSString *text) {
        [self updateClassName:text];
    }];
    
}


- (void)gotoGradeNewListViewController{

    GradeNewListViewController * gradeVC = [[GradeNewListViewController alloc]init];
    WEAKSELF
    gradeVC.selectedGradeBlock = ^(NSDictionary *selectedDic) {
      STRONGSELF
        strongSelf.selectedGradeDic = selectedDic;
         [self updateTableView];
    };
    [self pushViewController:gradeVC];
    
}

- (void)gotoCreateSubjects{
    
    ClassDetailTeacherModel *  model  = [[ClassDetailTeacherModel alloc]init];;
    if (self.selectedSubjectsArray && [self.selectedSubjectsArray count] >0) {
        NSString * subjectNames = @"";
        for (NSDictionary * dic in self.selectedSubjectsArray) {
            if (subjectNames.length == 0) {
                subjectNames = dic[@"subjects"];
            }else{
                subjectNames = [subjectNames stringByAppendingFormat:@",%@", dic[@"subjects"]];
            }
        }
        model.subjectNames = subjectNames;
    }
    model.sex = [[SessionHelper sharedInstance] getAppSession].sex;
    model.teacherName =  [[SessionHelper sharedInstance] getAppSession].name;
    model.phone = [[SessionHelper sharedInstance] getAppSession].phone;
    SubjectsListNewViewController * subjectsListVC = [[SubjectsListNewViewController alloc]initWithType:SubjectsListNewViewControllerFromeType_Create withChangeTeacher:model];
    WEAKSELF
    subjectsListVC.createSubjectsBlock = ^(NSArray *selectedSubjects) {
      
        weakSelf.selectedSubjectsArray = selectedSubjects;
        [weakSelf updateTableView];
    };
    [self pushViewController:subjectsListVC];
    
}

- (void)gotoInvitation{

    XXYActionSheetView*  alertSheetView = [[XXYActionSheetView alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"通讯录", @"手动输入" , nil];
    alertSheetView.textColor = project_main_blue;
    alertSheetView.textLabelFont = fontSize_14;
    alertSheetView.cancelBtnFont = fontSize_14;
    alertSheetView.cancelBtnColor = project_main_blue;
    alertSheetView.separatorLineColor = project_line_gray;
    
    //弹出视图
    [alertSheetView xxy_show];
}
#pragma mark - XXYActionSheetViewDelegate
- (void)actionSheet:(XXYActionSheetView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"delegate点击的是:%zd", buttonIndex);
    if (buttonIndex == 0) {
        [self gotoAddressBook];
    }else if (buttonIndex == 1){
        NSString * title       =  @"邀请老师";
        NSString * placeholder =  @"请输入老师手机号码";
        [self showAlertInputPhoneTitle:title content:nil items:nil placeholder:placeholder handler:^(NSString *text) {
            [self requestQueryTeacherByPhone:text];
        }];
        
    }
    else if (buttonIndex == 2){
        //取消
    }
    
}

#pragma mark ---
- (void)deleteInvitationIndex:(NSIndexPath *)index{

    NSString *content = [NSString stringWithFormat:@"您确定要删除该老师吗？"];
    NSString *title = @"删除邀请老师";
    
    
    MMPopupItemHandler itemHandler = ^(NSInteger index){
       [self.inviteTeacherArray removeObjectAtIndex:self.deleteInvitationIndex.row -1];
        [self updateTableView];
    };
    NSArray *items = @[MMItemMake(@"否", MMItemTypeHighlight, nil),
                       MMItemMake(@"是", MMItemTypeHighlight, itemHandler)];
    [self showNormalAlertTitle:title content:content items:items block:itemHandler];
 
 
}
- (void)updateClassName:(NSString *)name{

    self.className = name;

    [self updateTableView];
}


- (void)gotoAddressBook{

    [[UINavigationBar appearance] setBarTintColor:project_main_blue];
    
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    if (IOS9) {
        //创建选择联系人的导航控制器
       CNContactPickerViewController* peoplePickVC = [[CNContactPickerViewController alloc] init];
        
        //设置代理
        peoplePickVC.delegate = self;
        
        [self presentViewController:peoplePickVC animated:YES completion:nil];
        
    }else{
        ABPeoplePickerNavigationController *nav = [[ABPeoplePickerNavigationController alloc] init];
        nav.peoplePickerDelegate = self;
        nav.delegate = (id<UINavigationControllerDelegate>)self;
        if(IOS8){
            nav.predicateForSelectionOfPerson = [NSPredicate predicateWithValue:false];
        }
        
        
        [self presentViewController:nav animated:YES completion:nil];
    }
    
    
}
-(void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty
{
    //获取联系人信息
    NSString * firstName = contactProperty.contact.familyName;  //姓
    NSString * lastName = contactProperty.contact.givenName;    //名
    
    if([contactProperty.key isEqualToString:CNContactPhoneNumbersKey]){
        NSString * phoneNum = [contactProperty.value stringValue];  //号码
        NSString * phoneLabel = contactProperty.label;                //号码类型
        
        NSLog(@"姓名:%@ %@ \n %@:%@",firstName,lastName, phoneLabel, phoneNum);
        if ([phoneNum hasPrefix:@"+"]) {
            phoneNum = [phoneNum substringFromIndex:3];
        }
        
        phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@"-" withString:@""];
        if (phoneNum && ![ProUtils checkMobilePhone:phoneNum]) {
            
            [self selectedPhone:phoneNum withName:firstName];
            return;
        }else{
            
            [self showAlert:TNOperationState_Unknow content:@"请选择手机号码"];
        }
    }
}



#pragma mark --- ABPeoplePickerNavigationControllerDelegate

//取消选择
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}

//ios 8
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
    
    long phoneindex = ABMultiValueGetIndexForIdentifier(phone,identifier);
      //解决删除一个号码 点击另一个号码的bug 
    if (phoneindex <0) {
        [peoplePicker dismissViewControllerAnimated:YES completion:nil];
        
        [self showAlert:TNOperationState_Unknow content:@"不能获取此号码，请手动输入"];
        return  ;
    }
    

    NSString *firstName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    NSString *lastName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
    
    NSString *nickname = [NSString stringWithFormat:@"%@%@",firstName?firstName:@"",lastName];
    NSString *phoneNO = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phone, phoneindex);
     if ([phoneNO hasPrefix:@"+"]) {
            phoneNO = [phoneNO substringFromIndex:3];
     }
    phoneNO = [phoneNO stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSLog(@"%@=-=%@", phoneNO,nickname);
        
    if (phone && ![ProUtils checkMobilePhone:phoneNO]) {
        [peoplePicker dismissViewControllerAnimated:YES completion:nil];
        [self selectedPhone:phoneNO withName:nickname];
        return;
        }else{
        [self showAlert:TNOperationState_Unknow content:@"请选择手机号码"];
    }

}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person
{
    ABPersonViewController *personViewController = [[ABPersonViewController alloc] init];
    personViewController.displayedPerson = person;
    
    
    [peoplePicker pushViewController:personViewController animated:YES];
}
  //iOS7下

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    return YES;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
    long index = ABMultiValueGetIndexForIdentifier(phone,identifier);
    
        if (index < 0) {
            [peoplePicker dismissViewControllerAnimated:YES completion:nil];
    
            [self showAlert:TNOperationState_Unknow content:@"不能获取此号码，请手动输入"];
            return  YES;
        }
    
    //读取nickname呢称
    ABMultiValueRef  nicknameRef =  ABRecordCopyValue(person, kABPersonNicknameProperty);
    long nicknameindex = ABMultiValueGetIndexForIdentifier(nicknameRef,identifier);
    
    
    
    NSString *nickname = (__bridge NSString *)ABMultiValueCopyValueAtIndex(nicknameRef, nicknameindex);

    
    NSString *phoneNO = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phone, index);
    if ([phoneNO hasPrefix:@"+"]) {
        phoneNO = [phoneNO substringFromIndex:3];
    }
    
    phoneNO = [phoneNO stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSLog(@"%@", phoneNO);
    if (phone && ![ProUtils checkMobilePhone:phoneNO]) {
        
        [peoplePicker dismissViewControllerAnimated:YES completion:nil];
         [self selectedPhone:phoneNO withName:nickname];
        return NO;
    }else{
    
         [self showAlert:TNOperationState_Unknow content:@"请选择手机号码"];
    }
    return YES;
}


#pragma mark ---

- (void)createAction:(UIButton *)sender{

    
    NSMutableDictionary *parameterDic = [NSMutableDictionary dictionary];
    
    if (self.className) {
        [parameterDic addEntriesFromDictionary:@{@"clazzName":self.className}];
    }else{
        
        [self showAlert:TNOperationState_Unknow content:@"请填写班级名称"];
        return ;
    }
    if (self.selectedGradeDic) {
        [parameterDic addEntriesFromDictionary:@{@"grade":self.selectedGradeDic[@"id"]}];
    }else{
        
        [self showAlert:TNOperationState_Unknow content:@"请选择年级"];
        return ;
    }
    if ([self.selectedSubjectsArray count] > 0) {
        
        NSString * subjectIds = @"";
        for (NSDictionary * dic in self.selectedSubjectsArray) {
            if (subjectIds.length == 0) {
                subjectIds = dic[@"subjectsId"];
            }else{
                subjectIds = [subjectIds stringByAppendingFormat:@",%@", dic[@"subjectsId"]];
            }
        }
        [parameterDic addEntriesFromDictionary:@{@"subjectIds":subjectIds}];
    }else{
    
        [self showAlert:TNOperationState_Unknow content:@"请选择执教科目"];
        return ;
    }
    if ([self.inviteTeacherArray count] > 0) {
        
        NSMutableArray * inviteeTeachers = [[NSMutableArray alloc]init];
        
        for (NSDictionary * dic in self.inviteTeacherArray) {
           
            NSString * subjectIds = @"";
            NSMutableArray * subjectArray = [[NSMutableArray alloc]init];
            for (NSDictionary * tempDic in dic[@"subjects"]) {
                if (subjectIds.length == 0) {
                    subjectIds = [NSString stringWithFormat:@"\"%@\"",tempDic[@"subjectsId"]];
                    
                }else{
                    subjectIds = [subjectIds stringByAppendingFormat:@",\"%@\"", tempDic[@"subjectsId"]];
                }
                [subjectArray addObject:tempDic[@"subjectsId"]];
            }
            NSString *string = [NSString stringWithFormat:@"{\"phone\":\"%@\",\"subjectIds\":%@}",dic[@"phone"],[NSString stringWithFormat:@"[%@]",subjectIds ]];
//            NSDictionary * tempDic = @{@"phone":dic[@"phone"],@"subjectId":[NSString stringWithFormat:@"[%@]",subjectIds ]};
            
//             NSString * stringone = [ProUtils dictionaryToJson:tempDic];
            
            [inviteeTeachers addObject:string];
        }
        
    
        NSString * inviteeTeachersStr = [NSString stringWithFormat:@"[%@]",[inviteeTeachers componentsJoinedByString:@","]];
        [parameterDic addEntriesFromDictionary:@{@"inviteeTeachers":inviteeTeachersStr}];
    }
    
    //1 管理员   0 普通老师
    NSNumber *  adminTeacher =  @(1);
   [parameterDic addEntriesFromDictionary: @{ @"adminTeacher":adminTeacher}];
   [self createClazz:parameterDic];
    
}

- (void)selectedPhone:(NSString *)phone withName:(NSString *)username{
 
    [self requestQueryTeacherByPhone:phone];
}

- (void)requestQueryTeacherByPhone:(NSString *)phone{

    self.invitationPhone = phone;
    NSDictionary * parameterDic = @{@"phone":phone};
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_QueryTeacherByPhone] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_QueryTeacherByPhone];
    
    
}

- (void)createClazz:(NSDictionary *)parameterDic{

    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_TeacherCreateClazz] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_TeacherCreateClazz];
}


- (void)setNetworkRequestStatusBlocks{

    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_QueryTeacherByPhone) {
           
            [strongSelf gotoCreateClassInvitationSubjects:successInfoObj];
            
        }else if (request.tag == NetRequestType_TeacherCreateClazz){
           
            [strongSelf showAlert:TNOperationState_OK content:@"创建班级成功" block:^(NSInteger index) {
                
                [strongSelf gotoDetailVC:successInfoObj[@"clazzId"]];
                
                SessionModel *sesstion = [[SessionHelper sharedInstance] getAppSession];
                sesstion.hasClazz = @(1);
                [[SessionHelper sharedInstance]saveCacheSession:sesstion];
               
                
            }];
        }
    }];
}
- (void)gotoDetailVC:(NSString *)classID{
    NSString * title = [NSString stringWithFormat:@"%@ %@",self.selectedGradeDic[@"gradeName"],self.className];
 
    NewClassDetailViewController * classDetail = [[NewClassDetailViewController alloc]initWithTitle:title withClassId:classID withType:NewClassDetailVCFromeType_Create isTeacherIdentity:YES];
    [self pushViewController:classDetail];
}

- (void)gotoCreateClassInvitationSubjects:(NSDictionary *)dic{
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        ClassDetailTeacherModel * model =  [self getClassDetailModel:dic];
        SubjectsListNewViewController * subjectsVC = [[SubjectsListNewViewController alloc]initWithType:SubjectsListNewViewControllerFromeType_CreateInvitation withChangeTeacher:model];
        WEAKSELF
        subjectsVC.invitationSubjectsBlock = ^(NSDictionary *invitationDic) {
            
            if ([weakSelf.inviteTeacherArray count] >0) {
                BOOL isContains = NO;
                for (NSDictionary * dic in weakSelf.inviteTeacherArray) {
                    if ([dic[@"phone"] isEqualToString:invitationDic[@"phone"]]) {
                        isContains = YES;
                    }
                }
                if (!isContains) {
                    [weakSelf.inviteTeacherArray addObject:invitationDic];
                    [weakSelf updateTableView];
                }else{
                    [self showAlert:TNOperationState_Unknow content:@"该联系人已经添加无需重复添加"];
                }
                
            }else{
                
                [weakSelf.inviteTeacherArray addObject:invitationDic];
                [weakSelf updateTableView];
                
            }
        };
        
        [self pushViewController:subjectsVC];
        
        
    });
}

- (ClassDetailTeacherModel *) getClassDetailModel:(NSDictionary *)dic{

    ClassDetailTeacherModel * model = [[ClassDetailTeacherModel alloc]init];
    
    NSNumber * registerNumber = dic[@"register"];
    //注册用户
    if ([registerNumber integerValue] == 1) {
        model.teacherName = dic[@"teacherName"] ;
        model.phone = self.invitationPhone;
    }else{
        model.teacherName = @"未注册";
        model.phone = self.invitationPhone;
    }
    model.registerNumber = registerNumber;
    model.sex = dic[@"sex"];
    model.avatar = dic[@"thumbnail"];
    return model;
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
