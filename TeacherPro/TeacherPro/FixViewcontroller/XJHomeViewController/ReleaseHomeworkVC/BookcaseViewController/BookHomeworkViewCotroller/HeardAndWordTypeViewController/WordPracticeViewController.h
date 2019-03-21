//
//  WordPracticeViewController.h
//  TeacherPro
//
//  Created by DCQ on 2017/9/7.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BaseCollectionViewController.h"

typedef void(^WordPracticeHomeworkBlock)(NSArray * wordArray);
@class HeardAndWordTypeModel;
@interface WordPracticeViewController : BaseCollectionViewController
- (instancetype)initWithCacheData:(NSArray *)wordCacheData;
@property(nonatomic, copy) WordPracticeHomeworkBlock homeworkBlock;
- (void)updateViewData:(HeardAndWordTypeModel *)model;
@end
