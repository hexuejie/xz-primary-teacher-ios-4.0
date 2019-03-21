//
//  TeachingAssistantsHomeworkListViewController.h
//  TeacherPro
//
//  Created by DCQ on 2017/11/3.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//
//作业详情 题目列表
#import "BaseTableViewController.h"

@protocol  TeachingAssistantsHomeworkDelegate <NSObject>
- (void) chooseAssistantsHomewrok:(NSDictionary *)questions  withAllQuestions:(NSInteger ) allQuestions withQuestionNum:(NSString *)questionNum ;
 
@end

@interface TeachingAssistantsHomeworkListViewController : BaseTableViewController
@property (nonatomic, assign) id<TeachingAssistantsHomeworkDelegate>delegate;
- (instancetype)initWithBookId:(NSString *)bookId withBookName: (NSString *)bookName withUnitId:(NSString *)unitId withQuestionNum:(NSString *)questionNum  withSelectedData:(NSArray *)selectedQuestionNumArray;
@end

