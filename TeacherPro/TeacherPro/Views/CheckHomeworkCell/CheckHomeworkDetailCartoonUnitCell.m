
//
//  CheckHomeworkDetailCartoonUnitCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/7/13.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "CheckHomeworkDetailCartoonUnitCell.h"
#import "PublicDocuments.h"
@interface CheckHomeworkDetailCartoonUnitCell()
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;

@end
@implementation CheckHomeworkDetailCartoonUnitCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubview];
}

-(void)setupSubview
{
    self.bottomLineView.backgroundColor =  HexRGB(0xF5F5F5);
//    self.titleLabel.textColor = project_main_blue;
//    self.titleLabel.font = fontSize_14;
}

- (void)setupTitle:(NSString *)title withImageName:(NSString *)imageName{

    self.titleLabel.text = title;
    self.iconImgV.image = [UIImage imageNamed:imageName];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
