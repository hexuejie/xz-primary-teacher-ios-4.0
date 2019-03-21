//
//  MessageListCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/6/24.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageListCell : UITableViewCell

- (void)setupMessageCellInfo:(NSDictionary *)info;
- (void)setupNewMessageNumber:(NSInteger )newNumber withNotifyNumber:(NSNumber *)notifyCount;
@end
