//
//  LXDeviceVersion.h
//  lexiwed2
//
//  Created by Kyle on 2017/7/19.
//  Copyright © 2017年 乐喜网. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DeviceVersion){
    UnknownDevice  = 0     ,
    Simulator            ,

    iPhone4              ,
    iPhone4S             ,
    iPhone5              ,
    iPhone5C             ,
    iPhone5S             ,
    iPhone6              ,
    iPhone6Plus          ,
    iPhone6S             ,
    iPhone6SPlus         ,
    iPhone7              ,
    iPhone7Plus          ,
    iPhoneSE             ,
    iPhone8              ,
    iPhone8Plus          ,
    iPhoneX              ,

    iPad1                ,
    iPad2                ,
    iPadMini             ,
    iPad3                ,
    iPad4                ,
    iPadAir              ,
    iPadMini2            ,
    iPadAir2             ,
    iPadMini3            ,
    iPadMini4            ,
    iPadPro12Dot9Inch    ,
    iPadPro9Dot7Inch     ,
    iPad5                ,
    iPadPro12Dot9Inch2Gen,
    iPadPro10Dot5Inch    ,

    iPodTouch1Gen        ,
    iPodTouch2Gen        ,
    iPodTouch3Gen        ,
    iPodTouch4Gen        ,
    iPodTouch5Gen        ,
    iPodTouch6Gen
};

typedef NS_ENUM(NSInteger, DeviceSize){
    UnknownSize     = 0,
    Screen3Dot5inch = 1,
    Screen4inch     = 2,
    Screen4Dot7inch = 3,
    Screen5Dot5inch = 4,
    Screen5Dot8inch = 5
};

@interface LXDeviceVersion : NSObject

+ (DeviceVersion)deviceVersion;
+ (NSString *)deviceNameForVersion:(DeviceVersion)deviceVersion;
+ (DeviceSize)deviceSize;
//+ (DeviceSize)deviceSize;
+ (NSString *)deviceSizeName:(DeviceSize)deviceSize;
+ (NSString *)deviceNameString;
//+ (BOOL)isZoomed;

+ (BOOL)versionEqualTo:(NSString *)version;
+ (BOOL)versionGreaterThan:(NSString *)version;
+ (BOOL)versionGreaterThanOrEqualTo:(NSString *)version;
+ (BOOL)versionLessThan:(NSString *)version;
+ (BOOL)versionLessThanOrEqualTo:(NSString *)version;

@end


