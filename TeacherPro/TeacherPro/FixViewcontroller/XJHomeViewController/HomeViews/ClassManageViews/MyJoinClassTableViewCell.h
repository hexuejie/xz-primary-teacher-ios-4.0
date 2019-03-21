//
//  MyJoinClassTableViewCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/5/11.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassManageModel.h"

typedef NS_ENUM(NSInteger, MyJoinClassCellType) {

    //没选
    MyJoinClassCellType_normal  = 0,
    //选中
    MyJoinClassCellType_Selected     ,
    //禁止
    MyJoinClassCellType_ban        ,
};
@interface MyJoinClassTableViewCell : UITableViewCell
 
- (void)setupCellInfo:(ClassManageModel *) info;
- (void)setupCellSelected:(MyJoinClassCellType )type;
- (void)setupTableviewCellEdit:(BOOL)edit;
@end
