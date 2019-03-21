//
//  ApplyMessageViewController.h
//  TeacherPro
//
//  Created by DCQ on 2017/6/24.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BaseMessageTypeListViewController.h"


typedef NS_ENUM(NSInteger, ApplyMessageViewControllerType) {
    ApplyMessageViewControllerType_normal       =  0,
    ApplyMessageViewControllerType_apply            ,
    ApplyMessageViewControllerType_invitation       ,
    
};
@interface ApplyMessageViewController : BaseMessageTypeListViewController
- (instancetype)initWithType:(ApplyMessageViewControllerType )type;
@end
