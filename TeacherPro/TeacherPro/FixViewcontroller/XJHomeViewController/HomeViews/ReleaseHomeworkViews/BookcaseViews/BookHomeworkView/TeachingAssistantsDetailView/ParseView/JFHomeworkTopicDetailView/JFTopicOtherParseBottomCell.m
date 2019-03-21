//
//  JFTopicOtherParseBottomCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/12/22.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "JFTopicOtherParseBottomCell.h"
@interface JFTopicOtherParseBottomCell()
@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;
@property (weak, nonatomic) IBOutlet UIButton *zanBtn;

@end
@implementation JFTopicOtherParseBottomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.zanBtn addTarget:self action:@selector(zanbtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.selectedBtn addTarget:self action:@selector(selectedAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setupPraiseNumber:(NSNumber *)number withHasPraiseState:(NSNumber *)hasPraise{
    NSString * titleStr = [NSString stringWithFormat:@"%@",number];
    [self.zanBtn setTitle:titleStr forState:UIControlStateNormal];
    BOOL  state = NO;
    if ([hasPraise integerValue] == 1) {
        state = YES;
    }
     self.zanBtn.selected = state;
}

- (void)zanbtnAction:(UIButton *)sender{
    
    if (!sender.selected) {
        sender.selected = YES;
        if (self.praiseBlock) {
            self.praiseBlock(self.indexPath);
        }
    }
}

- (void)selectedAction:(id)sender{
    
    if (self.selectedBlock) {
        self.selectedBlock(self.indexPath);
    }
}
@end
