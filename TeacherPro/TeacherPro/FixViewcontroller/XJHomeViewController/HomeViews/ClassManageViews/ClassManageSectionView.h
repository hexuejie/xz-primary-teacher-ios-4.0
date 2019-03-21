//
//  ClassManageSectionView.h
//  TeacherPro
//
//  Created by DCQ on 2017/5/12.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ClassManageSectionViewType) {

    ClassManageSectionViewType_normal       = 0,
    ClassManageSectionViewType_MyManager        ,
    ClassManageSectionViewType_MyJoin         ,
};

typedef void(^SectionBtnTouchBlock)(NSInteger btnType);
@interface ClassManageSectionView : UIView
- (void)setupSectionType:(ClassManageSectionViewType )type withSectionIsEditState:(BOOL)YesOrNo withBtn:(BOOL)hidden withTitle:(NSString *)title;

@property (nonatomic, copy) SectionBtnTouchBlock   btnBlock;//btnType = 1 转让班级 =2 解散班级 =3 退出班级
@end
