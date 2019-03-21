//
//  BookHomeworkYXLXUnitCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/9/7.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookHomeworkYXLXUnitCell : UITableViewCell
-(void)setupUnitName:(NSString *)unitName withSelectedState:(BOOL )selectedSate;
- (void)setupArrowImgHidden:(BOOL)hidden;
@end
