//
//  InvitationJoinTeacherCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/8/4.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  JoiningTeacherModel;
@interface InvitationJoinTeacherCell : UITableViewCell
- (void)setupTeacherInfo:(JoiningTeacherModel *)model;
@end