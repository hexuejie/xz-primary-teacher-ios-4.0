
//
//  PersonalViewCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/7/20.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "PersonalViewCell.h"
#import "PublicDocuments.h"
#import "ProUtils.h"
@interface  PersonalViewCell()
@property (weak, nonatomic) IBOutlet UILabel *coinNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;

@end
@implementation PersonalViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
     
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setupIcon:(NSString *)imgName withTitle:(NSString *)title withCoin:(NSString *)coin{

    self.iconImgV.image = [UIImage imageNamed:imgName];
    self.titleLabel.text = title;
    if (coin.length >0) {
//         self.coinNumberLabel.hidden = NO;
//         self.coinNumberLabel.text = coin;
        NSString * textTemp = [coin stringByAppendingString:@"(超过500可在兑换商城中兑换)"];
        NSRange coinRange = [textTemp rangeOfString:coin];
       NSAttributedString * textAttr = [ProUtils setAttributedText:textTemp withColor:UIColorFromRGB(0xFA5D00) withRange:coinRange withFont:fontSize_13];
        self.coinNumberLabel.attributedText = textAttr;
    }else{
    
        self.coinNumberLabel.hidden = YES;
    }
   
}
@end
