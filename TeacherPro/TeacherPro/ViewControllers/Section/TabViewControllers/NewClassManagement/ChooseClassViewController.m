//
//  CreateClassViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/5/10.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "ChooseClassViewController.h"
//#import "CreateClassView.h"
#import "LeftGradeView.h"
#import "RightClassView.h"
#import "ClassManageModel.h"
#import "ReleaseAddBookworkCell.h"
#import "ClassChooseTableViewCell.h"
#import "ClassChooseHeaderVIew.h"
#import "ClassChooseCollectionViewCell.h"

#define bottomViewHeight     65
#define titleLabelTag       10000
@interface ChooseClassViewController ()<UITableViewDelegate,UITableViewDataSource,ReleaseAddBookworkCellDelegate,ClassChooseHeaderVIewDelegate,ClassChooseTableViewCellDelegate>
@property(nonatomic, strong) ReleaseAddBookworkCell * bottomView;
@property(nonatomic, strong) NSArray *dataArray;
//@property(nonatomic, strong) CreateClassView * classListView;

@property(nonatomic, copy)  NSString * gradeId;
@property(nonatomic, copy)  NSString * gradeName;
//@property(nonatomic, strong) NSDictionary  *gradeDic;
//@property(nonatomic, strong) NSArray  *gradeList;
@property(nonatomic, assign) ViewControllerFromeType  vcType;
@property(nonatomic, strong) NSDictionary *classInfo;
@end

@implementation ChooseClassViewController
- (instancetype)initWithViewControllerFromeType:(ViewControllerFromeType )type{

    if (self ==[super init]) {
        self.vcType = type;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.scrollsToTop = YES;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.allowsSelection = NO;
    self.tableView.allowsSelectionDuringEditing = NO;
    self.tableView.estimatedRowHeight = 45.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.backgroundColor = HexRGB(0xf7f7f7);
    self.tableView.backgroundView = nil;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
    NSString * title = @"选择班级";
    
    [self setNavigationItemTitle:title];
    
    self.tableView.backgroundColor = HexRGB(0xF6F6F8);
    [self.view addSubview: self.tableView];
    [self.tableView registerClass:[ClassChooseTableViewCell class] forCellReuseIdentifier:@"ClassChooseTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ClassChooseHeaderVIew class]) bundle:nil] forHeaderFooterViewReuseIdentifier:@"ClassChooseHeaderVIew"];

    
   
    
    [self.view addSubview:self.bottomView];
    [self requestBindingClass];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self navUIBarBackground:0];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self navUIBarBackground:8];
}

- (UIView *)bottomView{
    if (!_bottomView) {
       
        _bottomView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ReleaseAddBookworkCell class]) owner:nil options:nil].firstObject;
         _bottomView.frame = CGRectMake(0, self.view.frame.size.height -bottomViewHeight,self.view.frame.size.width, bottomViewHeight);
        _bottomView.backgroundColor = [UIColor whiteColor];
        [_bottomView.addButton setTitle:@"确认" forState:UIControlStateNormal];
        _bottomView.delegate = self;
        _bottomView.buttonCenterY.constant = 1;
        if (kScreenWidth == 375&&kScreenHeight>667){
            _bottomView.frame = CGRectMake(0, self.view.frame.size.height -bottomViewHeight-18,self.view.frame.size.width, bottomViewHeight);
             _bottomView.backgroundColor = [UIColor clearColor];
        }
    }
    return _bottomView;
}

#pragma mark ---
- (void)requestBindingClass{
    NSString *classRequest = [NetRequestAPIManager getRequestURLStr:NetRequestType_QueryTeacherBindClazzs];
    [self sendHeaderRequest:classRequest parameterDic:nil requestMethodType:RequestMethodType_POST requestTag:NetRequestType_QueryTeacherBindClazzs];
}
-  (void)setNetworkRequestStatusBlocks{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_QueryTeacherBindClazzs) {
            
            NSMutableArray *tempArray = [NSMutableArray new];
            for (NSDictionary *tempDic in successInfoObj[@"clazzList"]) {
                ClassListGruopModel *tempModel = [[ClassListGruopModel alloc]initWithDictionary:tempDic error:nil];
                
                if (weakSelf.classIds.length>0) {
                    for (ClassManageModel *classMode in tempModel.clazzes) {
                        if([weakSelf.classIds containsString:classMode.clazzId]) {
                            
                            classMode.isSelected = YES;
                        }
                    }
                }
                [tempArray addObject:tempModel];
            }
            weakSelf.dataArray = tempArray;
            [weakSelf.tableView reloadData];
        }
        
    }];
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count;//年级数
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    ClassListGruopModel *tempModel = self.dataArray[section];
    if (tempModel.clazzes.count) {
        return 1;
    }
    return 0;//当前年级 班级数
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ClassChooseTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ClassChooseTableViewCell"];
    ClassListGruopModel *tempModel = self.dataArray[indexPath.section];
    cell.classArray = tempModel.clazzes.mutableCopy;//class
    cell.delegate = self;
    cell.tag = 1000+indexPath.section;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    ClassChooseHeaderVIew * headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ClassChooseHeaderVIew"];
    ClassListGruopModel *tempModel = self.dataArray[section];
 
    if (self.vcType == ViewControllerFromeType_checkChoose) {
        headerView.allClassButton.hidden = YES;
    }
    headerView.gradeLabel.text = tempModel.gradeName;
    headerView.delegate = self;
    headerView.tag = 1000+section;
    return headerView;
}

#pragma mark Action
- (void)didChooseHeader:(ClassChooseHeaderVIew *)header{
    
    for (NSInteger i = 0;i<self.dataArray.count; i++) {
        
        ClassChooseHeaderVIew * tempHeaderView = [self.tableView headerViewForSection:i];
        
        ClassListGruopModel *tempModel = self.dataArray[i];
        if (i == header.tag-1000 && !tempHeaderView.allClassButton.selected) {
            
            for (ClassManageModel *classMode in tempModel.clazzes) {
                classMode.isSelected = YES;
            }
            tempHeaderView.allClassButton.selected = YES;
        }else{
            for (ClassManageModel *classMode in tempModel.clazzes) {
                classMode.isSelected = NO;
            }
            tempHeaderView.allClassButton.selected = NO;
        }
        
        ClassChooseTableViewCell * tempCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]];
        tempCell.classArray = tempModel.clazzes.mutableCopy;
    }
}

- (void)didChooseButtonCell:(ClassChooseTableViewCell *)cell ChooseItem:(ClassChooseCollectionViewCell *)item{
    
    for (NSInteger i = 0;i<self.dataArray.count; i++) {
        ClassChooseHeaderVIew * tempHeaderView = [self.tableView headerViewForSection:i];
        ClassListGruopModel *tempModel = self.dataArray[i];
        if (i == cell.tag-1000 && !tempHeaderView.allClassButton.selected) {
        }else{
            for (ClassManageModel *classMode in tempModel.clazzes) {
                classMode.isSelected = NO;
            }
            tempHeaderView.allClassButton.selected = NO;
        }
        ClassChooseTableViewCell * tempCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]];
        tempCell.classArray = tempModel.clazzes.mutableCopy;
    }
    
    
    for (NSInteger i = 0;i<self.dataArray.count; i++) {
        ClassListGruopModel *tempModel = self.dataArray[i];
        ClassChooseHeaderVIew *tempHeaderView = [self.tableView headerViewForSection:i];
        tempHeaderView.allClassButton.selected = NO;
        for (ClassManageModel *classMode in tempModel.clazzes) {
            if (self.vcType == ViewControllerFromeType_checkChoose) {
                classMode.isSelected = NO;
            }
        }
    }
    
    for (ClassChooseCollectionViewCell *replyView in cell.classViews) {
        if (replyView == item) {
            if (replyView.model.isSelected == NO&& self.vcType != ViewControllerFromeType_checkChoose) {
                replyView.model.isSelected = NO;
            }else{
                replyView.model.isSelected = YES;
            }
        }
        else{
            if (self.vcType == ViewControllerFromeType_checkChoose) {
                replyView.model.isSelected = NO;
            }
        }
    }
    
    [self.tableView reloadData];
}

- (void)didAddBookwork:(ReleaseAddBookworkCell *)header{///////// 确认选择的班级
    NSString *strGrade;
    for (NSInteger i = 0;i<self.dataArray.count; i++) {
        ClassChooseHeaderVIew * tempHeaderView = [self.tableView headerViewForSection:i];
        if (tempHeaderView.allClassButton.selected) {
            strGrade = tempHeaderView.gradeLabel.text;
        }
    }
  
    //isected
    if ([self.chooseDelegate respondsToSelector:@selector(ChooseClassViewController:data:gradeStr:)]) {
            [self.chooseDelegate ChooseClassViewController:self data:self.dataArray gradeStr:strGrade];
        
    }
    
    
//    if (strGrade == nil) {
//        for (NSInteger i = 0;i<self.dataArray.count; i++) {
//            ClassListGruopModel *tempModel = self.dataArray[i];
//            for (ClassManageModel *classMode in tempModel.clazzes) {
//                if (classMode.isSelected == YES) {
//                    strGrade = classMode.clazzName; ///////// 选出选择的班级
//                }
//            }
//        }
//    }
    NSString * classId = @"";
    NSString * className = strGrade;
    for (ClassListGruopModel * model in  self.dataArray) {
        for (ClassManageModel *classMode in model.clazzes) {
            if (classMode.isSelected == YES) {
                if ([classId length] <=0) {
                    classId = classMode.clazzId;
//                    if (className.length == 0) {
                        className = classMode.clazzName;
//                    }
                    
                }else{
                    
                    classId = [classId stringByAppendingString:[NSString stringWithFormat:@",%@",classMode.clazzId]];
                    className = [className stringByAppendingString:[NSString stringWithFormat:@",%@",classMode.clazzName]];
                }
            }
        }
    }
    
    classId = [NSString stringWithFormat:@"%@",classId];
    if (className == nil) {
        className = @"";
        [SVProgressHelper dismissWithMsg:@"请至少选择一个班级!"];
        return;
    }
    [[NSNotificationCenter defaultCenter]  postNotificationName:@"ClassChoose" object:nil userInfo:@{@"classId":classId,@"className":className}];
    [self sureAction];
}

- (void)sureAction{

    [self backViewController];
  
//    if ([self.chooseDelegate respondsToSelector:@selector(chooseClassInfo:)]) {
//        if (self.classInfo) {
//             [self.chooseDelegate chooseClassInfo:self.classInfo];
//        }
//
//    }
}

- (void)checkAllClassAction{
    [self backViewController];
    if ([self.chooseDelegate respondsToSelector:@selector(checkChooseClassInfo:)]) {
        [self.chooseDelegate checkChooseClassInfo:nil];
    }
}

- (void)dealloc{
    [self setChooseDelegate:   nil];
    [self setBottomView:nil ];
    [self setClassInfo:nil ];
//    [self setClassListModel:nil];
    
//    [self setClassListView:nil];
    [self setGradeId:nil];
//    [self setGradeDic:nil];
    [self setGradeName: nil];
//    [self setGradeList:nil];
    [self clearDelegate];
}

- (BOOL )getLayoutIncludesOpaqueBars{
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
