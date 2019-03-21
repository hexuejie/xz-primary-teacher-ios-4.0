//
//  ApplyMessageCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/6/25.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"
@class NotifyRecvModel;

typedef void(^ApplyMessageCellBlock)(NSInteger index,NSString * recvId,NSIndexPath *handleIndexPath);
@interface ApplyMessageCell : BaseTableViewCell
@property(nonatomic, copy) ApplyMessageCellBlock handleBlock;
@property(nonatomic, strong) NSIndexPath * handleIndexPath;
- (void)setupApplyMessageInfo:(NotifyRecvModel *) notifyModel;

@end
