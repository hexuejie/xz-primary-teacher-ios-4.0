//
//  ReleaseVoiceworkCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/6/13.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ReleaseVoiceButtonBlock)();
@interface ReleaseVoiceworkCell : UITableViewCell
@property (nonatomic, copy) ReleaseVoiceButtonBlock deleteBlock;
- (void)updateVoice:(NSURL *)url;
- (void)stopPlayer;
@end
