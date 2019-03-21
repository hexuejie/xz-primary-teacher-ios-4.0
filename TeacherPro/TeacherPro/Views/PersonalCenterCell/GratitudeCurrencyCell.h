//
//  GratitudeCurrencyCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/7/6.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GratitudeChangeBtnBlock)(NSIndexPath *indexPath);
@class GratitudeCurrencyModel;
@interface GratitudeCurrencyCell : UITableViewCell
@property(nonatomic, strong) NSIndexPath * indexPath;
@property(nonatomic, copy)  GratitudeChangeBtnBlock giftChangeBlock;
- (void)setupGratitudeCellInfo:(GratitudeCurrencyModel *)info;
- (void)giftExchangeConsumption;
- (void)giftExchangeObtain;
@end
