//
//  UIView+TNView.m
//  AplusKidsMasterPro
//
//  Created by neon on 16/4/18.
//  Copyright © 2016年 neon. All rights reserved.
//

#import "UIView+TNView.h"
#import "CommonConfig.h"
//IB_DESIGNABLE
@implementation UIView (TNView)

#pragma mark - setCornerRadius/borderWidth/borderColor
- (void)setCornerRadius:(CGFloat)cornerRadius{
    self.layer.cornerRadius = FITSCALE(cornerRadius);
    self.layer.masksToBounds = cornerRadius > 0;
    
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
}

- (CGFloat)cornerRadius{
    
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    
    return self.layer.cornerRadius;
}

- (void)setBorderWidth:(CGFloat)borderWidth{
    
   
    self.layer.borderWidth = FITSCALE(borderWidth);
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

- (CGFloat)borderWidth{
    return self.layer.borderWidth;
}

- (void)setBorderColor:(UIColor *)borderColor{
    self.layer.borderColor = borderColor.CGColor;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

- (UIColor *)borderColor{
    return [UIColor colorWithCGColor:self.layer.borderColor];
}


- (void)setMasksToBounds:(BOOL)bounds{
    self.layer.masksToBounds = bounds;
}

- (BOOL)masksToBounds{
    return self.layer.masksToBounds;
}




@end
