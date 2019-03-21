//
//  GFMallOrderAddressContentCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/12/5.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "GFMallOrderAddressContentCell.h"
#import "GFMallAddressListModel.h"
#import "PublicDocuments.h"

@interface GFMallOrderAddressContentCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@end

@implementation GFMallOrderAddressContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubView];
}
- (void)setupSubView{
    self.nameLabel.textColor = UIColorFromRGB(0x6b6b6b);
    self.phoneLabel.textColor = UIColorFromRGB(0x6b6b6b);
    self.detailLabel.textColor = UIColorFromRGB(0x6b6b6b);
    self.nameLabel.font = fontSize_14;
    self.phoneLabel.font = fontSize_14;
    self.detailLabel.font = fontSize_14;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setupModel:(GFMallAddressModel *)model{
    self.nameLabel.text = [NSString stringWithFormat:@"姓名：%@",model.contactName];
    self.phoneLabel.text = [NSString stringWithFormat:@"电话：%@",model.contactPhone];
    self.detailLabel.text = [NSString stringWithFormat:@"地址：%@",model.completeAddress];
}
@end
