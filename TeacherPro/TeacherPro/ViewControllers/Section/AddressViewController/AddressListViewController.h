//
//  AddressListViewController.h
//  TeacherPro
//
//  Created by DCQ on 2017/5/5.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BaseNetworkViewController.h"
//选择完学校返回到主界面调用方法
typedef void(^SelectAddressBlock)(void);

@interface AddressListViewController : BaseNetworkViewController
@property(nonatomic, copy)SelectAddressBlock addressSuccessblock;
@end
