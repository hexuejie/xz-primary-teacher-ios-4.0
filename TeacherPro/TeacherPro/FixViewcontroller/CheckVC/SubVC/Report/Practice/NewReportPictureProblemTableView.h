//
//  NewReportPictureProblemTableView.h
//  TeacherPro
//
//  Created by 何学杰 on 2019/1/16.
//  Copyright © 2019 ZNXZ. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewReportPictureProblemTableView : BaseTableViewController

- (instancetype)initWithHomeworkId:(NSString *)homeworkId;

@property (assign ,nonatomic) NSInteger chooseTag;

@end

NS_ASSUME_NONNULL_END
