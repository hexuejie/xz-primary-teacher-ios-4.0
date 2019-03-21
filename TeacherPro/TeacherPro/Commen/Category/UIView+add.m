//
//  UIView+add.m
//  TeacherPro
//
//  Created by 何学杰 on 2018/12/21.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "UIView+add.h"

@implementation UIView (add)


- (void)setCornerRadius:(CGFloat)radius withShadow:(BOOL)shadow withOpacity:(CGFloat)opacity {
    self.layer.cornerRadius = radius;
    if (shadow) {
        self.layer.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.05].CGColor;//0.05
        self.layer.shadowOpacity = opacity;
        self.layer.shadowOffset = CGSizeMake(0, 8);
        self.layer.shadowRadius = 5;
        self.layer.shouldRasterize = NO;
        self.layer.shadowPath = [[UIBezierPath bezierPathWithRoundedRect:[self bounds] cornerRadius:radius] CGPath];
    }
    self.layer.masksToBounds = !shadow;
}

- (void)setCornerRadius:(CGFloat)radius withShadow:(BOOL)shadow withOpacity:(CGFloat)opacity withAlpha:(CGFloat)alpha {
    self.layer.cornerRadius = radius;
    if (shadow) {
        self.layer.shadowColor = [UIColor colorWithWhite:0.0 alpha:alpha].CGColor;//0.05
        self.layer.shadowOpacity = opacity;
        self.layer.shadowOffset = CGSizeMake(0, 8);
        self.layer.shadowRadius = 5;
        self.layer.shouldRasterize = NO;
        self.layer.shadowPath = [[UIBezierPath bezierPathWithRoundedRect:[self bounds] cornerRadius:radius] CGPath];
    }
    self.layer.masksToBounds = !shadow;
}

- (void)setCornerRadius:(CGFloat)radius withShadow:(BOOL)shadow withOpacity:(CGFloat)opacity withAlpha:(CGFloat)alpha withCGSize:(CGSize)size{
    self.layer.cornerRadius = radius;
    if (shadow) {
        self.layer.shadowColor = [UIColor colorWithWhite:0.0 alpha:alpha].CGColor;//0.05
        self.layer.shadowOpacity = opacity;
        self.layer.shadowOffset = size;
        self.layer.shadowRadius = 5;
        self.layer.shouldRasterize = NO;
        self.layer.shadowPath = [[UIBezierPath bezierPathWithRoundedRect:[self bounds] cornerRadius:radius] CGPath];
    }
    self.layer.masksToBounds = !shadow;
}

@end
