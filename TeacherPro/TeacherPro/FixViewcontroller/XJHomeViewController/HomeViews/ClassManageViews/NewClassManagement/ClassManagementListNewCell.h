//
//  ClassManagementListNewCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/8/2.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ClassManageModel;
@interface ClassManagementListNewCell : UITableViewCell

- (void)setupClassInfo:(ClassManageModel *)model;
@end
