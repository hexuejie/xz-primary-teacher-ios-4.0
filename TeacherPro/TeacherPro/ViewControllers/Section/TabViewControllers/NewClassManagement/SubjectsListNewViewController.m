

//
//  SubjectsListNewViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/8/2.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "SubjectsListNewViewController.h"
#import "CourseModel.h"
#import "SubjectsListNewCell.h"
#import "SubjectsUserInfoNewCell.h"
#import "SubjectsNewTitleCell.h"
#import "ClassDetailTeacherModel.h"
#import "ProUtils.h"

static NSString * const SubjectsListNewCellIdentifier = @"SubjectsListNewCellIdentifier";
static NSString * const SubjectsUserInfoNewCellIdentifier = @"SubjectsUserInfoNewCellIdentifier";
static NSString * const SubjectsNewTitleCellIdentifier = @"SubjectsNewTitleCellIdentifier";
@interface SubjectsListNewViewController ()
@property(nonatomic, assign) SubjectsListNewViewControllerFromeType  type;
@property(nonatomic, strong) CoursesModel * couresArray;
@property(nonatomic, strong) NSMutableArray  *selectedIndexArray;
@property(nonatomic, strong) ClassDetailTeacherModel * teacherModel;
@end

@implementation SubjectsListNewViewController

- (instancetype)initWithType:(SubjectsListNewViewControllerFromeType)type withChangeTeacher:(ClassDetailTeacherModel *)model{
    
    if (self == [super init]) {
        self.type = type;
        self.teacherModel = model;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString * title = @"选择科目";
    if (self.type == SubjectsListNewViewControllerFromeType_Change ) {
        title = @"修改科目";
    }else if (self.type == SubjectsListNewViewControllerFromeType_Create ) {
        title = @"选择科目";
    }else if (self.type == SubjectsListNewViewControllerFromeType_Invitation) {
        title = @"选择科目";
    }
    else if (self.type == SubjectsListNewViewControllerFromeType_Join) {
        title = @"选择科目";
    }else if (self.type == SubjectsListNewViewControllerFromeType_CreateInvitation){
        title = @"选择科目";
    }
    [self setNavigationItemTitle:title];
    [self configTableView];
    [self initBottomView];
    // Do any additional setup after loading the view.
}

- (NSMutableArray *)selectedIndexArray{

    if (!_selectedIndexArray) {
           _selectedIndexArray = [[NSMutableArray alloc]init];
    }
    return _selectedIndexArray;
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
    UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - bottomHeight, self.view.frame.size.width,  bottomHeight )];
    
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
    
    UIView * backgroundView = [[UIView alloc]initWithFrame:CGRectMake(10, top, self.view.frame.size.width-20,  bottomHeight -top*2)];
    backgroundView.backgroundColor = project_main_blue;
    backgroundView.layer.masksToBounds  = YES;
    backgroundView.layer.borderColor = [UIColor clearColor].CGColor;
    backgroundView.layer.borderWidth = 1.0;
    backgroundView.layer.cornerRadius =( bottomHeight - top*2) /2;
    [bottomView addSubview:backgroundView];
    
    
    UIButton * createBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [createBtn setTitle:@"确  定" forState:UIControlStateNormal];
    [createBtn setFrame:CGRectMake(10, 0, self.view.frame.size.width - 20 , backgroundView.frame.size.height)];
    [createBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    createBtn.titleLabel.font = fontSize_14;
    [createBtn addTarget:self action:@selector(subjectsAction:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:createBtn];
    
    
    
}

- (void)subjectsAction:(id)sender{

    [self sureAction];
}

- (CGRect)getTableViewFrame{
    
    return CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - FITSCALE(60));
}
- (void)registerCell{

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SubjectsListNewCell class]) bundle:nil] forCellReuseIdentifier:SubjectsListNewCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SubjectsUserInfoNewCell class]) bundle:nil] forCellReuseIdentifier:SubjectsUserInfoNewCellIdentifier];
     [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SubjectsNewTitleCell class]) bundle:nil] forCellReuseIdentifier:SubjectsNewTitleCellIdentifier];
}

- (void)getNormalTableViewNetworkData{

    [self requestCourse];
}
- (void)sureAction{
    
    if (self.selectedIndexArray.count ==0) {
        [self showAlert:TNOperationState_Fail content: @"请选择科目"];
        return;
    }
    
    if (self.type == SubjectsListNewViewControllerFromeType_Change) {
        [self requestUpdateClazSubject ];
       
    }else if(self.type ==  SubjectsListNewViewControllerFromeType_Join){
        [self requestTeacherAddToClazz];
        
    }else if(self.type ==  SubjectsListNewViewControllerFromeType_Invitation){
        [ self requestInvitation];
        
    }else if(self.type ==  SubjectsListNewViewControllerFromeType_Create){
 
        NSMutableArray * subjects = [[NSMutableArray alloc]init];
        for (NSIndexPath * index in self.selectedIndexArray) {
            CourseModel *model = self.couresArray.items[index.row - 1];
            [subjects addObject:@{@"subjectsId":model.dicKey,@"subjects":model.dicValue}];
        }
        if (subjects.count >0) {
            if (self.createSubjectsBlock) {
                self.createSubjectsBlock(subjects);
            }
            [self backViewController];
        }
    
    }else if(self.type ==  SubjectsListNewViewControllerFromeType_CreateInvitation){
        NSMutableArray * subjects = [[NSMutableArray alloc]init];
        for (NSIndexPath * index in self.selectedIndexArray) {
            CourseModel *model = self.couresArray.items[index.row - 1];
            [subjects addObject:@{@"subjectsId":[NSString stringWithFormat:@"%@",model.dicKey],@"subjects":model.dicValue}];
        }
        if ([subjects count] > 0) {
            if (self.invitationSubjectsBlock ) {
                
                NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
                [dic addEntriesFromDictionary:@{@"subjects":subjects,@"register":self.teacherModel.registerNumber,@"phone":self.teacherModel.phone}];
                if (self.teacherModel.teacherName) {
                    [dic addEntriesFromDictionary:@{@"teacherName":self.teacherModel.teacherName}];
                }
                if (self.teacherModel.avatar) {
                    [dic addEntriesFromDictionary:@{@"avatar":self.teacherModel.avatar}];
                }
                if (self.teacherModel.sex) {
                    [dic addEntriesFromDictionary:@{@"sex":self.teacherModel.sex}];
                }
                
                self.invitationSubjectsBlock(dic);
            }
            
            [self backViewController];
          
        }
     
    }
    
}



- (void)requestUpdateClazSubject{
    
  
     NSString * subjectIds = [self getSubjectsId];
    
    NSDictionary * parameterDic = @{@"desTeacherId":self.teacherModel.teacherId,@"clazzId":self.teacherModel.classId,@"subjectIds":subjectIds};
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_TeacherUpdateClazSubject] parameterDic: parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_TeacherUpdateClazSubject];
    
}


- (void)requestTeacherAddToClazz{
    
 
    NSString * subjectIds = [self getSubjectsId];
    
    
    NSDictionary * parameterDic = @{@"clazzId":self.teacherModel.classId,@"subjectIds":subjectIds};
    
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_TeacherApplyAddToClazz] parameterDic: parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_TeacherApplyAddToClazz];
    
}


- (NSString *)getSubjectsId{

    NSString * subjectIds = @"";
    for (NSIndexPath * indexPath in self.selectedIndexArray) {
        CourseModel * model = self.couresArray.items[indexPath.row-1];
        
        if (subjectIds.length == 0) {
            subjectIds = [NSString stringWithFormat:@"%@",model.dicKey];
        }else{
            subjectIds = [NSString stringWithFormat:@"%@,%@",subjectIds,model.dicKey];
        }
    }
    return subjectIds;
}
- (void)requestInvitation{
    
 
    NSString * subjectIds = [self getSubjectsId];
    NSDictionary * parameterDic = @{@"inviteePhone":self.teacherModel.phone,@"subjectIds": subjectIds,@"clazzId":self.teacherModel.classId};
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_InviteTeacherJoinClazz] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_InviteTeacherJoinClazz];
    
}

- (void)setNetworkRequestStatusBlocks{
    
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_QueryDictionary) {
            strongSelf.couresArray =  [[CoursesModel alloc]initWithDictionary:successInfoObj error:nil];
            
            if (strongSelf.teacherModel) {
            
                for (int i = 0;i< [strongSelf.couresArray.items count]; i++) {
                    
                    NSArray * array =  [strongSelf.teacherModel.subjectNames componentsSeparatedByString:@","];
                   
                    for ( id object in  array) {
                         NSString  * subjectsName= object;
//                        if (self.type == SubjectsListNewViewControllerFromeType_Create) {
//                            subjectsName = object;
//                        }else if (self.type == SubjectsListNewViewControllerFromeType_Change){
//                          subjectsName =  object;
//                        }
                            CourseModel * model = strongSelf.couresArray.items[i];
                            if ([model.dicValue isEqualToString: subjectsName]) {
                                NSIndexPath * index = [NSIndexPath indexPathForRow:i+1 inSection:1];
                                [strongSelf.selectedIndexArray addObject:index];
                            }
                            
                        }
                        
                    }
                }
            
            [strongSelf updateTableView];
            
            
        } else if(request.tag == NetRequestType_TeacherUpdateClazSubject){
            [strongSelf showAlert:TNOperationState_OK content:@"修改科目成功" block:^(NSInteger index) {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_CLASS_TEACHER_LIST object:nil];
                [strongSelf backViewController];
            }];
            
        }else if (request.tag == NetRequestType_TeacherApplyAddToClazz){
            
            NSString * className = strongSelf.teacherModel.className;
            NSString *alertTilte = [NSString stringWithFormat:@"您已申请加入 %@，请等待管理员通过申请。",className];
            [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_SEARCH_CLASS_LIST object:nil];
            
            [strongSelf showAlert:TNOperationState_OK content:alertTilte block:^(NSInteger index) {
                
                [strongSelf backViewController];
            
            }];
        }else if (request.tag == NetRequestType_InviteTeacherJoinClazz){
            
            [strongSelf showAlert:TNOperationState_OK content:@"您已成功发出邀请，请等待对方回复。 " block:^(NSInteger index) {
                [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_INVITATION_CLASS_LIST object:nil];
                [strongSelf backViewController];
                
            }];
        }
        
    }];
}
#pragma mark ----

- (void)requestCourse{
    
    NSDictionary * parameterDic = @{@"type":@"subject"};
    
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_QueryDictionary] parameterDic: parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_QueryDictionary];
    
}

#pragma mark ---

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger  row = 0;
    if (section == 0) {
        row = 1;
    }else if (section == 1){
        row = 1 + [self.couresArray.items count];
    }
    return row;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
         return FITSCALE(60);
    }else if (indexPath.section == 1){
    
        return FITSCALE(50);
    }
    return 0;
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
        headherHeight =  FITSCALE(12);
    }else if (section == 1){
        
        headherHeight = FITSCALE(7);
    }
    return headherHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell ;
    
    
    if (indexPath.section == 0) {
        SubjectsUserInfoNewCell * tempCell = [tableView dequeueReusableCellWithIdentifier:SubjectsUserInfoNewCellIdentifier];
        NSAttributedString  * title = nil;
        
        NSString * imgName =  @"student_img";
        
        if (self.type == SubjectsListNewViewControllerFromeType_Create ||self.type == SubjectsListNewViewControllerFromeType_Join) {
            
            if (self.teacherModel.teacherName) {
                
                NSString *replacingPhone = [ProUtils replacingCenterPhone:self.teacherModel.phone withReplacingSymbol:@"*"];
                
                NSString * tempText = [NSString stringWithFormat:@"%@(%@)",self.teacherModel.teacherName,replacingPhone];
         
                 NSRange range = [tempText rangeOfString:[NSString stringWithFormat:@"(%@)",replacingPhone]];
                title = [ProUtils setAttributedText:tempText withColor:UIColorFromRGB(0x898989) withRange:range withFont:fontSize_12];
                
                
            }else{
                title = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",self.teacherModel.phone]];
            }
           
            
        }else if (self.type == SubjectsListNewViewControllerFromeType_Change){
            if (self.teacherModel.teacherName) {
                
                NSString *replacingPhone = [ProUtils replacingCenterPhone:self.teacherModel.teacherPhone withReplacingSymbol:@"*"];
                
                NSString * tempText = [NSString stringWithFormat:@"%@(%@)",self.teacherModel.teacherName,replacingPhone];
                 NSRange range = [tempText rangeOfString:[NSString stringWithFormat:@"(%@)",replacingPhone]];
                
                title = [ProUtils setAttributedText:tempText withColor:UIColorFromRGB(0x898989) withRange:range withFont:fontSize_12];
                
               
            }else{
                title = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",self.teacherModel.teacherPhone]];
            }
            
            
        }else if (self.type == SubjectsListNewViewControllerFromeType_CreateInvitation|| self.type == SubjectsListNewViewControllerFromeType_Invitation){
            if (self.teacherModel.teacherName) {
                NSString *replacingPhone = [ProUtils replacingCenterPhone:self.teacherModel.phone withReplacingSymbol:@"*"];
                
                NSString * tempText = [NSString stringWithFormat:@"%@(%@)",self.teacherModel.teacherName,replacingPhone];
                NSRange range = [tempText rangeOfString:[NSString stringWithFormat:@"(%@)",replacingPhone]];
                
                title = [ProUtils setAttributedText:tempText withColor:UIColorFromRGB(0x898989) withRange:range withFont:fontSize_12];
                
            }else{
                title = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",self.teacherModel.phone]];
            }
        }
        
        if ([self.teacherModel.sex isEqualToString:@"male"]) {
            imgName = @"tearch_man";
        }else if([self.teacherModel.sex isEqualToString:@"female"]){
            imgName =  @"tearch_wuman";
        }
        [tempCell setupInfoTitle:title withUrlImg:self.teacherModel.avatar withPlaceholderImageImg: imgName];
 
        cell = tempCell;
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            SubjectsNewTitleCell * tempCell = [tableView dequeueReusableCellWithIdentifier:SubjectsNewTitleCellIdentifier];
            cell = tempCell;
        }else{
        
            SubjectsListNewCell * tempCell = [tableView dequeueReusableCellWithIdentifier:SubjectsListNewCellIdentifier];
            CourseModel *model = self.couresArray.items[indexPath.row - 1];
            BOOL state = NO;
            if ([self.selectedIndexArray containsObject:indexPath]) {
                state = YES;
            }else{
                state = NO;
            }

            [tempCell setupTitle:model.dicValue withState:state];
             cell = tempCell;
        }
    
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.selectedIndexArray containsObject:indexPath]) {
        [self.selectedIndexArray removeObject:indexPath];
    }else{
        [self.selectedIndexArray addObject:indexPath];
    }
    
    [self updateTableView];
}


@end
