//
//  TeacherRowOneTypeCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/6/1.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger ,TeacherRowOneTypeCellTouchType) {
    
    
    TeacherRowOneTypeCellTouchType_normal  = 0,
 
    TeacherRowOneTypeCellTouchType_ExitClass       , //退出班级
    TeacherRowOneTypeCellTouchType_DissolutionClasss    ,//解散班级
    TeacherRowOneTypeCellTouchType_ChangeCourse    , //修改科目
    TeacherRowOneTypeCellTouchType_HomeworkReview    , //作业回顾
    TeacherRowOneTypeCellTouchType_KickedOut        ,//踢出班级
};
typedef void(^TeacherRowOneTypeCellTouchBlock)(TeacherRowOneTypeCellTouchType type,NSIndexPath* index);
@interface TeacherRowOneTypeCell : UITableViewCell
- (void)setupCellIsAdmin:(BOOL)isAdmin;
@property(nonatomic, copy) TeacherRowOneTypeCellTouchBlock  touchBlock;
@property(nonatomic, strong) NSIndexPath *  index;
- (void)setupCellIsAdmin:(BOOL)isAdmin withOneself:(BOOL )oneself;
@end
