
//
//  JFTopicOtherParseCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/12/20.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "JFTopicOtherParseCell.h"
#import "PublicDocuments.h"
#import "ProUtils.h"
@interface JFTopicOtherParseCell()
@property (weak, nonatomic) IBOutlet UIImageView *bgImgV;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;
@property (weak, nonatomic) IBOutlet UILabel *otherDecTitle;
@property (weak, nonatomic) IBOutlet UILabel *checkTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *chooseOtherParsingLabel;

@end
@implementation JFTopicOtherParseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubView];
}
- (void)setupSubView{
    
    self.checkTitleLabel.textColor = UIColorFromRGB(0x6E280C);
    self.otherDecTitle.textColor = UIColorFromRGB(0x848581);
    self.chooseOtherParsingLabel.backgroundColor = UIColorFromRGB(0xD2200D);
}
- (void)setupOther:(NSInteger )Number withShowChooseParsing:(BOOL)show{
    NSString * numberStr = [NSString stringWithFormat:@"%ld",Number];
    NSString * desTitle = [NSString stringWithFormat:@"共有%@位老师为本题提供了解析",numberStr];
    NSRange desRange = [desTitle rangeOfString:numberStr];
    UIColor * rangeColor = UIColorFromRGB(0xCD0012);
    self.otherDecTitle.attributedText= [ProUtils setAttributedText:desTitle withColor:rangeColor withRange:desRange withFont:self.otherDecTitle.font];
    
   self.chooseOtherParsingLabel.hidden = !show;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
