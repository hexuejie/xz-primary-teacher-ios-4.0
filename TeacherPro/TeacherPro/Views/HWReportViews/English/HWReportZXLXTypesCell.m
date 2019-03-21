
//
//  HWReportTypesCell.m
//  TeacherPro
//
//  Created by DCQ on 2018/7/27.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "HWReportZXLXTypesCell.h"
#import "PublicDocuments.h"
#import "ProUtils.h"

@interface HWReportZXLXTypesCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bgImgV;

@end
@implementation HWReportZXLXTypesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubView];
}

- (void)setupSubView{
    self.titleLabel.font = fontSize_13;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setupInfo:(NSDictionary *)dic{
    if (dic[@"title"]) {
         [self setupTitle:dic[@"title"]];
        UIImage  * bgImg = [ProUtils getResizableImage:[UIImage imageNamed:@"hwreport_types_title_bg.png"]   withEdgeInset:UIEdgeInsetsMake(10, 10, 10, 50)];
        [self.bgImgV setImage:bgImg ];
    }
    
}

- (void)setupTitle:(NSString *)titleStr{
    
    self.titleLabel.text = titleStr;
}
@end
