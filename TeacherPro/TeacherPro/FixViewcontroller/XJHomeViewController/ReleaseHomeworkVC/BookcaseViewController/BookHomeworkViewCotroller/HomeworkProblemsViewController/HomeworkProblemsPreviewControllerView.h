//
//  HomeworkProblemsPreviewControllerView.h
//  TeacherPro
//
//  Created by DCQ on 2018/1/19.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "BaseTableViewController.h"
@protocol HomeworkProblemsPreviewDelegate <NSObject>
@optional
- (void)updateDetailList;
@end


@interface HomeworkProblemsPreviewControllerView : BaseTableViewController

- (instancetype)initWithModel:(NSArray *)listModel withSelectedIndexPathArray:(NSMutableArray *)selectedIndexPathArray;

- (instancetype)initWithPreviewData:(NSDictionary *)previewDataDic withSelectedIndexPathData:(NSMutableDictionary *)selectedIndexPathDic;
@property(nonatomic, weak) id <HomeworkProblemsPreviewDelegate> detailDelegate;
@end
