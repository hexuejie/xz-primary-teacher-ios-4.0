//
//  ChooseRecipientTeacherHeader.h
//  TeacherPro
//
//  Created by DCQ on 2017/6/26.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ChooseRecipientTeacherHeaderBlock)(NSInteger indexPathSection);//是否打开关闭
typedef void(^ChooseRecipientTeacherHeaderALLSelectedOrCancelBlock)(NSInteger indexPathSection, BOOL yesOrNo);//是否全选

@interface ChooseRecipientTeacherHeader : UITableViewHeaderFooterView
@property (nonatomic, assign) NSInteger indexPathSection;
@property (nonatomic, copy) ChooseRecipientTeacherHeaderBlock  teacherHeaderBlock;
@property (nonatomic, copy) ChooseRecipientTeacherHeaderALLSelectedOrCancelBlock allChooseBlock;
- (void)setupSelectedImgState:(BOOL)YesOrNo;
- (void)setupOpenImgState:(BOOL)YesOrNo;
@end
