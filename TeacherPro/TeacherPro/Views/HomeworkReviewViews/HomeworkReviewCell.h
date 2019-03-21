//
//  HomeworkReviewCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/7/19.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomeworkReviewModel;
@interface HomeworkReviewCell : UITableViewCell
- (void)setupHomeworkReviewInfo:(HomeworkReviewModel *)model;
@end
