//
//  SessionHelper.h
//  AplusKidsMasterPro
//
//  Created by neon on 16/5/16.
//  Copyright © 2016年 neon. All rights reserved.
//

#import <Foundation/Foundation.h>
@class  SessionModel;
@interface SessionHelper : NSObject
typedef void (^LoadBlock)(id data);

+ (instancetype)sharedInstance;
- (void)saveCacheSession :(SessionModel *)session;
- (BOOL)checkUserStatus;
- (SessionModel *)getAppSession;
- (void)setAppSession:(SessionModel *)session;
- (BOOL)checkSession;
- (void)clearMessageList;
- (void)clearSaveCacheSession;
- (NSString *)getSessionPhone;
@end
