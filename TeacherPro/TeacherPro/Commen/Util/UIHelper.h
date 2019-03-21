//
//  ESUIHelper.h
//  eShop
//
//  Created by Kyle on 14-10-13.
//  Copyright (c) 2014年 yujiahui. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^ESCompletion)(void);

typedef NS_ENUM(NSUInteger, TabBarControllerType)
{
    TabBarControllerHome = 0,
    TabBarControllerCategory,
    TabBarControllerShopCar,
    TabBarControllerUserCenter,
    TabBarControllerMore,
    TabBarControllerTotal
};


@interface UIHelper : NSObject


@end
