//
//  NewCheckPictureLastTableViewCell.h
//  TeacherPro
//
//  Created by 何学杰 on 2019/1/3.
//  Copyright © 2019 ZNXZ. All rights reserved.
//

#import "LXBaseTableViewCell.h"
#import "SCChart.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewCheckPictureLastTableViewCell : LXBaseTableViewCell

@property (weak, nonatomic) IBOutlet UIView *backgroundbottom;

@property (weak, nonatomic) IBOutlet UIButton *rangButton;
@property (weak, nonatomic) IBOutlet UIView *circleView;

@property (strong, nonatomic) SCCircleChart *chartView1;
@property (strong, nonatomic) SCCircleChart *chartView2;
@property (strong, nonatomic) SCCircleChart *chartView3;

@property (weak, nonatomic) IBOutlet UILabel *problemLabel1;
@property (weak, nonatomic) IBOutlet UILabel *problemLabel2;
@property (weak, nonatomic) IBOutlet UILabel *problemLabel3;



@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondTop;
@property (weak, nonatomic) IBOutlet UIView *secondBottom;


@property (strong, nonatomic) NSArray *dataArray;

- (void)configUI:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
