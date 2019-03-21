
//
//  BaseHomeworkUnitViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/9/15.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BaseHomeworkUnitViewController.h"
#import "BookPreviewModel.h"
#import "YYCache.h"
@interface BaseHomeworkUnitViewController ()

@end

@implementation BaseHomeworkUnitViewController
- (instancetype)initWithBookDetail:(BookPreviewDetailModel *)model withTitle:(PracticeTypeModel *)typeModel withCacheData:(NSArray *)cacheData{
    
    self = [super init];
    if (self) {
        self.model = model;
        self.typeModel = typeModel;
        [self setupUnitType];
        self.oldCacheData = cacheData;
    }
    return self;
}
- (void)setupUnitType{
    if ([self.typeModel.practiceType isEqualToString:@"zxlx"]) {
        self.unitType = BookHomeworkTypeUnitType_YXLX;
    }else if ([self.typeModel.practiceType isEqualToString:@"tkwly"]) {
        self.unitType = BookHomeworkTypeUnitType_TKWLY;
        
    }else if ([self.typeModel.practiceType isEqualToString:@"ldkw"]) {
        self.unitType = BookHomeworkTypeUnitType_LDKW;
    }else if ([self.typeModel.practiceType isEqualToString:@"dctx"]) {
        self.unitType = BookHomeworkTypeUnitType_DCTX;
    }else if ([self.typeModel.practiceType isEqualToString:@"ywdd"]){
        
        self.unitType = BookHomeworkTypeUnitType_YWDD;
    }
}
- (CGRect)getTableViewFrame{
    
    CGFloat bottomHeight = 0;
    if ( self.unitType  == BookHomeworkTypeUnitType_LDKW|| self.unitType  == BookHomeworkTypeUnitType_TKWLY ||self.unitType == BookHomeworkTypeUnitType_DCTX) {
        bottomHeight = 65;
    }
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - bottomHeight);
    return frame;
}
- (UITableViewStyle)getTableViewStyle{
    
    return UITableViewStyleGrouped;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationItemTitle:self.typeModel.practiceTypeDes];
   
    self.passCount = 1;
 
    if (self.unitType  == BookHomeworkTypeUnitType_LDKW||self.unitType  == BookHomeworkTypeUnitType_TKWLY||self.unitType == BookHomeworkTypeUnitType_DCTX) {
        [self setupBottomView];
    }
    [self configTableView];
}
- (void)configTableView{
    
    self.tableView.backgroundColor = [UIColor clearColor];
    // 隐藏UITableViewStyleGrouped上边多余的间隔
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    
    self.view.backgroundColor = project_background_gray;
}
- (void)setupBottomView{
    CGFloat bottomHeight = 65 ;
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - bottomHeight, self.view.frame.size.width, bottomHeight)];
    bottomView.backgroundColor = UIColorFromRGB(0xffffff);
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,  self.view.frame.size.width, 0.5)];
    lineView.backgroundColor = project_line_gray;
    [bottomView addSubview:lineView];
    UIButton * sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setTitle:@"确  认" forState:UIControlStateNormal];
    sureBtn.titleLabel.font = systemMediumFontSize(16);
    sureBtn.frame = CGRectMake(10, 4, bottomView.frame.size.width - 10*2, bottomHeight-5);
    [sureBtn setBackgroundImage:[UIImage imageNamed:@"add_background_image"] forState:UIControlStateNormal];
     [sureBtn setBackgroundImage:[UIImage imageNamed:@"add_background_image"] forState:UIControlStateHighlighted];
    
    [sureBtn addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:sureBtn];
    [self.view addSubview:bottomView];
}
- (void)sureAction:(id)sender{
    
    if (!self.selectedIndex) {
        [self showAlert:TNOperationState_Unknow content:@"请选择布置作业单元"];
        
    }else{
        NSInteger indexRow =  self.selectedIndex.row;
        if (self.unitType == BookHomeworkTypeUnitType_TKWLY ||self.unitType == BookHomeworkTypeUnitType_LDKW) {
            indexRow = self.selectedIndex.row ;
        }
        
        BookUnitModel *unitModel = self.model.bookUnits[ indexRow];
        
        NSString *unitId = unitModel.unitId;
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
                //            submitDic = @{@"unitId":unitId,@"wordCount":@(0)};
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
