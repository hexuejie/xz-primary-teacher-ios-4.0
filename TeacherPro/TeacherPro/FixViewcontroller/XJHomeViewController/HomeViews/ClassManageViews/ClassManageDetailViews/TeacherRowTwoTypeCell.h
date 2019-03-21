//
//  TeacherRowTwoTypeCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/6/1.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger ,TeacherRowTwoTypeCellTouchType) {
    
    
    TeacherRowTwoTypeCellTouchType_normal  = 0,
    TeacherRowTwoTypeCellTouchType_ChangeCourse    , //修改科目
    TeacherRowTwoTypeCellTouchType_KickedCourse    , //踢出班级
    TeacherRowTwoTypeCellTouchType_SetupAdmin    , //设为管理员
   
    
};
typedef void(^TeacherRowTwoTypeCellTouchBlock)(TeacherRowTwoTypeCellTouchType type,NSIndexPath* index);
@interface TeacherRowTwoTypeCell : UITableViewCell
@property (nonatomic, copy) TeacherRowTwoTypeCellTouchBlock touchBlock;
@property (nonatomic, strong) NSIndexPath * index;
@end
