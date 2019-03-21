//
//  UINavigationController+Block.m
//  eShop
//
//  Created by Kyle on 14/10/21.
//  Copyright (c) 2014年 yujiahui. All rights reserved.
//

#import "UINavigationController+Block.h"

static id weakObject(id object) {
    __block typeof(object) weakSelf = object;
    return weakSelf;
}


static void(^_completionBlock)(void) ;
static UIViewController *_viewController;

@implementation UINavigationController(Block)

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated onCompletion:(void(^)(void))completion
{
    [CATransaction begin];
    [CATransaction setCompletionBlock:completion];
    [self pushViewController:viewController animated:animated];
    [CATransaction commit];
    
//    [self setCompletionBlock:completion viewController:viewController delegate:weakObject(self)];
//    [self pushViewController:_viewController animated:animated];
    
}

- (void)popToViewController:(UIViewController *)viewController animated:(BOOL)animated onCompletion:(void(^)(void))completion
{
    
    [CATransaction begin];
    [CATransaction setCompletionBlock:completion];
    [self popToViewController:viewController animated:animated];
    [CATransaction commit];
    
}

- (void)popViewControllerAnimated:(BOOL)animated onCompletion:(void(^)(void))completion
{
    NSUInteger index = [self.viewControllers indexOfObject:self.visibleViewController];
    
    if (index > 0) {
        
        index--;
        UIViewController *viewController = [self.viewControllers objectAtIndex:index];
        
        [CATransaction begin];
        [CATransaction setCompletionBlock:completion];
        [self popToViewController:viewController animated:animated];
        [CATransaction commit];
    }
}

- (void)popToRootViewControllerAnimated:(BOOL)animated onCompletion:(void(^)(void))completion
{
    NSUInteger index = [self.viewControllers indexOfObject:self.visibleViewController];
    
    if (index > 0) {
        
        UIViewController *viewController = [self.viewControllers objectAtIndex:0];
        
        [CATransaction begin];
        [CATransaction setCompletionBlock:completion];
        [self popToRootViewControllerAnimated:animated];
        [CATransaction commit];
    
    }
}

//- (void)setCompletionBlock:(void(^)(void))completion viewController:(UIViewController *)viewController delegate:(id)delegate
//{
//    if (!completion) {
//        return;
//    }
//    
//    _completionBlock  = [completion copy];
//    _viewController = viewController;
//    
//    self.delegate = delegate;
//}
//
//- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    if ([viewController isEqual:_viewController] && _completionBlock) {
//        _completionBlock();
//        _viewController = nil;
//    }
//}


@end
