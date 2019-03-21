

//
//  HWGameTypeDetailCell.m
//  TeacherPro
//
//  Created by DCQ on 2018/7/19.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "HWReportZXLXTypeDetailCell.h"
#import "PublicDocuments.h"
@interface HWReportZXLXTypeDetailCell()
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end
@implementation HWReportZXLXTypeDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubViews];
}
- (void)setupSubViews{
    
    self.btn.titleLabel.font = fontSize_13;
}
- (void)setupBtnTitle:(NSString *)title{
    [self.btn setTitle:title forState:UIControlStateNormal];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)detailAction:(id)sender {
    if (self.btnBlock) {
        self.btnBlock(self.indexPath);
    }
}

@end
