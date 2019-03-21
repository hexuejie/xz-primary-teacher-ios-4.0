//
//  ChooseParseItemTitleCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/11/8.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "ChooseParseItemTitleCell.h"
#import "PublicDocuments.h"
#import "AssistantsQuestionModel.h"

@interface ChooseParseItemTitleCell()

@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *itemTitle;
@property (weak, nonatomic) IBOutlet UIButton *answerBtn;
@property (weak, nonatomic) IBOutlet UIButton *parseBtn;
 @property (weak, nonatomic) IBOutlet UIButton *audioBtn;

@end
@implementation ChooseParseItemTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self  setupSubview];
}

- (void)setupSubview{
    self.itemTitle.textColor = UIColorFromRGB(0x6b6b6b);
    UIColor * normalColor =  UIColorFromRGB(0xef0224);
    self.answerBtn.hidden = self.parseBtn.hidden = self.audioBtn.hidden = YES;
    [self.answerBtn setTitleColor:normalColor forState:UIControlStateNormal];
    [self.parseBtn setTitleColor:normalColor forState:UIControlStateNormal];
    [self.audioBtn setTitleColor:normalColor forState:UIControlStateNormal];
    
    [self.answerBtn setTitleColor:project_main_blue forState:UIControlStateSelected];
    [self.parseBtn setTitleColor:project_main_blue forState:UIControlStateSelected];
    [self.audioBtn setTitleColor:project_main_blue forState:UIControlStateSelected];
}

- (void)setupModel:(QuestionModel *)model{
 
//    self.answerBtn.selected = [self validationIsMyAnswer:model];
//    self.parseBtn.selected = [self validationIsParse:model];
//    self.audioBtn.selected = [self validationIsAudio:model];
    
    self.itemTitle.text = [NSString stringWithFormat:@"%@题",model.questionNum];
    
}
- (BOOL)validationIsParse:(QuestionModel *)model{
    BOOL yesOrNo = NO;
    if ([model.otherAnalysis isKindOfClass:[NSArray class]] && [model.otherAnalysis count] >0 ) {
        yesOrNo = YES;
    }
    if (model.analysis ) {
        yesOrNo = YES;
    }
    if (model.myAnalysis   ) {
        yesOrNo = YES;
    }
    return yesOrNo;
}

- (BOOL)validationIsMyAnswer:(QuestionModel *)model{
    BOOL yesOrNo = NO;
    
    if ([model.answer isKindOfClass:[NSString class]] && model.answer.length >0) {
        yesOrNo = YES;
    }
    
    return yesOrNo;
    
}
- (BOOL)validationIsAudio:(QuestionModel *)model{
    BOOL yesOrNo = NO;
    if (model.continuousAudios && [model.continuousAudios count]) {
        yesOrNo = YES;
    }else{
        if (model.singleAudios && [model.singleAudios count]) {
            yesOrNo = YES;
        }
    }
    return yesOrNo;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
