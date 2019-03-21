//
//  TeachingAssistantsListBigItemAudioCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/12/18.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QuestionAnalysisAudioModel ;
@class TeachingAssistantsListBigItemAudioCell;

 
typedef void(^TABigItemPlaybackControlCellPlayIndexPathBlock)(BOOL playBtnSelected,TeachingAssistantsListBigItemAudioCell *cell,NSIndexPath * indexPath);

@interface TeachingAssistantsListBigItemAudioCell : UITableViewCell
@property(nonatomic, strong) NSIndexPath * indexPath;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property(nonatomic, copy)TABigItemPlaybackControlCellPlayIndexPathBlock  playIndexPathBlock;
- (void)setupVoiceDuration:(NSString *)voiceDuration;
- (void)resetVoiceView;

@end
