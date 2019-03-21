//
//  RepositoryCartoonViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/9/18.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "RepositoryCartoonViewController.h"
#import "RepositoryListModel.h"
 
#import "CartoonCollectionViewController.h"
#import "BookSearchViewController.h"
#import "BookSearchViewController.h"
@interface RepositoryCartoonViewController ()
@property(nonatomic, strong) RepositoryListModel *listModel;
@end

@implementation RepositoryCartoonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationItemTitle:@"精品绘本"];
    [self setupNavigatioBarRight];
    [self setupIndicator];
}

- (void)setupIndicator{
    
    self.buttonBarView.shouldCellsFillAvailableWidth = YES;
    self.buttonBarView.backgroundColor = [UIColor whiteColor];
    self.isProgressiveIndicator = NO;
    self.isElasticIndicatorLimit = YES;
    self.buttonBarView.isAutoCrawlerIndicator = YES;
    self.buttonBarView.isAutoIndicatorWidth = NO;
    self.buttonBarView.selectedBarAlignment = XLSelectedBarAlignmentCenter;
    self.buttonBarView.indicatorWidth = 30;
    self.buttonBarView.selectedBar.backgroundColor =  UIColorFromRGB(0x2E8AFF);
    
    self.buttonBarView.backgroundColor = [UIColor whiteColor];
    self.bottomLineView.backgroundColor = UIColorFromRGB(0xededed);
    self.buttonBarView.bottomLineHeight = 1;
    
}
- (void)setupNavigatioBarRight{
    UIButton * searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    
    [searchBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
    [searchBtn addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
    [searchBtn setFrame:CGRectMake(0, 5, 40,60)];
    searchBtn.titleLabel.font = fontSize_14;
    UIBarButtonItem * rightBar = [[UIBarButtonItem alloc]initWithCustomView:searchBtn];
    self.navigationItem.rightBarButtonItem = rightBar;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}
#pragma mark ---
-(NSArray *)childViewControllersForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    CartoonCollectionViewController *oneVC = [[CartoonCollectionViewController alloc]initWithName:@"一年级" withGradeId:@"1"];
    [oneVC updateData];
    CartoonCollectionViewController *twoVC = [[CartoonCollectionViewController alloc]initWithName:@"二年级" withGradeId:@"2"];
    CartoonCollectionViewController *threeVC = [[CartoonCollectionViewController alloc]initWithName:@"三年级" withGradeId:@"3"];
    CartoonCollectionViewController *fourVC = [[CartoonCollectionViewController alloc]initWithName:@"四年级" withGradeId:@"4"];
    CartoonCollectionViewController *fiveVC = [[CartoonCollectionViewController alloc]initWithName:@"五年级" withGradeId:@"5"];
    CartoonCollectionViewController *sixVC = [[CartoonCollectionViewController alloc]initWithName:@"六年级" withGradeId:@"6"];
    NSArray * childViewControllers = [NSMutableArray arrayWithObjects:oneVC,twoVC,threeVC,fourVC,fiveVC,sixVC,nil];
    
    return childViewControllers;
}
- (void)changeCurrentIndexUpdate:(NSInteger )toIndex  {
    
     CartoonCollectionViewController * cartoonVC  = self.pagerTabStripChildViewControllers[toIndex];
    if (!cartoonVC.hasLoadData) {
            [cartoonVC updateData];
     }
}

- (void)rightAction:(UIButton *)sender{
    
    [self gotoSearchBookVC];
}
- (void)gotoSearchBookVC{
    
//    SearchBookViewController * searchBookVC = [[SearchBookViewController alloc]init];
//
//    [self pushViewController:searchBookVC];
    
    BookSearchViewController * searchBookVC = [[BookSearchViewController alloc]init];
    [self pushViewController:searchBookVC];
}


- (UIColor *)getTabTitleColorNor{
    
    return UIColorFromRGB(0x9f9f9f);
}
- (UIColor *)getTabTitleColorSelected{
    
    return UIColorFromRGB(0x4C6B9A);
}
@end
