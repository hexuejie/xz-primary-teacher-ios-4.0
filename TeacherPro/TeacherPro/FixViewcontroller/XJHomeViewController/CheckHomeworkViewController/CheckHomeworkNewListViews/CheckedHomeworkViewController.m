

//
//  CheckedHomeworkViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/8/12.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "CheckedHomeworkViewController.h"

@class XLPagerTabStripViewController;

@interface CheckedHomeworkViewController ()

@end

@implementation CheckedHomeworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSString *)titleForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    return @"已检查";
    
}

- (NSInteger )getCheckHomeworkType{
    
    return 1;
}
- (NSString *)getDescriptionText{
    
    NSString * description = @"暂无已检查作业!";
    
    return description;
}

- (BOOL)isBeginRefreshing{
    
    return NO;
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
