//
//  CheckDetialCollectionCell.h
//  TeacherPro
//
//  Created by 何学杰 on 2018/12/24.
//  Copyright © 2018 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CheckDetialCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;



@property (weak, nonatomic) IBOutlet UIImageView *CheckUpImage;
@property (weak, nonatomic) IBOutlet UIImageView *checkGoodImage;
@property (weak, nonatomic) IBOutlet UIImageView *checkSpeedImage;


@property (nonatomic ,strong) NSDictionary *dataDic;
@end

NS_ASSUME_NONNULL_END
