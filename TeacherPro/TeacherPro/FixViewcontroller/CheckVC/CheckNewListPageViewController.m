//
//  CheckNewListPageViewController.m
//  TeacherPro
//
//  Created by 何学杰 on 2019/2/22.
//  Copyright © 2019 ZNXZ. All rights reserved.
//

#import "CheckNewListPageViewController.h"
#import "UnCheckedHomeworkViewController.h"
#import "CheckedHomeworkViewController.h"
#import "ChooseClassViewController.h"
#import "ClassManageModel.h"
#import "UIView+add.h"

@interface CheckNewListPageViewController ()<ChooseClassViewDelegate>

@property(nonatomic, assign) BOOL  isSwitchClass;//是否有筛选切换过班级操作
@property(nonatomic, assign) BOOL  isCheckHome;//判断是否有检查作业操作

@property(nonatomic, strong) UIButton * releaseBtn;

@end

@implementation CheckNewListPageViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = true;
    
    UIView *uiBarBackground = self.navigationController.navigationBar.subviews.firstObject;
    [uiBarBackground setCornerRadius:0 withShadow:YES withOpacity:0];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyCalculatesItemWidths = YES;
    self.menuViewContentMargin = -57;
    self.delegate = self;
    self.title = @"检查作业";
//    [self setNavigationItemTitle:@"检查作业"];
    [super viewDidLoad];
    
//    [self setNavigationItemTitle:@"检查作业"];
    [self setupNavigationRightItem];
    
    
    UnCheckedHomeworkViewController  *merchantVc1 = [[UnCheckedHomeworkViewController alloc]init];
    merchantVc1.title = @"未检查";//。。。。
    merchantVc1.superVC = self;

    CheckedHomeworkViewController *merchantVc2 = [[CheckedHomeworkViewController alloc]init];
    merchantVc2.title = @"已检查";//。。。。Phonics
    merchantVc2.superVC = self;

    self.subViewControllers = @[merchantVc1,merchantVc2];
    
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
    if (self.clazzId.length>0) {
        createClassVC.classIds = self.clazzId;
    }
    
    [self pushViewController:createClassVC];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
