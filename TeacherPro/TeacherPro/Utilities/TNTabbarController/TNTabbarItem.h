//
//  TNTabbarItem.h
//  AplusEduPro
//
//  Created by neon on 15/7/15.
//  Copyright (c) 2015年 neon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TNTabbarItem : UIControl

@property (nonatomic,copy  ) NSString     *title;
@property (nonatomic,strong) NSDictionary *titleSelectedAttrs;
@property (nonatomic,strong) NSDictionary *titleUnselectedAttrs;

@property (nonatomic,strong) UIImage *selectedItemImage;
@property (nonatomic,strong) UIImage *selectedItemBackgroundImage;
@property (nonatomic,strong) UIImage *unselectedItemBackgroundImage;
@property (nonatomic,strong) UIImage *unselectedItemImage;

@property (nonatomic,strong) NSString *badgeValue;

-(void)setSelectedItemImage:(UIImage *)selectedImage withUnselectedItemImage:(UIImage *)unselectedImage;

@end
