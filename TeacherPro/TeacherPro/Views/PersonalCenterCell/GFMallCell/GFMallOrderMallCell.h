//
//  GFMallOrderMallCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/12/5.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GFMallModel;
typedef void(^GFMallCountBlock)(NSInteger giftCount);
@interface GFMallOrderMallCell : UITableViewCell
@property(nonatomic, copy) GFMallCountBlock giftBlock;
- (void)setupModel:(GFMallModel *)model;
@end
