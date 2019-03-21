//
//  FeedbackCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/6/5.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  FeedbackModel;

@interface FeedbackCell : UITableViewCell
- (void)setupCellInfo:(FeedbackModel *)model withSelected:(BOOL)state;

@end
