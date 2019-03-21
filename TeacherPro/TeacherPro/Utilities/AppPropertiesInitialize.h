//
//  AppPropertiesInitialize.h
//  TeacherPro
//
//  Created by DCQ on 2017/4/24.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppPropertiesInitialize : NSObject
/**
 @ 方法描述    进行应用程序一系列属性的初始化设置
 @ 输入参数    无
 @ 返回值      void
 @ 创建人
 
 */
+ (void)startAppPropertiesInitialize;


/**
 @ 方法描述    对键盘事件进行设置取消or开启
 @ 输入参数    是否取消
 @ 返回值      void
 @ 创建人
 
 */
+ (void)setKeyboardManagerEnable:(BOOL)enable;

@end
