//
//  LJRingChartView.h
//  LJChartViewDemo
//
//  Created by liujun on 2018/4/13.
//  Copyright © 2018年 liujun. All rights reserved.
// * RingChartView

#import <UIKit/UIKit.h>

@interface LJChartItem : NSObject

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) NSNumber *value;

@end


@interface LJRingChartView : UIView

@property (nonatomic, strong) NSArray<LJChartItem *> *chartItems; // every part color of chart
@property (nonatomic, readonly) UILabel *contentLabel;

@property (nonatomic, assign) CGFloat innerRingWidth; // default is 15
@property (nonatomic, assign) CGFloat outerRingWidth; // default is 2
@property (nonatomic, assign) CGFloat ringMargin; // default is 5
@property (nonatomic, assign) CGFloat dotMargin; // default is 10
@property (nonatomic, assign) CGSize dotSize; // default is CGSizeMake(5, 5)
@property (nonatomic, assign) BOOL hideDot; // default is NO
@property (nonatomic, assign) BOOL animate; // default is YES
@property (nonatomic, assign) CGFloat animateDuration; // default is 0.5

@end
