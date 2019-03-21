//
//  StudentHomeworkBookUnitSctionCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/7/27.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "StudentHomeworkBookUnitSctionCell.h"
#import "PublicDocuments.h"
#import "ProUtils.h"

@interface StudentHomeworkBookUnitSctionCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImgV;

@end
@implementation StudentHomeworkBookUnitSctionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = fontSize_14;
    self.bottomView.backgroundColor = project_background_gray;
}
- (void)setupTitle:(NSString *)title{

    self.titleLabel.text = title;

    UIImage  * bgImg = [ProUtils getResizableImage:[UIImage imageNamed:@"student_zxlx_type_bg.png"]   withEdgeInset:UIEdgeInsetsMake(10, 10, 10, 50)];
    [self.bgImgV setImage:bgImg ];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
