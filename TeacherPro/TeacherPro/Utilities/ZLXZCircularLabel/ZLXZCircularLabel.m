
//
//  ZLXZCircularLabel.m
//  TeacherPro
//
//  Created by DCQ on 2018/7/17.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "ZLXZCircularLabel.h"
@interface ZLXZCircularLabel()
 
@end
@implementation ZLXZCircularLabel
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    return self;
}
- (void)setContentInset:(UIEdgeInsets)contentInset {
    _contentInset = contentInset;

    [self setNeedsDisplay];
}

-(void)drawTextInRect:(CGRect)rect {
    
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.contentInset)];
    
    CGRect bezierRect = rect;
    
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:bezierRect cornerRadius:bezierRect.size.height/2];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = bezierRect;
    maskLayer.path = bezierPath.CGPath;
    self.layer.mask = maskLayer;
}
@end
