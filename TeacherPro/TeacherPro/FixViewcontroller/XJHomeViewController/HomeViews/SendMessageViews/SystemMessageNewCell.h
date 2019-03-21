//
//  SystemMessageNewCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/8/14.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"
@class NotifyRecvModel;

@interface SystemMessageNewCell : BaseTableViewCell
@property(nonatomic, strong) NotifyRecvModel * notifyModel;

@end
