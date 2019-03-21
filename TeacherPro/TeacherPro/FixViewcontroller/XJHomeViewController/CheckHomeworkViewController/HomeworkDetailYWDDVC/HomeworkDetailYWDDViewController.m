//
//  HomeworkDetailYWDDViewController.m
//  TeacherPro
//
//  Created by DCQ on 2018/2/5.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "HomeworkDetailYWDDViewController.h"

@interface HomeworkDetailYWDDViewController ()

@end

@implementation HomeworkDetailYWDDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (CGRect)getCollectionViewRect{
    CGRect rect = CGRectMake(-10, 0, self.view.frame.size.width + 20, self.view.frame.size.height);
    return rect;
}
- (BOOL)ShowBottomView{
    return NO;
}
- (BOOL)isChangeSelectedItem{
    return NO;
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
