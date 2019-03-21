//
//  ChechHomeworkDetailBookUnitCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/7/13.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckHomeworkDetailBookUnitCell : UITableViewCell
- (void)setupTitle:(NSString *)title withImageName:(NSString *)imageName withContent:(NSString *)content  withDetail:(NSString *)detail  withNumber:(NSString *)numberStr;
@end
