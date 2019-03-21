//
//  FeedbackViewController.h
//  TeacherPro
//
//  Created by DCQ on 2017/6/2.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BaseTableViewController.h"

@class FeedbackModel;
typedef void(^FeedbackBlock)(FeedbackModel *model,NSInteger  index);
@interface FeedbackViewController : BaseTableViewController
- (instancetype)initWithIndex:(NSInteger )index;
@property(nonatomic, copy) FeedbackBlock  feedbackBlock;
@end
