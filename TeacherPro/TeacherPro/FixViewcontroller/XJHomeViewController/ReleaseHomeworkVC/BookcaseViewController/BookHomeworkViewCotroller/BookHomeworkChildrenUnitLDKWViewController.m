//
//  BookHomeworkChildrenUnitLDKWViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/9/15.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BookHomeworkChildrenUnitLDKWViewController.h"
#import "BookHomeworkAdjustmentRepeatedNumberCell.h"
#import "BookHomeworkUnitRemindingHeaderView.h"
#import "BookHomeworkChildrenUnitSectionHeaderView.h"
#import "BookHomeworkChildrenUnitChooseCell.h"
#import "BookPreviewModel.h"
#import "BookHomeworkHeardAndWordTypeViewController.h"
#import "YYCache.h"
NSString * const BookHomeworkAdjustmentRepeatedNumberCellLDKWIdentifier =@"BookHomeworkAdjustmentRepeatedNumberCellLDKWIdentifier";
NSString * const BookHomeworkUnitRemindingHeaderViewLDKWIdentifier =@"BookHomeworkUnitRemindingHeaderViewLDKWIdentifier";

NSString * const BookHomeworkChildrenUnitSectionHeaderViewLDKWIdentifier =@"BookHomeworkChildrenUnitChooseCellLDKWIdentifier";
NSString * const BookHomeworkChildrenUnitChooseCellLDKWIdentifier =@"BookHomeworkChildrenUnitChooseCellLDKWIdentifier";

@interface BookHomeworkChildrenUnitLDKWViewController ()

@end

@implementation BookHomeworkChildrenUnitLDKWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self defaultSelectedData];
}
- (CGRect)getTableViewFrame{
    
    CGFloat bottomHeight = 0;
    
    bottomHeight = 65;
    
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - bottomHeight);
    return frame;
}
- (void)defaultSelectedData{
    if( self.oldCacheData && self.oldCacheData.count >0){
        NSString * unitId = self.oldCacheData.firstObject[@"unitId"];
        for (int section = 0; section< [self.model.bookUnits count]; section++) {
            BookUnitModel *model  = self.model.bookUnits[section];
            for (int row = 0; row < [model.children count]; row++) {
                ChildrenUnitModel *childrenModel = model.children[row];
                if ([childrenModel.unitId isEqualToString:unitId]) {
                    self.selectedIndex = [NSIndexPath indexPathForRow:row inSection:section + 2];
                }
            }
            
        }
        
    }
    
}

- (void)registerCell{
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BookHomeworkUnitRemindingHeaderView class]) bundle:nil] forHeaderFooterViewReuseIdentifier: BookHomeworkUnitRemindingHeaderViewLDKWIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BookHomeworkChildrenUnitSectionHeaderView  class]) bundle:nil] forHeaderFooterViewReuseIdentifier: BookHomeworkChildrenUnitSectionHeaderViewLDKWIdentifier];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BookHomeworkAdjustmentRepeatedNumberCell class]) bundle:nil] forCellReuseIdentifier:BookHomeworkAdjustmentRepeatedNumberCellLDKWIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BookHomeworkChildrenUnitChooseCell  class]) bundle:nil] forCellReuseIdentifier:BookHomeworkChildrenUnitChooseCellLDKWIdentifier];
    
    
    
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2 + [self.model.bookUnits count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger row = 0;
    if (section == 0) {
        row = 0;
    }else if(section == 1){
        
        row = 1;
    } else{
        NSInteger index = section -2;
        BookUnitModel *model  = self.model.bookUnits[index];
        row = [model.children count];
    }
    return row;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height =  0;
    
    height = FITSCALE(44);
    
    return height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    CGFloat height = 0.00001;
    if ( section == 1) {
        height = 10;
    }
    return height;
    
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footerView = [UIView new ];
    
    return footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = 0.00001;
    if ( section == 1) {
        height = 0.001;
    }else{
        
        height = FITSCALE(44);
    }
    return height;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headerView = nil;
    if (section == 0) {
        BookHomeworkUnitRemindingHeaderView * tempHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:BookHomeworkUnitRemindingHeaderViewLDKWIdentifier];
        NSString * remindingType = @"课文跟读";
        NSString *remindingName = [NSString stringWithFormat:@"学生可使用\"小佳学习\"的\"%@\"功能完成此项作业",remindingType];
        [tempHeaderView setupReminding:remindingName];
        headerView = tempHeaderView;
    }else if(section == 1){
        headerView = nil;
    } else{
        
        BookHomeworkChildrenUnitSectionHeaderView * tempHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:BookHomeworkChildrenUnitSectionHeaderViewLDKWIdentifier];
        NSInteger index = section -2;
        BookUnitModel *model  = self.model.bookUnits[index];
        [tempHeaderView setupUnitName:model.unitName];
        headerView = tempHeaderView;
    }
    return headerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell =  nil;
    if (indexPath.section == 1) {
        BookHomeworkAdjustmentRepeatedNumberCell * tempCell = [tableView dequeueReusableCellWithIdentifier:BookHomeworkAdjustmentRepeatedNumberCellLDKWIdentifier];
        WEAKSELF
        tempCell.adjustmentBlock = ^(NSInteger number) {
            STRONGSELF
            strongSelf.passCount = number;
            
        };
        cell = tempCell;
    }else {
        BookHomeworkChildrenUnitChooseCell * tempCell = [tableView dequeueReusableCellWithIdentifier:BookHomeworkChildrenUnitChooseCellLDKWIdentifier];
        NSInteger index = indexPath.section-2;
        BookUnitModel *unitModel = self.model.bookUnits[index];
        ChildrenUnitModel * childrenModel = unitModel.children[indexPath.row];
        
        NSString *  unitName= childrenModel.unitName;
        
        BOOL isSelected = NO;
        if (self.selectedIndex.section == indexPath.section && self.selectedIndex.row == indexPath.row) {
            isSelected = YES;
        }
        tempCell.backgroundColor = [UIColor clearColor];
        tempCell.backgroundView.backgroundColor = [UIColor clearColor];
        [tempCell setupChildrenUnitName:unitName withState:isSelected];
        if((!childrenModel.hasFollow||![childrenModel.hasFollow boolValue])){
            //没有内容不能选题
            [tempCell setSelectedImgVHidden:YES];
        }else{
              [tempCell setSelectedImgVHidden:NO];
        }
        cell = tempCell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section >1) {
        self.selectedIndex = indexPath;
        NSInteger index = indexPath.section-2;
        BookUnitModel *unitModel = self.model.bookUnits[index];
        ChildrenUnitModel * childrenModel = unitModel.children[indexPath.row];
      
        if((!childrenModel.hasFollow||![childrenModel.hasFollow boolValue])){
            //没有内容不能选题
            [self showAlert:TNOperationState_Fail content:@"该单元下没有题~"];
        }else{
            [self updateTableView];
            
        }
    }
    
}

//重写父类方法
- (void)setupNewCacheData{
    
    
    NSInteger index = self.selectedIndex.section - 2;
    BookUnitModel *unitModel = self.model.bookUnits[index];
    ChildrenUnitModel * childrenModel = unitModel.children[self.selectedIndex.row];
    
    NSString *unitId = childrenModel.unitId;
    NSDictionary * submitDic;
    NSString * key = @"";
    if (self.unitType == BookHomeworkTypeUnitType_TKWLY ) {
        submitDic = @{@"unitId":unitId ,@"count":@(self.passCount)};
        key = TKWLY_PRACTICE_MEMORY_KEY;
    }else if (self.unitType == BookHomeworkTypeUnitType_DCTX){
        
        submitDic = @{@"unitId":unitId,@"wordCount":unitModel.wordCount};
        key = DCTX_PRACTICE_MEMORY_KEY;
    }else if ( self.unitType == BookHomeworkTypeUnitType_LDKW){
        submitDic = @{@"unitId":unitId ,@"count":@(self.passCount)};
        key = LDKW_PRACTICE_MEMORY_KEY;
    }
    
    NSArray * submitArray = @[submitDic];
    
    YYCache *cache = [YYCache cacheWithName:HOMEWORK_CONTENT_PATH];
    cache.memoryCache.shouldRemoveAllObjectsOnMemoryWarning = YES;
    cache.memoryCache.shouldRemoveAllObjectsWhenEnteringBackground = YES;
    [cache setObject: submitArray  forKey:key];
    
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
