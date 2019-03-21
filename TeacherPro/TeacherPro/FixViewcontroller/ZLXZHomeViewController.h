//
//  ZLXZHomeViewController.h
//  TeacherPro
//
//  Created by DCQ on 2018/5/28.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "BaseTableViewController.h"
typedef NS_ENUM(NSInteger, ZLXZHomeViewControllerType){
    ZLXZHomeViewControllerType_Normal    = 0,
    ZLXZHomeViewControllerType_Info        ,
    ZLXZHomeViewControllerType_Login       ,
    
};
@interface ZLXZHomeViewController : BaseTableViewController
- (instancetype)initWithType:(ZLXZHomeViewControllerType) type;
@end
