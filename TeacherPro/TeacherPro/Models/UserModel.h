//
//  UserModel.h
//  TeacherPro
//
//  Created by DCQ on 2017/4/25.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "Model.h"

@interface UserModel : Model


//感恩币
@property (nonatomic, copy) NSString * coin;
//用户姓名
@property (nonatomic, copy) NSString * name;

//可选属性 (就是说这个属性可以为null或者为空)
@property (strong, nonatomic) NSString<Optional>* schoolName;

//忽略属性 (就是完全忽略这个属性)
@property (strong, nonatomic) NSString<Ignore>* customProperty;
@end
