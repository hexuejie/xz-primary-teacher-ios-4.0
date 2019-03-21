//
//  Env.h
//  CommonLib
//
//  Created by Kyle on 14-10-11.
//  Copyright (c) 2014年 yujiahui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/utsname.h>
#import "LXDeviceVersion.h"

#define kStandardWidth 320.0f




@interface Env : NSObject



@property (nonatomic, readonly) NSUInteger systemMajorVersion; //系统版本号
@property (nonatomic, readonly) DeviceSize deviceSize;
@property (nonatomic, readonly) CGSize screenSize;
@property (nonatomic, readonly) CGFloat screenWidth;
@property (nonatomic, readonly) NSUInteger scale;

@property (nonatomic, readonly) NSString *deviceName;
@property (nonatomic, copy) NSString *screenWidthString;
@property (nonatomic, copy) NSString *screenHeightString;

+(instancetype)shareEnv;



@end
