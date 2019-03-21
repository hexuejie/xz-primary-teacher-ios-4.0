//
//  ExchangeInstructionFirstSectionCell.m
//  TeacherPro
//
//  Created by DCQ on 2018/1/25.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "ExchangeInstructionFirstSectionCell.h"
#import "PublicDocuments.h"

@interface ExchangeInstructionFirstSectionCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
@implementation ExchangeInstructionFirstSectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    CGFloat fontSize =  14;
    UIFont * boldFont = (iPhone6Plus? [UIFont boldSystemFontOfSize:fontSize*ip6size]:[UIFont boldSystemFontOfSize:FITSCALE(fontSize)]);
    // Initialization code
    self.titleLabel.font =  boldFont;
    self.titleLabel.textColor = project_main_blue;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setupSectionTitle:(NSString *)title{
    
    self.titleLabel.text = title;
}
@end
