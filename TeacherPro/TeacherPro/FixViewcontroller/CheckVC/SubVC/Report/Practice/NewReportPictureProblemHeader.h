//
//  NewReportPictureProblemHeader.h
//  TeacherPro
//
//  Created by 何学杰 on 2019/1/16.
//  Copyright © 2019 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCChart.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewReportPictureProblemHeader : UIView

@property (assign, nonatomic) NSInteger currnetSelected;

@property (strong, nonatomic) UIView *circleView;

@property (strong, nonatomic) SCCircleChart *chartView1;
@property (strong, nonatomic) SCCircleChart *chartView2;
@property (strong, nonatomic) SCCircleChart *chartView3;

@property (strong, nonatomic) UILabel *titleLabel1;
@property (strong, nonatomic) UILabel *titleLabel2;
@property (strong, nonatomic) UILabel *titleLabel3;

@property (strong, nonatomic) UIView *tagView;

- (void)configUI:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
