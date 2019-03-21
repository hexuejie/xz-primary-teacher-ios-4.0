//
//  ChooseParseMyEditCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/11/29.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "ChooseParseMyEditCell.h"
#import "PublicDocuments.h"
#import "ProUtils.h"
@interface ChooseParseMyEditCell()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@end

@implementation ChooseParseMyEditCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubView];
}
- (void)setupSubView{
    UIEdgeInsets edge = UIEdgeInsetsMake(0, 0, 0, 10);
    [self.editBtn setImageEdgeInsets: edge];
    [self.deleteBtn setImageEdgeInsets: edge];
    [self.deleteBtn setImage:[UIImage imageNamed:@"new_parse_edit_icon"] forState:UIControlStateNormal];
     [self.editBtn setImage:[UIImage imageNamed:@"new_parse_del_icon"] forState:UIControlStateNormal];
    UIColor * titleColor = project_main_blue;
    [self.editBtn setTitleColor:titleColor forState:UIControlStateNormal];
    [self.deleteBtn setTitleColor:titleColor forState:UIControlStateNormal];
    
//    self.bgView.backgroundColor =  UIColorFromRGB(0xDEEDFE);
//    self.lineView.backgroundColor = project_line_gray;
    
}
- (IBAction)editAction:(id)sender {
    if (self.editBlock) {
        self.editBlock();
    }
}
- (IBAction)deleteAction:(id)sender {
    if (self.deleteBlock) {
        self.deleteBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
