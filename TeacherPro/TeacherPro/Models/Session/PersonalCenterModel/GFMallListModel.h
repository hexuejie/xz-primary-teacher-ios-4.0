//
//  GFMallListModel.h
//  TeacherPro
//
//  Created by DCQ on 2017/12/5.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "Model.h"

@class GFMallModel;
@protocol GFMallModel;
@interface GFMallListModel : Model
@property(nonatomic, strong) NSArray <GFMallModel>* list;
@property(nonatomic, copy) NSString  *giftExchangeNotice;
@end
@interface GFMallModel : Model
@property(nonatomic, copy) NSString  * giftLogo;//图片
@property(nonatomic, strong) NSNumber  * count;//所需感恩币
@property(nonatomic, copy) NSString  *type;//
@property(nonatomic, strong)NSNumber  *id;
@property(nonatomic, copy) NSString  *ctime;//
@property(nonatomic, copy) NSString  *giftDesc;//
@property(nonatomic, strong) NSNumber  *availableCoin;//可用金币
@property(nonatomic, copy) NSString  *giftName;//

@end
