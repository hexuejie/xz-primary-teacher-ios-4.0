//
//  HomeworkProblemsDetailViewController.h
//  TeacherPro
//
//  Created by DCQ on 2018/1/19.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "BaseTableViewController.h"

@interface HomeworkProblemsDetailViewController : BaseTableViewController
- (instancetype)initWithUnitIds:(NSArray *)unitIds withUnitNames:(NSArray *)unitNames withCacheData:(NSArray *)cacheData;
@end
