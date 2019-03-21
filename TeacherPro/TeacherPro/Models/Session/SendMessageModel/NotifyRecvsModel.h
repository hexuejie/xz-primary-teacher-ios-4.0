 
//  NotifyRecvsModel.h
//  TeacherPro
//
//  Created by DCQ on 2017/6/29.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "Model.h"

@class NotifyRecvModel;
@protocol  NotifyRecvModel;
@interface NotifyRecvsModel : Model
@property(nonatomic, strong) NSMutableArray <NotifyRecvModel>*notifyRecvs;
@end

@interface NotifyRecvModel : Model
//内容类型
@property(nonatomic, copy) NSString * contentType;
@property(nonatomic, strong) NSNumber * voiceDuration;

@property(nonatomic, strong) NSNumber *cTimestamp;
 
/**
 * 消息内容
 */
@property(nonatomic, copy) NSString * content;



/**
 * 消息内容-图片地址（最大支持10张图片地址存储）
 */
@property(nonatomic, strong) NSArray * images;



/**
 * 通知id
 */
@property(nonatomic, strong) NSNumber * notifyId;

/**
 * 消息读取状态 0:未读 1:已读
 */
@property(nonatomic, strong) NSNumber * readStatus;

@property(nonatomic, strong) NSNumber * readTime;

/**
 * 阅读时间
 */
@property(nonatomic, strong) NSNumber * readTimestamp;

/**
 * 流水号
 */
@property(nonatomic, strong) NSNumber * recvId;

/**
 * 角色 teacher,parent,student
 */
@property(nonatomic, copy) NSString * recvRole;

/**
 * 接收角色ID
 */
@property(nonatomic, copy) NSString * recvRoleId;

/**
 * 发送者名称
 */
@property(nonatomic, copy) NSString * sendName;

/**
 * 发送者角色
 */
@property(nonatomic, copy) NSString * sendRole;

@property(nonatomic, copy) NSString * sendSex;

@property(nonatomic, copy) NSString *sendThumbnail;
/**
 * 消息状态（1：新消息、2：未读消息、3：已读消息）
 */
@property(nonatomic, strong) NSNumber * status;

/**
 * 消息标题
 */
@property(nonatomic, copy) NSString * title;

/**
 * 消息类型(00：老师消息、01：作业消息、02：系统通知、03：奖励通知、04：邀请通知、05、申请通知)
 */
@property(nonatomic, copy) NSString * type;

/**
 * 消息内容-音频地址
 */
@property(nonatomic, copy) NSString * voice;

@property (nonatomic, strong)NSNumber * isOpening;

@property (nonatomic, strong) NSDictionary * extraContent;
// getters and setters...
@end
