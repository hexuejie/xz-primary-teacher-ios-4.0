//
//  WrittenParseItemTitleCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/11/8.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "WrittenParseItemTitleCell.h"
#import "PublicDocuments.h"
#import "AssistantsQuestionModel.h"
@interface WrittenParseItemTitleCell()

@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *itemTitle;
@property (weak, nonatomic) IBOutlet UIButton *answerBtn;
@property (weak, nonatomic) IBOutlet UIButton *parseBtn;
@end
@implementation WrittenParseItemTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubView];
}

- (void)setupSubView{
    self.lineView.backgroundColor = project_line_gray;
    self.itemTitle.textColor = UIColorFromRGB(0x6b6b6b);
    UIColor * normalColor =  UIColorFromRGB(0xef0224);
    
    [self.answerBtn setTitleColor:normalColor forState:UIControlStateNormal];
    [self.parseBtn setTitleColor:normalColor forState:UIControlStateNormal];
    [self.answerBtn setTitleColor:project_main_blue forState:UIControlStateSelected];
    [self.parseBtn setTitleColor:project_main_blue forState:UIControlStateSelected];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setupModel:(QuestionModel *)model{
     
    
    self.itemTitle.text = [NSString stringWithFormat:@"%@题",model.questionNum];
    
}
@end
