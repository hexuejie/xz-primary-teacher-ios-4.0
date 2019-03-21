//
//  StudentRowOneTypeCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/6/1.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger ,StudentRowOneTypeCellTouchType) {
    
    
    StudentRowOneTypeCellTouchType_normal  = 0,
    StudentRowOneTypeCellTouchType_sendMessage        , // 发送消息
  
    StudentRowOneTypeCellTouchType_Info           ,//个人信息
    
     
};
typedef void(^StudentRowOneTypeCellTouchBlock)(StudentRowOneTypeCellTouchType touchType,NSIndexPath *index);

@interface StudentRowOneTypeCell : UITableViewCell
@property(nonatomic, strong) NSIndexPath * index;
@property(nonatomic, copy) StudentRowOneTypeCellTouchBlock touchBlock;
@end
