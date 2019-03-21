//
//  HomeBannerHeaderView.h
//  TeacherPro
//
//  Created by DCQ on 2018/8/22.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomeListModel;
@interface HomeBannerHeaderView : UIView
typedef void(^HomeBannerHeaderBlock)(NSInteger  advertisingIndex);
@property (copy, nonatomic) HomeBannerHeaderBlock  advertisingBlock;
- (void)setupHomeAdModel:(HomeListModel *)model;
@end
