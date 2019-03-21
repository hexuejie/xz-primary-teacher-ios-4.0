//
//  HWReportImgVCell.m
//  TeacherPro
//
//  Created by DCQ on 2018/8/1.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "HWReportImgVCell.h"
#import "UIImageView+WebCache.h"
#import "PublicDocuments.h"

@interface HWReportImgVCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (weak, nonatomic) IBOutlet UIView *imgVBg;
@end
@implementation HWReportImgVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLabel.font = fontSize_13;
    self.titleLabel.textColor = UIColorFromRGB(0x6b6b6b);
    self.detailLabel.font = fontSize_13;
    self.imgVBg.tag = 989898;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setupImVUrls:(NSArray *)urls{
    self.titleLabel.text = [NSString stringWithFormat:@"有%ld作业图片备注",[urls count]];
    [self.imgV sd_setImageWithURL:[NSURL URLWithString:urls.firstObject] placeholderImage:[UIImage imageNamed:@"hw_report_img_normal"]];
}
@end
