//
//  LeftGradeCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/5/11.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftGradeCell : UITableViewCell
- (void)setupCellInfo:(NSString *)grade withManagerClass:(NSString *)managerName withJoinClass:(NSString *)joinName;
- (void)setupBackgroundView:(UIColor *)color textColor:(UIColor *)textColor layerColor:(UIColor *)layerColor;
@end
