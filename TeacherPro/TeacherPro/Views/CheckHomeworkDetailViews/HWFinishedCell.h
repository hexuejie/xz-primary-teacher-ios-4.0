//
//  HWFinishedCell.h
//  TeacherPro
//
//  Created by DCQ on 2018/7/12.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HWFinishedCell : UITableViewCell
- (void)setupStudentDic:(NSDictionary *)studentDic withJF:(BOOL)isJF;
- (void)hiddenArrow:(BOOL)hidden;
@end
