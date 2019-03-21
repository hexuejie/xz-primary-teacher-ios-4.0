//
//  HomeViewController.h
//  TeacherPro
//
//  Created by DCQ on 2017/5/3.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BaseNetworkViewController.h"

typedef NS_ENUM(NSInteger, HomeViewControllerType){
   HomeViewControllerType_Normal    = 0,
    HomeViewControllerType_Info        ,
    HomeViewControllerType_Login       ,
    
};
@interface HomeViewController : BaseNetworkViewController
- (instancetype)initWithType:(HomeViewControllerType) type;
@end
