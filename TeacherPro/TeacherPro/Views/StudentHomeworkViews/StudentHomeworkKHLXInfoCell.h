//
//  StudentHomeworkKHLXInfoCell.h
//  TeacherPro
//
//  Created by DCQ on 2018/2/1.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^StudentHomeworkKHLXInfoCellBlock)();
@interface StudentHomeworkKHLXInfoCell : UITableViewCell
- (void)setupRightNumber:(NSNumber *)rightNumber  andWrongNumber:(NSNumber *)wrongNumber;
@property(nonatomic, copy) StudentHomeworkKHLXInfoCellBlock detailBlock;
@end
