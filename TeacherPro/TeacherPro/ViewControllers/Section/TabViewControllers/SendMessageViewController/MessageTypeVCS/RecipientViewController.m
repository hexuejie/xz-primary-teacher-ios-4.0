//
//  RecipientViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/6/24.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "RecipientViewController.h"
#import "ChooseRecipientInfoCell.h"
#import "ChooseRecipientTeacherInfoCell.h"
#import "ChooseRecipientClassHeader.h"
#import "ChooseRecipientTeacherHeader.h"
#import "ProUtils.h"
#import "ReceuvedMessageModel.h"

NSString * const ChooseRecipientInfoCellIdentifier = @"ChooseRecipientInfoCellIdentifier";
NSString * const ChooseRecipientClassHeaderIdentifier = @"ChooseRecipientClassHeaderIdentifier";
NSString * const ChooseRecipientTeacherHeaderIdentifier = @"ChooseRecipientTeacherHeaderIdentifier";
NSString * const ChooseRecipientTeacherInfoCellIdentifier = @"ChooseRecipientTeacherInfoCellIdentifier";
@interface RecipientViewController ()
@property(nonatomic, strong) ReceuvedMessageModel * models;

@property (nonatomic, strong) NSMutableArray *foldingStatusArray;//是否打开 关闭

@property (nonatomic, strong) NSMutableDictionary  *selectedIndexDic;//确定后选择的收件人下标

@end

@implementation RecipientViewController
- (instancetype)initWithSelectedIndexDic:(NSDictionary *)indexDic{

    self = [super init];
    if (self) {
        self.selectedIndexDic = [NSMutableDictionary dictionaryWithDictionary: indexDic];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationItemTitle:@"选择收件人"];
    [self setupNavigationRightbar];
 
  
 
}
- (void)getNormalTableViewNetworkData
{
    
      [self requestRecipient];
    // do nothing
    
}
- (void)setupNavigationRightbar{
    UIButton * releaseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [releaseBtn setTitle:@"确定" forState:UIControlStateNormal];
    [releaseBtn setTitleColor:HexRGB(0x4d4d4d) forState:UIControlStateNormal ];
    [releaseBtn addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    [releaseBtn setFrame:CGRectMake(0, 5, 40,60)];
    releaseBtn.titleLabel.font = fontSize_14;
    releaseBtn.hidden = YES;
    UIBarButtonItem * rightBar = [[UIBarButtonItem alloc]initWithCustomView:releaseBtn];
    self.navigationItem.rightBarButtonItem = rightBar;
    
}

- (void)sendAction:(id)sender{

    
    NSMutableArray * teachers = [NSMutableArray array];
    NSMutableArray * students = [NSMutableArray array];
    for (NSString * key in self.selectedIndexDic.allKeys) {
        
        if ([key isEqualToString: @"0"]) {
            //选择的有老师
            if([self.models.teacherContacts count] > 0){
                [teachers addObjectsFromArray:[self getSelectedRecipient:key]];
            }else{
                // 学生信息
                [students addObjectsFromArray:[self getSelectedRecipient:key]];
            };
        }else{
        
            //学生信息
             [students addObjectsFromArray:[self getSelectedRecipient:key]];
        }
    }
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    if ([students count] >0) {
        [dic addEntriesFromDictionary:@{@"student":students}];
    }
    if ([teachers count] > 0) {
        [dic addEntriesFromDictionary:@{@"teacher":teachers}];
    }
  

    if ([dic.allKeys count] == 0) {
        
        NSString * content = @"请选择收件人";
        [self showAlert:TNOperationState_Unknow content:content];
        teachers = nil;
        students = nil;
        dic = nil;
    }else{
        if (self.recipientBlock) {
            self.recipientBlock(dic,self.selectedIndexDic);
        }
        teachers = nil;
        students = nil;
        dic = nil;
        [self backViewController];
    }
    
 
    
  
}

- (NSArray *)getSelectedRecipient:(NSString *)sectionStr{

    NSMutableArray * sectionArray = [NSMutableArray array];
    NSArray * selectedIndexs = self.selectedIndexDic[sectionStr];
    
    for (NSIndexPath * index in selectedIndexs) {
        if ([sectionStr isEqualToString:@"0"]) {
            
            if ( [self.models.teacherContacts count]>0) {
                [sectionArray addObject: self.models.teacherContacts[index.row]];
                
            }else{
                ReceuvedStudentContacts * contactes = self.models.studentContacts[[sectionStr intValue]];
                
                //存储所有学生  暂未按班级分开  待以后优化
                [sectionArray addObject: contactes.students[index.row]];
            }
        }else{
          
            NSInteger teampSection ;
            if ([self.models.teacherContacts count] >0) {
                teampSection = [sectionStr intValue]-1;
            }else{
            
                teampSection = [sectionStr intValue];
            }
            
            ReceuvedStudentContacts * contactes = self.models.studentContacts[teampSection];
            
            //存储所有学生  暂未按班级分开  待以后优化
            [sectionArray addObject: contactes.students[index.row]];
        }
    }
    
    return sectionArray;
}

- (void)sureButtonAction:(id)sender{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)registerCell{
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ChooseRecipientInfoCell class]) bundle:nil] forCellReuseIdentifier:ChooseRecipientInfoCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ChooseRecipientTeacherInfoCell class]) bundle:nil] forCellReuseIdentifier:ChooseRecipientTeacherInfoCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ChooseRecipientClassHeader class]) bundle:nil] forHeaderFooterViewReuseIdentifier:ChooseRecipientClassHeaderIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ChooseRecipientTeacherHeader class]) bundle:nil] forHeaderFooterViewReuseIdentifier:ChooseRecipientTeacherHeaderIdentifier];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    NSInteger scetion = 0;
    
    if ([self.models.teacherContacts count] >0) {
        scetion = 1+[self.models.studentContacts count];
    }else{
    
        scetion = [self.models.studentContacts count];
    }
    return scetion;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger  row =  0;
    if (section == 0 && [self.models.teacherContacts count] >0) {
        
        if ([self.foldingStatusArray[section] intValue] == 0) {
            
          row = 0;
            
        }else if([self.foldingStatusArray[section] intValue] == 1){
           row = [self.models.teacherContacts count];
            
        }

       
    }else {
        NSInteger tempSection ;
        if ([self.models.teacherContacts count] > 0) {
            tempSection = section - 1;
        }else{
           tempSection = section  ;
        }
        
        ReceuvedStudentContacts * studentContacts = self.models.studentContacts[tempSection];
        
        if ([self.foldingStatusArray[section] intValue] == 0) {
            
            row = 0;
            
        }else if([self.foldingStatusArray[section] intValue] == 1){
             row = [studentContacts.students count] ;
            
        }
       
    }
    return row;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return FITSCALE(56);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell * cell = nil;
    
    NSString * indexSection = [NSString stringWithFormat:@"%zd",indexPath.section];
    NSArray * selelctedIndexPaths = self.selectedIndexDic[indexSection];
    if (indexPath.section == 0 &&[self.models.teacherContacts count] >0) {
        ChooseRecipientTeacherInfoCell * tempCell = [tableView dequeueReusableCellWithIdentifier:ChooseRecipientTeacherInfoCellIdentifier];
        tempCell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([selelctedIndexPaths containsObject:indexPath]) {
            [tempCell setupSelectedImgState:YES];
        }else{
        
            [tempCell setupSelectedImgState:NO];
        }
     
        ReceuvedTeacherContacts * teacherContacts = self.models.teacherContacts[indexPath.row];
        
      
        [tempCell setupCellInfo:teacherContacts];
        cell = tempCell;
    }else {
        ChooseRecipientInfoCell  *infoCell = [ tableView dequeueReusableCellWithIdentifier:ChooseRecipientInfoCellIdentifier];
        infoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if ([selelctedIndexPaths containsObject:indexPath]) {
            [infoCell setupSelectedImgState:YES];
        }else{
            
            [infoCell setupSelectedImgState:NO];
        }
        
        NSInteger tempSection ;
        if ([self.models.teacherContacts count] > 0) {
            tempSection = indexPath.section - 1;
        }else{
            tempSection = indexPath.section  ;
        }
 
        ReceuvedStudentContacts * studentContacts = self.models.studentContacts[tempSection];
        
        [infoCell setupCellInfo:studentContacts.students[indexPath.row]];
        cell = infoCell;
    }
  
    return cell;
}


- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    NSLog(@"imageForEmptyDataSet:empty_placeholder");
    return [UIImage imageNamed:@"Recipient_no_info"];
}
- (NSString *)getDescriptionText{
    
    return @"您的收件人列表为空~";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return  FITSCALE(56);
}
- ( UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView * headerView = nil;
    if (section == 0 &&[self.models.teacherContacts count]> 0) {
 
        ChooseRecipientTeacherHeader * teacherHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ChooseRecipientTeacherHeaderIdentifier];
        teacherHeaderView.indexPathSection = section;
        teacherHeaderView.teacherHeaderBlock = ^(NSInteger indexPathSection) {
            [self touchOpenOrCloseIndexPathSection:section];
        };
        teacherHeaderView.allChooseBlock = ^(NSInteger indexPathSection, BOOL yesOrNo) {
            if (yesOrNo) {
               [self addAllSelectedState:indexPathSection];
            }else{
                [self cancelAllSelectedState:indexPathSection];
            }
            
        };
        
        if ([self.foldingStatusArray[section] intValue] == 0) {
            [teacherHeaderView setupOpenImgState:NO];
        }else if([self.foldingStatusArray[section] intValue] == 1){
            [teacherHeaderView setupOpenImgState:YES];
        }
        
        NSString * indexSection =  @"0";
        NSArray * selectedTeaches = self.selectedIndexDic[indexSection];
        if ([selectedTeaches count] == [self.models.teacherContacts count]) {
            NSLog(@"全选");
            [teacherHeaderView setupSelectedImgState:YES];
        }else{
            NSLog(@"取消全选");
             [teacherHeaderView setupSelectedImgState:NO];
        }
        
        headerView = teacherHeaderView;
    }else {
 
        ChooseRecipientClassHeader * classHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ChooseRecipientClassHeaderIdentifier];
        classHeaderView.indexPathSection = section;
        classHeaderView.classHeaderBlock = ^(NSInteger indexPathSection) {
            [self touchOpenOrCloseIndexPathSection:section];
        };
        
        classHeaderView.allChooseBlock = ^(NSInteger indexPathSection, BOOL yesOrNo) {
            if (yesOrNo) {
                [self addAllSelectedState:indexPathSection];
            }else{
                [self cancelAllSelectedState:indexPathSection];
            }
            
        };
        if ([self.foldingStatusArray[section] intValue] == 0) {
            [classHeaderView setupOpenImgState:NO];
        }else if([self.foldingStatusArray[section] intValue] == 1){
            
            [classHeaderView setupOpenImgState:YES];
        }
        NSInteger tempSection =  0;
     
        if ([self.models.teacherContacts count] > 0) {
            tempSection = section -1;
            
        }else{
        
            tempSection = section;
        }
        
        NSString * indexSection = [NSString stringWithFormat:@"%zd",section];
        NSArray * selectedTeaches = self.selectedIndexDic[indexSection];
        ReceuvedStudentContacts * studentModel = self.models.studentContacts[tempSection];
        if ([selectedTeaches count] == [studentModel.students count]) {
            NSLog(@"全选");
            [classHeaderView setupSelectedImgState:YES];
        }else{
            NSLog(@"取消全选");
            [classHeaderView setupSelectedImgState:NO];
        }
        
        ReceuvedStudentContacts * studentContacts = self.models.studentContacts[tempSection];
        [classHeaderView setupHeaderViewinfo:studentContacts];
        headerView = classHeaderView;
    }
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     
    NSString * indexSection = [NSString stringWithFormat:@"%zd",indexPath.section];
    
    if (self.selectedIndexDic[indexSection]) {
        NSMutableArray * indexPaths = self.selectedIndexDic[indexSection];
        if ([indexPaths containsObject:indexPath]) {
            [indexPaths removeObject:indexPath];
        }else {
            [indexPaths addObject:indexPath];
        }
        [self.selectedIndexDic setObject:indexPaths forKey:indexSection];
    }else{
    
        NSMutableArray * indexPaths = [NSMutableArray array];
        [indexPaths addObject:indexPath];
        [self.selectedIndexDic setObject:indexPaths forKey:indexSection];
    }
    
    [self updateSectionAllSelectedState:indexPath.section];

  
}

- (void)updateSectionAllSelectedState:(NSInteger)section{
   
    [self.tableView  reloadData];
 
}


- (void)cancelAllSelectedState:(NSInteger)section{

    NSString * sectionKey = [NSString stringWithFormat:@"%zd",section];
    if (self.selectedIndexDic[sectionKey]) {
        [self.selectedIndexDic[sectionKey] removeAllObjects];
    }
    [self updateSectionAllSelectedState:section];
}


- (void)addAllSelectedState:(NSInteger)section{
    
    NSString * indexSection = [NSString stringWithFormat:@"%zd",section];
    if ([self.models.teacherContacts count] >0 && section == 0) {
         NSMutableArray * indexPaths = [[NSMutableArray alloc]init];
        for (int i =0 ;i< [self.models.teacherContacts count];i++ ) {
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:section];
           
            [indexPaths addObject:indexPath];
           
        }
         [self.selectedIndexDic setObject:indexPaths forKey:indexSection];
    }else{
    
        NSMutableArray * indexPaths = [[NSMutableArray alloc]init];
        NSInteger tempSection = 0;
        if ([self.models.teacherContacts count] > 0) {
            tempSection =  section -1;
        }else{
            tempSection = section;
        }
        ReceuvedStudentContacts * studentContacts = self.models.studentContacts[tempSection];
        
        for (int i =0 ;i< [studentContacts.students count];i++ ) {
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:section];
            
            [indexPaths addObject:indexPath];
            
        }
        [self.selectedIndexDic setObject:indexPaths forKey:indexSection];
    }
    
     [self updateSectionAllSelectedState:section];
}
- (void)section:(NSInteger )section isAllSelected:(BOOL)yesOrNo{

    if (yesOrNo) {
        
    }else{
    
    }
}

- (void)touchOpenOrCloseIndexPathSection:(NSInteger )section{

    BOOL yesOrNo;
    if ([self.foldingStatusArray[ section] intValue] == 0) {
        yesOrNo = YES;
    }else {
        yesOrNo = NO;
    }
    [self.foldingStatusArray replaceObjectAtIndex:section withObject:[NSNumber numberWithInteger:yesOrNo]];
    [self.tableView reloadData];

}
#pragma mark ---
- (void)requestRecipient{
 
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_ListNofityContacts] parameterDic:nil requestMethodType:RequestMethodType_POST requestTag:NetRequestType_ListNofityContacts];
}


- (void)setNetworkRequestStatusBlocks{
    
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        strongSelf.models = [[ReceuvedMessageModel alloc]initWithDictionary:successInfoObj error:nil];
        if ([strongSelf.models.studentContacts count]> 0 ||[strongSelf.models.teacherContacts count]> 0) {
              strongSelf.navigationItem.rightBarButtonItem.customView.hidden = NO;
        }
      
        [strongSelf updateTableView];
    }];
}


//折叠状态
-(NSMutableArray *)foldingStatusArray
{
    if (!_foldingStatusArray) {
        _foldingStatusArray = [NSMutableArray array];
    }
    
    NSInteger numberOfSections =    0 ;
    if ([self.models.teacherContacts count] >0) {
        numberOfSections =   (1 + self.models.studentContacts.count);
    }else{
        numberOfSections  = self.models.studentContacts.count;
        
    }
    if (_foldingStatusArray.count) {
        if (_foldingStatusArray.count > numberOfSections) {
            [_foldingStatusArray removeObjectsInRange:NSMakeRange(numberOfSections- 1, _foldingStatusArray.count - numberOfSections)];
            
        }else if (_foldingStatusArray.count < numberOfSections) {
            for (NSInteger i = numberOfSections - _foldingStatusArray.count; i < numberOfSections; i++) {
                [_foldingStatusArray addObject:[NSNumber numberWithInteger:YES]];
            }
        }
    }else{
        for (NSInteger i = 0; i < numberOfSections; i++) {
            [_foldingStatusArray addObject:[NSNumber numberWithInteger:YES]];
        }
    }
    return _foldingStatusArray;
}



- (NSMutableDictionary *)selectedIndexDic{
    if (!_selectedIndexDic) {
        _selectedIndexDic = [NSMutableDictionary dictionary];
    }
    return _selectedIndexDic;
}
 
@end
