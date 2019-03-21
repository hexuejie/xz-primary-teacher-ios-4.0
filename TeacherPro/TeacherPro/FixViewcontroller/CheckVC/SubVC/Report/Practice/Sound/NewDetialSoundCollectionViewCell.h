//
//  NewDetialSoundCollectionViewCell.h
//  TeacherPro
//
//  Created by 何学杰 on 2019/1/15.
//  Copyright © 2019 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewDetialSoundCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *backGroundButton;



@property (weak, nonatomic) IBOutlet UIImageView *soundCheckUpImage;

@property (strong, nonatomic) NSDictionary *dataDic;
//@property (assign, nonatomic) BOOL *isPlay;
@end

NS_ASSUME_NONNULL_END
