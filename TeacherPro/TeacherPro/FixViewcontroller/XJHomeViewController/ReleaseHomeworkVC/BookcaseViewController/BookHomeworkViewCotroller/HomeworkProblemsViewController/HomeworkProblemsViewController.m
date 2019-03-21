//
//  HomeworkProblemsViewController.m
//  TeacherPro
//
//  Created by DCQ on 2018/1/19.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "HomeworkProblemsViewController.h"
#import "HomeworkProblemsUnitSectionCell.h"
#import "HomeworkProblemsChapterSectionCell.h"
#import "BookPreviewModel.h"
#import "HomeworkProblemsDetailViewController.h"
#import "HomeworkProblemsBottomView.h"

#define bottomViewH  60
NSString *const HomeworkProblemsUnitSectionCellIdentifier = @"HomeworkProblemsUnitSectionCellIdentifier";
NSString *const HomeworkProblemsChapterSectionCellIdentifier = @"HomeworkProblemsChapterSectionCellIdentifier";
@interface HomeworkProblemsViewController ()
@property(nonatomic, strong) NSMutableArray * selectedIndexPathArray;
@property(nonatomic, strong) HomeworkProblemsBottomView * bottomView;
@end

@implementation HomeworkProblemsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isNetReqeustEmptyData = YES;
    self.title = @"课后练习";
    [self configTableView];
    [self.view addSubview:self.bottomView];
    [self confighBottomView];
    [self verifyAndConfigCache];
    [self updateTableView];
    
}
- (NSString *)getDescriptionText{
    
    return @"暂无数据~";
}
- (void)verifyAndConfigCache{
    //找出选择的单元id
    NSMutableArray * unitIdArray = [NSMutableArray array];
    if (self.oldCacheData && [self.oldCacheData count] > 0) {
        NSArray * tempData = self.oldCacheData[0];
        for (NSDictionary * dic in tempData) {
           NSString * unitId  = dic[@"unitId"];

            [unitIdArray addObject:unitId];
        }
    }
    
    //遍历找出与选择的单元id 相同的数据 并计算数据所在列表的位置
    for (int i = 0; i < [self.model.bookUnits count]; i++) {
        BookUnitModel *model = self.model.bookUnits[i];
        NSInteger section = i + 1;
        NSInteger row =  0;
        //父单元
        if ([unitIdArray containsObject:model.unitId]) {
            [self setupCacheIndexPathRow:row section:section ];
        }else{
            //子单元
            if (model.children && [model.children count] > 0) {
                for (int j = 0; j< [model.children count]; j++) {
                    ChildrenUnitModel* childrenModel = model.children[j];
                    row = j + 1;
                    if ([unitIdArray containsObject:childrenModel.unitId]) {
                        [self setupCacheIndexPathRow:row section:section ];
                    }
                }
            }
         
        }
        
    }
  
}

- (void)setupCacheIndexPathRow:(NSInteger) row section:(NSInteger )section{
    
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    [self selectedOrCancelIndexPath:indexPath];
}
- (void)confighBottomView{
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left) ;
        make.top.mas_equalTo (self.tableView.mas_bottom);
        make.height.mas_equalTo(bottomViewH);
        make.right.mas_equalTo(self.view.mas_right);
    }];
    WEAKSELF
    self.bottomView.btnActionBlock = ^{
        [weakSelf gotoPreviewVC];
    };
    if (self.model.bookUnits&&[self.model.bookUnits count] > 0) {
        self.bottomView.hidden = NO;
    }else{
        self.bottomView.hidden = YES;
    }
}
- (CGRect)getTableViewFrame{
    CGRect tableViewFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - bottomViewH);
    return tableViewFrame;
}
- (void)configTableView{
    
    self.tableView.backgroundColor = [UIColor clearColor];
    // 隐藏UITableViewStyleGrouped上边多余的间隔
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    
    self.view.backgroundColor = project_background_gray;
}
- (NSMutableArray *)selectedIndexPathArray{
    if (!_selectedIndexPathArray) {
        _selectedIndexPathArray = [NSMutableArray array];
    }
    return _selectedIndexPathArray;
}
- (HomeworkProblemsBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([HomeworkProblemsBottomView class]) owner:nil options:nil].firstObject;
    }
   
    return _bottomView;
}
- (void)registerCell{
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeworkProblemsChapterSectionCell class]) bundle:nil] forCellReuseIdentifier:HomeworkProblemsChapterSectionCellIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeworkProblemsUnitSectionCell class]) bundle:nil] forCellReuseIdentifier:HomeworkProblemsUnitSectionCellIdentifier];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  
    NSInteger section = 0;
    if (self.model.bookUnits && [self.model.bookUnits count] > 0) {
        section = 1 + [self.model.bookUnits count];
    }
    return section ;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger row = 0;
    if (section == 0) {
          row = 1;
    }else{
        NSInteger index = section -1;
        BookUnitModel *unitModel  = self.model.bookUnits[index];
        row = [unitModel.children count] +1;
        
    }
    return row;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height =  0;
    if (indexPath.section == 0) {
        height = 44;
    }else{
        height = 44;
        
    }
    
    return height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    CGFloat height = 0.00001;
    if (section == 0) {
          height = FITSCALE(8);
    }else{
        NSInteger index = section -1;
        BookUnitModel *unitModel  = self.model.bookUnits[index];
        if (unitModel.children) {
            height = FITSCALE(8);
        }
    } 
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = 0.00001;
    if (section == 0 ) {
        height = 10;
    }
    return height;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView * footerView = [UIView new];
    
    return footerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headerView = [UIView new];
    return headerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell =  nil;
    if (indexPath.section == 0) {
        HomeworkProblemsUnitSectionCell * tempCell = [tableView dequeueReusableCellWithIdentifier:HomeworkProblemsUnitSectionCellIdentifier];
        BOOL selected = NO;
        [tempCell setupTitle:@"选择单元" withIsSelected:selected];
       [tempCell setupDefaultUnitTitle];
        cell = tempCell;
    }else{
        if (indexPath.row == 0) {
            HomeworkProblemsUnitSectionCell * tempCell = [tableView dequeueReusableCellWithIdentifier:HomeworkProblemsUnitSectionCellIdentifier];
            BookUnitModel * unitModel = self.model.bookUnits[indexPath.section-1];
             BOOL selected = NO;
            if ([unitModel.hasExercise boolValue] && [self.selectedIndexPathArray containsObject:indexPath]) {
                selected = YES;
            }
            [tempCell setupTitle:unitModel.unitName withIsSelected:selected];
            BOOL isShow = NO;
            if (unitModel.children) {
                [tempCell setupDefaultUnitTitle ];
            }else{
                if ([unitModel.hasExercise boolValue]) {
                    isShow = YES;
                }
                [tempCell setupShowChooseImgVSate:isShow];
            }

           
            cell = tempCell;
        }else{
            
            HomeworkProblemsChapterSectionCell * tempCell = [tableView dequeueReusableCellWithIdentifier:HomeworkProblemsChapterSectionCellIdentifier];
            BookUnitModel * unitModel = self.model.bookUnits[indexPath.section-1];
            ChildrenUnitModel* childrenModel = unitModel.children[indexPath.row -1];
            BOOL selected = NO;
            if ([self.selectedIndexPathArray containsObject:indexPath]) {
                selected = YES;
            }
            [tempCell setupTitle:childrenModel.unitName withIsSelected:selected];
            BOOL isShow = NO;
            if ([childrenModel.hasExercise boolValue]  ) {
                isShow = YES;
            }
            [tempCell setupShowChooseImgVSate:isShow];
            cell = tempCell;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section>0) {
//        if (indexPath.row == 0) {
//            //选择的单元
//        }else{
//            //选择单元下的章节
//
//        }
        BOOL hasExercise = NO;
        BookUnitModel * unitModel = self.model.bookUnits[indexPath.section-1];
        if (indexPath.row == 0) {
            if ([unitModel.hasExercise boolValue] ) {
                hasExercise = YES;
            }
        }else{
            ChildrenUnitModel* childrenModel = unitModel.children[indexPath.row -1];
            if ([childrenModel.hasExercise boolValue] ) {
                 hasExercise = YES;
            }
        }
        if (hasExercise) {
            [self selectedOrCancelIndexPath:indexPath];
            [self updateTableViewIndex:indexPath];
        }
       
    }
    
}
- (void)selectedOrCancelIndexPath:(NSIndexPath *)indexPath{
    if ([self.selectedIndexPathArray containsObject:indexPath]) {
        [self.selectedIndexPathArray removeObject:indexPath];
    }else{
        [self.selectedIndexPathArray addObject:indexPath];
        
    }
 
}
- (void)updateTableViewIndex:(NSIndexPath *)indexPath{
    
   [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}
- (void)gotoPreviewVC{
    if ([self.selectedIndexPathArray count] == 0) {
        [self showAlert:TNOperationState_Unknow content:@"请选择单元"];
        return ;
    }
    NSMutableArray * unitIds = [NSMutableArray array];
    NSMutableArray * unitNames = [NSMutableArray array];
    for (NSIndexPath * index in self.selectedIndexPathArray) {
          BookUnitModel * unitModel = self.model.bookUnits[index.section-1];
        if (index.row == 0) {
            [unitIds addObject:unitModel.unitId];
            [unitNames addObject:unitModel.unitName];
        }else{
            ChildrenUnitModel * childrenUnitModel = unitModel.children[index.row -1 ];
            [unitIds addObject:childrenUnitModel.unitId];
            [unitNames addObject:childrenUnitModel.unitName];
        }
        
    }
    
    HomeworkProblemsDetailViewController *detailVC = [[HomeworkProblemsDetailViewController alloc]initWithUnitIds:unitIds  withUnitNames:unitNames withCacheData:self.oldCacheData ];
    [self pushViewController:detailVC];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
