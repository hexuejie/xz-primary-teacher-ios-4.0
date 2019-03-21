//
//  SubjectsListNewViewController.h
//  TeacherPro
//
//  Created by DCQ on 2017/8/2.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BaseTableViewController.h"

@class ClassDetailTeacherModel;
typedef NS_ENUM(NSInteger ,SubjectsListNewViewControllerFromeType){

    SubjectsListNewViewControllerFromeType_normal = 0,
    SubjectsListNewViewControllerFromeType_Invitation,//邀请老师
    SubjectsListNewViewControllerFromeType_Change     ,//修改
    SubjectsListNewViewControllerFromeType_Create     ,//创建
    SubjectsListNewViewControllerFromeType_Join     ,//加入
    SubjectsListNewViewControllerFromeType_CreateInvitation,//创建班级时附带 邀请老师的选择科目
};

typedef void(^CreateClassSubjectsBlock)(NSArray * selectedSubjects);
typedef void(^InvitationTeacherSubjectsBlock)(NSDictionary *invitationDic);
@interface SubjectsListNewViewController : BaseTableViewController
- (instancetype)initWithType:(SubjectsListNewViewControllerFromeType )type withChangeTeacher:(ClassDetailTeacherModel *)model;
@property(nonatomic, copy) CreateClassSubjectsBlock createSubjectsBlock;
@property(nonatomic, copy) InvitationTeacherSubjectsBlock invitationSubjectsBlock;
 


@end
