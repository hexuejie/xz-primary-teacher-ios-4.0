//
//  NSObject+Extension.m
//  lexiwed2
//
//  Created by Kyle on 2017/3/22.
//  Copyright © 2017年 乐喜网. All rights reserved.
//

#import "NSObject+Extension.h"

@implementation NSObject(Extension)

+ (NSString*)className {
    return NSStringFromClass([self class]);
}

@end
