//
//  ReleaseHomeworkTimeViewMask.h
//  TeacherPro
//
//  Created by 何学杰 on 2019/1/25.
//  Copyright © 2019 ZNXZ. All rights reserved.
//

#import "LXBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ReleaseHomeworkTimeViewMask : LXBaseTableViewCell

@property (weak, nonatomic) IBOutlet UIButton *cancleButton;
@property (weak, nonatomic) IBOutlet UIButton *finishButton;
@property (weak, nonatomic) IBOutlet UIDatePicker *pickBottom;


@end

NS_ASSUME_NONNULL_END
