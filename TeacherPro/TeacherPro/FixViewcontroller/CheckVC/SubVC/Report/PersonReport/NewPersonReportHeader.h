//
//  NewPersonReportHeader.h
//  TeacherPro
//
//  Created by 何学杰 on 2019/1/21.
//  Copyright © 2019 ZNXZ. All rights reserved.
//

#import "LXBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewPersonReportHeader : LXBaseTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headerLogo;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;



@end

NS_ASSUME_NONNULL_END
