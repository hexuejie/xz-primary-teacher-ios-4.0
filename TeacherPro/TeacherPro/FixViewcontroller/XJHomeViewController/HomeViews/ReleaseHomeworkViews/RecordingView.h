//
//  RecordingCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/6/8.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RecordingBlock)(NSURL * recordingUrl,NSURL *mp3Url,NSInteger totalLength);
@interface RecordingView : UIView
-(instancetype)initWithFrame:(CGRect)frame;
@property (nonatomic, copy) RecordingBlock saveRecordingBlock;
@end

@interface CircleView : UIView

@property (nonatomic, assign) CGFloat progress;

@end
