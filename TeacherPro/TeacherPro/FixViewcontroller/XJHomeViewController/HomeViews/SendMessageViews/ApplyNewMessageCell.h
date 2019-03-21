//
//  ApplyNewMessageCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/8/14.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"
@class NotifyRecvModel;
typedef void(^ApplyMessageCellBlock)(NSInteger index,NSString * recvId,NSIndexPath *handleIndexPath);
@interface ApplyNewMessageCell : BaseTableViewCell
@property(nonatomic, copy) ApplyMessageCellBlock handleBlock;
@property(nonatomic, strong) NSIndexPath * handleIndexPath;
@property(nonatomic, strong) NotifyRecvModel* notifyRecvModel;
@end
