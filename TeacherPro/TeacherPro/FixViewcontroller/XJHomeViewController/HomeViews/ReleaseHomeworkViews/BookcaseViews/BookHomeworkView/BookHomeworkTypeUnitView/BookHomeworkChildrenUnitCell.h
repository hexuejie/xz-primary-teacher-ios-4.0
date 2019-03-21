//
//  BookHomeworkChildrenUnitCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/9/15.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookHomeworkChildrenUnitCell : UITableViewCell
- (void)setupChildrenUnitName:(NSString *)name withSelectedState:(BOOL )selectedSate;
- (void)setupArrowImgHidden:(BOOL)hidden;
@end
