//
//  GFMallAddressAdministerFooterCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/12/8.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GFMallAddressAdministerEditBlock)(NSIndexPath * indexPath);
typedef void(^GFMallAddressAdministerDelBlock)(NSIndexPath * indexPath);
@interface GFMallAddressAdministerFooterCell : UITableViewCell
@property(nonatomic, strong) NSIndexPath * indexPath;
@property(nonatomic, copy) GFMallAddressAdministerEditBlock  editBlock ;
@property(nonatomic, copy) GFMallAddressAdministerDelBlock  delBlock;
- (void)setupShowChooseAddressSate:(BOOL)showState;
@end
