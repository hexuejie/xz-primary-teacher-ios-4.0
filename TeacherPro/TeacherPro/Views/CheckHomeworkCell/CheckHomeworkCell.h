//
//  CheckHomeworkCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/7/6.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZCircleProgress.h"
typedef NS_ENUM(NSInteger,  CheckHomeworkCellButtonType) {
        CheckHomeworkCellButtonType_normal =  0,
        CheckHomeworkCellButtonType_check      ,//检查
        CheckHomeworkCellButtonType_look       ,//查看
        CheckHomeworkCellButtonType_detail     ,//详情
        CheckHomeworkCellButtonType_worth     ,//催缴
        CheckHomeworkCellButtonType_reprot     ,//报告
        CheckHomeworkCellButtonType_InviteStudents     ,//邀请学生
};
@class CheckHomeworkModel;
typedef void(^CheckHomeworkCellBlock)(CheckHomeworkModel * model,NSInteger type);
@interface CheckHomeworkCell : UITableViewCell
@property(nonatomic, copy) CheckHomeworkCellBlock  checkeBlock;
-(void)setupHomeworkInfo:(CheckHomeworkModel *)model isRemarked:(BOOL )remarked;
@end
