//
//  HomeworkConfirmationItemCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/9/11.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "HomeworkConfirmationItemCell.h"
#import "PublicDocuments.h"
#import "ProUtils.h"
@interface HomeworkConfirmationItemCell()
@property (weak, nonatomic) IBOutlet UIButton *previewBtn;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;
@property (weak, nonatomic) IBOutlet UIView *bottomLineV;

@end
@implementation HomeworkConfirmationItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubview];
}

- (void)setupSubview{

  self.bottomLineV.backgroundColor = project_line_gray;
    self.titleLabel.textColor = UIColorFromRGB(0x434343);
    self.titleLabel.font = fontSize_14;
    self.detailLabel.textColor = UIColorFromRGB(0x434343);
    self.detailLabel.font = fontSize_14;
    [self.previewBtn setTitleColor:project_main_blue forState:UIControlStateNormal];
    self.previewBtn.titleLabel.font = fontSize_14;
    [ProUtils setupButtonContent:self.previewBtn withType:ButtonContentType_imageRight];
}

- (void)setupTitle:(NSString *)title withDetail:(NSString *)detail withIcon:(NSString *)imageName{

    self.titleLabel.text = title;
    self.detailLabel.text = detail;
    [self.iconImgV setImage:[UIImage imageNamed:imageName]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)previewAction:(id)sender {
    
    if (self.previewBlock) {
        self.previewBlock(self.index);
    }
    
}

@end
