//
//  Animation_View.m
//  EmitterDemo
//
//  Created by yangjian on 2017/2/13.
//  Copyright © 2017年 赵飞宇. All rights reserved.
//

#import "CoinAnimationView.h"
@interface CoinAnimationView()

@property (nonatomic, strong)CAEmitterLayer * emitterLayer;

@end

@implementation CoinAnimationView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Do any additional setup after loading the view, typically from a nib.
        [self setupSubView];
        [self createEmitter];
    }
    return self;
}

- (void)setupSubView{
    
    [self addSubview:self.showLable];
     self.showLable.hidden = YES;
//    UIView * grayView = [[UIView alloc] initWithFrame:self.frame];
//    grayView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
//    [self addSubview:self.backgroundView = grayView];
    [self addSubview:self.backgroundView];
    self.backgroundView.hidden = YES;
}

- (UIView *)backgroundView{
    if (!_backgroundView) {
       _backgroundView  =[[UIView alloc] initWithFrame:self.frame];
       _backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    }
    return _backgroundView;
}
- (UILabel *)showLable{
    if (!_showLable) {
        _showLable= [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 50)];
        _showLable.center = CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0);
        _showLable.text = @"+5";
        _showLable.textAlignment = NSTextAlignmentCenter;
        _showLable.textColor = [UIColor colorWithRed:254/255.0 green:211/255.0 blue:10/255.0 alpha:1];
    }
    return  _showLable;
}
 //粒子动画
- (void)createEmitter{
    
        //发射源
        CAEmitterLayer * emitter = [CAEmitterLayer layer];
        emitter.frame = CGRectMake(0, 0, CGRectGetWidth(self.showLable.frame), CGRectGetHeight(self.showLable.frame));
        [self.showLable.layer addSublayer:self.emitterLayer = emitter];
        //发射源形状
        emitter.emitterShape = kCAEmitterLayerCircle;
        //发射模式
        emitter.emitterMode = kCAEmitterLayerOutline;
        //渲染模式
        //    emitter.renderMode = kCAEmitterLayerAdditive;
        //发射位置
        emitter.emitterPosition = CGPointMake(self.showLable.frame.size.width/2.0, self.showLable.frame.size.height/2.0);
        //发射源尺寸大小
        emitter.emitterSize = CGSizeMake(20, 20);
        
        // 从发射源射出的粒子
        {
            CAEmitterCell * cell = [CAEmitterCell emitterCell];
            cell.name = @"zanShape";
            //粒子要展现的图片
            if (self.iconImage != nil) {
                cell.contents = (__bridge id)self.iconImage.CGImage;
            }else{
                cell.contents = (__bridge id)[UIImage imageNamed:@"coin_icon"].CGImage;
            }
            //    cell.contents = (__bridge id)[UIImage imageNamed:@"EffectImage"].CGImage;
            //            cell.contentsRect = CGRectMake(100, 100, 100, 100);
            //粒子透明度在生命周期内的改变速度
            cell.alphaSpeed = -0.5;
            //生命周期
            cell.lifetime = 3.0;
            //粒子产生系数(粒子的速度乘数因子)
            cell.birthRate = 0;
            //粒子速度
            cell.velocity = 300;
            //速度范围
            cell.velocityRange = 100;
            //周围发射角度
            cell.emissionRange = M_PI / 8;
            //发射的z轴方向的角度
            cell.emissionLatitude = -M_PI;
            //x-y平面的发射方向
            cell.emissionLongitude = -M_PI / 2;
            //粒子y方向的加速度分量
            cell.yAcceleration = 250;
            emitter.emitterCells = @[cell];
        }
    
}
/**
 *  开始动画
 */
-(void)beginAnimationMethod{
    
    __weak typeof(self)bself = self;
    self.showLable.hidden = NO;
    self.backgroundView.hidden = NO;
    [UIView animateWithDuration:2.f delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:5 options:UIViewAnimationOptionCurveLinear animations:^{
        CABasicAnimation * effectAnimation = [CABasicAnimation animationWithKeyPath:@"emitterCells.zanShape.birthRate"];
        effectAnimation.fromValue = [NSNumber numberWithFloat:30];
        effectAnimation.toValue = [NSNumber numberWithFloat:0];
        effectAnimation.duration = 0.0f;
        effectAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        [bself.emitterLayer addAnimation:effectAnimation forKey:@"zanCount"];
        //放大动画
        {
            CABasicAnimation * aniScale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            aniScale.fromValue = [NSNumber numberWithFloat:0.5];
            aniScale.toValue = [NSNumber numberWithFloat:3.0];
            aniScale.duration = 1.5;
            aniScale.delegate = self;
            aniScale.removedOnCompletion = NO;
            aniScale.repeatCount = 1;
            [bself.showLable.layer addAnimation:aniScale forKey:@"babyCoin_scale"];
        }
    } completion:^(BOOL finished) {
        
    }];
    
    [UIView animateWithDuration:3.0 animations:^{
        bself.backgroundView.alpha = 0;
    }];
}
/**
 *  动画结束代理方法
 */
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (anim == [self.showLable.layer animationForKey:@"babyCoin_scale"]) {
        [self babyCoinFadeAway];
#warning 等文字下落完毕后调用动画加载完毕Block
        if (self.endAnimationBlock) {//动画结束
            self.endAnimationBlock();
        }
    }
    if (anim == [self.showLable.layer animationForKey:@"aniMove_aniScale_groupAnimation"]) {
        self.showLable.hidden = YES;
        self.backgroundView.alpha = 0.6;
        self.backgroundView.hidden = YES;
    }
}
/**
 *  金币散开结束后文字下落动画
 */
-(void)babyCoinFadeAway
{
    CGFloat aPPW = [UIScreen mainScreen].bounds.size.width;
    CGFloat aPPH = [UIScreen mainScreen].bounds.size.height;
    CABasicAnimation * aniMove = [CABasicAnimation animationWithKeyPath:@"position"];
    aniMove.fromValue = [NSValue valueWithCGPoint:self.showLable.layer.position];
    
    aniMove.toValue = [NSValue valueWithCGPoint:CGPointMake(aPPW, aPPH)];
    
    CABasicAnimation * aniScale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    aniScale.fromValue = [NSNumber numberWithFloat:3.0];
    aniScale.toValue = [NSNumber numberWithFloat:0.5];
    
    CAAnimationGroup * aniGroup = [CAAnimationGroup animation];
    aniGroup.duration = 1.0;
    aniGroup.repeatCount = 1;
    aniGroup.delegate = self;
    aniGroup.animations = @[aniMove,aniScale];
    aniGroup.removedOnCompletion = NO;
    //    aniGroup.fillMode = kCAFillModeForwards;  //防止动画结束后回到原位
    [self.showLable.layer removeAllAnimations];
    [self.showLable.layer addAnimation:aniGroup forKey:@"aniMove_aniScale_groupAnimation"];
    
}


@end
