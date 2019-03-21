//
//  BookHomeworkChooseCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/9/7.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookHomeworkChooseCell : UITableViewCell
- (void)setupUnitName:(NSString *)unitName withChooseState:(BOOL)selected;
- (void)setSelectedImgVHidden:(BOOL)hidden;
@end
