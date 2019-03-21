//
//  NSDate+Extension.h
//  lexiwed2
//
//  Created by Kyle on 2017/3/28.
//  Copyright © 2017年 乐喜网. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate(Extension)

+(NSString *)weddingDateString:(NSDate*)date;
-(NSString*)yyyyMMdd;
+(BOOL)isBetweenFromStartDate:(NSString *)startDate toEndDate:(NSString *)endDate;
+(NSDate *)dateFromTimeInterval:(long)timeInterval;
-(NSString*)yyyyMMddhhmm;

@end
