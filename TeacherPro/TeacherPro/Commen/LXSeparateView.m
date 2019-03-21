//
//  LXSeparateView.m
//  lexiwed2
//
//  Created by Kyle on 2017/4/22.
//  Copyright © 2017年 乐喜网. All rights reserved.
//

#import "LXSeparateView.h"

@interface LXSeparateView()

@end


@implementation LXSeparateView

-(id)init{

    return [self initWithFrame:CGRectZero];
}

-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        [self setup];
    }
    return self;
}


-(void)setup{

    _lineColor = HexRGB(0xeeeeee);
}

-(void)setLineColor:(UIColor *)lineColor{
    _lineColor = lineColor;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextBeginPath(context);


    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, self.bounds.size.width, 0);


    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    CGContextStrokePath(context);
}



@end
