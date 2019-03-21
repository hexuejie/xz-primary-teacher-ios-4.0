//
//  AdjustRewardView.h
//  AplusKidsMasterPro
//
//  Created by DCQ on 2017/3/9.
//  Copyright © 2017年 neon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AdjustRewardCoinBlock)(NSString * coinNumber,NSString * adjustCoinNubmer);
typedef void(^AdjustRewardSendCoinBlock)();
@interface AdjustRewardView : UIView
@property (nonatomic, copy) AdjustRewardCoinBlock  coinBlock;
@property (nonatomic, copy) AdjustRewardSendCoinBlock  sendCoinBlock;
- (void)setupCoinNumber:(NSString *)coinNumber;
- (void)setupLimitText:(NSString *)text withImage:(NSString *)imageName withType:(NSInteger)type;
- (void)setupMax:(NSInteger )max min:(NSInteger )min;
@end
