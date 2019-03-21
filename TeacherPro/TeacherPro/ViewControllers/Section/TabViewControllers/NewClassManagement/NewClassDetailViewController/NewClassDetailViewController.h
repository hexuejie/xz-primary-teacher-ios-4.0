//
//  NewClassDetailViewController.h
//  TeacherPro
//
//  Created by DCQ on 2017/8/3.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "XLButtonBarPagerTabStripViewController.h"

typedef NS_ENUM(NSInteger, NewClassDetailVCFromeType){
     NewClassDetailVCFromeType_normal    = 0,
     NewClassDetailVCFromeType_Create       ,//创建成功
     NewClassDetailVCFromeType_ClasssList    ,//班级列表
    
};

@interface NewClassDetailViewController : XLButtonBarPagerTabStripViewController
- (instancetype)initWithTitle:(NSString *)titleStr  withClassId:(NSString *)classID withType:(NewClassDetailVCFromeType)type isTeacherIdentity:(BOOL)isAdmin;
@end
