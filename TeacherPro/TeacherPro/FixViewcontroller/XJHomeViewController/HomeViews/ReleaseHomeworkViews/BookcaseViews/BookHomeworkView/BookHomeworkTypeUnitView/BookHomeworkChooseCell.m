//
//  BookHomeworkChooseCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/9/7.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BookHomeworkChooseCell.h"
#import "PublicDocuments.h"

@interface BookHomeworkChooseCell()
@property (weak, nonatomic) IBOutlet UILabel *unitNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImgV;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;

@end
@implementation BookHomeworkChooseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubview];
}
- (void)setupSubview{
    
    self.unitNameLabel.textColor = UIColorFromRGB(0x6b6b6b);
    self.unitNameLabel.font = fontSize_14;
    self.bottomLine.backgroundColor = project_line_gray;
}

- (void)setupUnitName:(NSString *)unitName withChooseState:(BOOL)selected{

    self.unitNameLabel.text = unitName;
    NSString * imageName = @"homework_unselected.png";
    if (selected) {
        imageName = @"homework_selected.png";
    }
    self.selectedImgV.image = [UIImage imageNamed:imageName];
}

- (void)setSelectedImgVHidden:(BOOL)hidden{
    self.selectedImgV.hidden = hidden;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
