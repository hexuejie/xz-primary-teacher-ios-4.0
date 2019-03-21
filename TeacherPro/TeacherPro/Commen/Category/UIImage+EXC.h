//
//  UIImage+EXC.h
//  eShop
//
//  Created by Kyle on 14/10/22.
//  Copyright (c) 2014年 yujiahui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage(EXC)

- (UIImage *)scaleToSize:(CGSize)size;
- (UIImage *)imageByScalingAndCroppingForSize:(CGSize)targetSize;
- (UIImage *)imageZipCroppingForSize:(CGSize)targetSize;
- (NSData *)compressQualityWithMaxLength:(NSInteger)maxLength;
@end
