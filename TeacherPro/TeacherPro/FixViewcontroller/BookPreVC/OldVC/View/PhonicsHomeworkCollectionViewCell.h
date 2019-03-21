//
//  PhonicsHomeworkCollectionViewCell.h
//  TeacherPro
//
//  Created by 何学杰 on 2019/1/7.
//  Copyright © 2019 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookPreviewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PhonicsHomeworkCollectionViewCell : UICollectionViewCell


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (assign, nonatomic)  BOOL isSelected;

@property (nonatomic ,strong) ChildrenUnitModel *model;
@end

NS_ASSUME_NONNULL_END
