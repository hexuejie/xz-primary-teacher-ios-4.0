
//
//  UnCheckedHomeworkViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/8/12.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "UnCheckedHomeworkViewController.h"

@class XLPagerTabStripViewController;

@interface UnCheckedHomeworkViewController ()

@end

@implementation UnCheckedHomeworkViewController

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
    return @"未检查";
    
}

- (NSInteger )getCheckHomeworkType{
    
    return 0;
}
- (NSString *)getDescriptionText{
    
    NSString * description = @"暂无作业!";
    
    return description;
}
@end
