//
//  UIBarButtonItem+LXExtension.m
//  lexiwed2
//
//  Created by LEXIWED on 2017/12/22.
//  Copyright © 2017年 乐喜网. All rights reserved.
//

#import "UIBarButtonItem+LXExtension.h"

@implementation UIBarButtonItem (LXExtension)

+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    return [[self alloc] initWithCustomView:button];
    
}
@end
