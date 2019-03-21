//
//  BookHomeworkAdjustmentRepeatedNumberCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/9/7.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BookHomeworkAdjustmentBlock)(NSInteger number);
@interface BookHomeworkAdjustmentRepeatedNumberCell : UITableViewCell
@property(nonatomic, copy) BookHomeworkAdjustmentBlock adjustmentBlock;
@end
