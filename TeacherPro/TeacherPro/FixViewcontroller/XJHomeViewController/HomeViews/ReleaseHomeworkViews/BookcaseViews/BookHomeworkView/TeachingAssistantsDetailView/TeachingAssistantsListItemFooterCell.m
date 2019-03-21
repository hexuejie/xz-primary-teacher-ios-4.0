//
//  TeachingAssistantsListItemFooterCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/11/7.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "TeachingAssistantsListItemFooterCell.h"

@interface TeachingAssistantsListItemFooterCell()
@property (weak, nonatomic) IBOutlet UIImageView *bgImgV;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@end
@implementation TeachingAssistantsListItemFooterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupView];
}

- (void)setupView{
    
    [self.leftBtn addTarget:self action:@selector(leftAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightBtn addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)leftAction:(id)sender{
    
    if (self.writttenBlock) {
        self.writttenBlock(self.indexPath);
    }
    
}

- (void)rightAction:(id)sender{
    if (self.chooseParseBlock) {
        self.chooseParseBlock(self.indexPath);
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
