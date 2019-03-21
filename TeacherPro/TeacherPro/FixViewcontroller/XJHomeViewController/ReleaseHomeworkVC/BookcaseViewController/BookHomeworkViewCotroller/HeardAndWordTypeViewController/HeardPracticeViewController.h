//
//  HeardPracticeViewController.h
//  TeacherPro
//
//  Created by DCQ on 2017/9/7.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BaseCollectionViewController.h"
typedef void(^HeardPracticeHomeworkBlock)(NSArray * heardArray);
@class HeardAndWordTypeModel;
@interface HeardPracticeViewController : BaseCollectionViewController
- (instancetype)initWithCacheData:(NSArray *)heardCacheData;
@property(nonatomic, copy) HeardPracticeHomeworkBlock  homeworkBlock;
- (void)updateViewData:(HeardAndWordTypeModel *)model;
- (void)setupCacheHeardData:(HeardAndWordTypeModel *)model;
@end
