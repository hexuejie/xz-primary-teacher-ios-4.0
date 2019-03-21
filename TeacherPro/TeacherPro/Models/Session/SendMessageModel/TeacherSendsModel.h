 
//  TeacherSendsModel.h
//  TeacherPro
//
//  Created by DCQ on 2017/6/29.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "Model.h"

@class NotifySendsModel;
@protocol NotifySendsModel

@end
@interface TeacherSendsModel : Model
@property (nonatomic,strong) NSMutableArray <NotifySendsModel>*notifySends;
@end

@class Target;

@interface NotifySendsModel :Model

//内容类型
@property(nonatomic, copy) NSString * contentType;

@property(nonatomic, strong) NSNumber * voiceDuration;
/**
 * 通知发送的班级列表
 */
@property (nonatomic,strong) NSArray * clazzs;

/**
 * 消息内容
 */
@property (nonatomic,copy) NSString * content;



/**
 * 创建时间
 */
@property (nonatomic,strong) NSNumber *  ctimeRsp;





/**
 * 消息内容-图片地址（最大支持10张图片地址存储）
 */
@property (nonatomic,strong) NSArray *imagesRsp;

/**
 * 消息id
 */
@property (nonatomic,strong) NSNumber * notifyId;

/**
 * 发送者名称
 */
@property (nonatomic,copy) NSString * sendName;

/**
 * 发送者角色 system,teacher,parent
 */
@property (nonatomic,copy) NSString * sendRole;

/**
 * 发送者角色ID
 */
@property (nonatomic,copy) NSString * sendRoleId;

/**
 * 消息标题
 */
@property (nonatomic,copy) NSString * title;

/**
 * 消息类型(00：老师消息、01：作业消息、02：系统通知、03：奖励通知、04：邀请通知、05、申请通知)
 */
@property (nonatomic,copy) NSString * type;

/**
 * 消息内容-音频地址
 */
@property (nonatomic,copy) NSString * voice;

//是否显示全文
@property (nonatomic,strong) NSNumber * isOpening;
//发送对象
@property (nonatomic, strong) Target * target;

//已阅读数
@property (nonatomic,strong) NSNumber *readedTargetCounter;
//发送总条数
@property (nonatomic,strong) NSNumber *targetCounter;
// getters and setters...
@end

@interface Target : Model
@property(nonatomic, strong) NSArray <Optional>* studentTarget;
@property(nonatomic, strong) NSArray <Optional>* teacherTarget;
@end
