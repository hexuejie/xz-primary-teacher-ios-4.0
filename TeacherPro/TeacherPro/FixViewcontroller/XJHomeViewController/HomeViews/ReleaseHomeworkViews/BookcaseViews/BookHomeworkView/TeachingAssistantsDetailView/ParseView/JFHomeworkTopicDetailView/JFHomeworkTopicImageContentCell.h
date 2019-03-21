//
//  JFHomeworkTopicImageContentCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/12/20.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QuestionModel;
@interface JFHomeworkTopicImageContentCell : UITableViewCell
- (void)setupModel:(QuestionModel *)model withImgHeight:(CGFloat) height withIndexPath:(NSInteger )index;
@end
