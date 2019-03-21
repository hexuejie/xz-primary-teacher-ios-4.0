//
//  JFAssistantsAnswerCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/12/21.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "JFAssistantsAnswerCell.h"
#import "PublicDocuments.h"
#import "ProUtils.h"
@interface JFAssistantsAnswerCell()
@property (weak, nonatomic) IBOutlet UILabel *answerLabel;


@end
@implementation JFAssistantsAnswerCell

- (void)awakeFromNib {
    [super awakeFromNib];
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
