//
//  CourseCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/5/11.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseModel.h"
@interface CourseCell : UITableViewCell
- (void)setupCourseInfo:(CourseModel *)model;
- (void)setupCellState:(BOOL )state;
@end
