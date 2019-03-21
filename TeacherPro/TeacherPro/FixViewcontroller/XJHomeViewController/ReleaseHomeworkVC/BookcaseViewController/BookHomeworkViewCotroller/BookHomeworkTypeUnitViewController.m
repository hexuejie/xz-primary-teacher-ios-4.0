//
//  BookHomeworkTypeUnitViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/9/7.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BookHomeworkTypeUnitViewController.h"
#import "BookPreviewModel.h"
#import "BookHomeworkYXLXSectionCell.h"
#import "BookHomeworkAdjustmentRepeatedNumberCell.h"
#import "BookHomeworkUnitRemindingHeaderView.h"
#import "BookHomeworkChooseCell.h"
#import "BookHomeworkYXLXUnitCell.h"
#import "BookHomeworkHeardAndWordTypeViewController.h"
#import "YYCache.h"
#import "YWReadDetailViewController.h"


NSString * const BookHomeworkUnitRemindingHeaderViewIdentifier =@"BookHomeworkUnitRemindingHeaderViewIdentifier";
NSString * const BookHomeworkYXLXSectionCellIdentifier =@"BookHomeworkYXLXSectionCellIdentifier";
NSString * const BookHomeworkAdjustmentRepeatedNumberCellIdentifier =@"BookHomeworkAdjustmentRepeatedNumberCellIdentifier";
NSString * const BookHomeworkChooseCellIdentifier =@"BookHomeworkChooseCellIdentifier";
NSString * const BookHomeworkYXLXUnitCellIdentifier = @"BookHomeworkYXLXUnitCellIdentifier";

@interface BookHomeworkTypeUnitViewController ()

@end

@implementation BookHomeworkTypeUnitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self defaultSelectedData];
    [self configTableView];
    
}
- (void)configTableView{
    
    self.tableView.backgroundColor = [UIColor clearColor];
    // 隐藏UITableViewStyleGrouped上边多余的间隔
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    
    self.view.backgroundColor = project_background_gray;
}

- (void)defaultSelectedData{
    if( self.oldCacheData && self.oldCacheData.count >0){
        NSString * unitId = self.oldCacheData.firstObject[@"unitId"];
        for (int i = 0; i< [self.model.bookUnits count]; i++) {
            BookUnitModel *model  = self.model.bookUnits[i];
            if ([unitId isEqualToString:model.unitId]) {
                NSInteger row =  i;
                NSInteger section = 1;
                if (self.unitType == BookHomeworkTypeUnitType_YXLX||self.unitType == BookHomeworkTypeUnitType_DCTX) {
                    row = i;
                }else{
                    row = i ;
                }
                self.selectedIndex = [NSIndexPath indexPathForRow:row inSection:section ];
            }
        }
 
    }
    
    
}

- (void)registerCell{
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BookHomeworkUnitRemindingHeaderView class]) bundle:nil] forHeaderFooterViewReuseIdentifier: BookHomeworkUnitRemindingHeaderViewIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BookHomeworkAdjustmentRepeatedNumberCell class]) bundle:nil] forCellReuseIdentifier:BookHomeworkAdjustmentRepeatedNumberCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BookHomeworkYXLXSectionCell class]) bundle:nil] forCellReuseIdentifier:BookHomeworkYXLXSectionCellIdentifier];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BookHomeworkChooseCell class]) bundle:nil] forCellReuseIdentifier:BookHomeworkChooseCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BookHomeworkYXLXUnitCell class]) bundle:nil] forCellReuseIdentifier:BookHomeworkYXLXUnitCellIdentifier];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger row = 0;
    if (section == 0) {
        if (self.unitType == BookHomeworkTypeUnitType_DCTX) {
            row = 0;
        }else
            row = 1;
    }else{
        row = [self.model.bookUnits count];
        switch (self.unitType) {
            case  BookHomeworkTypeUnitType_TKWLY:
                row  = row;
                break;
            case  BookHomeworkTypeUnitType_LDKW:
                row  = row;
                break;
            default:
                break;
        }
        
        
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
    if (self.unitType != BookHomeworkTypeUnitType_DCTX) {
        height = FITSCALE(8);
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = 0.00001;
    if (section == 0 && self.unitType !=BookHomeworkTypeUnitType_YXLX &&self.unitType!= BookHomeworkTypeUnitType_YWDD) {
        height = 44;
    }
    return height;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView * footerView = [UIView new];
    
    return footerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headerView = nil;
    if (section == 0 && self.unitType != BookHomeworkTypeUnitType_YXLX &&self.unitType!= BookHomeworkTypeUnitType_YWDD) {
        BookHomeworkUnitRemindingHeaderView * tempHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:BookHomeworkUnitRemindingHeaderViewIdentifier];
 
        NSString * remindingDetail = @"";
        switch (self.unitType) {
            case BookHomeworkTypeUnitType_DCTX:
 
                remindingDetail = @"单词听写";
                break;
            case BookHomeworkTypeUnitType_LDKW:
 
                remindingDetail = @"课文跟读";
                break;
            case BookHomeworkTypeUnitType_TKWLY:
 
                remindingDetail = @"课本点读";
                break;
            default:
                break;
        }
            //听课文录音——学生可使用"小佳学习"的"课本点读"功能完成此项作业
        NSString *remindingName = [NSString stringWithFormat:@"学生可使用\"小佳学习\"的\"%@\"功能完成此项作业",remindingDetail];
        [tempHeaderView setupReminding:remindingName];
        
        headerView = tempHeaderView;
    }
    return headerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell =  nil;
    if (indexPath.section == 0) {
         if (self.unitType == BookHomeworkTypeUnitType_YXLX||self.unitType == BookHomeworkTypeUnitType_YWDD) {
            BookHomeworkYXLXSectionCell * tempCell = [tableView dequeueReusableCellWithIdentifier:BookHomeworkYXLXSectionCellIdentifier];
             cell = tempCell;
             
         }else{
             BookHomeworkAdjustmentRepeatedNumberCell  * tempCell = [tableView dequeueReusableCellWithIdentifier:BookHomeworkAdjustmentRepeatedNumberCellIdentifier];
             WEAKSELF
             tempCell.adjustmentBlock = ^(NSInteger number) {
                 STRONGSELF
                 strongSelf.passCount = number;
             };
             cell = tempCell;
             
         }
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else if (indexPath.section == 1){
        //游戏练习
        if (self.unitType == BookHomeworkTypeUnitType_YXLX || self.unitType == BookHomeworkTypeUnitType_YWDD) {
            BookHomeworkYXLXUnitCell * tempCell = [tableView dequeueReusableCellWithIdentifier:BookHomeworkYXLXUnitCellIdentifier];
            BookUnitModel *unitModel = self.model.bookUnits[indexPath.row];
            NSString *  unitName= unitModel.unitName;
            BOOL selectedState = NO;
           
            if (self.selectedIndex.section == indexPath.section  && self.selectedIndex.row == indexPath.row) {
                selectedState = YES;
            }
            if (self.unitType == BookHomeworkTypeUnitType_YXLX) {
                if((!unitModel.hasListen||![unitModel.hasListen boolValue]) && (!unitModel.hasWord||![unitModel.hasWord boolValue])){
                    //没有内容不能选题
                    [tempCell setupArrowImgHidden:YES];
                }else{
                     [tempCell setupArrowImgHidden:NO];
                }
            }
            [tempCell setupUnitName:unitName withSelectedState:selectedState];
            
            cell = tempCell;
             cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }else{
            // 不是游戏练习
          
                //其它行显示
                BookHomeworkChooseCell  * tempCell = [tableView dequeueReusableCellWithIdentifier:BookHomeworkChooseCellIdentifier];
                NSString * unitName = @"";
                NSInteger indexRow = 0;
                if (self.unitType == BookHomeworkTypeUnitType_DCTX) {
                    indexRow = indexPath.row;
                }else{
                   indexRow =indexPath.row;
                }
                BookUnitModel *unitModel = self.model.bookUnits[indexRow];
                unitName= unitModel.unitName;
                BOOL chooseState = NO;
           
                if (self.selectedIndex.section == indexPath.section  && self.selectedIndex.row == indexPath.row) {
                      chooseState = YES;
                }
            
            if (self.unitType == BookHomeworkTypeUnitType_DCTX &&(!unitModel.hasWord ||![unitModel.hasWord boolValue])) {
                
                tempCell.selectionStyle = UITableViewCellSelectionStyleNone;
                [tempCell setSelectedImgVHidden:YES];
              
            }else{
                if (self.unitType == BookHomeworkTypeUnitType_TKWLY) {
                    if((!unitModel.hasRead||![unitModel.hasRead boolValue])){
                        //没有内容不能选题
                          [tempCell setSelectedImgVHidden:YES];
                    }else{
                        [tempCell setSelectedImgVHidden:NO];
                    }
                }else if (self.unitType == BookHomeworkTypeUnitType_LDKW) {
                    if((!unitModel.hasFollow||![unitModel.hasFollow boolValue])){
                        //没有内容不能选题
                          [tempCell setSelectedImgVHidden:YES];
                    }else{
                        [tempCell setSelectedImgVHidden:NO];
                    }
                }else{
                       [tempCell setSelectedImgVHidden:NO];
                }
                tempCell.selectionStyle = UITableViewCellSelectionStyleNone;
             
               
            }

             [tempCell setupUnitName:unitName withChooseState:chooseState];
             cell = tempCell;
            
        }
    }
   
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1 ) {
        //  选择单元进详情
        if ( self.unitType == BookHomeworkTypeUnitType_YXLX) {
             BookUnitModel *unitModel = self.model.bookUnits[indexPath.row];
            if((!unitModel.hasListen||![unitModel.hasListen boolValue]) && (!unitModel.hasWord||![unitModel.hasWord boolValue])){
                  [self showAlert:TNOperationState_Fail content:@"该单元下没有题~"];
            }else{
                [self gotoHeardAndWordIndex:indexPath];
                
            }
           
        }else if(self.unitType == BookHomeworkTypeUnitType_YWDD){
            
             [self gotoYWDDTypeVC:indexPath];
        } else{
            //除开游戏练习 直接选择单元 没有详情页
            [self NoDetaildidSelectRowAtIndexPath:indexPath];
        }
    }
}

- (void)NoDetaildidSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
    BookUnitModel *unitModel = self.model.bookUnits[indexPath.row];
    if (self.unitType == BookHomeworkTypeUnitType_DCTX &&(!unitModel.hasWord ||![unitModel.hasWord boolValue])) {
        [self showAlert:TNOperationState_Fail content:@"该单元下没有单词~"];
    }else{
        if (self.unitType == BookHomeworkTypeUnitType_TKWLY) {
            if((!unitModel.hasRead||![unitModel.hasRead boolValue])){
                //没有内容不能选题
                [self showAlert:TNOperationState_Fail content:@"该单元下没有题~"];
            }else{
                self.oldCacheData = nil;
                self.selectedIndex = indexPath;
                [self updateTableView];
                
            }
            
        }else if (self.unitType == BookHomeworkTypeUnitType_LDKW) {
            if((!unitModel.hasFollow||![unitModel.hasFollow boolValue])){
                //没有内容不能选题
                [self showAlert:TNOperationState_Fail content:@"该单元下没有题~"];
            }else{
                self.oldCacheData = nil;
                self.selectedIndex = indexPath;
                [self updateTableView];
            }
        }else{
            self.oldCacheData = nil;
            self.selectedIndex = indexPath;
            [self updateTableView];
            
        }
    }
}

#pragma mark ---

//词汇 听说 详情
- (void)gotoHeardAndWordIndex:(NSIndexPath *)indexPath{
    
    BookUnitModel *unitModel = self.model.bookUnits[indexPath.row];
     BOOL isExistsSelected = NO;
    if( self.oldCacheData && self.oldCacheData.count >0){
        NSString * unitId = self.oldCacheData.firstObject[@"unitId"];
        if ([unitId isEqualToString:unitModel.unitId]) {
            isExistsSelected = YES;
        }
    }
    
    if (isExistsSelected||!self.oldCacheData) {
        [self gotoWordTypeVC:unitModel.unitId withCacheData:self.oldCacheData];
    }else{
        NSArray * items = @[MMItemMake(@"取消",MMItemTypeNormal, nil),
                            MMItemMake(@"确定",MMItemTypeNormal, ^(NSInteger index){
                                self.oldCacheData = nil;
                                 self.selectedIndex = indexPath;
                                [self updateTableView];
                                [self gotoWordTypeVC:unitModel.unitId withCacheData:self.oldCacheData];
                            })];
        [self showNormalAlertTitle:@"温馨提示" content:@"是否修改已选择的作业" items:items block:nil];
        
    }
    
}

- (void)gotoWordTypeVC:(NSString *)unitId withCacheData:(NSArray *)cacheData{
    
    BookHomeworkHeardAndWordTypeViewController * heardAndWordVC = [[BookHomeworkHeardAndWordTypeViewController alloc]initWithNavigationTitle:self.navigationItem.title withUnitId:unitId withCacheData:cacheData];
    [self pushViewController:heardAndWordVC];
}
#pragma mark ---

//语文点读
- (void)gotoYWDDTypeVC:(NSIndexPath *)indexPath {
    BookUnitModel *unitModel = self.model.bookUnits[indexPath.row];
    if(!unitModel.hasRead){
        //该单元下没有 题目
        [self showAlert:TNOperationState_Unknow content:@"该单元下没有作业题目~"];
        return ;
    }
    if (!unitModel.hasWord) {
        [self showAlert:TNOperationState_Unknow content:@"该单元下没有单词~"];
        return ;
    }
    BOOL isExistsSelected = NO;
    if( self.oldCacheData && self.oldCacheData.count >0){
        NSString * unitId = self.oldCacheData.firstObject[@"unitId"];
        if ([unitId isEqualToString:unitModel.unitId]) {
            isExistsSelected = YES;
        }
    }
    
    if (isExistsSelected||!self.oldCacheData) {
        [self gotoYWDDVC:unitModel.unitId withCacheData:self.oldCacheData];
    }else{
        NSArray * items = @[MMItemMake(@"取消",MMItemTypeNormal, nil),
                            MMItemMake(@"确定",MMItemTypeNormal, ^(NSInteger index){
                                self.oldCacheData = nil;
                                 self.selectedIndex = indexPath;
                                [self updateTableView];
                                [self gotoYWDDVC:unitModel.unitId withCacheData:self.oldCacheData];
                            })];
        [self showNormalAlertTitle:@"温馨提示" content:@"是否修改已选择的作业" items:items block:nil];
        
    }
    
 
}


- (void)gotoYWDDVC:(NSString *)unitId withCacheData:(NSArray *)cacheData{
    YWReadDetailViewController * detailVC = [[YWReadDetailViewController alloc]initWithBookId:self.bookId withUnitId:unitId withBookName:self.bookName withBookInfo:self.model withCacheData:cacheData];
    [self pushViewController:detailVC];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

