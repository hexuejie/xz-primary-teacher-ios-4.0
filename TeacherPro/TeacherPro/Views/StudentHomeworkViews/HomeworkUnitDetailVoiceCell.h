//
//  HomeworkUnitDetailVoiceCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/7/12.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeworkUnitDetailModel ;

@class HomeworkUnitDetailVoiceCell ;
typedef void(^HomeworkUnitDetailVoiceCellBlock)(BOOL playBtnSelected,HomeworkUnitDetailVoiceCell *cell,NSIndexPath * indexPath);
@interface HomeworkUnitDetailVoiceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *fatherView;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property(nonatomic, strong) NSIndexPath * indexPath;
@property(nonatomic, copy)HomeworkUnitDetailVoiceCellBlock  playIndexPathBlock;
- (void)setupDetailModel:(HomeworkUnitDetailModel *)model;
- (void)resetVoiceView;
@end
