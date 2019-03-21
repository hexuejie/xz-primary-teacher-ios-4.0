//
//  ReleaseStyleCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/6/12.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, ReleaseStyle) {
    
    ReleaseStyle_Normal                  = -1,
    ReleaseStyle_ReleaseGrade             = 0 ,//布置班级对象
    ReleaseStyle_ReleaseFeedback            ,//反馈方式
    ReleaseStyle_ReleaseCompleteDate        ,//完成时间
    
    
};
@interface ReleaseStyleCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
- (void)setupReleaseHomeworkStyle:(ReleaseStyle )style withDetail:(NSString *)detail;
- (void)hiddeArrow;
@end
