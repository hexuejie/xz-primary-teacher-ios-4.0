 
//  CachedDownloadManager.h
//  TeacherPro
//
//  Created by DCQ on 2017/8/21.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CachedDownloadManager : NSObject
/// 缓存一个数据
+ (void)storeResponseData:(NSData *)data cacheKey:(NSString *)key expiresInSeconds:(NSTimeInterval)expiresInSeconds;

/// 根据key值获取一个已缓存的数据
+ (NSData *)cachedResponseDataForKey:(NSString *)key;

/// 根据key值移除一个已缓存的数据
+ (void)removeCachedDataForKey:(NSString *)key;

/// 移除所以已缓存的数据
+ (void)clearAllCachedResponses;
@end
