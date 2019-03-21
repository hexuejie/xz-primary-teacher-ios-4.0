//
//  StudentRowTwoTypeCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/6/1.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger ,StudentRowTwoTypeCellTouchType) {
    
    
    StudentRowTwoTypeCellTouchType_normal  = 0,
    StudentRowTwoTypeCellTouchType_sendMessage        , // 发送消息
    StudentRowTwoTypeCellTouchType_KickedClass       ,//踢出班级
    StudentRowTwoTypeCellTouchType_Info           ,//个人信息
    
    
};
typedef void(^StudentRowTwoTypeCellTouchBlock)(StudentRowTwoTypeCellTouchType touchType,NSIndexPath *index);
@interface StudentRowTwoTypeCell : UITableViewCell
@property(nonatomic, strong) NSIndexPath * index;
@property(nonatomic, copy) StudentRowTwoTypeCellTouchBlock touchBlock;
@end
