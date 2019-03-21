//
//  MyManageClassTableViewCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/5/11.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassManageModel.h"


typedef NS_ENUM(NSInteger ,MyManageClassType) {
    //没选
    MyManageClassType_normal  = 0,
    //选中
    MyManageClassType_Selected     ,
    //禁止
    MyManageClassType_ban        ,
};


@interface MyManageClassTableViewCell : UITableViewCell
 
- (void)setupCellInfo:(ClassManageModel *) info;
- (void)setupCellSelected:(MyManageClassType )type;
- (void)setupTableviewCellEdit:(BOOL )edit;
@end
