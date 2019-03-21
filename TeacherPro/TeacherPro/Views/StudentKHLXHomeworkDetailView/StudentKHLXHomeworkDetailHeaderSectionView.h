//
//  StudentKHLXHomeworkDetailHeaderSectionView.h
//  TeacherPro
//
//  Created by DCQ on 2018/2/1.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StudentKHLXHomeworkDetailModel;
@interface StudentKHLXHomeworkDetailHeaderSectionView : UITableViewHeaderFooterView
- (void)setupUnitModel:(StudentKHLXHomeworkDetailModel *) model;
- (void)setupUnitDic:(NSDictionary *) model;
@end
