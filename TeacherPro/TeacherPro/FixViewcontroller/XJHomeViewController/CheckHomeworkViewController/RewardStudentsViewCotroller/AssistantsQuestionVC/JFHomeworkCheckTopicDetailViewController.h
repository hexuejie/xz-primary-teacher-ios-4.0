//
//  JFHomeworkCheckTopicDetailViewController.h
//  TeacherPro
//
//  Created by DCQ on 2018/1/3.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "JFHomeworkTopicDetailViewController.h"
@class QuestionModel;
@interface JFHomeworkCheckTopicDetailViewController : JFHomeworkTopicDetailViewController

- (instancetype)initWithBookId:(NSString *)bookId  withBookHomeworkId:(NSString *)bookHomeworkId withHomeworkId:(NSString *)homeworkId withBookName: (NSString *)bookName withModel:(QuestionModel *)model;
@end
