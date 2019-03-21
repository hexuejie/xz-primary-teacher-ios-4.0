//
//  TeacherSectionCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/5/14.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassDetailTeacherModel.h"

typedef void(^TeacherSectionCellTouchBtnBlock)(NSIndexPath * openIndex,BOOL isOpen);
@interface TeacherSectionCell : UITableViewCell
@property(nonatomic, strong) NSIndexPath * indexPath;
@property(nonatomic, strong) TeacherSectionCellTouchBtnBlock  btnBlock;
- (void)setupCellOpenState:(BOOL )isOpen;
- (void)setupCellInfo:(ClassDetailTeacherModel *)model isAdmin:(BOOL)isAdmin;
- (void)setupTableviewCellEdit:(BOOL)edit;
- (void)showDetailArrow;
- (void)hiddenDetailArrow;
@end
