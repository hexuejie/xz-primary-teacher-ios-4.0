
//
//  kickedOutStudentsViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/8/4.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "KickedOutStudentsViewController.h"
#import "NewClassDetailStudentOneRowCell.h"
#import "ClassDetailStudentModel.h"

NSString * const KickedOutStudentsOneRowCellIdentifier = @"KickedOutStudentsNewClassDetailStudentOneRowCell";
@interface KickedOutStudentsViewController ()
@property(nonatomic, strong) NSMutableArray*  selectedArray ;//存储所有选择的Index
@property(nonatomic, copy) NSString * classID;
@property(nonatomic, strong)NSString * className;
@end

@implementation KickedOutStudentsViewController
- (instancetype)initWithClassId:(NSString *)classId withClassName:(NSString *)className{
    
    if (self == [super init]) {
       
        self.classID = classId;
        self.className = className;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationItemTitle:@"移除学生"];
    [self updateRequestData];
}

- (NSString *)getDescriptionText{
    
    return @"本班暂无学生！";
}
- (NSMutableArray *)selectedArray{

    if (!_selectedArray) {
        _selectedArray = [[NSMutableArray alloc]init];
    }
    return _selectedArray;
}
- (void)registerCell{

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NewClassDetailStudentOneRowCell class]) bundle:nil] forCellReuseIdentifier:KickedOutStudentsOneRowCellIdentifier];
}
- (void)initBottomView{
    
  
    CGFloat bottomHeight = FITSCALE(60);
    
     CGFloat bottomY = CGRectGetMaxY(self.tableView.frame) ;
    NSLog(@"%f===",self.view.frame.size.height - bottomHeight);
      NSLog(@"view= %f---=bottomHeight==",self.view.frame.size.height);
    
    UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, bottomY, self.view.frame.size.width,  bottomHeight )];
    
    UIImage * tempImage =  [UIImage imageNamed:@"new_bottom_button_background"]  ;
    // 指定为拉伸模式，伸缩后重新赋值
    tempImage = [tempImage resizableImageWithCapInsets:UIEdgeInsetsMake(10, 15, 15, 10) resizingMode:UIImageResizingModeStretch];
    imageV.image = tempImage;
    imageV.backgroundColor = [UIColor clearColor];
    [self.view addSubview:imageV];
    
    
    
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, bottomY, self.view.frame.size.width,  bottomHeight)];
    
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
    
    
    UIButton *  sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setTitle:@"确  定" forState:UIControlStateNormal];
    
    [sureBtn setFrame:CGRectMake(10, 0, self.view.frame.size.width - 20 , backgroundView.frame.size.height)];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = fontSize_14;
    [sureBtn addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:sureBtn];
    
    
    
}

- (void)sureAction:(id)sender{
    
    if ([self.selectedArray count] ==0) {
        
        NSString *content = [NSString stringWithFormat:@"请您选择学生"];
        
        [self showAlert:TNOperationState_Unknow content:content];
        return;
    }
    NSString *content = [NSString stringWithFormat:@"您确定要将选中的学生从 %@ 移除吗？",self.className];
    NSString * title = @"移除学生";
    
    MMPopupItemHandler handler = ^(NSInteger index){
        [self requestTeacherRemoveStudent:[self getSelectedStudentId]];
    };
    NSArray* items = @[MMItemMake(@"否",MMItemTypeHighlight , nil),
                       MMItemMake(@"是",MMItemTypeHighlight , handler)];
    
    
    [self showNormalAlertTitle:title content:content items:items block:nil];

}
- (NSString * )getSelectedStudentId{
    
    NSString  * studentIds = @"";
    for (NSIndexPath * index in self.selectedArray) {
        ClassDetailStudentModel * tempModel = self.studentsModel.students[index.section];
        if ([studentIds length] <= 0) {
            studentIds = tempModel.studentId;
        }else   {
            studentIds = [studentIds stringByAppendingString:[NSString stringWithFormat:@",%@",tempModel.studentId]];
        }
         
    }
    return studentIds;
}

- (void)requestTeacherRemoveStudent:(NSString *)studentIds{
    
    NSDictionary * parameterDic = @{@"studentIds":studentIds};
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_TeacherRemoveStudent] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_TeacherRemoveStudent];
}

- (void)setNetworkRequestStatusBlocks{
    
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag ==  NetRequestType_ListStudentByClazzId) {
            
            strongSelf.studentsModel = [[ClassDetailStudentsModel alloc]initWithDictionary:successInfoObj error:nil];
            if ([strongSelf.studentsModel.students count] > 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [strongSelf initBottomView];
                });
                
            }
            [strongSelf updateTableView];
            
  
            
        }else if(request.tag == NetRequestType_TeacherRemoveStudent){
            
            NSString *content = [NSString stringWithFormat:@"移除学生成功"];
            MMPopupItemHandler handler = ^(NSInteger index){
                
//                [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_CLASS_STUDENT_LIST object:nil];
                if (strongSelf.updateBlock) {
                    strongSelf.updateBlock();
                }
                [strongSelf backViewController];
            };
            [strongSelf showAlert:TNOperationState_OK content:content block:handler];
            
           
            
        }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell ;
    
    NewClassDetailStudentOneRowCell *tempCell = [tableView dequeueReusableCellWithIdentifier:KickedOutStudentsOneRowCellIdentifier];
    [tempCell setupCellInfo:self.studentsModel.students[indexPath.section]];
    [tempCell showCellSelectedState];
    if ([self.selectedArray containsObject:indexPath]) {
        [tempCell selectedState:YES];
    }else{
        [tempCell selectedState:NO];
    }
    tempCell.indexPath = indexPath;
    
    WEAKSELF
    tempCell.btnBlock = ^(NSIndexPath *openIndex, BOOL isOpen) {
        if ([weakSelf.selectedArray containsObject:indexPath]) {
            [weakSelf.selectedArray removeObject:indexPath];
        }else{
            
            [weakSelf.selectedArray addObject:indexPath];
        }
         [weakSelf updateTableView];
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell = tempCell;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.selectedArray containsObject:indexPath]) {
        [self.selectedArray removeObject:indexPath];
    }else{
        
        [self.selectedArray addObject:indexPath];
    }
    [self updateTableView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (CGRect)getTableViewFrame{
    
    
    return CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - FITSCALE(60));
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
