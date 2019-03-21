//
//  ChooseParseItemOriginalCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/12/6.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "ChooseParseItemOriginalCell.h"
#import "ProUtils.h"
#import "PublicDocuments.h"
@interface ChooseParseItemOriginalCell()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *orangeLabel;

@end
@implementation ChooseParseItemOriginalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubview];
}

- (void)setupSubview{
    self.bgView.backgroundColor = [UIColor whiteColor];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setupTextCell:(NSString *)analysis{
    
    self.orangeLabel.attributedText = [ProUtils strToAttriWithStr: analysis];
}
@end
