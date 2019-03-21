//
//  JoinClassListCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/5/10.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ClassManageModel;
@interface JoinClassListCell : UITableViewCell
- (void)setupCellInfo:(ClassManageModel *)model;
@end
