//
//  HomeworkMessageCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/6/26.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"

typedef void(^ HomeworkMessageCellDetailBlock)(NSIndexPath *index);
@class NotifyRecvModel;
@interface HomeworkMessageCell : BaseTableViewCell
@property(nonatomic, strong) NSIndexPath * index;
@property(nonatomic, copy) HomeworkMessageCellDetailBlock detailBlock;
- (void)setupHomeworkMessageInfo:(NotifyRecvModel *)model;
 
@end
