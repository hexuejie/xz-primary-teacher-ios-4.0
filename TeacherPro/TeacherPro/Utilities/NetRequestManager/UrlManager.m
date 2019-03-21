//
//  UrlManager.m
//  TeacherPro
//
//  Created by DCQ on 2017/4/24.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "UrlManager.h"
#import "Interface.h"

@implementation UrlManager
+ (NSString *)getRequestNameSpace
{
    // 服务器选择的类型(0:政府外网 1:公司外网)
    //    NSNumber *serviceSeletedValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"service"];
    
    NSString *nameSpace = nil;
    
    //    nameSpace = Request_NameSpace;
    nameSpace = Request_NameSpace_company_internal;
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:EnvironmentIndex] == 2) {//181
        nameSpace = @"http://192.168.1.181/TeacherServer/single_api";//
    }else if ([[NSUserDefaults standardUserDefaults] integerForKey:EnvironmentIndex] == 1) {//150
        nameSpace = @"http://218.76.7.150:8080/ajiau-api/TeacherServer/single_api";//
    }else if ([[NSUserDefaults standardUserDefaults] integerForKey:EnvironmentIndex] == 0) {//正式
        nameSpace = @"https://api.p.ajia.cn/TeacherServer/single_api";//
    }
    

    if (nameSpace && 0 != nameSpace.length)
    {
        if (![nameSpace hasSuffix:@"/"])
        {
            return nameSpace;
        }
        else
        {
            return [nameSpace stringByReplacingCharactersInRange:NSMakeRange(nameSpace.length - 1, 1) withString:@""];
        }
    }
    return nil;
}

+ (NSString *)getImageNameSpace
{
    // 服务器选择的类型(0:政府外网 1:公司外网)
    NSNumber *serviceSeletedValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"service"];
    
    NSString *nameSpace = nil;
    
    //    nameSpace = Img_NameSpace;
    //    nameSpace = Img_NameSpace_company_internal;
    
    //    if (0 == serviceSeletedValue.intValue)
    //        nameSpace = Img_NameSpace_gov;
    //    else if (1 == serviceSeletedValue.intValue)
    //        nameSpace = Img_NameSpace_company_external;
    //    else if (2 == serviceSeletedValue.intValue)
    //        nameSpace = Img_NameSpace_company_internal;
    //    else if (3 == serviceSeletedValue.intValue)
    //        nameSpace = Img_NameSpace_company_external_test;
    
    if (nameSpace && 0 != nameSpace.length)
    {
        if (![nameSpace hasSuffix:@"/"])
        {
            return nameSpace;
        }
        else
        {
            return [nameSpace stringByReplacingCharactersInRange:NSMakeRange(nameSpace.length - 1, 1) withString:@""];
        }
    }
    return nil;
}

+ (NSURL *)getRequestUrlByMethodName:(NSString *)methodName
{
    return [self getRequestUrlByMethodName:methodName andArgsDic:nil];
}

+ (NSURL *)getRequestUrlByMethodName:(NSString *)methodName andArgsDic:(NSDictionary *)dic
{
    NSString *nameSpaceStr = [self getRequestNameSpace];
    
    NSURL *url = nil;
    
    if (nameSpaceStr && 0 != nameSpaceStr.length)
    {
        methodName = [methodName   stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *urlStr;
        if ([[methodName substringWithRange:NSMakeRange(0, 1) ] isEqualToString:@"/"]) {
            // 不用stringByAppendingPathComponent:,这个会自动把http://中的一个/去掉
            urlStr = [nameSpaceStr stringByAppendingFormat:@"%@",methodName];
        }else{
        
           urlStr = [nameSpaceStr stringByAppendingFormat:@"/%@",methodName];
        }
        
        
        if (dic && 0 != dic.count)
        {
            urlStr = [urlStr stringByAppendingFormat:@"?%@",[UrlManager urlArgsStringFromDictionary:dic]];
        }
        NSString * encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)urlStr, NULL, NULL,  kCFStringEncodingUTF8 ));
        url = [NSURL URLWithString: encodedString];
    }
    return url;
}



+ (NSURL *)getRequestUrlByMethodName:(NSString *)methodName andArgsDicStr:(NSDictionary *)dic{
    
    NSString *nameSpaceStr = [self getRequestNameSpace];
    
    NSURL *url = nil;
    
    if (nameSpaceStr && 0 != nameSpaceStr.length)
    {
        // 不用stringByAppendingPathComponent:,这个会自动把http://中的一个/去掉
        NSString *urlStr = [nameSpaceStr stringByAppendingFormat:@"%@",methodName];
        
        if (dic && 0 != dic.count)
        {
            urlStr = [urlStr stringByAppendingFormat:@"%@",[UrlManager urlArgsSpecialStringFromDictionary:dic specialStr:@"/"]];
        }
        NSString * encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)urlStr, NULL, NULL,  kCFStringEncodingUTF8 ));
        url = [NSURL URLWithString: encodedString];
    }
    return url;
}


#pragma mark ---------

+ (NSString*)urlArgsStringFromDictionary:(NSDictionary*)dict
{
    NSMutableArray* keyValues = [NSMutableArray arrayWithCapacity:[dict count]];
    for (NSString* key in dict)
    {
        NSString* value = [dict objectForKey:key];
        NSString* keyValue = [NSString stringWithFormat:@"%@=%@", key, value];
        [keyValues addObject:keyValue];
    }
    return [keyValues componentsJoinedByString:@"&"];
}

+ (NSString*) urlArgsSpecialStringFromDictionary:(NSDictionary *)dict specialStr:(NSString *)special{
    
    NSMutableArray* keyValues = [NSMutableArray arrayWithCapacity:[dict count]];
    for (NSString* key in dict)
    {
        NSString* value = [dict objectForKey:key];
        NSString* keyValue = [NSString stringWithFormat:@"%@%@",special,value];
        [keyValues addObject:keyValue];
    }
    return [keyValues componentsJoinedByString:[NSString stringWithFormat:@"%@",special]];
}
#pragma mark ----

@end
