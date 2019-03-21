//
//  NewClassDetailStudentOneRowCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/8/3.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ClassDetailStudentModel;
typedef void(^NewClassDetailStudentOneRowCellTouchBtnBlock)(NSIndexPath * openIndex,BOOL isOpen);
@interface NewClassDetailStudentOneRowCell : UITableViewCell
@property(nonatomic, strong) NSIndexPath * indexPath;
@property(nonatomic, copy) NewClassDetailStudentOneRowCellTouchBtnBlock  btnBlock;
- (void)setupCellInfo:(ClassDetailStudentModel *)model;
- (void)setupCellOpenState:(BOOL )isOpen;
- (void)showCellSelectedState;
- (void)selectedState:(BOOL )state;
@end
