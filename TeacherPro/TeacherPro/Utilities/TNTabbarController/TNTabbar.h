//
//  TNTabbar.h
//  AplusEduPro
//
//  Created by neon on 15/7/15.
//  Copyright (c) 2015年 neon. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TNTabbarItem.h"
@class TNTabbar;
@protocol TNTabbarDelegate <NSObject>

-(BOOL)tabBar:(TNTabbar *)tabBar shouldSelectItemAtIndex:(NSInteger)index;
-(void)tabBar:(TNTabbar *)tabBar didSelectItemAtIndex:(NSInteger)index;
@end


@interface TNTabbar : UIView
@property (nonatomic,weak  ) id<TNTabbarDelegate> delegate;
@property (nonatomic,strong) NSArray          *items;
@property (nonatomic,strong) TNTabbarItem     *selectedItem;
@property (nonatomic,readonly) UIView           *tabbarBgView;
@property (nonatomic       ) CGFloat          tabbarHeight;
@property BOOL ishidden;
@end
