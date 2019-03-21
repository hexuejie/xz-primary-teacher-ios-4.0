\

//
//  JFHomeworkListItemQuestionCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/12/25.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "JFHomeworkListItemQuestionCell.h"
#import "PublicDocuments.h"
#import "ProUtils.h"
@interface JFHomeworkListItemQuestionCell()
@property (weak, nonatomic) IBOutlet UIImageView *bgImgV;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;
@property (weak, nonatomic) IBOutlet UILabel *otherDecTitle;
@property (weak, nonatomic) IBOutlet UILabel *checkTitleLabel;

@end
@implementation JFHomeworkListItemQuestionCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubView];
}
- (void)setupSubView{
    
    self.checkTitleLabel.textColor = UIColorFromRGB(0x6E280C);
    self.otherDecTitle.textColor = UIColorFromRGB(0x848581);
    
}
- (void)setupNum:(NSInteger )Number{
    NSString * numberStr = [NSString stringWithFormat:@"%ld",Number];
    NSString * desTitle = [NSString stringWithFormat:@"共有%@位学生对题目提出不会做",numberStr];
    NSRange desRange = [desTitle rangeOfString:numberStr];
    UIColor * rangeColor = UIColorFromRGB(0xCD0012);
    self.otherDecTitle.attributedText= [ProUtils setAttributedText:desTitle withColor:rangeColor withRange:desRange withFont:self.otherDecTitle.font];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
