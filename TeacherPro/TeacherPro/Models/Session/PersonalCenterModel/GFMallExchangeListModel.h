//
//  GFMallExchangeListModel.h
//  TeacherPro
//
//  Created by DCQ on 2018/1/8.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "Model.h"

@class  GFMallExchangeModel;
@protocol  GFMallExchangeModel;
@interface GFMallExchangeListModel : Model
@property(strong ,nonatomic)NSMutableArray <GFMallExchangeModel>*items;
@end
@interface GFMallExchangeModel : Model
@property(copy ,nonatomic) NSString  *addressDetail;
@property(copy ,nonatomic) NSString  *completeAddress;
@property(copy ,nonatomic) NSString  *contactName;
@property(copy ,nonatomic) NSString  *contactPhone;
@property(copy ,nonatomic) NSString  *ctime;//时间
@property(copy ,nonatomic) NSString  *giftCount;//兑换数量
@property(copy ,nonatomic) NSString  *giftDesc;//兑换说明
@property(strong ,nonatomic) NSNumber  *giftId;
@property(copy ,nonatomic) NSString  *giftLogo;//图片
@property(copy ,nonatomic) NSString  *giftName;//名字
@property(copy ,nonatomic) NSString  *costCount;//消耗感恩币
@property(copy ,nonatomic) NSString  *deliveryTime;//发货时间
@property(strong ,nonatomic) NSNumber  *status;//是否发货
@end
