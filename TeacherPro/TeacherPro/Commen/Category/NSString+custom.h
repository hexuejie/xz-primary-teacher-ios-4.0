//
//  NSString+custom.h
//  lexiwed2
//
//  Created by pxj on 16/10/13.
//  Copyright © 2016年 乐喜网. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (custom)

- (BOOL)isEmpty;

+ (NSString *)customStringByAppendingFormer:(NSString *)preString Later:(NSString *)finalString Null:(NSString *)nullString;
@end
