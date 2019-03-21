//
//  BookHomeworkChildrenUnitChooseCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/9/15.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookHomeworkChildrenUnitChooseCell : UITableViewCell
- (void)setupChildrenUnitName:(NSString *)name withState:(BOOL )isSelected;
- (void)setSelectedImgVHidden:(BOOL)hidden;
@end
