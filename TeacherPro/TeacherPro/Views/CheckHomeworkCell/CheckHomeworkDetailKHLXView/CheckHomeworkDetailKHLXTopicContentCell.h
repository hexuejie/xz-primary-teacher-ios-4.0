//
//  CheckHomeworkDetailKHLXTopicContentCell.h
//  TeacherPro
//
//  Created by DCQ on 2018/2/1.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  HomeworkDetailKHLXQuestionsModel;
typedef void(^CheckHomeworkDetailKHLXTopicButtonBlock)(NSIndexPath * indexPath);
@interface CheckHomeworkDetailKHLXTopicContentCell : UITableViewCell
@property(nonatomic, strong) NSIndexPath * indexPath;
@property(nonatomic, copy) CheckHomeworkDetailKHLXTopicButtonBlock buttonBlock;
- (void)setupTopicModel:(HomeworkDetailKHLXQuestionsModel *) model;
- (void)setupTopicDic:(NSDictionary *) itemDic;
@end
