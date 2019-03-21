//
//  CreateNewClassNormalCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/8/2.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "CreateNewClassNormalCell.h"
#import "PublicDocuments.h"

@interface CreateNewClassNormalCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;

@end
@implementation CreateNewClassNormalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubview];
}

- (void)setupSubview{

//    self.titleLabel.textColor = UIColorFromRGB(0x6b6b6b);
//    self.titleLabel.font = fontSize_14;
    self.bottomLine.backgroundColor = [UIColor clearColor];
    
    
}

- (void)setupTitle:(NSString *)title withIcon:(NSString *)imageName{

    self.titleLabel.text = title;
    self.iconImgV.image = [UIImage imageNamed:imageName];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
