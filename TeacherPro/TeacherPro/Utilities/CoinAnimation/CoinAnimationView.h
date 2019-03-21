//
//  Animation_View.h
//  EmitterDemo
//
//  Created by yangjian on 2017/2/13.
//  Copyright © 2017年 赵飞宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoinAnimationView : UIView

@property (nonatomic, strong)UILabel * showLable;// +5金币
@property(nonatomic,strong)UIView *backgroundView;//背景
@property(nonatomic,strong)UIImage *iconImage;//粒子要展示的图片


-(instancetype)initWithFrame:(CGRect)frame;

/** 开始动画*/
-(void)beginAnimationMethod;

/** 动画结束调用block*/
@property(nonatomic,copy) void (^endAnimationBlock)();

@end
