//
//  LXBaseTableViewCell.h
//  lexiwed2
//
//  Created by Kyle on 2017/3/22.
//  Copyright © 2017年 乐喜网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LXSeparateView.h"

@interface LXBaseTableViewCell : UITableViewCell

@property (nonatomic, readonly) NSIndexPath *indexPath;
@property (nonatomic, readonly) LXSeparateView *lineView;
@property (nonatomic, assign) CGFloat lineHeight; // <= 0 隐藏 line

@property (nonatomic, assign) UIEdgeInsets lineEdge;

-(void)setup;

@end
