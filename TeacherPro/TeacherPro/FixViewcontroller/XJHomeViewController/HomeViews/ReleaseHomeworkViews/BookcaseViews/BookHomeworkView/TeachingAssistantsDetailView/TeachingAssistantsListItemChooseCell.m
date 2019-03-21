//
//  TeachingAssistantsListItemChooseCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/12/18.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "TeachingAssistantsListItemChooseCell.h"
#import "PublicDocuments.h"
#import "AssistantsQuestionModel.h"
#import "ProUtils.h"
@interface TeachingAssistantsListItemChooseCell()
@property (weak, nonatomic) IBOutlet UIView *topDottedLine;
@property (weak, nonatomic) IBOutlet UIImageView *answerImgV;
@property (weak, nonatomic) IBOutlet UIImageView *parseImgV;
@property (weak, nonatomic) IBOutlet UIImageView *audioImgV;
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;
@end
@implementation TeachingAssistantsListItemChooseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupView];
}
- (void)setupView{
    [self.chooseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self setNeedsDisplay];
}
- (void)layoutSubviews{
    [super layoutSubviews];
//    [ProUtils drawDashLine:self.topDottedLine lineLength:8 lineSpacing:2 lineColor:UIColorFromRGB(0xC7C7C7)];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)chooseAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.chooseBlock) {
        self.chooseBlock(self.indexPath );
    }
}

- (void)setupModel:(QuestionModel *)model isChoose:(BOOL)chooseState{
    self.chooseBtn.selected = chooseState;
    BOOL  answer = [self validationIsMyAnswer:model];
    BOOL  parse =  [self validationIsParse:model];
    BOOL  audio =  [self validationIsAudio:model];
    NSMutableArray * array = [NSMutableArray array];
    if (answer) {
        [array addObject:@"jf_answer_icon"];
    }
    if (parse) {
        [array addObject:@"jf_parse_icon"];
    }
    if (audio) {
        [array addObject:@"jf_audio_icon"];
    }
    NSString * answerImg = @"";
    NSString * parseImg = @"";
    NSString * audioImg = @"";
    if ([array count] == 1) {
       
        answerImg = array[0];
    }else if ([array count] == 2){
         answerImg = array[0];
         parseImg = array[1];
       
    }else if ([array count] == 3){
        answerImg = array[0];
        parseImg = array[1];
        audioImg = array[2];
    }
    self.answerImgV.image = [UIImage imageNamed:answerImg];
    self.parseImgV.image = [UIImage imageNamed:parseImg];
    self.audioImgV.image = [UIImage imageNamed:audioImg];
  
}
- (BOOL)validationIsParse:(QuestionModel *)model{
    BOOL yesOrNo = NO;
    if (model.analysisType && model.analysisType.length >0) {
         yesOrNo = YES;
    }else{
        if ([model.otherAnalysis isKindOfClass:[NSArray class]] && [model.otherAnalysis count] >0 ) {
            yesOrNo = YES;
        }
        if (model.analysis ) {
            yesOrNo = YES;
        }
        if (model.myAnalysis   ) {
            yesOrNo = YES;
        }
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
@end
