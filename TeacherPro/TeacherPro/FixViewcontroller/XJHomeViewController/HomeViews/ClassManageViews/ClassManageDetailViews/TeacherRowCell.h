//
//  TeacherRowCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/5/14.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassDetailTeacherModel.h"


typedef NS_ENUM(NSInteger ,TeacherRowCellTouchType) {
    

    TeacherRowCellTouchType_normal  = 0,
    TeacherRowCellTouchType_AdminSendMessage        , //管理员发送消息
    TeacherRowCellTouchType_MembersSendMessage      ,//普老师通发消息
    TeacherRowCellTouchType_ExitClass       , //退出班级
    TeacherRowCellTouchType_DissolutionClasss    ,//解散班级
    TeacherRowCellTouchType_ChangeCourse    , //修改科目
    TeacherRowCellTouchType_KickedCourse    , //踢出班级
    TeacherRowCellTouchType_SetupAdmin    , //设为管理员
};
typedef void(^TeacherRowCellTouchBlock)(TeacherRowCellTouchType touchType,NSIndexPath *index);
@interface TeacherRowCell : UITableViewCell
@property(nonatomic, strong) NSIndexPath * index;
@property(nonatomic, copy) TeacherRowCellTouchBlock touchBlock;
- (void)setupCellInfo:(ClassDetailTeacherModel *)model withIsAdmin:(BOOL)isAdmin;
 
@end
