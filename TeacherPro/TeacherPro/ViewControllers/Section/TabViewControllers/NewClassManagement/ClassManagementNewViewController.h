//
//  ClassManagementNewViewController.h
//  TeacherPro
//
//  Created by DCQ on 2017/8/2.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BaseTableViewController.h"

typedef NS_ENUM(NSInteger, ClassManagementType){
    ClassManagementType_normal = 0,
    ClassManagementType_preson,
    ClassManagementType_tab,
};
@interface ClassManagementNewViewController : BaseTableViewController
- (instancetype)initWithType:(ClassManagementType)type;
@end
