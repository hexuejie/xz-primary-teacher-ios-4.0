//
//  UserDefault.h
//  eShop
//
//  Created by Kyle on 14-10-16.
//  Copyright (c) 2014年 yujiahui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Config.h"

@interface UserDefault : NSObject


+(NSInteger)integerValueForKey:(NSString *)key;
+(void)setintegerValue:(NSInteger)value forKey:(NSString *)key;

+(double)doubleValueForKey:(NSString *)key;
+(void)setDoubleValue:(double)value forKey:(NSString *)key;

+(CGFloat)floatValueForKey:(NSString *)key;
+(void)setFloatVaule:(CGFloat)value forKey:(NSString *)key;

+(BOOL)BoolValueForKey:(NSString *)key;
+(void)setBoolVaule:(BOOL)value forKey:(NSString *)key;

+(id)objectValueForKey:(NSString *)key;
+(void)setObjectValue:(id)value forKey:(NSString *)key;

@end
