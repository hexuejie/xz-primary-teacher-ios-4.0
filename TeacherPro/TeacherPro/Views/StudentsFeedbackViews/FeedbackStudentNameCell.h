//
//  FeedbackStudentNameCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/7/9.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedbackStudentNameCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *haedLogoImage;
@property (weak, nonatomic) IBOutlet UIButton *audioPlayer;


- (void)setupStudentName:(NSString *)studentName;
@end
