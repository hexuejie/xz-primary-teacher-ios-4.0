 
//  WebProgressLayer.h
//  TeacherPro
//
//  Created by DCQ on 2017/6/16.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface WebProgressLayer : CAShapeLayer

+ (instancetype)layerWithFrame:(CGRect)frame;
- (void)finishedLoad;
- (void)startLoad;

- (void)closeTimer;

@end
@interface NSTimer (WebProgressLayer)

- (void)pause;
- (void)resume;
- (void)resumeWithTimeInterval:(NSTimeInterval)time;

@end
