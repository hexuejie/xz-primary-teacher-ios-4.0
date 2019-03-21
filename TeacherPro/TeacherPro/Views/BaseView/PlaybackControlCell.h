//
//  PlaybackControlCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/7/9.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>


@class PlaybackControlCell ;
typedef void(^PlaybackControlCellPlayBlock)(BOOL playBtnSelected,PlaybackControlCell *cell);

typedef void(^PlaybackControlCellPlayIndexPathBlock)(BOOL playBtnSelected,PlaybackControlCell *cell,NSIndexPath * indexPath);
@interface PlaybackControlCell : UITableViewCell
@property(nonatomic, strong) NSIndexPath * indexPath;

@property(nonatomic, strong)IBOutlet  UIButton *playButton;
@property (nonatomic, strong) IBOutlet UIView *fatherView;
 @property(nonatomic, strong)IBOutlet  UILabel *timeLabel;

@property(nonatomic, copy)PlaybackControlCellPlayBlock  playBlock;
@property(nonatomic, copy)PlaybackControlCellPlayIndexPathBlock  playIndexPathBlock;
- (void)setupVoiceDuration:(NSNumber *)voiceDuration;
- (void)resetVoiceView;
@end
