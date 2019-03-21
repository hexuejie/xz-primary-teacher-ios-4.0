//
//  TransferClassViewController.h
//  TeacherPro
//
//  Created by DCQ on 2017/8/4.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "NewClassDetailTeacherViewController.h"

typedef void(^TransferClassViewControllerBlock)();

@interface TransferClassViewController : NewClassDetailTeacherViewController
@property(nonatomic, copy) TransferClassViewControllerBlock transferBlock;
@end
