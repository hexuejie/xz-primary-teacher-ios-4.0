//
//  WrittenParseViewController.h
//  TeacherPro
//
//  Created by DCQ on 2017/11/3.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BaseTableViewController.h"

@protocol  WrittenParseViewDelegate<NSObject>
- (void)updateMyParse ;
@end
@class QuestionModel;
@interface WrittenParseViewController : BaseTableViewController
@property(nonatomic, assign) id<WrittenParseViewDelegate>delegate;
- (instancetype)initWithBookId:(NSString *)bookId withBookName: (NSString *)bookName withModel:(QuestionModel *)model;

@end

