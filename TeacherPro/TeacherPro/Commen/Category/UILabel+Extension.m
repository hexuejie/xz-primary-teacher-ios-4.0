
//
//  UILabel+Extension.m
//  lexiwed2
//
//  Created by Kyle on 2017/5/3.
//  Copyright © 2017年 乐喜网. All rights reserved.
//

#import "UILabel+Extension.h"

@implementation UILabel(Extension)

-(BOOL)isTextTruncated

{
    CGRect testBounds = self.bounds;
    testBounds.size.height = NSIntegerMax;
    CGRect limitActual = [self textRectForBounds:[self bounds] limitedToNumberOfLines:self.numberOfLines];
    CGRect limitTest = [self textRectForBounds:testBounds limitedToNumberOfLines:self.numberOfLines + 1];
    return limitTest.size.height>limitActual.size.height;
}

@end
