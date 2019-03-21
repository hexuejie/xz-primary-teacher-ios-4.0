//
//  NewRewardDetialCell.h
//  TeacherPro
//
//  Created by 何学杰 on 2019/1/3.
//  Copyright © 2019 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewRewardDetialCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *tagImage;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@property (strong ,nonatomic) NSDictionary *dataDic;

@end

NS_ASSUME_NONNULL_END
