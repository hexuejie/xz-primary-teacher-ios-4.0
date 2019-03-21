//
//  HomeworkProblemsChapterSectionCell.h
//  TeacherPro
//
//  Created by DCQ on 2018/1/19.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeworkProblemsChapterSectionCell : UITableViewCell
- (void)setupTitle:(NSString *)titleStr withIsSelected:(BOOL)selected;
- (void)setupShowChooseImgVSate:(BOOL)YesOrNo;
@end
