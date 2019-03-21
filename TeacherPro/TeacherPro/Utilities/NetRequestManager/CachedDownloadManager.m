//
//  CachedDownloadManager.m
//  TeacherPro
//
//  Created by DCQ on 2017/8/21.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "CachedDownloadManager.h"
#import "DownloadCache.h"
#import "CoreDataManager.h"

@implementation CachedDownloadManager
+ (void)storeResponseData:(NSData *)data cacheKey:(NSString *)key expiresInSeconds:(NSTimeInterval)expiresInSeconds
{
    DownloadCache *downloadCache = [[CoreDataManager shareCoreDataManagerManager] createEmptyObjectWithEntityName:@"DownloadCache"];
    downloadCache.key = key;
    downloadCache.cacheDate = [NSDate date];
    downloadCache.expiresInSeconds = [NSNumber numberWithDouble:expiresInSeconds];
    downloadCache.contentData = data;
    downloadCache.expiryDate = [[NSDate date] dateByAddingTimeInterval:expiresInSeconds];
    
    [[CoreDataManager shareCoreDataManagerManager] save];
    
}

+ (NSData *)cachedResponseDataForKey:(NSString *)key
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"key == %@",key];/*用CONTAINS和LIKE(通配符)也可以,一定要注意字符串不能用''单引号括住*/
    
    NSArray *array = [[CoreDataManager shareCoreDataManagerManager] getListWithPredicate:predicate sortDescriptors:nil entityName:@"DownloadCache" limitNum:[NSNumber numberWithInt:1]];
    
    if (array && 0 != array.count)
    {
        DownloadCache *downloadCache = [array lastObject];
        
        // 存储的数据已过期
        if (NSOrderedDescending == [[NSDate date] compare:downloadCache.expiryDate])
        {
            // 删除过期数据
            [self removeCachedDataForKey:key];
            
            return nil;
        }
        return downloadCache.contentData;
    }
    return nil;
}

+ (void)removeCachedDataForKey:(NSString *)key
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"key == %@",key];/*用CONTAINS和LIKE(通配符)也可以,一定要注意字符串不能用''单引号括住*/
    
    NSArray *array = [[CoreDataManager shareCoreDataManagerManager] getListWithPredicate:predicate sortDescriptors:nil entityName:@"DownloadCache" limitNum:[NSNumber numberWithInt:1]];
    
    if (array && 0 != array.count)
    {
        DownloadCache *downloadCache = [array lastObject];
        
        [[CoreDataManager shareCoreDataManagerManager] deleteObject:downloadCache];
    }
}

+ (void)clearAllCachedResponses
{
    [[CoreDataManager shareCoreDataManagerManager] removeAllObjectWithEntityName:@"DownloadCache"];
}

@end
