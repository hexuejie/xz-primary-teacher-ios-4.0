//
//  BookHomeworkChildrenUnitDCTXViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/9/15.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BookHomeworkChildrenUnitDCTXViewController.h"

#import "BookHomeworkUnitRemindingHeaderView.h"
#import "BookHomeworkChildrenUnitSectionHeaderView.h"
#import "BookHomeworkChildrenUnitChooseCell.h"
#import "BookPreviewModel.h"
#import "BookHomeworkHeardAndWordTypeViewController.h"
#import "YYCache.h"

NSString * const BookHomeworkUnitRemindingHeaderViewDCTXIdentifier =@"BookHomeworkUnitRemindingHeaderViewDCTXIdentifier";

NSString * const BookHomeworkChildrenUnitSectionHeaderViewDCTXIdentifier =@"BookHomeworkChildrenUnitChooseCellDCTXIdentifier";
NSString * const BookHomeworkChildrenUnitChooseCellDCTXIdentifier =@"BookHomeworkChildrenUnitChooseCellDCTXIdentifier";

@interface BookHomeworkChildrenUnitDCTXViewController ()

@end

@implementation BookHomeworkChildrenUnitDCTXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self defaultSelectedData];
}
- (CGRect)getTableViewFrame{
    
    CGFloat bottomHeight = 0;
    
    bottomHeight = FITSCALE(50);
    
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
                    self.selectedIndex = [NSIndexPath indexPathForRow:row inSection:section + 1];
                }
            }
            
        }
        
    }
    
}

- (void)registerCell{
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BookHomeworkUnitRemindingHeaderView class]) bundle:nil] forHeaderFooterViewReuseIdentifier: BookHomeworkUnitRemindingHeaderViewDCTXIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BookHomeworkChildrenUnitSectionHeaderView  class]) bundle:nil] forHeaderFooterViewReuseIdentifier: BookHomeworkChildrenUnitSectionHeaderViewDCTXIdentifier];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BookHomeworkChildrenUnitChooseCell  class]) bundle:nil] forCellReuseIdentifier:BookHomeworkChildrenUnitChooseCellDCTXIdentifier];
    
    
    
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1 + [self.model.bookUnits count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger row = 0;
    if (section == 0) {
        row = 0;
    }  else{
        NSInteger index = section -1;
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
    if ( section == 0) {
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
    if ( section == 0) {
        height = 44;
    }else{
        height = FITSCALE(44);
    }
    return height;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headerView = nil;
    if (section == 0) {
        BookHomeworkUnitRemindingHeaderView * tempHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:BookHomeworkUnitRemindingHeaderViewDCTXIdentifier];
        NSString * remindingType = @"单词听写";
        NSString *remindingName = [NSString stringWithFormat:@"学生可使用\"小佳学习\"的\"%@\"功能完成此项作业",remindingType];
        [tempHeaderView setupReminding:remindingName];
        headerView = tempHeaderView;
    }  else{
        
        BookHomeworkChildrenUnitSectionHeaderView * tempHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:BookHomeworkChildrenUnitSectionHeaderViewDCTXIdentifier];
        NSInteger index = section - 1;
        BookUnitModel *model  = self.model.bookUnits[index];
        [tempHeaderView setupUnitName:model.unitName];
        headerView = tempHeaderView;
    }
    return headerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell =  nil;
    
    BookHomeworkChildrenUnitChooseCell * tempCell = [tableView dequeueReusableCellWithIdentifier:BookHomeworkChildrenUnitChooseCellDCTXIdentifier];
    NSInteger index = indexPath.section-1;
    BookUnitModel *unitModel = self.model.bookUnits[index];
    ChildrenUnitModel * childrenModel = unitModel.children[indexPath.row];
    
    NSString *  unitName= childrenModel.unitName;
    
    BOOL isSelected = NO;
    if (self.selectedIndex.section == indexPath.section && self.selectedIndex.row == indexPath.row) {
        isSelected = YES;
    }
    if (self.unitType == BookHomeworkTypeUnitType_DCTX &&(!childrenModel.hasWord ||![childrenModel.hasWord boolValue])) {
        [tempCell setSelectedImgVHidden:YES];
        tempCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else{
        tempCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    tempCell.backgroundColor = [UIColor clearColor];
    tempCell.backgroundView.backgroundColor = [UIColor clearColor];
    [tempCell setupChildrenUnitName:unitName withState:isSelected];
    cell = tempCell;
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section >0) {
        self.selectedIndex = indexPath;
        NSInteger index = indexPath.section-1;
        BookUnitModel *unitModel = self.model.bookUnits[index];
        ChildrenUnitModel * childrenModel = unitModel.children[indexPath.row];
        if((!childrenModel.hasWord ||![childrenModel.hasWord boolValue])){
            [self showAlert:TNOperationState_Fail content:@"该单元下没有单词~" block:nil];
        }else{
            [self updateTableView];
        }
        
    }
    
}

//重写父类方法
- (void)setupNewCacheData{
    
    
    NSInteger index = self.selectedIndex.section - 1;
    BookUnitModel *unitModel = self.model.bookUnits[index];
    ChildrenUnitModel * childrenModel = unitModel.children[self.selectedIndex.row];
    
    NSString *unitId = childrenModel.unitId;
    NSDictionary * submitDic;
    NSString * key = @"";
    if (self.unitType == BookHomeworkTypeUnitType_TKWLY ) {
        submitDic = @{@"unitId":unitId ,@"count":@(self.passCount)};
        key = TKWLY_PRACTICE_MEMORY_KEY;
    }else if (self.unitType == BookHomeworkTypeUnitType_DCTX){
        
        
        if(unitModel.wordCount){
            submitDic = @{@"unitId":unitId,@"wordCount":unitModel.wordCount};
        }else {
            [self showAlert:TNOperationState_Fail content:@"该单元下没有单词" block:nil];
            return;
        }
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
    [self backViewController];
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

