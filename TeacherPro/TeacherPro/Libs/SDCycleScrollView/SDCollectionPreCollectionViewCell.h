//
//  SDCollectionPreCollectionViewCell.h
//  TeacherPro
//
//  Created by 何学杰 on 2019/1/29.
//  Copyright © 2019 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+add.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDCollectionPreCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) UIView *backGView;
@property (strong, nonatomic) UIImageView *advImageView;
@property (strong, nonatomic) UITextView *contentLabel;

@property (nonatomic,strong) CADisplayLink *progressTimer;

@property (strong, nonatomic) NSDictionary *dataDic;
@property (nonatomic, assign) BOOL isChinese;
@property (nonatomic,assign) NSInteger currentLcrIndex;

/** 只展示文字轮播 */
@property (nonatomic, assign) BOOL onlyDisplayText;

@end

NS_ASSUME_NONNULL_END
