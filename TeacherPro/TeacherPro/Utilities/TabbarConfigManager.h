//
//  TabbarConfigManager.h
//  TeacherPro
//
//  Created by DCQ on 2017/5/4.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <Foundation/Foundation.h>
@class  UIViewController;
@class  UIImagePickerController;
typedef NS_ENUM(NSInteger, TabbarViewControllerType) {
    TabbarViewControllerType_normal          = 0 ,
    TabbarViewControllerType_Login              ,
    TabbarViewControllerType_Info               ,
};
@interface TabbarConfigManager : NSObject
+ (UIViewController *)getTabbarViewController:(TabbarViewControllerType )type withDelegate:(id )delegate;
+ (void)presentViewController:(UIImagePickerController *)imagePickerVc;
@end
