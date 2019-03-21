//
//  MessageVoiceView.h
//  TeacherPro
//
//  Created by DCQ on 2017/6/29.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MessageVoiceViewPlayBlock)(BOOL playBtnSelected);
@interface MessageVoiceView : UIView
@property(nonatomic, strong)  UILabel *timeLabel;
@property(nonatomic, strong)  UIButton *playButton;
@property(nonatomic, strong)  UIProgressView *progressView;
@property(nonatomic, assign)  NSInteger totalVoiceDuration;

@property(nonatomic, copy)MessageVoiceViewPlayBlock  playBlock;
- (void)setupVoiceDuration:(NSNumber *)voiceDuration;
- (void)resetVoiceView;
@end
