//
//  GFMallExchangeListViewController.h
//  TeacherPro
//
//  Created by DCQ on 2018/1/8.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "BaseTableViewController.h"

typedef NS_ENUM(NSInteger,GFMallExchangeVCType) {
    GFMallExchangeType_normal = 0,
    GFMallExchangeType_detail ,
};
@interface GFMallExchangeListViewController : BaseTableViewController
- (instancetype)initWithId:(NSString*)mallId withVC:(GFMallExchangeVCType )type;
@end
