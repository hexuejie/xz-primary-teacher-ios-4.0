//
//  CheckHomeworkDetailKHLXUnitCell.h
//  TeacherPro
//
//  Created by DCQ on 2018/1/31.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CheckHomeworkDetailButtonBlock)(NSIndexPath * indexPath);
 
@interface CheckHomeworkDetailKHLXUnitCell : UITableViewCell
@property(nonatomic, copy) CheckHomeworkDetailButtonBlock detailBlock;
@property(nonatomic, strong) NSIndexPath * indexPath;
- (void)setupTitle:(NSString *)unit;
@end
