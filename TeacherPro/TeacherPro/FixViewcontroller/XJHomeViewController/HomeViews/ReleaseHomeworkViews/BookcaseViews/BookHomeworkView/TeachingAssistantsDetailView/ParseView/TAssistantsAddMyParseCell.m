//
//  TAssistantsAddMyParseCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/11/30.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "TAssistantsAddMyParseCell.h"
#import "PublicDocuments.h"
@interface TAssistantsAddMyParseCell()
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end
@implementation TAssistantsAddMyParseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubview];
}

- (void)setupSubview{
     self.bgView.backgroundColor = UIColorFromRGB(0xDEEDFE);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)addButtonAction:(id)sender {
    if (self.addBlock) {
        self.addBlock();
    }
}

@end
