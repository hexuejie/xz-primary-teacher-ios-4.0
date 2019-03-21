//
//  ClassManageBottomCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/5/31.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, bottomButtonType) {
    bottomButtonType_normal             = 0,
    bottomButtonType_dissolution           ,
    bottomButtonType_eixt                  ,
    bottomButtonType_transfer              ,
};
typedef void(^ClassManageBottomCellBlock)(bottomButtonType buttonType,NSIndexPath *indexPath);
@class ClassManageModel;
@interface ClassManageBottomCell : UITableViewCell
- (void)setupInfo:(ClassManageModel *)model;
@property(nonatomic, copy) ClassManageBottomCellBlock bottomBlock;
@property(nonatomic, strong) NSIndexPath *indexPath;
@end
