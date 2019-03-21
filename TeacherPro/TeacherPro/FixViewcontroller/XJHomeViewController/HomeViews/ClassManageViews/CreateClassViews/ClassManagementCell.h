//
//  ClassManagementCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/5/11.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassManageModel.h"
typedef NS_ENUM(NSInteger ,  CellType) {
    CellType_normal = 0,
    CellType_create    ,
    CellType_choose    ,
    CellType_checkChoose    ,//检查作业选择班级样式
};
@interface ClassManagementCell : UITableViewCell
- (void)setupClassInfo:(ClassManageModel *)model;
- (void)setupCellType:(CellType) type;
- (void)setupChooseCellSelected:(BOOL )yesOrNo;
@end
