//
//  JFHomeworkTopicDetailViewController.h
//  TeacherPro
//
//  Created by DCQ on 2017/12/20.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BaseTableViewController.h"
@protocol JFHomeworkTopicParseDelegate <NSObject>
- (void)chooseItmeIndex:(NSIndexPath *)indexPath withParsingIndex:(NSInteger)selectedIndex;
- (void)updateListData;
@end
@class QuestionModel;
@interface JFHomeworkTopicDetailViewController : BaseTableViewController
@property(nonatomic, assign) id<JFHomeworkTopicParseDelegate> delegate;
@property(nonatomic, strong)  QuestionModel * model;
@property(nonatomic, copy)    NSString * bookId;
@property(nonatomic, copy)    NSString * bookName;
@property(nonatomic, assign)  NSInteger selectedIndex;  //1 原书解析 2 我的解析 3 其它老师解析
@property(nonatomic, strong) NSIndexPath *seletedChangePareTopicIndexPath;//选择的题目
- (instancetype)initWithBookId:(NSString *)bookId withBookName: (NSString *)bookName withModel:(QuestionModel *)model withSelectedIndex:(NSInteger)selectedIndex;
- (NSString *)getBookId;
- (void)updatePopTopicListData;
- (void)updateBottomView;
@end
