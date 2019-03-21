//
//  StudentHomeworkUnitSectionCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/7/9.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^StudentHomeworkUnitSectionCellBlock)(NSIndexPath *index);
@interface StudentHomeworkUnitSectionCell : UITableViewCell
@property(nonatomic, strong) NSIndexPath * index;
@property(nonatomic, copy) StudentHomeworkUnitSectionCellBlock unitDetailBlock;
- (void)setupUnitSectionInfo:(NSDictionary *)dic withImageName:(NSString *)imageName withType:(NSString *)type;
@end
