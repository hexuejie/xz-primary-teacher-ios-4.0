
//
//  RepositoryScreeningCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/9/19.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "RepositoryScreeningCell.h"
#import "PublicDocuments.h"
@interface RepositoryScreeningCell ()
@property (weak, nonatomic) IBOutlet UIView *bottomLine;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
@implementation RepositoryScreeningCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubview];
}
- (void)setupSubview{

    self.bottomLine.backgroundColor = project_line_gray;
    self.nameLabel.font = fontSize_12;
    self.nameLabel.textColor = UIColorFromRGB(0x6b6b6b);
    
}

- (void)setupName:(NSString *)name withChoose:(BOOL )isSelected{
    self.nameLabel.text = name;
    UIColor *textColor = nil;
    UIColor * backgroundColor = nil;
    if (isSelected) {
       textColor = project_main_blue;
        backgroundColor =  UIColorFromRGB(0xEAEAEA);
    }else{
       textColor = UIColorFromRGB(0x6b6b6b);
         backgroundColor = [UIColor whiteColor];
    }
    self.backgroundColor = backgroundColor;
    self.nameLabel.textColor = textColor;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
