//
//  Env.m
//  CommonLib
//
//  Created by Kyle on 14-10-11.
//  Copyright (c) 2014年 yujiahui. All rights reserved.
//

#import "Env.h"


@interface Env()


@property (nonatomic, assign, readwrite) NSUInteger systemMajorVersion;
@property (nonatomic, assign, readwrite) DeviceSize deviceSize;
@property (nonatomic, assign, readwrite) CGSize screenSize;
@property (nonatomic, assign, readwrite) CGFloat screenWidth;
@property (nonatomic, assign, readwrite) NSUInteger scale;

@property (nonatomic, strong) NSString *deviceName;

@end


@implementation Env


+ (instancetype)shareEnv {
    static Env *env = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        env = [[Env alloc] init];
    });
    
    return env;
}



- (id)init
{
    self =[super init];
    if (self) {
        
        _systemMajorVersion = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
        _deviceName = [LXDeviceVersion deviceNameString];
        _deviceSize = [LXDeviceVersion deviceSize];
        _screenSize = [[UIScreen mainScreen] bounds].size;
        _screenWidth = _screenSize.width;
        _scale = 2;
        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
            _scale = [[UIScreen mainScreen] scale];
        }

        _screenWidthString = [NSString stringWithFormat:@"%ld",(long)_screenSize.width];
        _screenHeightString = [NSString stringWithFormat:@"%ld",(long)_screenSize.height];
    }
    return self;
}








@end
