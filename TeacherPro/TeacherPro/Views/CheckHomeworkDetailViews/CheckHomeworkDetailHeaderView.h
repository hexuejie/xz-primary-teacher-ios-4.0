//
//  CheckHomeworkDetailHeaderView.h
//  TeacherPro
//
//  Created by DCQ on 2018/7/11.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZCircleProgress.h"

@class CHWInfoModel;
typedef void(^FeedbackBlock)();

@interface CheckHomeworkDetailHeaderView : UIView
@property (nonatomic, copy) FeedbackBlock feedbackBlock;
- (void)setupHeaderData:(CHWInfoModel*)data withCheckState:(BOOL)state;
@end
