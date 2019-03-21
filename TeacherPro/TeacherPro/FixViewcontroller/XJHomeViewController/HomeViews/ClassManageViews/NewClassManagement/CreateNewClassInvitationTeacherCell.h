//
//  CreateNewClassInvitationTeacherCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/8/2.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DeleteInvitationTeacherBlock)(NSIndexPath * index);
@interface CreateNewClassInvitationTeacherCell : UITableViewCell
@property(nonatomic, strong) NSIndexPath * index;
@property(nonatomic, copy) DeleteInvitationTeacherBlock deleteBlock;
- (void)setupInvitationInfo:(NSDictionary *)info;
@end
