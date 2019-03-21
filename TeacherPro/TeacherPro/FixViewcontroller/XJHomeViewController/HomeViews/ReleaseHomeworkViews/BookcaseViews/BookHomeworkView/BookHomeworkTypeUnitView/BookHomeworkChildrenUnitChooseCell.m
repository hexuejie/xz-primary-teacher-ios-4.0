
//
//  BookHomeworkChildrenUnitChooseCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/9/15.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BookHomeworkChildrenUnitChooseCell.h"
#import "PublicDocuments.h"

@interface BookHomeworkChildrenUnitChooseCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *chooseImgV;
@property (weak, nonatomic) IBOutlet UIView *lineV;

@end
@implementation BookHomeworkChildrenUnitChooseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubview];
}

- (void)setupSubview{

    self.titleLabel.textColor = UIColorFromRGB(0x6b6b6b);
    self.titleLabel.font = fontSize_14;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setupChildrenUnitName:(NSString *)name withState:(BOOL )isSelected{

     NSString * imageName = @"homework_unselected.png";
    if (isSelected) {
        imageName = @"homework_selected.png";
    }
    self.chooseImgV.image = [UIImage imageNamed:imageName];
    self.titleLabel.text = name;
}

- (void)setSelectedImgVHidden:(BOOL)hidden{
    self.chooseImgV.hidden = hidden;
}
@end
