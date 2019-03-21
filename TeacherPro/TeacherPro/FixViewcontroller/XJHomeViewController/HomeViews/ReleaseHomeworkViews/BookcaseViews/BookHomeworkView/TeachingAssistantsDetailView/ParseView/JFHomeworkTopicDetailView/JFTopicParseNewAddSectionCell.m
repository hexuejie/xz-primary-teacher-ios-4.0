
//
//  JFTopicParseNewAddSectionCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/12/21.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "JFTopicParseNewAddSectionCell.h"
#import "PublicDocuments.h"
#import "ProUtils.h"
@interface JFTopicParseNewAddSectionCell ()
@property (weak, nonatomic) IBOutlet UISwitch *swithBtn;
@property (weak, nonatomic) IBOutlet UIView *lineLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;

@end
@implementation JFTopicParseNewAddSectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupView];
}
- (void)setupView{
    
    self.lineLabel.backgroundColor = project_line_gray;
    self.titleLabel.font = fontSize_14;
    self.titleLabel.textColor = project_main_blue;
    self.swithBtn.onTintColor =  project_main_blue;
    // 控件大小，不能设置frame，只能用缩放比例
//    self.swithBtn.transform = CGAffineTransformMakeScale(0.75, 0.75);
}

- (void)setupIconImageName:(NSString *)imgName withTitle:(NSString *)title{
    self.iconImgV.image = [UIImage imageNamed:imgName];
    self.titleLabel.text = title;
}
- (void)setupSwitch:(BOOL)show{
    self.swithBtn.hidden = !show;
}
- (IBAction)switchAction:(UISwitch *)sender {
    if (self.switchBlock) {
        self.switchBlock(sender.on);
    }
}
@end
