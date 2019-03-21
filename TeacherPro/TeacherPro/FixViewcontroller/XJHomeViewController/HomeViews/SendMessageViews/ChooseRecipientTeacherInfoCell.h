//
//  ChooseRecipientTeacherInfoCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/6/28.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ReceuvedTeacherContacts;
@interface ChooseRecipientTeacherInfoCell : UITableViewCell
- (void)setupSelectedImgState:(BOOL)YesOrNo;
- (void)setupCellInfo:(ReceuvedTeacherContacts *)model;
@end
