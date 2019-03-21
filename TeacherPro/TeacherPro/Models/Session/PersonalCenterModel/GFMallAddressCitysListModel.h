//
//  GFMallAddressCitysListModel.h
//  TeacherPro
//
//  Created by DCQ on 2017/12/7.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "Model.h"
@class GFMallAddressProvinceModel;
@protocol GFMallAddressProvinceModel;
@interface GFMallAddressCitysListModel : Model
@property(nonatomic, strong)NSArray<GFMallAddressProvinceModel> *  citys;
@end
@class GFMallAddressCityModel;
@protocol GFMallAddressCityModel;
@interface GFMallAddressProvinceModel : Model
@property(nonatomic, strong)NSArray <GFMallAddressCityModel>*  city;
@property(nonatomic, copy)NSString  *  province;
@property(nonatomic, copy)NSString *  provinceName;
@end
@interface GFMallAddressCityModel : Model

@property(nonatomic, copy)NSString  *  city;
@property(nonatomic, copy)NSString *  cityName;
@end
