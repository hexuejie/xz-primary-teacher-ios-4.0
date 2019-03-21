//
//  GFMallOrderAddressTitleCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/12/5.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "GFMallOrderAddressTitleCell.h"
#import "PublicDocuments.h"
@interface GFMallOrderAddressTitleCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
@implementation GFMallOrderAddressTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubView];
}
- (void)setupSubView{
    
    self.titleLabel.font = fontSize_14;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
