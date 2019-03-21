//
//  JFHomeworkQuestionViewController.h
//  TeacherPro
//
//  Created by DCQ on 2017/12/25.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BaseTableViewController.h"
@class JFHomeworkQuestionModel;
@class QuestionModel;
@interface JFHomeworkQuestionViewController : BaseTableViewController
@property(nonatomic, copy)  NSString *homeworkId;
@property(nonatomic, strong) JFHomeworkQuestionModel * questionModel;
- (instancetype)initWithHomeworkId:(NSString *)homeworkId withBookId:(NSString *)bookId withBookHomeworkId:(NSString *)bookHomeworkId ;
- (instancetype)initWithHomeworkId:(NSString *)homeworkId withBookId:(NSString *)bookId withBookHomeworkId:(NSString *)bookHomeworkId withHomeworkTypeId:(NSString *)homeworkTypeId;
- (QuestionModel *)getQuesionModel:(NSInteger)section;
- (void)gotoJFHomeworkTopicDetailVC:(QuestionModel * )tempModel  withIndexPath:(NSIndexPath *)indexPath ;
@end
