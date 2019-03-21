//
//  NSDate+Extension.m
//  lexiwed2
//
//  Created by Kyle on 2017/3/28.
//  Copyright © 2017年 乐喜网. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate(Extension)


+(NSString *)weddingDateString:(NSDate*)date{
    if (date == nil){
        return @"未设置婚期";
    }
    
    NSTimeInterval dateInterval = [date timeIntervalSinceReferenceDate];
    NSTimeInterval nowIntervval = [[NSDate date] timeIntervalSinceReferenceDate];
    
    if (dateInterval < nowIntervval){
        return @"婚礼已完成";
    }
    return [NSString stringWithFormat:@"婚期:%@",[date yyyyMMdd]];
}

-(NSString*)yyyyMMdd{
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    
    NSString *dateString = [format stringFromDate:self];
    return dateString;

}

-(NSString*)yyyyMMddhhmm{
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy/MM/dd hh:mm"];
    
    NSString *dateString = [format stringFromDate:self];
    return dateString;
    
}


+(BOOL)isBetweenFromStartDate:(NSString *)startDate toEndDate:(NSString *)endDate{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];//创建一个日期格式化器
    dateFormatter.dateFormat=@"yyyy-MM-dd hh:mm:ss";
    
    NSDate *currentDate = [NSDate date];
    NSDate *tempStartDate = [dateFormatter dateFromString:startDate];
    NSDate *tempEndDate = [dateFormatter dateFromString:endDate];
    
    NSComparisonResult result1 = [currentDate compare:tempStartDate];
    NSComparisonResult result2 = [currentDate compare:tempEndDate];
    
    if (result1 == NSOrderedDescending && result2 == NSOrderedAscending ) {
        return YES;
    }

    return NO;
    
}

+(NSDate *)dateFromTimeInterval:(long)timeInterval{
    
    NSDateFormatter *stampFormatter = [[NSDateFormatter alloc] init];
    [stampFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];

    return date;
    
}

@end
