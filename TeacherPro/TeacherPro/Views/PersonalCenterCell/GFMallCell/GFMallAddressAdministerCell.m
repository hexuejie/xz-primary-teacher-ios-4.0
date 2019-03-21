//
//  GFMallAddressAdministerCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/12/8.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "GFMallAddressAdministerCell.h"
#import "GFMallAddressListModel.h"
#import "ProUtils.h"
#import "PublicDocuments.h"
@interface GFMallAddressAdministerCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end
@implementation GFMallAddressAdministerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubView];
}

- (void)setupSubView{
    
    self.nameLabel.textColor =  UIColorFromRGB(0x6b6b6b);
    self.phoneLabel.textColor =  UIColorFromRGB(0x6b6b6b);
    self.addressLabel.textColor =  UIColorFromRGB(0x6b6b6b);
    self.nameLabel.font = fontSize_14;
    self.phoneLabel.font = fontSize_14;
    self.addressLabel.font = fontSize_14;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupModel:(GFMallAddressModel *)model{
    self.nameLabel.text =  [NSString stringWithFormat:@"姓名：%@", model.contactName];
    self.phoneLabel.text = [NSString stringWithFormat:@"电话：%@", model.contactPhone];
    self.addressLabel.text=[NSString stringWithFormat:@"地址：%@",model.completeAddress];
}

@end
