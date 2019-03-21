
//
//  ExchangeInstructionFirstContentCell.m
//  TeacherPro
//
//  Created by DCQ on 2018/1/25.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "ExchangeInstructionFirstContentCell.h"
#import "PublicDocuments.h"
@interface ExchangeInstructionFirstContentCell ()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end
@implementation ExchangeInstructionFirstContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentLabel.font = fontSize_14;
    self.contentLabel.textColor = UIColorFromRGB(0x6b6b6b);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setupContentStr:(NSString *)content{
    
    self.contentLabel.text = content;
}
@end
