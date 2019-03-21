//
// UIImage+Color.h
// AplusProForTeacher
//
// Created by neon on 16/2/3.
// Copyright (c) 2016 neon. All rights reserved.
//

#import "UIImage+Color.h"
#import <CoreGraphics/CoreGraphics.h>

@implementation UIImage (Color)



+(UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end