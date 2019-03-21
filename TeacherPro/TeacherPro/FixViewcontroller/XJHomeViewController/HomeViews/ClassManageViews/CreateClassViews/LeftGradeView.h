//
//  LeftGradeView.h
//  TeacherPro
//
//  Created by DCQ on 2017/5/11.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LeftGradeViewSelectedGrade)(NSString * gradeName);
@interface LeftGradeView : UIView
@property(nonatomic, copy) LeftGradeViewSelectedGrade gradeBlock;
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style;
-(void)setupSelectedGrade:(NSString *)gradeName dataInfo:(NSDictionary *)info;

@end
