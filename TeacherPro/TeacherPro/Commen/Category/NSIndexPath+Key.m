//
//  NSIdexPath+Key.m
//  eShop
//
//  Created by Kyle on 14-10-13.
//  Copyright (c) 2014年 yujiahui. All rights reserved.
//

#import "NSIndexPath+Key.h"

@implementation NSIndexPath(Key)


- (NSString *)keyOfIndexPath
{
    return [NSString stringWithFormat:@"%ld-%ld",(long)self.section,(long)self.row];
}

@end
