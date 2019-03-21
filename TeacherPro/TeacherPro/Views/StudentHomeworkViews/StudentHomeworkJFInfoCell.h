//
//  StudentHomeworkJFInfoCell.h
//  TeacherPro
//
//  Created by DCQ on 2018/8/13.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^StudentHomeworkJFBlock)(void);

@interface StudentHomeworkJFInfoCell : UITableViewCell
@property(nonatomic, copy) StudentHomeworkJFBlock jfDetailBlock;
- (void)setupInfoCell:(NSArray *) unknowQuestions;
@end
