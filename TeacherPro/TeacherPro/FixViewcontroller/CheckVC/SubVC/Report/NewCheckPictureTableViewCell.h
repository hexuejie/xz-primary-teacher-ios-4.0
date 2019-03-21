//
//  NewCheckPictureTableViewCell.h
//  TeacherPro
//
//  Created by 何学杰 on 2019/1/3.
//  Copyright © 2019 ZNXZ. All rights reserved.
//

#import "LXBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewCheckPictureTableViewCell : LXBaseTableViewCell
@property (weak, nonatomic) IBOutlet UIView *backgroundBottom;


@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *rankButton;

@property (weak, nonatomic) IBOutlet UIView *circleView;


@property (weak, nonatomic) IBOutlet UILabel *prefectLabel;
@property (weak, nonatomic) IBOutlet UILabel *basicLabel;
@property (weak, nonatomic) IBOutlet UILabel *needLabel;

@property (weak, nonatomic) IBOutlet UILabel *nonLabel;


@property (nonatomic, strong) NSDictionary *dataDic;
- (void)configUI:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
