 
//  DownloadCache.h
//  TeacherPro
//
//  Created by DCQ on 2017/8/18.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface DownloadCache : NSManagedObject

/// 被缓存的日期
@property (nonatomic, strong) NSDate * cacheDate;
/// 缓存有效期
@property (nonatomic, strong) NSNumber * expiresInSeconds;
/// 过期日期
@property (nonatomic, strong) NSDate * expiryDate;
/// 缓存内容
@property (nonatomic, strong) NSData * contentData;
/// key值
@property (nonatomic, copy) NSString * key;
@end
