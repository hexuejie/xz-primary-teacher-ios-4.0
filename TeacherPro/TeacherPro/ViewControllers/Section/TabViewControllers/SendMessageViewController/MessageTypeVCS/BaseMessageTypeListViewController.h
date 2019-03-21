//
//  BaseMessageListViewController.h
//  TeacherPro
//
//  Created by DCQ on 2017/7/3.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BaseTableViewController.h"
#define  bottomHeight   FITSCALE(54)
#define  bottomTag      6666666
#define  AllButtonTag    9233434

typedef void(^UpdateMessageList)();
@interface BaseMessageTypeListViewController : BaseTableViewController
@property(nonatomic, strong) NSMutableArray  *selectedIndexArray;
@property(nonatomic, copy) UpdateMessageList   updateMessageList;
//获取列表数据
- (NSArray *)getListArray;
//删除指定的消息
- (void) deleteMessage;
- (void)rightAction:(UIButton *)button;

- (void)exitEdit;


@end
