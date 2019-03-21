//
//  GFMallListCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/12/4.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "GFMallListCell.h"
#import "ProUtils.h"
#import "UIImageView+WebCache.h"
#import "GFMallListModel.h"
#import "PublicDocuments.h"

@interface GFMallListCell()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *mallImgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UILabel *coinNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *exchangeLabel;

@end
@implementation GFMallListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubview];
}

- (void)setupSubview{
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.bgView.layer.cornerRadius = 8;
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.borderWidth = 0.5;
    self.bgView.layer.borderColor = project_line_gray.CGColor;
    
    self.titleLabel.textColor = UIColorFromRGB(0x333333);
    self.titleLabel.font = fontSize_15;
    self.desLabel.textColor = UIColorFromRGB(0x8d8d8d);
    self.desLabel.font = fontSize_13;
    self.exchangeLabel.textColor = UIColorFromRGB(0x40bdf6);
    self.exchangeLabel.font = fontSize_13;
    self.coinNumberLabel.textColor = UIColorFromRGB(0x8d8d8d);
    self.coinNumberLabel.font = fontSize_13;
}
- (void)setupGFMallModel:(GFMallModel *)model{
    UIImage * defaultImage = [UIImage imageNamed:@"default_mall_img.png"];
    [self.mallImgV sd_setImageWithURL:[NSURL URLWithString:model.giftLogo] placeholderImage:defaultImage];
    self.mallImgV.contentMode = UIViewContentModeScaleAspectFit;
    
    self.titleLabel.text = model.giftName;
    NSString * desStr = model.giftDesc;
    self.desLabel.text = desStr;
    
    NSString * coinStr = [NSString stringWithFormat:@"感恩币 %@ 个",model.count];
    NSRange range = [coinStr rangeOfString:[NSString stringWithFormat:@"%@",model.count]];
    UIColor * color = UIColorFromRGB(0xf4535b);
    UIFont * font = [UIFont boldSystemFontOfSize:18];
    self.coinNumberLabel.attributedText = [ProUtils setAttributedText:coinStr withColor:color withRange:range withFont:font]; 
}
@end
