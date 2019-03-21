//
//  TNTabbarController.m
//  AplusEduPro
//
//  Created by neon on 15/7/15.
//  Copyright (c) 2015年 neon. All rights reserved.
//

#import "TNTabbarController.h"
#import "TNTabbarItem.h"
#import "TNTabbar.h"
#import "objc/runtime.h"
#import "CommonConfig.h"
#import "FourPingTransition.h"
#import "CommonConfig.h"
#import "UIView+add.h"

@interface UIViewController (TNTabbarViewControllerInternal)<UIActionSheetDelegate,UIViewControllerTransitioningDelegate>
-(void)tn_setTnTabbarViewController:(TNTabbarController *)tabbarVC;
@end


@interface TNTabbarController (){
//     UIView *_contentView;
}
//@property (nonatomic, readwrite) TNTabbar *tabBar;
@end


@implementation TNTabbarController {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
   
    self.extendedLayoutIncludesOpaqueBars =NO;
//     self.transitioningDelegate = self;
    [self.view addSubview:[self contentView]];
  
    [self.view addSubview:[self tabBar]];
    
//    [self.tabBar mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.view.mas_left);
//         make.right.mas_equalTo(self.view.mas_right);
//         make.bottom.mas_equalTo(self.view.mas_bottom);
//    }];
//    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.view.mas_left);
//        make.right.mas_equalTo(self.view.mas_right);
//        make.bottom.mas_equalTo(self.tabBar.mas_top);
//         make.top.mas_equalTo(self.view.mas_top);
//    }];
    [self setIsTabbarHidden:NO];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self setSelectedIndex:[self selectedIndex]];
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark method


- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        [_contentView setBackgroundColor:[UIColor whiteColor]];
        
//        UIViewAutoresizingFlexibleWidth 自动调整自己的宽度，保证与superView左边和右边的距离不变。
//        UIViewAutoresizingFlexibleHeight 自动调整自己的高度，保证与superView顶部和底部的距离不变。
        [_contentView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|
                                           UIViewAutoresizingFlexibleHeight )];
    }
    return _contentView;
}

- (TNTabbar *)tabBar {
    if(!_tabBar){
        _tabBar = [[TNTabbar alloc]init];
        _tabBar.delegate=self;
        _tabBar.backgroundColor=[UIColor whiteColor];
      
        [_tabBar setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|
                                      UIViewAutoresizingFlexibleTopMargin|
                                      UIViewAutoresizingFlexibleLeftMargin|
                                      UIViewAutoresizingFlexibleRightMargin|
                                      UIViewAutoresizingFlexibleBottomMargin)];
    }

    return _tabBar;
}

- (UIViewController *)selectedViewController {
    UIViewController *selectedVC = [self.viewcontrollerArray objectAtIndex:[self selectedIndex]];
    UIView *uiBarBackground = selectedVC.navigationController.navigationBar.subviews.firstObject;
    [uiBarBackground setCornerRadius:0 withShadow:YES withOpacity:0];
    return selectedVC;
}


-(void)setViewcontrollerArray:(NSArray *)viewcontrollerArray{
    
    if([viewcontrollerArray isKindOfClass:[NSArray class]]){
        _viewcontrollerArray=viewcontrollerArray;
        NSMutableArray *tabbarItems=[[NSMutableArray alloc]init];
        
        for(UIViewController *vc  in viewcontrollerArray){
            TNTabbarItem *tabbarItem=[[TNTabbarItem alloc]init];
            [tabbarItem setTitle:vc.title];
            [tabbarItems addObject:tabbarItem];
            [vc tn_setTnTabbarViewController:self];
        }
        [self.tabBar setItems:tabbarItems];
    }else{
        for (UIViewController *viewController in viewcontrollerArray) {
            [viewController tn_setTnTabbarViewController:nil];
        }
        
        _viewcontrollerArray = nil;
    }
}

-(NSInteger)indexOfObjectInViewController:(UIViewController *)vc{
    return [self.viewcontrollerArray indexOfObject:vc];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if(selectedIndex>=self.viewcontrollerArray.count){
        return;
    }
    if([self selectedViewController]){
        [[self selectedViewController] willMoveToParentViewController:nil];
        [[[self selectedViewController] view] removeFromSuperview];
        [[self selectedViewController] removeFromParentViewController];
    }
    
    _selectedIndex=selectedIndex;
    [[self tabBar] setSelectedItem:[[self tabBar] items][selectedIndex]];
    [self setSelectedViewController:[[self viewcontrollerArray] objectAtIndex:selectedIndex]];
    [self addChildViewController:[self selectedViewController]];
    
    CGRect contentViewFrame = [[self contentView] bounds];
      
    UIView * bgView   = [[self selectedViewController] view];
     [bgView setFrame:contentViewFrame];
 
    [[self contentView] addSubview:bgView];
    [[self selectedViewController] didMoveToParentViewController:self];

}

- (void)setIsTabbarHidden:(BOOL)isTabbarHidden {
    _isTabbarHidden = isTabbarHidden;
    
    CGSize frameSize=self.view.frame.size;
    CGFloat tabbarOriginalY=frameSize.height;
    CGFloat contentHeight=frameSize.height;
    CGFloat tabbarHeight=tn_tabbat_height;
 
    if(!_isTabbarHidden){    //如果不隐藏tabbar
        contentHeight-=tabbarHeight;
        tabbarOriginalY=frameSize.height-tabbarHeight;
        [self.tabBar setHidden:NO];
    }

    [_tabBar setFrame:CGRectMake(0, tabbarOriginalY, frameSize.width, tn_tabbat_height)];
    [_contentView setFrame:CGRectMake(0, 0, frameSize.width, contentHeight)];
    
}

#pragma mark tababrdelegate


- (BOOL)tabBar:(TNTabbar *)tabBar shouldSelectItemAtIndex:(NSInteger)index {
  
    if([[self delegate]respondsToSelector:@selector(tabBarController:shouldSelectViewController:)]){
        if(![self.delegate tabBarController:self shouldSelectViewController:self.viewcontrollerArray[index]]){
            return NO;
        }
    }
    
    if ([self selectedViewController] == [self viewcontrollerArray][index]) {
                if ([[self selectedViewController] isKindOfClass:[UINavigationController class]]) {
                    UINavigationController *selectedController = (UINavigationController *)[self selectedViewController];
        
                    if ([selectedController topViewController] != [selectedController viewControllers][0]) {
                        [selectedController popToRootViewControllerAnimated:YES];
                    }
                }
                
                return NO;
            }
    return YES;
    
}

- (void)tabBar:(TNTabbar *)tabBar didSelectItemAtIndex:(NSInteger)index {

    if (index < 0 || index >= [[self viewcontrollerArray] count]) {
        return;
    }
    [self setSelectedIndex:index];
    if (index == 2) {
       TNTabbarItem * item = tabBar.items[index];
        item.badgeValue = nil;
    }
    if ([[self delegate] respondsToSelector:@selector(tabBarController:didSelectViewController:)]) {
        [[self delegate] tabBarController:self didSelectViewController:[self viewcontrollerArray][index]];
    }
}


-(void)presentViewController:(UIImagePickerController *)imagePickerVC{
     [self presentViewController:imagePickerVC animated:YES completion:nil];
}
@end


#pragma mark tabbarviewcontrollerInternal & tabbaritem

@implementation UIViewController (TNTabbarViewControllerInternal)

-(void)tn_setTnTabbarViewController:(TNTabbarController *)tabbarVC{
    objc_setAssociatedObject(self, @selector(tnTabbarController), tabbarVC, OBJC_ASSOCIATION_ASSIGN);
}

@end

@implementation UIViewController (TNTabbarItem)
- (TNTabbarItem *)tnTabbarItem {
    TNTabbarController *tnvc=[self tnTabbarController];
    NSInteger index=[tnvc indexOfObjectInViewController:tnvc];
    return [tnvc.tabBar.items objectAtIndex:index];
}

- (void)tn_settabbarItem:(TNTabbarItem *)tnTabbarItem {
        TNTabbarController *vc = [self tnTabbarController];
        if(!vc){
            return;
        }
        TNTabbar *tabbar=[vc tabBar];
        NSInteger index=[vc indexOfObjectInViewController:vc];
        NSMutableArray *items=[[NSMutableArray alloc]initWithArray:tabbar.items];
        [items replaceObjectAtIndex:index withObject:tnTabbarItem];
        [tabbar setItems:items];
}

- (TNTabbarController *)tnTabbarController {
    TNTabbarController *tnvc=objc_getAssociatedObject(self, @selector(tnTabbarController));

    if(!tnvc && self.parentViewController){
        tnvc=self.parentViewController.tnTabbarController;
    }
    return tnvc;
}


-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return [FourPingTransition transitionWithTransitionType:XWPresentOneTransitionTypePresent];
}


@end

