//
//  HomeworkProblemsTopicContentCell.h
//  TeacherPro
//
//  Created by DCQ on 2018/1/22.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HomeworkProblemsTopicButtonBlock)(BOOL btnSelected,NSIndexPath * indexPath);
@class HomeworkProblemsQuestionsModel;
@interface HomeworkProblemsTopicContentCell : UITableViewCell
@property(nonatomic, strong) NSIndexPath * indexPath;
@property(nonatomic, copy) HomeworkProblemsTopicButtonBlock buttonBlock;
- (void)setupTopicModel:(HomeworkProblemsQuestionsModel *) model;

- (void)setupTopicDic:(NSDictionary *) itemDic;
- (void)setupBtnSelectedState:(BOOL)state;

@end
