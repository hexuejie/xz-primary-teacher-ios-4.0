//
//  OnlineUnfinishedCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/8/15.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OnlineUnfinishedAdjustCell : UITableViewCell
- (void)setupSelectedImgHidden:(BOOL)YesOrNo;
- (void)setupSelectedImgState:(BOOL)YesOrNo;
- (void)setupStudentInfo:(NSDictionary *)info;
@end
