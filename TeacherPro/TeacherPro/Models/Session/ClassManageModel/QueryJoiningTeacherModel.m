

//
//  QueryJoiningTeacherModel.m
//  TeacherPro
//
//  Created by DCQ on 2017/8/4.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "QueryJoiningTeacherModel.h"

@implementation QueryJoiningTeacherModel

@end

@implementation JoiningTeacherModel


+(JSONKeyMapper*)keyMapper
{
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                       @"isRegister": @"register"
                                                      }];
}


@end
