//
//  ExchangeInstructionOtherContentCell.m
//  TeacherPro
//
//  Created by DCQ on 2018/1/25.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "ExchangeInstructionOtherContentCell.h"
#import "PublicDocuments.h"

@interface ExchangeInstructionOtherContentCell()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end
@implementation ExchangeInstructionOtherContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentLabel.font = fontSize_14;
    self.contentLabel.textColor = UIColorFromRGB(0x6b6b6b);
    self.contentLabel.contentMode = UIViewContentModeTopLeft;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setupContentStr:(NSString *)content{
    
    self.contentLabel.text = content;
}
@end
