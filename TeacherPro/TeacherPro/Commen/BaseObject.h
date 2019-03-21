//
//  BaseObject.h
//  eShop
//
//  Created by Kyle on 14-10-15.
//  Copyright (c) 2014年 yujiahui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBJson4.h"
//#import "LXEnum.h"


@interface BaseObject : NSObject



- (id) proxyForJson;

+(id)mockObj;
+(NSArray *)mockArray:(NSUInteger)number;

+(id)parseDic:(NSDictionary *)dic;
+(NSArray *)parseArrayDic:(NSArray *)array;


@end
