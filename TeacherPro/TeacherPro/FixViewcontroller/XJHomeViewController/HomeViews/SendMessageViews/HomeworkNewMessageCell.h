//
//  HomeworkNewMessageCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/8/14.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"
@class NotifyRecvModel;
typedef void(^ HomeworkMessageCellDetailBlock)(NSIndexPath *index);
@interface HomeworkNewMessageCell : BaseTableViewCell
@property(nonatomic, strong) NotifyRecvModel * notifyRecvModel;
@property(nonatomic, strong) NSIndexPath * index;
@property(nonatomic, copy) HomeworkMessageCellDetailBlock detailBlock;
@end
