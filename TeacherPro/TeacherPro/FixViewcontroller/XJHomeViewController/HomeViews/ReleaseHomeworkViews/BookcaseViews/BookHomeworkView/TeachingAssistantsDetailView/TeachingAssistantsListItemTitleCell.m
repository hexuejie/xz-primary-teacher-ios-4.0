//
//  TeachingAssistantsListItemTitleCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/12/18.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "TeachingAssistantsListItemTitleCell.h"
#import "PublicDocuments.h"
#import "AssistantsQuestionModel.h"
@interface TeachingAssistantsListItemTitleCell ()
@property (weak, nonatomic) IBOutlet UILabel *itemTitle;
@property (weak, nonatomic) IBOutlet UILabel *noItemLabel;
@property (weak, nonatomic) IBOutlet UIImageView *noItemIcon;

@end
@implementation TeachingAssistantsListItemTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupView];
}
- (void)setupView{
 
    self.itemTitle.textColor = [UIColor  whiteColor];
    self.itemTitle.backgroundColor = project_main_blue;
    self.itemTitle.font = fontSize_13;
    self.noItemLabel.font = fontSize_13;
    self.noItemLabel.textColor = UIColorFromRGB(0xFAA947);
    self.noItemLabel.text = @"这题不会做";
}
- (void)setupModel:(QuestionModel *)model {
       NSString * itmeNumber = model.questionNum;
//      if ([[model.questionNum componentsSeparatedByString:@"."] isKindOfClass:[NSArray class]] && [[model.questionNum componentsSeparatedByString:@"."] count] >1) {
//            itmeNumber = [model.questionNum componentsSeparatedByString:@"."][1];
//     }
    
     self.itemTitle.text = [NSString stringWithFormat:@"%@",itmeNumber];
     
    if (model.unKnowQuestion && [model.unKnowQuestion boolValue]) {
        self.noItemLabel.hidden = NO;
        self.noItemIcon.hidden = NO;
    }else{
        self.noItemLabel.hidden = YES;
        self.noItemIcon.hidden = YES;
    }
 
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
