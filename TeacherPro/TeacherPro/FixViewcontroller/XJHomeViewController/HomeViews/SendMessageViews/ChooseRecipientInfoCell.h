//
//  ChooseRecipientInfoCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/6/26.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StudentsModel;
@interface ChooseRecipientInfoCell : UITableViewCell
- (void)setupSelectedImgState:(BOOL)YesOrNo ;
- (void)setupCellInfo:(StudentsModel *)model;
@end
