//
//  NSArray+custom.m
//  lexiwed2
//
//  Created by pxj on 16/10/13.
//  Copyright © 2016年 乐喜网. All rights reserved.
//

#import "NSArray+custom.h"

@implementation NSArray (custom)

/**
 *  自定义数组取值（防止程序崩溃）
 *
 *  @param index 所取的下标
 *
 *  @return 返回取值或者错误
 */
- (instancetype)customObjectAtIndex:(NSUInteger)index{
    if (self.count > index) {
        return self[index];
    }else{
        return nil;
    }
}
@end
