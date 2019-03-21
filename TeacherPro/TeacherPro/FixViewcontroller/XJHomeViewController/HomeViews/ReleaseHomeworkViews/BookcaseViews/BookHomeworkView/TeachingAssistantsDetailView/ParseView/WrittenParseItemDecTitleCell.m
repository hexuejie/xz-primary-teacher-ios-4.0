//
//  WrittenParseItemDecTitleCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/11/8.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "WrittenParseItemDecTitleCell.h"
#import "PublicDocuments.h"

@interface WrittenParseItemDecTitleCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;
@property (weak, nonatomic) IBOutlet UIView *bgView;


@end
@implementation WrittenParseItemDecTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubview];
}

- (void)setupSubview{
    
    self.bgView.backgroundColor = UIColorFromRGB(0xDEEDFE);
}

- (void)setupTitle:(NSString *)title{
    
    self.titleLabel.text = title;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
