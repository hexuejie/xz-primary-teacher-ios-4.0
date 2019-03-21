//
//  AllRewardCell.h
//  AplusKidsMasterPro
//
//  Created by DCQ on 2017/3/21.
//  Copyright © 2017年 neon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AllRewardCellDetailBlock)(NSIndexPath * index);
@interface AllRewardCell : UITableViewCell
@property(nonatomic , strong) NSIndexPath * indexPath;
@property(nonatomic, copy) AllRewardCellDetailBlock detailBlock;
- (void)setupStudentInfo:(NSDictionary *)info withShowReward:(BOOL)isShow;
- (void)hiddenDetailButton;
- (void)hiddenDetailLabel;
@end
