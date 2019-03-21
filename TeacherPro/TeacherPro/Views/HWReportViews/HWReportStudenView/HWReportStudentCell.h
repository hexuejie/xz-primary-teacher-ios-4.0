//
//  HWReportStudentCell.h
//  TeacherPro
//
//  Created by DCQ on 2018/7/25.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HWReportStudentCell : UITableViewCell
- (void)setupStudentName:(NSString *)name withResults:(NSString *)results withCompleteState:(BOOL)state;
@end
