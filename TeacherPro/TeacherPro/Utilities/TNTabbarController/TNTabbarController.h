//
//  TNTabbarController.h
//  AplusEduPro
//
//  Created by neon on 15/7/15.
//  Copyright (c) 2015年 neon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TNTabbar.h"

@class TNTabbarController;
@protocol TNTabbarViewControllerDelegate;

@interface TNTabbarController : UIViewController <TNTabbarDelegate>
@property (nonatomic,assign) id<TNTabbarViewControllerDelegate> delegate;
@property (nonatomic,strong) TNTabbar *tabBar;
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UIViewController *selectedViewController;
@property (nonatomic, copy) IBOutletCollection(UIViewController) NSArray *viewcontrollerArray;
@property (nonatomic )NSInteger selectedIndex;
@property (nonatomic )BOOL isTabbarHidden;
- (void)presentViewController:(UIImagePickerController *)imagePickerVC;
@end




@protocol TNTabbarViewControllerDelegate<NSObject>
-(BOOL)tabBarController :(TNTabbarController *)tabBarController shouldSelectViewController:(UIViewController *) viewController;

-(void)tabBarController :(TNTabbarController *)tabBarController didSelectViewController:(UIViewController *)viewController;
@end


@interface UIViewController (TNTabbarItem)
@property (nonatomic,readonly) TNTabbarController *tnTabbarController;
@property (nonatomic,setter=tn_settabbarItem:) TNTabbarItem * tnTabbarItem;
@end
