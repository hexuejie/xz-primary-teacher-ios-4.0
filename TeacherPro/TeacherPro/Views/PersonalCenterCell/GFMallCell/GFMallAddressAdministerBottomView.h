//
//  GFMallAddressAdministerBottomView.h
//  TeacherPro
//
//  Created by DCQ on 2017/12/8.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GFMallAddressAdministerAddBlock)( );
@interface GFMallAddressAdministerBottomView : UIView
@property(nonatomic, copy) GFMallAddressAdministerAddBlock  addBlock;
@end
