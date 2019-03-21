//
//  UnOnlineRewardCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/8/15.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectedItemBlock)(NSIndexPath *indexPath);
@interface UnOnlineRewardCell : UITableViewCell
@property(nonatomic, strong) NSIndexPath *indexPath;
@property(nonatomic, copy) SelectedItemBlock  selectedBlock;
- (void)setupStudentInfo:(NSDictionary *)info ;
@end
