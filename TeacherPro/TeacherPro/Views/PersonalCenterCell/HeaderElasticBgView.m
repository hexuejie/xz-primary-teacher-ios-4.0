//
//      ┏┛ ┻━━━━━┛ ┻┓
//      ┃　　　　　　 ┃
//      ┃　　　━　　　┃
//      ┃　┳┛　  ┗┳　┃
//      ┃　　　　　　 ┃
//      ┃　　　┻　　　┃
//      ┃　　　　　　 ┃
//      ┗━┓　　　┏━━━┛
//        ┃　　　┃   神兽保佑
//        ┃　　　┃   代码无BUG！
//        ┃　　　┗━━━━━━━━━┓
//        ┃　　　　　　　    ┣┓
//        ┃　　　　         ┏┛
//        ┗━┓ ┓ ┏━━━┳ ┓ ┏━┛
//          ┃ ┫ ┫   ┃ ┫ ┫
//          ┗━┻━┛   ┗━┻━┛
//
//  PersonalHeaderBgView.m
//  TeacherPro
//
//  Created by DCQ on 2017/7/18.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//


#import "HeaderElasticBgView.h"
#import "PublicDocuments.h"
@interface HeaderElasticBgView ()
@property(nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, assign) CGFloat progress;
@end

@implementation HeaderElasticBgView

- (CAShapeLayer *)shapeLayer{
    if (!_shapeLayer) {
        _shapeLayer = [CAShapeLayer layer];
         _shapeLayer.fillColor = [UIColor clearColor].CGColor;
    }
    return _shapeLayer;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self.layer addSublayer:self.shapeLayer];
    }
    return self;
}
- (void)drawRect:(CGRect)rect
{
    
    CGFloat pathHeight = self.frame.size.height;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0,pathHeight)];
    [path addLineToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake([UIScreen mainScreen].bounds.size.width, 0)];
    [path addLineToPoint:CGPointMake([UIScreen mainScreen].bounds.size.width, pathHeight)];
    [path addCurveToPoint:CGPointMake(0, pathHeight) controlPoint1:CGPointMake([UIScreen mainScreen].bounds.size.width,  self.frame.size.height) controlPoint2:CGPointMake([UIScreen mainScreen].bounds.size.width/2,  self.frame.size.height - self.progress*2.2)];
    
    [path closePath];
    
    if (self.layerColor) {
        self.shapeLayer.fillColor = self.layerColor.CGColor;
    }
    self.shapeLayer.path = path.CGPath;
   
}

- (void)layoutSubviews
{
    NSLog(@"setNeedsLayout");
}

- (void)setupProgress:(CGFloat)progress{

    self.progress = progress;
    [self setNeedsDisplay];
}
//- (void)setProgress:(CGFloat)progress
//{
//    
//    _progress = progress;
//    
//    [self setNeedsDisplay];
//}

@end
