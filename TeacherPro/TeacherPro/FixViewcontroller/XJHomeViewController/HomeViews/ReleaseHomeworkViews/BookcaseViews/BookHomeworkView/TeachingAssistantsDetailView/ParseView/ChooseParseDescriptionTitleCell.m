//
//  ChooseParseDescriptionTitleCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/11/20.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "ChooseParseDescriptionTitleCell.h"
#import "AssistantsQuestionModel.h"
#import "SessionHelper.h"
#import "SessionModel.h"
#import "PublicDocuments.h"

@interface ChooseParseDescriptionTitleCell ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIImageView *orangeImgV;

@end
@implementation ChooseParseDescriptionTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupSubview];
    // Initialization code
}

- (void)setupSubview{
    self.titleLabel.textColor = project_main_blue;
    [self.editBtn addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.chooseBtn addTarget:self action:@selector(chooseAction:) forControlEvents:UIControlEventTouchUpInside];
    self.bgView.backgroundColor = UIColorFromRGB(0xDEEDFE);
    self.lineView.backgroundColor = UIColorFromRGB(0xB2C7DE);
}

- (void)editAction:(id)sender{
    if (self.editBlock) {
        self.editBlock(self.indexPath);
    }
    
}
- (void)chooseAction:(id)sender{
    if (self.chooseBlock) {
        self.chooseBlock(self.indexPath);
    }
}

- (void)setupModel:(QuestionAnalysisModel *)model isChooseState:(BOOL)chooseState {
    
    NSString * titleStr = @"";
    BOOL  isShowEdit = NO;
    BOOL  isShowChoose = NO;
    BOOL  isShowOrange = NO;
    self.chooseBtn.selected = chooseState;
    if (model) {
        isShowChoose = YES;
        isShowOrange = YES;
        if (self.indexPath.section == 1){
             //我的解析
            titleStr = @"原书的解析";
        }else if (self.indexPath.section == 2 ) {
            //我的解析
            titleStr = @"我的解析";
            isShowEdit = NO;
        }else{
            //其它解析
            titleStr = [NSString  stringWithFormat:@"%@%@",model.teacherName,@"的解析"]; 
        }
    }
    
    self.titleLabel.text = titleStr;
    self.editBtn.hidden = !isShowEdit;
    self.chooseBtn.hidden = !isShowChoose;
    self.orangeImgV.hidden = !isShowOrange;
}

- (void)setupChooseState:(BOOL)chooseState{
    NSString * titleStr = @"";
 
 
    self.chooseBtn.selected = chooseState;
     titleStr = @"原书的解析";
    
    self.titleLabel.text = titleStr;
    self.editBtn.hidden = YES;
  
   
}
-(void)setupDefaultMyParseTitle{
    self.titleLabel.text = @"我的解析";
    self.chooseBtn.hidden = YES;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
