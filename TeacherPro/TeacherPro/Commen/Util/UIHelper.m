//
//  ESUIHelper.m
//  eShop
//
//  Created by Kyle on 14-10-13.
//  Copyright (c) 2014年 yujiahui. All rights reserved.
//

#import "UIHelper.h"
#import "Utility.h"
#import "AppDelegate.h"
//#import "ESNavigationController.h"


@implementation UIHelper


+(UINavigationController *)navigationControllerViewController:(UIViewController *)controller
{
    if ([controller isKindOfClass:[UINavigationController class]]) {
        NSLog(@"navigationControllerViewController controller isKindOfClass");
        return (UINavigationController *)controller;
    }
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:controller];
    return navi;
}


+(void)tabControlerSeleteIndex:(NSInteger)index
{
    AppDelegate *delegate  = (AppDelegate *)[UIApplication sharedApplication].delegate;
   
}



+(void)tabController:(UIViewController *)tabController pushSubController:(UIViewController *)subViewController
{
    [tabController.navigationController pushViewController:subViewController animated:YES];
    tabController.navigationController.navigationBarHidden = FALSE;
}






+(void)viewControllerPop:(UIViewController *)naviController
{
    [naviController.navigationController popViewControllerAnimated:TRUE];
}



/**

 ViewController present and dissmiss
 
 
 */

+(void)viewController:(UIViewController *)naviController presentSubController:(UIViewController *)subViewController completion:(ESCompletion)completion
{
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:subViewController];
    
    [naviController.navigationController presentViewController:navi animated:YES completion:completion];
}


+(void)viewControllerDissmiss:(UIViewController *)naviController onCompletion:(ESCompletion)completion
{
    [naviController dismissViewControllerAnimated:YES completion:completion];
}



+(void)ViewController:(UIViewController *)viewController cardPresentSubController:(UIViewController *)subViewController completion:(ESCompletion)completion
{
    
}



@end
