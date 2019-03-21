//
//  PhonicsHomeworkCollectionViewHeader.h
//  TeacherPro
//
//  Created by 何学杰 on 2019/1/7.
//  Copyright © 2019 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class BookPreviewDetailModel;
@interface PhonicsHomeworkCollectionViewHeader : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *intoButton;

-(void)setupPreviewDetailInfo:(BookPreviewDetailModel *)detailModel;
@end

NS_ASSUME_NONNULL_END
