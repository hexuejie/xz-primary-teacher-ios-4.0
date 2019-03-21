
//
//  SessionModel.m
//  TeacherPro
//
//  Created by DCQ on 2017/5/2.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "SessionModel.h"

@implementation SessionModel



//序列化
- (void)encodeWithCoder:(NSCoder *)aCoder{
 
    [aCoder encodeObject:self.password forKey:@"password"];
    [aCoder encodeObject:self.thumbnail forKey:@"thumbnail"];
    [aCoder encodeObject:self.token forKey:@"token"];
    [aCoder encodeObject:self.teacherId forKey:@"teacherId"];
    [aCoder encodeObject:self.status forKey:@"status"];
    [aCoder encodeObject:self.schoolName forKey:@"schoolName"];
    [aCoder encodeObject:self.schoolId forKey:@"schoolId"];
    [aCoder encodeObject:self.phone forKey:@"phone"];
    [aCoder encodeObject:self.sex forKey:@"sex"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.levelId forKey:@"levelId"];
    [aCoder encodeObject:self.inviteCode forKey:@"inviteCode"];
    [aCoder encodeObject:self.historicalCoin forKey:@"historicalCoin"];
    [aCoder encodeObject:self.exp forKey:@"exp"];
    [aCoder encodeObject:self.ctime forKey:@"ctime"];
    [aCoder encodeObject:self.coin forKey:@"coin"];
    [aCoder encodeObject:self.hasClazz forKey:@"hasClazz"];
    
}
//反序列化
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (!self) { return nil; }
    self.name = [aDecoder decodeObjectForKey:@"name"];
    self.password = [aDecoder decodeObjectForKey:@"password"];
    self.thumbnail = [aDecoder decodeObjectForKey:@"thumbnail"];
    self.token = [aDecoder decodeObjectForKey:@"token"];
    self.teacherId = [aDecoder decodeObjectForKey:@"teacherId"];
    self.status = [aDecoder decodeObjectForKey:@"status"];
    self.schoolName = [aDecoder decodeObjectForKey:@"schoolName"];
    self.schoolId = [aDecoder decodeObjectForKey:@"schoolId"];
    self.phone = [aDecoder decodeObjectForKey:@"phone"];
    self.sex = [aDecoder decodeObjectForKey:@"sex"];
    self.levelId = [aDecoder decodeObjectForKey:@"levelId"];
    self.inviteCode = [aDecoder decodeObjectForKey:@"inviteCode"];
    self.historicalCoin = [aDecoder decodeObjectForKey:@"historicalCoin"];
    self.exp = [aDecoder decodeObjectForKey:@"exp"];
    self.ctime = [aDecoder decodeObjectForKey:@"ctime"];
    self.coin = [aDecoder decodeObjectForKey:@"coin"];
    self.hasClazz = [aDecoder decodeObjectForKey:@"hasClazz"];
    
    return self;
}


@end
