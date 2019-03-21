//
//  PreviewPictureBookAudioViewController.h
//  TeacherPro
//
//  Created by DCQ on 2017/9/11.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//
//绘本播放音乐

#import "BaseNetworkViewController.h"

@interface PreviewPictureBookAudioViewController : BaseNetworkViewController
- (instancetype)initWithName:(NSString *)pictureTitle withData:(NSArray *)playArray;
@end
