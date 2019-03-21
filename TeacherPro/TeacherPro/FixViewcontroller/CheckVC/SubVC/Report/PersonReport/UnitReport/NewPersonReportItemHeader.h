//
//  NewPersonReportItemHeader.h
//  TeacherPro
//
//  Created by 何学杰 on 2019/1/22.
//  Copyright © 2019 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewPersonReportItemHeader : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *titleStarBottom;
@property (weak, nonatomic) IBOutlet UIButton *starButton1;
@property (weak, nonatomic) IBOutlet UIButton *starButton2;
@property (weak, nonatomic) IBOutlet UIButton *starButton3;
@property (weak, nonatomic) IBOutlet UIButton *starButton4;
@property (weak, nonatomic) IBOutlet UIButton *starButton5;




@property (weak, nonatomic) IBOutlet UILabel *gradeTipLabel;
@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;
@property (weak, nonatomic) IBOutlet UIView *levelbackground;






@end

NS_ASSUME_NONNULL_END
