//
//  NewPersonReportListonPriceTableView.h
//  TeacherPro
//
//  Created by 何学杰 on 2019/1/18.
//  Copyright © 2019 ZNXZ. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewPersonReportListonPriceTableView : BaseTableViewController

- (instancetype)initWithHomeworkId:(NSString *)homeworkId;

@property (nonatomic ,strong) NSDictionary *personDic;

@end

NS_ASSUME_NONNULL_END
