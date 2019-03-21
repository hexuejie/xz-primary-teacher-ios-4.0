//
//  NSString+Extension.h
//  lexiwed2
//
//  Created by Kyle on 2017/3/22.
//  Copyright © 2017年 乐喜网. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(Extension)

-(NSURL *)covertURL;
- (CGFloat)widthWithFont:(UIFont*)font;
- (CGSize)sizeWithFont:(UIFont*)font andMaxSize:(CGSize)size;
+ (CGSize)sizeWithString:(NSString*)str andFont:(UIFont*)font andMaxSize:(CGSize)size;

- (NSMutableDictionary *)getURLParameters;

- (NSString*)sha256;
@end
