
//
//  NewClassDetailViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/8/3.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "NewClassDetailViewController.h"
#import "YBPopupMenu.h"
#import "NewClassDetailStudentViewController.h"
#import "NewClassDetailTeacherViewController.h"
#import "NewClassDetailInvitationViewController.h"
#import "InvitationStudentViewController.h"

#import "ProUtils.h"
#import "SessionModel.h"
#import "SessionHelper.h"
#import "TransferClassViewController.h"
#import "KickedOutStudentsViewController.h"
#import "ClassDetailTeacherModel.h"
#import "SubjectsListNewViewController.h"
#import "UIViewController+BackButtonHandler.h"
#import "XXYActionSheetView.h"
#import "ZAlertViewManager.h"

#import <AddressBook/ABPerson.h>
#import <AddressBookUI/ABPersonViewController.h> 
#import <AddressBookUI/ABPeoplePickerNavigationController.h>
#import <ContactsUI/ContactsUI.h>
@interface NewClassDetailViewController ()<YBPopupMenuDelegate,UIActionSheetDelegate,ABPeoplePickerNavigationControllerDelegate,XXYActionSheetViewDelegate,CNContactPickerDelegate>
@property (nonatomic, copy)   NSString * navigationTitle;
@property (nonatomic, copy)   NSString * classID;
@property (nonatomic, strong) NSMutableDictionary *rightBtnStateDic;//存储导航条右侧按钮的选中状态
@property (nonatomic, assign) NewClassDetailVCFromeType  fromType;//
@property (nonatomic, assign) BOOL   isTeacherIdentityAdmin;//
@property(nonatomic, copy) NSString * invitationPhone;//邀请人号码
@property (nonatomic, strong) AlertView * validationAlertView;
//学生数据有变化 需要更新学生列表
@property (nonatomic, assign) BOOL isUpdateStudentList;
@end

@implementation NewClassDetailViewController
- (instancetype)initWithTitle:(NSString *)titleStr  withClassId:(NSString *)classID withType:(NewClassDetailVCFromeType)type isTeacherIdentity:(BOOL)isAdmin{
    self = [super init];
    if (self ) {
        self.navigationTitle = titleStr;
        self.classID = classID;
        self.fromType = type;
        self.isTeacherIdentityAdmin = isAdmin;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationItemTitle:self.navigationTitle];
    [self setupRightBarButtonItem];
    [self setupBarView];
    
    [self navUIBarBackground:0];
}

- (void)backViewController{
    
    
    if (self.fromType == NewClassDetailVCFromeType_Create) {
       
        NSInteger index = [self.navigationController.viewControllers count]-3;
        [self.navigationController popToViewController:self.navigationController.viewControllers[index] animated:YES];
         [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_BINDINGCLASS object:nil];
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    
    }
    
}

/**
 * 协议中的方法，获取返回按钮的点击事件
 */
- (BOOL)navigationShouldPopOnBackButton
{
    if (self.fromType == NewClassDetailVCFromeType_Create) {
     
          NSInteger index = [self.navigationController.viewControllers count]-3;
        [self.navigationController popToViewController:self.navigationController.viewControllers[index] animated:YES];
        
           [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_BINDINGCLASS object:nil];
        return NO;
    }else
        return YES;
}

- (void)setupRightBarButtonItem{
    
    
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [  rightBtn setTitle:@"管理" forState:UIControlStateNormal];
    [  rightBtn setTitleColor:HexRGB(0x4D4D4D) forState:UIControlStateNormal];
    rightBtn.titleLabel.font = rightBarButtonItem_font;
    [  rightBtn addTarget:self action:@selector(managementAction:) forControlEvents:UIControlEventTouchUpInside];
    [  rightBtn setFrame:CGRectMake(0,5, 40, 44)];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:  rightBtn];
    
}

- (void)managementAction:(UIButton *)sender{
    
    NSArray * items = nil;
    if (self.isTeacherIdentityAdmin) {
        items = @[@{@"title":@"邀请老师",@"img":@"new_class_detail_Invite_teacher"},
                  @{@"title":@"邀请学生",@"img":@"new_class_detail_Invite_student"},
                  @{@"title":@"移除学生",@"img":@"new_class_detail_kicked_student"},
                  @{@"title":@"转让管理员",@"img":@"new_class_detail_transfer_class"},
                  @{@"title":@"解散班级",@"img":@"new_class_detail_dissolution_class"}
                
                  ];
    }else{
    
        items = @[
                  @{@"title":@"邀请学生",@"img":@"new_class_detail_Invite_student"},
                  @{@"title":@"退出班级",@"img":@"new_class_detail_exit_class"}
          
                  ];
    }
    
 
    
    
    NSMutableArray * menuItemTitles = [[NSMutableArray alloc]initWithCapacity:items.count];
    NSMutableArray * menuItemImgs = [[NSMutableArray alloc]initWithCapacity:items.count];
    
    for(int i =0;i< [items count]; i++)   {
        NSDictionary * dic= items[i];
        [menuItemTitles addObject: dic[@"title"]];
        [menuItemImgs    addObject: dic[@"img"]];
    }
    
    
    CGFloat menuW =  FITSCALE(140);
    CGFloat x = sender.center.x;
    if (IOS11) {
        x = sender.center.x + self.view.frame.size.width - sender.frame.size.width;
    }
    //    CGFloat y = CGRectGetMaxY(sender.frame)+15;
    CGFloat y =  NavigationBar_Height;
    WEAKSELF
    //推荐用这种写法
    [YBPopupMenu showAtPoint:CGPointMake(x, y ) titles:menuItemTitles icons:menuItemImgs menuWidth:menuW otherSettings:^(YBPopupMenu *popupMenu) {
        STRONGSELF
        popupMenu.dismissOnSelected = NO;
        popupMenu.isShowShadow = YES;
        popupMenu.delegate = strongSelf;
        popupMenu.offset = 10;
        popupMenu.fontSize =  iPhone6Plus?  14*ip6size : FITSCALE(14) ;
        popupMenu.type = YBPopupMenuTypeDark;
        
        popupMenu.rectCorner = UIRectCornerBottomLeft | UIRectCornerBottomRight|UIRectCornerTopLeft|UIRectCornerTopRight;
        popupMenu.backColor = [UIColor whiteColor];
        popupMenu.textColor = UIColorFromRGB(0x6b6b6b);
        
    }];

    
}


- (void)setupBarView{
    
    self.buttonBarView.shouldCellsFillAvailableWidth = YES;
    self.isProgressiveIndicator = NO;
    self.buttonBarView.leftRightMargin = 0;
    self.buttonBarView.scrollsToTop = NO;
    self.buttonBarView.scrollEnabled = NO;
    // Do any additional setup after loading the view.
    self.buttonBarView.selectedBarHeight = 3;
    self.buttonBarView.selectedBar.backgroundColor =  UIColorFromRGB(0x238EE3);
    self.bottomLineView.backgroundColor = UIColorFromRGB(0xededed);
    self.buttonBarView.bottomLineHeight = 1;
    
    
    self.buttonBarView.backgroundColor =[UIColor whiteColor];
    self.buttonBarView.layer.borderColor = [UIColor clearColor].CGColor;
    self.buttonBarView.layer.borderWidth = 0.5;
    self.buttonBarView.layer.masksToBounds = YES;
    self.buttonBarView.labelFont = fontSize_15;
    NSBundle * bundle = [NSBundle bundleForClass:[XLButtonBarView class]];
    NSURL * url = [bundle URLForResource:@"XLPagerTabStrip" withExtension:@"bundle"];
    if (url){
        bundle =  [NSBundle bundleWithURL:url];
    }
    [self.buttonBarView registerNib:[UINib nibWithNibName:@"ImgButtonCell" bundle:bundle] forCellWithReuseIdentifier:@"Cell"];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark ---

//解散班级验证码
- (void)reqeustDissolutionCode{
    NSString * phone =  @"";
    if([[SessionHelper sharedInstance] checkSession]){
        phone =  [[SessionHelper sharedInstance] getAppSession].phone;
    };
    
    if (phone &&[phone length] <=0) {
        NSLog(@"获取自己注册的手机号码错误");
        return;
    }
    NSDictionary * parameterDic = @{@"phone":phone,@"event":@"clazz_disband"};
    [self sendRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_TeacherDaisbandClassSendAuthCode] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_TeacherDaisbandClassSendAuthCode];
    
}
- (void)requestQuitClazz:(NSString *)clazzIds{
    
    NSDictionary * parameterDic = @{@"clazzIds":clazzIds};
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_TeacherQuitClazz] parameterDic:parameterDic  requestMethodType:RequestMethodType_POST requestTag:NetRequestType_TeacherQuitClazz];
}
- (void)requestDissolutionClazz:(NSString *)clazzIds code:(NSString *)authcode{
    
    
    NSDictionary * parameterDic = @{@"clazzIds":clazzIds,@"authcode":authcode};
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_TeacherDisbandClazz] parameterDic:parameterDic  requestMethodType:RequestMethodType_POST requestTag:NetRequestType_TeacherDisbandClazz];
}



- (void)setNetworkRequestStatusBlocks{
    
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_TeacherQuitClazz){
            
            [strongSelf showPromptView:@"退出班级成功"];
            
        }else if(request.tag == NetRequestType_TeacherDisbandClazz){
            
            [strongSelf showPromptView:@"解散班级成功"];
        } else if(request.tag == NetRequestType_TeacherDaisbandClassSendAuthCode){
            
            NSString * content =  @"验证码发送成功，请注意查收";
            
           strongSelf.validationAlertView.verificationText = content;
          
        }else if (request.tag == NetRequestType_QueryTeacherByPhone) {
            [strongSelf gotoInvitationSubjects:successInfoObj];
        }
    }];
}

- (void)setDefaultNetFailedBlockImplementationWithNetRequest:(NetRequest *)request error:(NSError *)error isAddFailedActionView:(BOOL)isAddActionView otherExecuteBlock:(void (^)(void))otherBlock
{
 

    if (request.tag == NetRequestType_TeacherDaisbandClassSendAuthCode) {
        
        NSString * errorStr = @"";
        // 无数据
        if (error.code == MyHTTPCodeType_DataSourceNotFound)
        {
            //        [self showHUDInfoByString:[LanguagesManager getStr:All_DataSourceNotFoundKey]];
        }
        // 未登录或登录过期
        else if (error.code == MyHTTPCodeType_TokenIllegal || error.code == MyHTTPCodeType_TokenIncomplete || error.code == MyHTTPCodeType_TokenOverdue||error.code == MyHTTPCodeType_NoLogin)
        {
            
            
            errorStr = error.localizedDescription;
            
            
        }
        else
        {
            /*
             [weakSelf showHUDInfoByType:HUDInfoType_Failed];
             */
            
            if (error.localizedDescription)
            {
                if ([error.localizedDescription containsString:@"Request failed"]) {
                    errorStr = @"网络连接失败,请稍后再试";
                }else if([error.localizedDescription containsString:@"Could not connect"]){
                    errorStr = @"网络连接失败,请稍后再试";
                    
                }else if([error.localizedDescription containsString:@"timed out"]){
                    errorStr = @"网络连接失败,请稍后再试";
                } else{
                    errorStr = error.localizedDescription;
                    
                }
                
            }
            else
            {
                errorStr = @"网络连接失败,请稍后再试";
                
            }
             
            
        }
        self.validationAlertView.verificationText = errorStr;
       
        
    }else{
    
        [super setDefaultNetFailedBlockImplementationWithNetRequest:request error:error isAddFailedActionView:isAddActionView otherExecuteBlock:otherBlock];
    }
   
}

- (void)showPromptView:(NSString *)content{
    
    [self showAlert:TNOperationState_OK content:content block:^(NSInteger index) {
      [self backViewController];
      [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_BINDINGCLASS object:nil];
        
    }];
    
}
#pragma mark --

-(NSArray *)childViewControllersForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    if (!self.classID) {
        self.classID = @"";
    }
    
    NewClassDetailTeacherViewController *teacherVC = [[NewClassDetailTeacherViewController alloc]initWithClassId:self.classID withClassName:self.navigationTitle isTeacherIdentity:self.isTeacherIdentityAdmin];
    
    
    
    NewClassDetailStudentViewController *studentVC = [[NewClassDetailStudentViewController alloc]initWithClassId:self.classID withClassName:self.navigationTitle];
    
    
    NewClassDetailInvitationViewController *invitationVC = [[NewClassDetailInvitationViewController alloc]initWithClassId:self.classID];
    
    NSMutableArray * childViewControllers = [NSMutableArray arrayWithObjects:teacherVC,studentVC, invitationVC,nil];
    
  
    return  childViewControllers ;
}

//-(void)pagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
//          updateIndicatorFromIndex:(NSInteger)fromIndex
//                           toIndex:(NSInteger)toIndex{
//    [super pagerTabStripViewController:pagerTabStripViewController updateIndicatorFromIndex:fromIndex toIndex:toIndex];
//
//    if ([self.pagerTabStripChildViewControllers[toIndex] isKindOfClass:[NewClassDetailStudentViewController class]]) {
//        if (self.isUpdateStudentList) {
//            NewClassDetailStudentViewController * studentVC = self.pagerTabStripChildViewControllers[toIndex];
//            [studentVC  requestStudents];
//            self.isUpdateStudentList = NO;
//        }
//    }
//
//
//}

- (void)changeCurrentIndexUpdate:(NSInteger )toIndex  {
    
    BaseNewClassDetailChildrenViewController *baseViewController = self.pagerTabStripChildViewControllers[toIndex];
    
    if (!baseViewController.hasLoadData) {
        [baseViewController updateRequestData];
    }
    if ([baseViewController isKindOfClass:[NewClassDetailStudentViewController class]]) {
        if (baseViewController.hasLoadData) {
             if (self.isUpdateStudentList) {

                [baseViewController updateRequestData];
                self.isUpdateStudentList = NO;
            }
        }
    }
}

 



#pragma mark ---
- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu{

    [ybPopupMenu dismiss];
 
    
        switch (index) {
            case 0:{
                if (self.isTeacherIdentityAdmin) {
                    [self gotoInvitationTeacherVC];
                }else{
                    [self gotoInvitationStudentVC];
                }
  
            }
                break;
            case 1:{
            
                if (self.isTeacherIdentityAdmin) {
                     [self gotoInvitationStudentVC];
                }else{
                     [self exitAction];
                }
            }
              
                break;
            case 2:{
                  [self kickedOutStudents];
               }
                break;
            case 3:{
                [self transferClass];
            }
                break;
            case 4:{
                 [self dissolutionAction];
            }
                
                break;
            default:
                break;
        }
    
}

- (void)gotoInvitationStudentVC{
    NSString * gradName = @"";
    NSArray * array = [self.navigationTitle componentsSeparatedByString:@" "];
    if (array.count >1) {
        gradName = array[1];
    }
    InvitationStudentViewController * studentVC = [[InvitationStudentViewController alloc]initWithClazzName:gradName withClazzId:self.classID];
    [self pushViewController:studentVC];
    
}


- (void)gotoInvitationTeacherVC{
    

    
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
        NSString * placeholder =  @"请输入教师手机号码";
        [self showAlertInputPhoneTitle:title content:nil items:nil placeholder:placeholder handler:^(NSString *text) {
            [self requestQueryTeacherByPhone:text];
        }];
        
    }
    else if (buttonIndex == 2){
        //取消
    }

}

- (void)kickedOutStudents{

    KickedOutStudentsViewController * transferVC = [[KickedOutStudentsViewController alloc]initWithClassId:self.classID withClassName:self.navigationTitle  ];
    WEAKSELF
    transferVC.updateBlock = ^{
        if (weakSelf.currentIndex ==1) {
           NewClassDetailStudentViewController * studentVC = weakSelf.pagerTabStripChildViewControllers[weakSelf.currentIndex];
             [studentVC  requestStudents];
        }else{
        
            weakSelf.isUpdateStudentList = YES;
        }
        
    };
    [self pushViewController:transferVC];

}

- (void)transferClass{
    TransferClassViewController * transferVC = [[TransferClassViewController alloc]initWithClassId:self.classID withClassName:self.navigationTitle isTeacherIdentity:YES];
    transferVC.transferBlock = ^{
      
        self.isTeacherIdentityAdmin = NO;
    };
    [self pushViewController:transferVC];
    
}
- (void)exitAction{
    
    NSString *clazzIds = self.classID;
    NSString *classNames =self.navigationTitle;
    NSString * alerTitle = [NSString stringWithFormat:@"确定要从 %@ 中退出吗？",classNames];
    
    [self showNormalAlertTitle:@"退出班级" content:alerTitle items:nil block:^(NSInteger index) {
        [self requestQuitClazz:clazzIds];
    }];
}
- (void)dissolutionAction{
    
    
    NSString *clazzIds = self.classID;
    NSString *classNames = self.navigationTitle;
    NSString *content =[NSString stringWithFormat:@"您确定要解散班级 %@ 吗？",classNames];
    NSString * title = @"解散班级";
    NSString * placeholder =  @"请输入验证码";
    
    MMPopupItemHandler rightItemHandler = ^(NSInteger index){
        //解散班级验证
        [self reqeustDissolutionCode];
    };
    MMPopupItem *rightItem = MMItemMake(@"获取验证码", MMItemTypeHighlight, rightItemHandler);
    
    MMPopupHandler inputHandler = ^(NSString *text) {
                [self requestDissolutionClazz:clazzIds code:text];
        
    };
    
    self.validationAlertView = [[AlertView alloc]initWithValidationInputTitle:title detail:content items: nil placeholder:placeholder handler:inputHandler  textFeildRightItem:rightItem ];
    
    [self.validationAlertView show];
//    [self showAlertValidationInputTitle:title content:content items:nil placeholder:placeholder handler:^(NSString *text) {
//        [self requestDissolutionClazz:clazzIds code:text];
        
//    } textFeildRightItem:rightItem];
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
- (void)requestQueryTeacherByPhone:(NSString *)phone{
    
    self.invitationPhone = phone;
    NSDictionary * parameterDic = @{@"phone":phone};
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_QueryTeacherByPhone] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_QueryTeacherByPhone];
    
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
    if (phoneindex < 0) {
        [peoplePicker dismissViewControllerAnimated:YES completion:nil];
        [self showAlert:TNOperationState_Unknow content:@"不能获取此号码，请手动输入"];
        return   ;
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
        
        [self selectedPhone:phoneNO withName:nickname];
        [peoplePicker dismissViewControllerAnimated:YES completion:nil];
        
        return;
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
    //读取nickname呢称
    ABMultiValueRef  nicknameRef =  ABRecordCopyValue(person, kABPersonNicknameProperty);
    long nicknameindex = ABMultiValueGetIndexForIdentifier(nicknameRef,identifier);
    
    //解决删除一个号码 点击另一个号码的bug 
    if (index < 0) {
        [peoplePicker dismissViewControllerAnimated:YES completion:nil];
        [self showAlert:TNOperationState_Unknow content:@"不能获取此号码，请手动输入"];
        return  YES;
    }
    
    NSString *nickname = (__bridge NSString *)ABMultiValueCopyValueAtIndex(nicknameRef, nicknameindex);
    
    
    NSString *phoneNO = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phone, index);
    if ([phoneNO hasPrefix:@"+"]) {
        phoneNO = [phoneNO substringFromIndex:3];
    }
    
    phoneNO = [phoneNO stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSLog(@"%@", phoneNO);
    if (phone && ![ProUtils checkMobilePhone:phoneNO]) {
        [self selectedPhone:phoneNO withName:nickname];
        [peoplePicker dismissViewControllerAnimated:YES completion:nil];
        return NO;
    }
    return YES;
}


#pragma mark ---

- (void)createAction:(UIButton *)sender{
    
    
}

- (void)selectedPhone:(NSString *)phone withName:(NSString *)username{

    [self requestQueryTeacherByPhone:phone];

}
#pragma mark --


- (void)gotoInvitationSubjects:(NSDictionary *)dic{

   ClassDetailTeacherModel * model =  [self getClassDetailModel:dic];
        SubjectsListNewViewController * subjectsVC = [[SubjectsListNewViewController alloc]initWithType:SubjectsListNewViewControllerFromeType_Invitation withChangeTeacher:model];
   [self pushViewController:subjectsVC];
  
   
}

- (ClassDetailTeacherModel *) getClassDetailModel:(NSDictionary *)dic{
    
    ClassDetailTeacherModel * model = [[ClassDetailTeacherModel alloc]init];
    
    NSNumber * registerNumber = dic[@"register"];
    //注册用户
    if ([registerNumber integerValue] == 1) {
        model.teacherName = dic[@"teacherName"];
        model.phone = self.invitationPhone;
    }else{
        model.teacherName = @"未注册";
        model.phone = self.invitationPhone;
    }
    model.registerNumber = registerNumber;
    model.classId = self.classID;
    model.sex = dic[@"sex"];
    model.avatar = dic[@"thumbnail"];
    return model;
}
- (UIColor *)getTabTitleColorNor{
    
    return UIColorFromRGB(0x9f9f9f);
}
- (UIColor *)getTabTitleColorSelected{
    
    return UIColorFromRGB(0x4C6B9A);
}
@end
