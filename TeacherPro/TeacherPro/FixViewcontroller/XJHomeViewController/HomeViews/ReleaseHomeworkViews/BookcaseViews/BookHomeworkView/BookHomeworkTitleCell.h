//
//  BookHomeworkTitleCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/9/7.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BookHomeworkChangeBookBlock)();
@class BookPreviewDetailModel;
@interface BookHomeworkTitleCell : UITableViewCell
@property(nonatomic, copy) BookHomeworkChangeBookBlock changeBookBlock;
-(void)setupPreviewDetailInfo:(BookPreviewDetailModel *)detailModel;
@end
