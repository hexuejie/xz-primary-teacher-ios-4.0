//
// /Users/pxj/Documents/ios_code/lexiwed2/code/lexiwed2.xcodeproj NSString+custom.m
//  lexiwed2
//
//  Created by pxj on 16/10/13.
//  Copyright © 2016年 乐喜网. All rights reserved.
//

#import "NSString+custom.h"

@implementation NSString (custom)

/**
 *  判断字符串为空
 *
 *  @return 返回YES为空
 */
- (BOOL)isEmpty{
    if ([self isEqualToString:@""]||self == nil||self == NULL||self) {
        return YES;
    }else{
        return NO;
    }
}

/**
 *  追加字符串并且判断字符串结构
 *
 *  @param preString   前一段字符串
 *  @param finalString 后一段字符串
 *  @param nullString  出现意外的时候的字符串
 *
 *  @return 返回最终的字符串
 */
+ (NSString *)customStringByAppendingFormer:(NSString *)preString Later:(NSString *)finalString Null:(NSString *)nullString{
    if ([finalString isEmpty]||[preString isEmpty]) {
        return nullString;
    }else{
        NSString *resultString = [NSString stringWithFormat:@"%@%@",preString,finalString];
        return resultString;
    }
}

@end
