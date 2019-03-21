//
//  TeachingAssistantsListBigAudioCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/11/7.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QuestionModel ;
typedef void(^TAPlayBlock)(NSArray * audioUrls);
@interface TeachingAssistantsListBigAudioCell : UITableViewCell
@property (nonatomic, strong) TAPlayBlock playBlock;
- (void)setupModel:(QuestionModel *)model;
- (void)setupPlayState:(BOOL)state;
@end
