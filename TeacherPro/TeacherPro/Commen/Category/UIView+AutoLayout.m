//
//  UIView+AutoLayout.m
//  autoLayout
//
//  Created by Kyle on 14-10-15.
//  Copyright (c) 2014年 yujiahui. All rights reserved.
//

#import "UIView+AutoLayout.h"

@implementation UIView(AutoLayout)

+(instancetype)autolayoutView
{
    UIView *view = [self new];
    view.backgroundColor = [UIColor clearColor];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    return view;
}





- (void)lx_removeAllConstraints
{
    UIView *superview = self.superview;
    while (superview != nil) {
        for (NSLayoutConstraint *c in superview.constraints) {
            if (c.firstItem == self || c.secondItem == self) {
                [superview removeConstraint:c];
            }
        }
        superview = superview.superview;
    }
    
    [self removeConstraints:self.constraints];
    self.translatesAutoresizingMaskIntoConstraints = YES;
}


@end
