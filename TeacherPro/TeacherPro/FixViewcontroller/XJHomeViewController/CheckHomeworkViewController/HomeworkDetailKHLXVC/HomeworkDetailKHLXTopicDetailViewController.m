
//
//  HomeworkDetailKHLXTopicDetailViewController.m
//  TeacherPro
//
//  Created by DCQ on 2018/1/31.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "HomeworkDetailKHLXTopicDetailViewController.h"
#import "StudentListViewController.h"
@interface HomeworkDetailKHLXTopicDetailViewController ()
@property(nonatomic, assign) HomeworkDetailKHLXTopicType  type;
@property(nonatomic, strong) NSArray  *studentTypeArray;
@end

@implementation HomeworkDetailKHLXTopicDetailViewController

- (instancetype)initWithType:(HomeworkDetailKHLXTopicType ) type withArray:(NSArray *)studentTypeArray{
    self = [super init];
    if (self) {
        self.type = type;
        self.studentTypeArray = studentTypeArray;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationItemTitle:@"课后练习"];
    // Do any additional setup after loading the view.
    [self setupIndicator];
    if (self.type == HomeworkDetailKHLXTopicType_Complete) {
          [self moveToViewControllerAtIndex:1];
    }
  
}
- (void)setupIndicator{
    
    self.buttonBarView.shouldCellsFillAvailableWidth = YES;
    self.buttonBarView.backgroundColor = [UIColor whiteColor];
    self.isProgressiveIndicator = NO;
    self.buttonBarView.isAutoIndicatorWidth = YES;
    self.buttonBarView.leftRightMargin = 0;
    self.buttonBarView.scrollsToTop = NO;
    self.buttonBarView.scrollEnabled = NO;
    // Do any additional setup after loading the view.
    
    self.buttonBarView.selectedBar.backgroundColor =  UIColorFromRGB(0x2E8AFF);
    
    self.buttonBarView.backgroundColor = [UIColor whiteColor];
    self.bottomLineView.backgroundColor = UIColorFromRGB(0xededed);
    self.buttonBarView.bottomLineHeight = 1;
    
}
 
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSArray *)childViewControllersForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    StudentListType  ListVCType = StudentListType_Normal;
    StudentListType listVC2Type = StudentListType_Normal;
    if (self.type == HomeworkDetailKHLXTopicType_Complete) {
        ListVCType = StudentListType_NoComplete ;
        listVC2Type = StudentListType_Complete;
    }else if (self.type == HomeworkDetailKHLXTopicType_RightAndWrong){
        ListVCType = StudentListType_Wrong;
        listVC2Type = StudentListType_Right;
    }
    StudentListViewController * listVC = [[StudentListViewController alloc]initWithType:ListVCType withArray:self.studentTypeArray.firstObject];
    StudentListViewController * listVC2 = [[StudentListViewController alloc]initWithType:listVC2Type withArray:self.studentTypeArray[1]];
    
    return @[listVC,listVC2];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (UIColor *)getTabTitleColorNor{
    
    return UIColorFromRGB(0x9f9f9f);
}
- (UIColor *)getTabTitleColorSelected{
    
    return UIColorFromRGB(0x4C6B9A);
}
@end
