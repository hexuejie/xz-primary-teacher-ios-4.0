
//
//  BookHomeworkChildrenUnitGameViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/9/15.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BookHomeworkChildrenUnitGameViewController.h"
#import "BookPreviewModel.h"
#import "BookHomeworkYXLXSectionCell.h"
#import "BookHomeworkChildrenUnitCell.h"
#import "BookHomeworkChildrenUnitSectionHeaderView.h"
#import "BookHomeworkHeardAndWordTypeViewController.h"
#import "YWReadDetailViewController.h"


NSString * const BookHomeworkYXLXSectionChildrenUnitGameCellIdentifier =@"BookHomeworkYXLXSectionChildrenUnitGameCellIdentifier";
NSString * const BookHomeworkChildrenUnitGameCellIdentifier =@"BookHomeworkChildrenUnitGameCellIdentifier";
NSString * const BookHomeworkChildrenUnitSectionHeaderGameViewIdentifier =@"BookHomeworkChildrenUnitSectionHeaderGameViewIdentifier";


@interface BookHomeworkChildrenUnitGameViewController ()

@end

@implementation BookHomeworkChildrenUnitGameViewController
 
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self defaultSelectedData];
}
- (CGRect)getTableViewFrame{
    
    CGFloat bottomHeight = 0;
   
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

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BookHomeworkChildrenUnitSectionHeaderView class]) bundle:nil] forHeaderFooterViewReuseIdentifier: BookHomeworkChildrenUnitSectionHeaderGameViewIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BookHomeworkYXLXSectionCell class]) bundle:nil] forCellReuseIdentifier:BookHomeworkYXLXSectionChildrenUnitGameCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BookHomeworkChildrenUnitCell class]) bundle:nil] forCellReuseIdentifier:BookHomeworkChildrenUnitGameCellIdentifier];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1 + [self.model.bookUnits count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger row = 0;
    if (section == 0) {
         row = 1;
    }else{
         NSInteger index =  section-1;
        BookUnitModel *model  = self.model.bookUnits[index];
        row = [model.children count];
     }
    return row;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height =  0;
    if (indexPath.section == 0) {
            height = FITSCALE(44);
    }else{
            height = FITSCALE(50);
    }
 
    
    return height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
     CGFloat height = 0.00001;
    if ( section == 0) {
        height = 10;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = 0.00001;
    if ( section == 0) {
        height = 0.001;
    }else{
        
        height = 40;
    }
    return height;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footerView = [UIView new ];
    
    return footerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headerView = nil;
    if (section != 0) {
        BookHomeworkChildrenUnitSectionHeaderView * tempHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:BookHomeworkChildrenUnitSectionHeaderGameViewIdentifier];
         NSInteger index =  section - 1;
        BookUnitModel *model  = self.model.bookUnits[index];
        [tempHeaderView setupUnitName:model.unitName];
        headerView = tempHeaderView;
    }
    return headerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell =  nil;
    if (indexPath.section == 0) {
        BookHomeworkYXLXSectionCell * tempCell = [tableView dequeueReusableCellWithIdentifier:BookHomeworkYXLXSectionChildrenUnitGameCellIdentifier];
        cell = tempCell;
    }else {
        BookHomeworkChildrenUnitCell * tempCell = [tableView dequeueReusableCellWithIdentifier:BookHomeworkChildrenUnitGameCellIdentifier];
         NSInteger index = indexPath.section-1;
        BookUnitModel *unitModel = self.model.bookUnits[index];
        ChildrenUnitModel * childrenModel = unitModel.children[indexPath.row];
        NSString *  unitName= childrenModel.unitName;
        BOOL selectedState = NO;
        if (self.selectedIndex.section == indexPath.section && self.selectedIndex.row == indexPath.row) {
            selectedState = YES;
        }
      
        if((!childrenModel.hasListen||![childrenModel.hasListen boolValue]) && (!childrenModel.hasWord||![childrenModel.hasWord boolValue])){
                //没有内容不能选题
           [tempCell setupArrowImgHidden:YES];
       }else{
           [tempCell setupArrowImgHidden:NO];
       }
        tempCell.backgroundColor = [UIColor clearColor];
        tempCell.backgroundView.backgroundColor = [UIColor clearColor];
        [tempCell setupChildrenUnitName:unitName withSelectedState:selectedState]; 
        cell = tempCell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section >0 ) {
        if (self.unitType == BookHomeworkTypeUnitType_YWDD) {
            [self gotoYWDDTypeVC:indexPath];
        }else{
            NSInteger index = indexPath.section-1;
            BookUnitModel *unitModel = self.model.bookUnits[index];
            ChildrenUnitModel * childrenModel = unitModel.children[indexPath.row];
            if((!childrenModel.hasListen||![childrenModel.hasListen boolValue]) && (!childrenModel.hasWord||![childrenModel.hasWord boolValue])){
                [self showAlert:TNOperationState_Fail content:@"该单元下没有题~"];
            }else{
                [self verifyClickCachedDataIndex:indexPath];
                
            }
        }
    }
  
}
//验证点击的数据有没有缓存
- (void)verifyClickCachedDataIndex:(NSIndexPath *)indexPath {
    NSInteger index = indexPath.section-1;
    BookUnitModel *unitModel = self.model.bookUnits[index];
    ChildrenUnitModel * childrenModel = unitModel.children[indexPath.row];
    BOOL isExistsSelected = NO;
    if( self.oldCacheData && self.oldCacheData.count >0){
        NSString * unitId = self.oldCacheData.firstObject[@"unitId"];
        if ([unitId isEqualToString:childrenModel.unitId]) {
            isExistsSelected = YES;
        }
    }
    
    if (isExistsSelected||!self.oldCacheData) {
        [self gotoWordTypeVC:childrenModel.unitId withCacheData:self.oldCacheData];
    }else{
        NSArray * items = @[MMItemMake(@"取消",MMItemTypeNormal, nil),
                            MMItemMake(@"确定",MMItemTypeNormal, ^(NSInteger index){
                                self.oldCacheData = nil;
                                 self.selectedIndex = indexPath;
                                [self updateTableView];
                                [self gotoWordTypeVC:childrenModel.unitId withCacheData:self.oldCacheData];
                            })];
        [self showNormalAlertTitle:@"温馨提示" content:@"是否修改已选择的作业" items:items block:nil];

    }

}
- (void)gotoWordTypeVC:(NSString *)unitId withCacheData:(NSArray *)cacheData{
    BookHomeworkHeardAndWordTypeViewController * heardAndWordVC = [[BookHomeworkHeardAndWordTypeViewController alloc]initWithNavigationTitle:self.navigationItem.title withUnitId:unitId withCacheData:cacheData];
    [self pushViewController:heardAndWordVC];
}

//语文点读
- (void)gotoYWDDTypeVC:(NSIndexPath *)indexPath {
    
    NSInteger index = indexPath.section-1;
    BookUnitModel *unitModel = self.model.bookUnits[index];
    ChildrenUnitModel * childrenModel = unitModel.children[indexPath.row];
    
    if(!childrenModel.hasRead){
        //该单元下没有 题目
        return ;
    }
    BOOL isExistsSelected = NO;
    if( self.oldCacheData && self.oldCacheData.count >0){
        NSString * unitId = self.oldCacheData.firstObject[@"unitId"];
        if ([unitId isEqualToString:childrenModel.unitId]) {
            isExistsSelected = YES;
        }
    }
    
    if (isExistsSelected||!self.oldCacheData) {
       
        [self gotoReadTypeVC:childrenModel.unitId withCacheData:self.oldCacheData];
    }else{
        NSArray * items = @[MMItemMake(@"取消",MMItemTypeNormal, nil),
                            MMItemMake(@"确定",MMItemTypeNormal, ^(NSInteger index){
                                self.oldCacheData = nil;
                                self.selectedIndex = indexPath;
                                [self updateTableView];
                                [self gotoReadTypeVC:childrenModel.unitId withCacheData:self.oldCacheData];
                            })];
        [self showNormalAlertTitle:@"温馨提示" content:@"是否修改已选择的作业" items:items block:nil];
    }
        
    
    
}

- (void)gotoReadTypeVC:(NSString *)unitId withCacheData:(NSArray *)oldCacheData{
    YWReadDetailViewController * detailVC = [[YWReadDetailViewController alloc]initWithBookId:self.bookId withUnitId:unitId withBookName:self.bookName withBookInfo:self.model withCacheData:self.oldCacheData];
    [self pushViewController:detailVC];
    
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
