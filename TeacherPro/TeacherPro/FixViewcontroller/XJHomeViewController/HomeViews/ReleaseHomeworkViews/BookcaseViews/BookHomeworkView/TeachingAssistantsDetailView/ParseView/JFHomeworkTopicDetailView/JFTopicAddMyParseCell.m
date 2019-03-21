//
//  JFTopicAddMyParseCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/12/20.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "JFTopicAddMyParseCell.h"
#import "PublicDocuments.h"
@interface JFTopicAddMyParseCell ()
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@end
@implementation JFTopicAddMyParseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubview];
}

- (void)setupSubview{
    self.bgView.backgroundColor = [UIColor whiteColor];
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
