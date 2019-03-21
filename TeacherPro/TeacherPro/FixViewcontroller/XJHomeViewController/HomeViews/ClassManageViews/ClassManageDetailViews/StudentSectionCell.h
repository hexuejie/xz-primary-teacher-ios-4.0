//
//  StudentCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/5/14.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassDetailStudentModel.h"
typedef void(^StudentSectionCellTouchBtnBlock)(NSIndexPath * openIndex,BOOL isOpen);
@interface StudentSectionCell : UITableViewCell
- (void)setupStudentInfo:(ClassDetailStudentModel *)model;
- (void)setupCellOpenState:(BOOL )isOpen;
- (void)setupTableviewCellEdit:(BOOL)edit;
@property(nonatomic, strong) NSIndexPath * indexPath;
@property(nonatomic, strong) StudentSectionCellTouchBtnBlock  btnBlock;
@end
