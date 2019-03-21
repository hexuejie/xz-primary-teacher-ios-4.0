 
//  MessageListViewController.h
//  TeacherPro
//
//  Created by DCQ on 2017/6/21.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BaseTableViewController.h"

typedef NS_ENUM(NSInteger, MessageListType) {
    MessageListType_normal = 0,
    MessageListType_Preson    ,
    MessageListType_Tab      ,
};
@interface MessageListViewController : BaseTableViewController
- (instancetype)initWithType:(MessageListType)type;
@end
