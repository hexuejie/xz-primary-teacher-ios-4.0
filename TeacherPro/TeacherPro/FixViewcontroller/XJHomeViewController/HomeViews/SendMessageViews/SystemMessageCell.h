//
//  SystemMessageCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/6/28.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"
@class NotifyRecvModel;

@interface SystemMessageCell : BaseTableViewCell
- (void)setupSystemMessageInfo:(NotifyRecvModel *) notifyModel;
@end
