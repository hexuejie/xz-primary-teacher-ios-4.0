//
//  CartoonCollectionViewController.h
//  TeacherPro
//
//  Created by DCQ on 2017/9/18.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BaseCollectionViewController.h"
@class XLPagerTabStripViewController;
@interface CartoonCollectionViewController : BaseCollectionViewController
- (instancetype)initWithName:(NSString *)name withGradeId:(NSString *)gradeId;
//是否加载过
 @property(nonatomic, assign) BOOL  hasLoadData;
- (void)updateData;
@end
