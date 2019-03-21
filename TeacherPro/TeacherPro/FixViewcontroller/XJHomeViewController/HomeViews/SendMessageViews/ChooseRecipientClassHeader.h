//
//  ChooseRecipientClassHeader.h
//  TeacherPro
//
//  Created by DCQ on 2017/6/26.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ChooseRecipientClassHeaderBlock)(NSInteger indexPathSection);//是否打开关闭
typedef void(^ChooseRecipientTeacherHeaderALLSelectedOrCancelBlock)(NSInteger indexPathSection, BOOL yesOrNo);//是否全选
@class ReceuvedStudentContacts;
@interface ChooseRecipientClassHeader : UITableViewHeaderFooterView
@property (nonatomic, assign) NSInteger indexPathSection;
@property (nonatomic, copy) ChooseRecipientClassHeaderBlock classHeaderBlock;
@property (nonatomic, copy) ChooseRecipientTeacherHeaderALLSelectedOrCancelBlock allChooseBlock;
- (void)setupOpenImgState:(BOOL)YesOrNo;
- (void)setupSelectedImgState:(BOOL)YesOrNo;
- (void)setupHeaderViewinfo:(ReceuvedStudentContacts *)model;
@end
