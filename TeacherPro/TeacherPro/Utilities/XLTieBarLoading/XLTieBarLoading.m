//
//  XLTieBarLoading.m
//  XLTieBarLoadingDemo
//
//  Created by MengXianLiang on 2017/3/7.
//  Copyright © 2017年 MengXianLiang. All rights reserved.
//

#import "XLTieBarLoading.h"
#import "PublicDocuments.h"
@interface XLTieBarLoading ()
{
    CADisplayLink *_disPlayLink;
    /**
     曲线的振幅
     */
    CGFloat _waveAmplitude;
    /**
     曲线角速度
     */
    CGFloat _wavePalstance;
    /**
     曲线初相
     */
    CGFloat _waveX;
    /**
     曲线偏距
     */
    CGFloat _waveY;
    /**
     曲线移动速度
     */
    CGFloat _waveMoveSpeed;
    
    //背景发暗的图片 蓝底白字
    UIImageView *_imageView1;
    
    //前面正常显示的图片 蓝底白字
    UIImageView *_imageView2;
    
    //动画的容器
    UIView *_container;
}
@end

@implementation XLTieBarLoading

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
        [self buildData];
    }
    return self;
}

-(void)buildUI
{

    
//    [self addSubview:self.shadeView];
    [self addAnimation];
}

//- (UIView *)shadeView{
//    if (!_shadeView) {
//        _shadeView = [[UIView alloc]initWithFrame:self.frame];
//        _shadeView.backgroundColor = self.shadeColor?self.shadeColor:[UIColor blackColor];
//         _shadeView.alpha = self.shadeAlpha?self.shadeAlpha:0.6;
//    }
//    return _shadeView;
//}
//- (void)setShadeColor:(UIColor *)shadeColor{
//
//    _shadeColor = shadeColor;
//     _shadeView.backgroundColor = self.shadeColor?self.shadeColor:[UIColor blackColor];
//}
//
//- (void)setShadeAlpha:(CGFloat)shadeAlpha{
//    _shadeAlpha = shadeAlpha;
//     _shadeView.alpha = self.shadeAlpha?self.shadeAlpha:0.6;
//    
//}
//初始化数据
-(void)buildData
{
    //振幅
    _waveAmplitude = 3;
    //角速度
    _wavePalstance = 0.12;
    //偏距
    _waveY = _container.bounds.size.height;
    //初相
    _waveX = 0;
    //x轴移动速度
    _waveMoveSpeed = 0.15;
    //y轴偏移量
    _waveY = _container.bounds.size.height/2.0f;
    //以屏幕刷新速度为周期刷新曲线的位置
    _disPlayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateWave)];
    [_disPlayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    _disPlayLink.paused = true;
}

-(void)updateWave
{
    _waveX -= _waveMoveSpeed;
//    [self updateWave1];
//    [self updateWave2];
    
    
}
#pragma mark 添加动画
- (void)addAnimation
{
    CGFloat width = 20;
    CGFloat x =  self.center.x- width/2 - (width+5) ;
    CGFloat y = self.center.y-width/2;
    
  
    
    for (NSInteger index = 0; index < 3; ++index)
    {
        CALayer *cirlce = [CALayer layer];
        [cirlce setFrame:CGRectMake(x + (width+5) * index, y, width, width)];
     
        [cirlce setBackgroundColor:project_main_blue.CGColor];
        [cirlce setCornerRadius:width/2];
        [self.layer addSublayer:cirlce];
        
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        [anim setFromValue:@0.2];//缩小倍数
        [anim setToValue:@1];//放大倍数
        [anim setAutoreverses:YES];
        [anim setDuration:0.4];
        [anim setRemovedOnCompletion:YES];
        [anim setBeginTime:CACurrentMediaTime()+0.2*index-1];
        [anim setRepeatCount:INFINITY];
        
        [anim setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [cirlce addAnimation:anim forKey:nil];
        
    }
}

-(void)updateWave1
{
    //波浪宽度
    CGFloat waterWaveWidth = _container.bounds.size.width;
    //初始化运动路径
    CGMutablePathRef path = CGPathCreateMutable();
    //设置起始位置
    CGPathMoveToPoint(path, nil, 0, _waveY);
    //初始化波浪其实Y为偏距
    CGFloat y = _waveY;
    //正弦曲线公式为： y=Asin(ωx+φ)+k;
    for (float x = 0.0f; x <= waterWaveWidth ; x++) {
        y = _waveAmplitude * sin(_wavePalstance * x + _waveX + 1) + _waveY;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    //填充底部颜色
    CGPathAddLineToPoint(path, nil, waterWaveWidth, _container.bounds.size.height);
    CGPathAddLineToPoint(path, nil, 0, _container.bounds.size.height);
    CGPathCloseSubpath(path);
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path;
    _imageView1.layer.mask = layer;
    CGPathRelease(path);
}

-(void)updateWave2
{
    //波浪宽度
    CGFloat waterWaveWidth = _container.bounds.size.width;
    //初始化运动路径
    CGMutablePathRef path = CGPathCreateMutable();
    //设置起始位置
    CGPathMoveToPoint(path, nil, 0, _waveY);
    //初始化波浪其实Y为偏距
    CGFloat y = _waveY;
    //正弦曲线公式为： y=Asin(ωx+φ)+k;
    for (float x = 0.0f; x <= waterWaveWidth ; x++) {
        y = _waveAmplitude * sin(_wavePalstance * x + _waveX) + _waveY;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    //添加终点路径、填充底部颜色
    CGPathAddLineToPoint(path, nil, waterWaveWidth, _container.bounds.size.height);
    CGPathAddLineToPoint(path, nil, 0, _container.bounds.size.height);
    CGPathCloseSubpath(path);
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path;
    _imageView2.layer.mask = layer;
    CGPathRelease(path);
}

#pragma mark -
#pragma mark 显示/隐藏方法

-(void)show{
    _disPlayLink.paused = false;
}

-(void)hide{
    _disPlayLink.paused = true;
}

+(void)showInView:(UIView *)view showShadeBg:(BOOL) showShadeState {
    
    XLTieBarLoading *loading = [[XLTieBarLoading alloc] initWithFrame:CGRectOffset(view.bounds, 0, 0)];
    loading.tag = 232323;
    if (showShadeState) {
        loading.shadeAlpha = 0.6;
        loading.shadeColor = [UIColor blackColor];
    }else{
        loading.shadeAlpha = 1;
        loading.shadeColor = [UIColor clearColor];
    }
    [view addSubview:loading];
    [view bringSubviewToFront:loading];
    [loading show];
    
}

+(void)hideInView:(UIView *)view{
    for (XLTieBarLoading *loading in view.subviews) {
        if ([loading isKindOfClass:[XLTieBarLoading class]]) {
            [loading hide];
            [loading removeFromSuperview];
        }
    }
}

-(void)dealloc
{
    if (_disPlayLink) {
        [_disPlayLink invalidate];
        _disPlayLink = nil;
    }
    
    if (_imageView1) {
        [_imageView1 removeFromSuperview];
        _imageView1 = nil;
    }
    if (_imageView2) {
        [_imageView2 removeFromSuperview];
        _imageView2 = nil;
    }
}

@end
