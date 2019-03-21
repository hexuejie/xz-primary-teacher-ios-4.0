//
//  GFMallAddressEditNameOrPhoneCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/12/7.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GFMallAddressEditBlock)(NSString *inputText);
@interface GFMallAddressEditNameOrPhoneCell : UITableViewCell
- (void)setupTitle:(NSString *)title withPlaceholder:(NSString *)placeholder;
@property(nonatomic, copy)GFMallAddressEditBlock inputBlock;
@property(nonatomic, strong) NSIndexPath * indexPath;
- (void)setupContent:(NSString *)contentStr;
@end
