//
//  Model.m
//  TeacherPro
//
//  Created by DCQ on 2017/4/24.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "Model.h"

@implementation Model


// //设置下划线自动转驼峰
//+(JSONKeyMapper*)keyMapper
//{
//    return [JSONKeyMapper mapperForSnakeCase];
//}
//
//设置所有的属性为可选(所有属性值可以为空)
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

/*
//自定义JSON校验
- (BOOL)validate:(NSError *__autoreleasing *)error {
    BOOL valid = [super validate:error];
    
    if (self.nameT.length < self.minNameLength.integerValue) {
        *error = [NSError errorWithDomain:@"me.mycompany.com" code:1 userInfo:nil];
        valid = NO;
    }
    
    return valid;
}
*/
/*
/////自定义处理指定的属性
// Convert and assign the locale property
- (void)setLocaleWithNSString:(NSString*)string {
    self.locale = [NSLocale localeWithLocaleIdentifier:string];
}

- (NSString *)JSONObjectForLocale {
    return self.locale.localeIdentifier;
}
*/
@end
