//
//  TeachingAssistantsAnswerCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/11/28.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "TeachingAssistantsAnswerCell.h"
#import "PublicDocuments.h"
#import "ProUtils.h"
@interface TeachingAssistantsAnswerCell()
@property (weak, nonatomic) IBOutlet UILabel *answerLabel;
@property (weak, nonatomic) IBOutlet UIButton *titleBtn;

@end
@implementation TeachingAssistantsAnswerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubview];
}
- (void)setupSubview{
    self.answerLabel.textColor = UIColorFromRGB(0x6b6b6b);
    [self.answerLabel sizeToFit];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setupTextCell:(NSString *)answer{
    if (answer) {
       self.answerLabel.attributedText = [ProUtils strToAttriWithStr:answer];
    
    }else{
        self.answerLabel.text = @"暂无答案";
    }
    
}
@end
