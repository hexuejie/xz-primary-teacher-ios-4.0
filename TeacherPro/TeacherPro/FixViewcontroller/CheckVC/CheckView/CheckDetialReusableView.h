//
//  CheckDetialReusableView.h
//  TeacherPro
//
//  Created by 何学杰 on 2018/12/24.
//  Copyright © 2018 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CheckDetialReusableView : UICollectionReusableView


@property (weak, nonatomic) IBOutlet UILabel *courseName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *finishTagTop;
@property (weak, nonatomic) IBOutlet UILabel *finishLabel;
@property (weak, nonatomic) IBOutlet UILabel *allCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (weak, nonatomic) IBOutlet UIView *lineNid;


@property (assign, nonatomic)  BOOL isFirst;

@end

NS_ASSUME_NONNULL_END
