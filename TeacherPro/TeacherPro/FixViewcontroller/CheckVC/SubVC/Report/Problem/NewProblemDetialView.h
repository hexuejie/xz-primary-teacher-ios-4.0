//
//  NewProblemDetialView.h
//  TeacherPro
//
//  Created by 何学杰 on 2019/1/24.
//  Copyright © 2019 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewProblemDetialView : UIView

@property (nonatomic, strong) UIImageView *headerImage;
@property (nonatomic, strong) UIButton *headerPlayerButton;
@property (nonatomic, strong) UILabel *headerTitleLabel;

@property (nonatomic, strong) UIView *backGround;

@property (nonatomic, strong) NSDictionary *dataDic;
@property (nonatomic, strong) NSArray *dataArray;

- (CGFloat)heightForHeader;
@end

NS_ASSUME_NONNULL_END
