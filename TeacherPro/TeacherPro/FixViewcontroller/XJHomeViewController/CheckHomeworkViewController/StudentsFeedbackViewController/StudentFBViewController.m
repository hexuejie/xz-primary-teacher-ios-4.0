//
//  StudentFBViewController.m
//  TeacherPro
//
//  Created by DCQ on 2018/8/17.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "StudentFBViewController.h"
#import "StudentsFeedbackViewController.h"

@interface StudentFBViewController ()
@property(nonatomic, copy)NSString * homeworkId;
@end

@implementation StudentFBViewController
- (instancetype)initWithHomeworkId:(NSString *)homeworkId{
    self = [super init];
    if (self) {
        self.homeworkId = homeworkId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupIndicator];
    [self setNavigationItemTitle:@"学生反馈"];
   
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self navUIBarBackground:0];
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
    self.buttonBarView.indicatorWidth = 80;
    
    self.itemColorChangeFollowContentScroll = YES;
    self.itemFontChangeFollowContentScroll = NO;
    self.itemTitleFont = fontSize_14;
    //     self.itemTitleSelectedFont = [UIFont systemFontOfSize:18];
    // Do any additional setup after loading the view.
    
    self.buttonBarView.selectedBar.backgroundColor =  UIColorFromRGB(0x2E8AFF);
    
    self.buttonBarView.backgroundColor = [UIColor whiteColor];
    self.bottomLineView.backgroundColor = UIColorFromRGB(0xededed);
    self.buttonBarView.bottomLineHeight = 1;
    
}
-(NSArray *)childViewControllersForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    StudentsFeedbackViewController *feedbackVC = [[StudentsFeedbackViewController alloc]initWithHomeworkId:self.homeworkId withStudentFeedbackType:StudentFeedbackType_feedback];
    
    StudentsFeedbackViewController *unFeedbackVC = [[StudentsFeedbackViewController alloc]initWithHomeworkId:self.homeworkId withStudentFeedbackType:StudentFeedbackType_unFeedback];
   
    NSArray * childViewControllers = [NSMutableArray arrayWithObjects:feedbackVC,unFeedbackVC,nil];
    return childViewControllers;
}

- (void)changeCurrentIndexUpdate:(NSInteger )toIndex  {
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIColor *)getTabTitleColorNor{
    
    return UIColorFromRGB(0x9f9f9f);
}
- (UIColor *)getTabTitleColorSelected{
    
    return UIColorFromRGB(0x4C6B9A);
}

@end
