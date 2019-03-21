//
//  UIView+Corner.h
//  eShop
//
//  Created by Kyle on 14/11/3.
//  Copyright (c) 2014年 yujiahui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SMBSide) {
    kSMBSideLeft,
    kSMBSideRight,
    kSMBSideUp,
    kSMBSideBottom,
};

@interface UIView(Corner)


- (void)setCornerOnTopRadius:(CGFloat)radius;

- (void)setCornerOnBottomRadius:(CGFloat)radius;

- (void)setAllCornerRadius:(CGFloat)radius;

- (void)setSelfLayerCornerRadius:(CGFloat)radius;

- (void)setLayerWithCornerRadius:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

- (void)setNoneCorner;

- (void)roundSide:(SMBSide)side cornerRadius:(CGFloat)radius;

@end
