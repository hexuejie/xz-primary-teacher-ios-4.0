//
//  TabbarConfigManager.m
//  TeacherPro
//
//  Created by DCQ on 2017/5/4.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "TabbarConfigManager.h"
#import "TNTabbarController.h"
#import "HomeViewController.h"
#import "PersonalViewController.h"
#import "ZLXZHomeViewController.h"
#import "ClassManagementNewViewController.h"
#import "MessageListViewController.h"
#import "HBDNavigationController.h"
#import "UIViewController+HBD.h"
#import "SessionHelper.h"
#import "SessionModel.h"

@interface TabbarConfigManager()

@end
@implementation TabbarConfigManager

+ (UIViewController *)getTabbarViewController:(TabbarViewControllerType )type withDelegate:(id)delegate{
    
    TNTabbarController * tabbarVC = [[TNTabbarController alloc]init];
//    HomeViewControllerType  homeType ;
//    if (type == TabbarViewControllerType_Info) {
//        homeType = HomeViewControllerType_Info;
//    }else if (type == TabbarViewControllerType_Login){
//        homeType = HomeViewControllerType_Login;
//    }else{
//        homeType = HomeViewControllerType_Normal;
//    }
    
    
//    HomeViewController* homeVC = [[HomeViewController alloc]initWithType:homeType];
    ZLXZHomeViewControllerType    homeType ;
    if (type == TabbarViewControllerType_Info) {
        homeType = ZLXZHomeViewControllerType_Info;
    }else if (type == TabbarViewControllerType_Login){
        homeType = ZLXZHomeViewControllerType_Login;
    }else{
        homeType = ZLXZHomeViewControllerType_Normal;
    }

    ZLXZHomeViewController * homeVC = [[ZLXZHomeViewController alloc]initWithType:homeType];
    ClassManagementNewViewController * classVC = [[ClassManagementNewViewController alloc]initWithType:ClassManagementType_tab];
    

    MessageListViewController * messageVC = [[MessageListViewController alloc]initWithType:MessageListType_Tab];
  
    PersonalViewController * personalVC = [[PersonalViewController alloc]init];
    
    HBDNavigationController * homeNavVC = [[HBDNavigationController alloc]initWithRootViewController:homeVC];
    HBDNavigationController * classNavVC = [[HBDNavigationController alloc]initWithRootViewController:classVC];
    HBDNavigationController * messageNavVC = [[HBDNavigationController alloc]initWithRootViewController:messageVC];
    HBDNavigationController * personalNavVC = [[HBDNavigationController alloc]initWithRootViewController:personalVC];
    
    tabbarVC.viewcontrollerArray = @[homeNavVC,classNavVC,messageNavVC,personalNavVC];
    [TabbarConfigManager initCustomerTabbar:tabbarVC];
    tabbarVC.delegate = delegate;
    tabbarVC.selectedIndex =  0;
    return tabbarVC;
}


+ (void)initCustomerTabbar:(TNTabbarController  *)tabbarVC{
    
    
    
    NSArray *selectedImages = @[[UIImage imageNamed:@"home_tab_home_icon_select"], [UIImage imageNamed:@"home_tab_class_icon_select"],[UIImage imageNamed:@"home_tab_message_icon_select"], [UIImage imageNamed:@"home_tab_my_icon_select"]];
    
    NSArray *unSelectedImages = @[[UIImage imageNamed:@"home_tab_home_icon_normal"], [UIImage imageNamed:@"home_tab_class_icon_normal"],[UIImage imageNamed:@"home_tab_message_icon_normal"], [UIImage imageNamed:@"home_tab_my_icon_normal"]];
    
    for (int i=0; i<tabbarVC.tabBar.items.count; i++) {
        TNTabbarItem *item = tabbarVC.tabBar.items[i];
        switch (i) {
            case 0:
                item.title = @"首页";
                break;
            case 1:
                item.title = @"班级";
                break;
            case 2:
                item.title = @"消息";
//                item.badgeValue = @"12";
                break;
            case 3:
                item.title = @"我的";
                break;
            default:
                break;
        }
        
        [item setSelectedItemImage:selectedImages[i] withUnselectedItemImage:unSelectedImages[i]];
    }
}
+ (void)presentViewController:(UIImagePickerController *)imagePickerVc{

    if ([[[UIApplication sharedApplication].delegate window].rootViewController isKindOfClass:[TNTabbarController class]]) {
        TNTabbarController *rootVC = (TNTabbarController *)[[UIApplication sharedApplication].delegate window].rootViewController;
        [rootVC presentViewController:imagePickerVc];
 
    }else{
        UINavigationController * navc  = (UINavigationController *)[[UIApplication sharedApplication].delegate window].rootViewController;
       
        [ navc.topViewController.presentedViewController presentViewController:imagePickerVc animated:YES completion:nil];
    }
    
  
}
@end
