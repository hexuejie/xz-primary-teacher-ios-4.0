//
//  CheckHomeworkDetailKHLXUnitCell.m
//  TeacherPro
//
//  Created by DCQ on 2018/1/31.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "CheckHomeworkDetailKHLXUnitCell.h"
#import "PublicDocuments.h"

@interface CheckHomeworkDetailKHLXUnitCell ()
@property (weak, nonatomic) IBOutlet UIView *lineV;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;

@end
@implementation CheckHomeworkDetailKHLXUnitCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubView];
}
- (void)setupSubView{
    self.lineV.backgroundColor = project_line_gray;
    self.unitLabel.textColor = UIColorFromRGB(0x6b6b6b);
    self.unitLabel.font = fontSize_14;
    self.detailBtn.layer.borderWidth = 1;
    self.detailBtn.layer.borderColor = project_main_blue.CGColor;
    self.detailBtn.layer.masksToBounds = YES;
    self.detailBtn.layer.cornerRadius = 4;
    [self.detailBtn setTitleColor:project_main_blue forState:UIControlStateNormal];
    self.detailBtn.titleLabel.font = fontSize_14;
    [self.detailBtn setTitle:@"查看" forState:UIControlStateNormal];
    [self.detailBtn addTarget:self action:@selector(detailBtnAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)detailBtnAction:(id)sender{
    
    if (self.detailBlock) {
        self.detailBlock(self.indexPath);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setupTitle:(NSString *)unit {
    
    self.unitLabel.text = unit;
}
@end
