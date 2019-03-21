//
//  HWReportVoiceCell.h
//  TeacherPro
//
//  Created by DCQ on 2018/8/1.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HWReportVoicePlayBlock)(UIButton * btn,UILabel*playTitleLabel);
@interface HWReportVoiceCell : UITableViewCell
@property(nonatomic, copy) HWReportVoicePlayBlock playblock;
- (UIButton *)getPlayBtn;
- (UILabel *)getPlayTitleLabel;
@end
