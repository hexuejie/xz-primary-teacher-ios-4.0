//
//  HWGameTypeDetailCell.h
//  TeacherPro
//
//  Created by DCQ on 2018/7/19.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HWGameTypeDetailBtnBlock)(NSIndexPath * indexPath);
@interface HWReportZXLXTypeDetailCell : UITableViewCell
@property(nonatomic, copy) HWGameTypeDetailBtnBlock btnBlock;
@property(nonatomic, strong) NSIndexPath * indexPath;
- (void)setupBtnTitle:(NSString *)title;
@end
