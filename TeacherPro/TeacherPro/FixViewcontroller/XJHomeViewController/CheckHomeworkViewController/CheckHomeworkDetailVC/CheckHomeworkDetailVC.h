//
//  CheckHomeworkDetailVC.h
//  TeacherPro
//
//  Created by DCQ on 2018/7/6.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "BaseNetworkViewController.h"
#import "NewCheckHomeworkDetailVC.h"

@interface CheckHomeworkDetailVC : BaseNetworkViewController
- (instancetype)initHomeworkID:(NSString *)homeworkId  withType:(CheckHomeworkDetailVCType )type withOnlineHomework:(NSNumber *)onlineHomework;
@end
