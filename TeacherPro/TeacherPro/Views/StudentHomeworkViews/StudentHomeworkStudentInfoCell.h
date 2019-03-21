//
//  StudentHomeworkStudentInfoCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/7/9.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>


@class StudentHomeworkDetailModel;

@protocol StudentHomeworkStudentInfoCellDelegate <NSObject>

- (void)leftButtonAction:(NSInteger)currentPage;
- (void)rightButtonAction:(NSInteger)currentPage;
@end
@interface StudentHomeworkStudentInfoCell : UITableViewCell
@property(nonatomic, assign) NSInteger currentPage;
@property(nonatomic, weak) id<StudentHomeworkStudentInfoCellDelegate> delegate;
- (void)setupStuentName:(NSString *)name withCoin:(NSString *)coin withResults:(StudentHomeworkDetailModel *)results withStudentList:(NSArray *)studentList withCurrenntIndex:(NSInteger)currenntIndex;
@end
