//
//  GFMallChooseAreaCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/12/7.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "GFMallChooseAreaCell.h"
#import "PublicDocuments.h"
@interface GFMallChooseAreaCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImgV;

@end
@implementation GFMallChooseAreaCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubView];
}

- (void)setupSubView{
    self.titleLabel.font = fontSize_14;
     self.detailLabel.font = fontSize_14;
    self.titleLabel.textColor = UIColorFromRGB(0x000000);
    self.detailLabel.textColor = UIColorFromRGB(0x6b6b6b);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setupArea:(NSString *)areaStr{
    if (areaStr) {
        self.detailLabel.text = areaStr;
    }
    
}
@end
