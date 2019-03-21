//
//  HomeworkConfirmationViewController.h
//  TeacherPro
//
//  Created by DCQ on 2017/9/11.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BaseTableViewController.h"

@interface HomeworkConfirmationViewController : BaseTableViewController

- (instancetype)initWithWorkData:(NSArray *)workDataArray withHeardData:(NSArray *)heardDataArray withUnityID:(NSString *)unitId;
@end
