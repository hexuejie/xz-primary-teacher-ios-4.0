//
//  StudentKHLXHomeworkTopicContentCell.h
//  TeacherPro
//
//  Created by DCQ on 2018/2/1.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StudentKHLXHomeworkDetailQuestionModel;
@interface StudentKHLXHomeworkTopicContentCell : UITableViewCell
- (void)setupTopicModel:(StudentKHLXHomeworkDetailQuestionModel *) model;
- (void)setupTopicDic:(NSDictionary *) itemDic;
@end
