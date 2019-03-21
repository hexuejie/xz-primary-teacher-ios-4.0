//
//  ApplyRecordCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/8/24.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ApplyRecordCellBlock)( NSIndexPath * index);
@class ApplyRecordModel ;
@interface ApplyRecordCell : UITableViewCell
@property(nonatomic,strong) NSIndexPath * index;
@property(nonatomic, copy) ApplyRecordCellBlock urgedBlock;
- (void)setupCellInfo:(ApplyRecordModel *)model;
@end
