
//
//  ExchangeInstructionOtherSectionCell.m
//  TeacherPro
//
//  Created by DCQ on 2018/1/25.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "ExchangeInstructionOtherSectionCell.h"
#import "PublicDocuments.h"

@interface ExchangeInstructionOtherSectionCell()
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end
@implementation ExchangeInstructionOtherSectionCell
- (void)setupSectionTitle:(NSString *)title withImageName:(NSString *)imgName{
    
    [self.btn setTitle:title forState:UIControlStateNormal];
    [self.btn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    CGFloat fontSize =  14;
    UIFont * boldFont = (iPhone6Plus? [UIFont boldSystemFontOfSize:fontSize*ip6size]:[UIFont boldSystemFontOfSize:FITSCALE(fontSize)]);
    self.btn.titleLabel.font = boldFont;
    [self.btn setTitleColor:project_main_blue forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
