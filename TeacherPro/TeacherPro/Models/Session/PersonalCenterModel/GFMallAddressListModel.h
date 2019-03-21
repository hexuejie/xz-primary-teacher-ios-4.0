//
//  GFMallAddressListModel.h
//  TeacherPro
//
//  Created by DCQ on 2017/12/7.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "Model.h"
@class GFMallAddressModel;
@protocol  GFMallAddressModel;
@interface GFMallAddressListModel : Model
@property(nonatomic, strong) NSMutableArray <GFMallAddressModel>* items;
@end

@interface GFMallAddressModel : Model
@property(nonatomic, copy) NSString * addressDetail;

@property(nonatomic, copy) NSString *city ;
@property(nonatomic, copy) NSString *completeAddress ;//详情地址
@property(nonatomic, copy) NSString *contactName  ;
@property(nonatomic, copy) NSString *contactPhone  ;

@property(nonatomic, copy) NSString *id ;
@property(nonatomic, copy) NSString *province ;
@property(nonatomic, copy) NSString *roleId  ;

@end
