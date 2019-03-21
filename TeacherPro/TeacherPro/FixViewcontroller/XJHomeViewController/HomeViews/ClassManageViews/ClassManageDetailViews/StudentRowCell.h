//
//  StudentRowCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/5/14.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger ,StudentRowCellTouchType) {
    
    
    StudentRowCellTouchType_normal  = 0,
    StudentRowCellTouchType_AdminSendMessage        , //管理员发送消息
    StudentRowCellTouchType_MembersSendMessage      ,//普老师通发消息
    StudentRowCellTouchType_KickedClass       , //管理员 踢出班级
    StudentRowCellTouchType_Info    ,//个人信息
   
};
typedef void(^StudentRowCellTouchBlock)(StudentRowCellTouchType touchType,NSIndexPath *index);
@interface StudentRowCell : UITableViewCell
@property(nonatomic, strong) NSIndexPath * index;
@property(nonatomic, copy) StudentRowCellTouchBlock touchBlock;
- (void)setupCellIsAdmin:(BOOL)isAdmin;
@end
