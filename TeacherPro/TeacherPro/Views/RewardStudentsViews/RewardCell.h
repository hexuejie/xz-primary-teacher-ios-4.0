//
//  RewardCell.h
//  AplusKidsMasterPro
//
//  Created by DCQ on 2017/3/9.
//  Copyright © 2017年 neon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RewardCell : UITableViewCell
- (void)setupStudentInfo:(NSDictionary *)info setupUnfinished:(BOOL)isUnfinished;
- (void)setupSelectedImgState:(BOOL)YesOrNo;
- (void)setupCoinNumber:(NSString *)coin;
- (void)setupSelectedImgHidden:(BOOL)YesOrNo;
@end
