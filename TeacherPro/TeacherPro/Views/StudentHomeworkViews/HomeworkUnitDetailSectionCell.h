//
//  HomeworkUnitDetailSectionCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/7/12.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeworkUnitDetailSectionCell : UITableViewCell
- (void)setupUnitName:(NSString *)unitName withQuestionNumber:(NSInteger)number withType:(NSString *)type;
@end
