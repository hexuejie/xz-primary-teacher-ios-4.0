

//
//  CheckHomeworkNewListViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/8/12.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "CheckHomeworkNewListViewController.h"
#import "UnCheckedHomeworkViewController.h"
#import "CheckedHomeworkViewController.h"
#import "ChooseClassViewController.h"
#import "ClassManageModel.h"

@interface CheckHomeworkNewListViewController ()<ChooseClassViewDelegate>
@property(nonatomic, copy)NSString * clazzId;
@property(nonatomic, assign) BOOL  isSwitchClass;//是否有筛选切换过班级操作
@property(nonatomic, assign) BOOL  isCheckHome;//判断是否有检查作业操作

@property(nonatomic, strong) UIButton * releaseBtn;
@end

@implementation CheckHomeworkNewListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupIndicator];
    [self setNavigationItemTitle:@"检查作业"];
    [self setupNavigationRightItem];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self navUIBarBackground:0];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self navUIBarBackground:8];
}

- (void)setupIndicator{
    
    self.buttonBarView.shouldCellsFillAvailableWidth = YES;
    self.buttonBarView.backgroundColor = [UIColor whiteColor];
    self.isProgressiveIndicator = NO;
    self.isElasticIndicatorLimit = YES;
    self.buttonBarView.isAutoCrawlerIndicator = YES;
    self.buttonBarView.isAutoIndicatorWidth = NO;
    
    self.buttonBarView.leftRightMargin = 0;
    self.buttonBarView.scrollsToTop = NO;
    self.buttonBarView.scrollEnabled = NO;
    self.buttonBarView.indicatorWidth = 22;

    self.itemColorChangeFollowContentScroll = YES;
    self.itemFontChangeFollowContentScroll = NO;
    self.itemTitleFont = systemFontSize(16);
    self.itemTitleSelectedFont = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    
//     self.itemTitleSelectedFont = [UIFont systemFontOfSize:18];
    // Do any additional setup after loading the view.
    
    self.buttonBarView.selectedBar.backgroundColor =  UIColorFromRGB(0x2E8AFF);
    
    self.buttonBarView.backgroundColor = [UIColor whiteColor];
    self.bottomLineView.backgroundColor = UIColorFromRGB(0xededed);
    self.buttonBarView.bottomLineHeight = 1;
   
}
- (void) setupNavigationRightItem{
    
    _releaseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_releaseBtn setTitle:@"筛选" forState:UIControlStateNormal];
    [_releaseBtn setTitleColor:HexRGB(0x4D4D4D) forState:UIControlStateNormal ];
    [_releaseBtn addTarget:self action:@selector(changeAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_releaseBtn setFrame:CGRectMake(0, 5, 100,60)];
    _releaseBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _releaseBtn.titleLabel.font = systemFontSize(16);
    
    
    UIBarButtonItem * rightBar = [[UIBarButtonItem alloc]initWithCustomView:_releaseBtn];
    self.navigationItem.rightBarButtonItem = rightBar;
    
}
- (void)changeAction:(UIButton *)sender{
    
    ChooseClassViewController * createClassVC = [[ChooseClassViewController alloc]initWithViewControllerFromeType:ViewControllerFromeType_checkChoose];
    createClassVC.chooseDelegate = self;
    [self pushViewController:createClassVC];
    
}

#pragma mark -- chooseClassDelegate

- (void)checkChooseClassInfo:(ClassManageModel *)classInfo{
  
    
    NSString * btnTittle = @"";
    if (classInfo) {
         btnTittle = classInfo.clazzName;
    }else{
    
        btnTittle = @"筛选";
    }
    UIButton * releaseBtn  = self.navigationItem.rightBarButtonItem.customView;
    [releaseBtn setTitle:btnTittle forState:UIControlStateNormal];
   
    
    BaseCheckHomeworkListViewController * oneBaseCheckVC = self.pagerTabStripChildViewControllers[self.currentIndex];
    oneBaseCheckVC.clazzId = classInfo.clazzId;
    [oneBaseCheckVC beginRefresh];
    self.clazzId = classInfo.clazzId;
    self.isSwitchClass = YES;
}


-(NSArray *)childViewControllersForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    UnCheckedHomeworkViewController *uncheckedVC = [[UnCheckedHomeworkViewController alloc]init];
    uncheckedVC.checkSuccessBlock = ^{
        self.isCheckHome = YES;
    };
    CheckedHomeworkViewController *checkedVC = [[CheckedHomeworkViewController alloc]init];
    checkedVC.superVC =self;
    uncheckedVC.superVC =self;
    NSArray * childViewControllers = [NSMutableArray arrayWithObjects:uncheckedVC,checkedVC,nil];

    return childViewControllers;
}

- (void)changeCurrentIndexUpdate:(NSInteger )toIndex  {
     
    BaseCheckHomeworkListViewController * oneBaseCheckVC = self.pagerTabStripChildViewControllers[toIndex];
    oneBaseCheckVC.clazzId =  self.clazzId;
    
    //第一次加载
    if (!oneBaseCheckVC.hasLoadData) {
        [oneBaseCheckVC beginRefresh];
    }else{
        
        //筛选班级 检查作业 刷新
        if (self.isSwitchClass ||self.isCheckHome ) {
            [oneBaseCheckVC beginRefresh];
            self.isSwitchClass = NO;
            self.isCheckHome = NO;
        }
    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIColor *)getTabTitleColorNor{
    
    return UIColorFromRGB(0xA1A7B3);
}
- (UIColor *)getTabTitleColorSelected{
    
    return UIColorFromRGB(0x525B66);
}
@end
