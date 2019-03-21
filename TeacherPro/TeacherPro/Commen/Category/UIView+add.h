//
//  UIView+add.h
//  TeacherPro
//
//  Created by 何学杰 on 2018/12/21.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (add)

- (void)setCornerRadius:(CGFloat)radius withShadow:(BOOL)shadow withOpacity:(CGFloat)opacity;

- (void)setCornerRadius:(CGFloat)radius withShadow:(BOOL)shadow withOpacity:(CGFloat)opacity withAlpha:(CGFloat)alpha ;

- (void)setCornerRadius:(CGFloat)radius withShadow:(BOOL)shadow withOpacity:(CGFloat)opacity withAlpha:(CGFloat)alpha withCGSize:(CGSize)size;
@end

NS_ASSUME_NONNULL_END
