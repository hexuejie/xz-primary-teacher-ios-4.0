
//
//  GFMallAddressAdministerFooterCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/12/8.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "GFMallAddressAdministerFooterCell.h"
@interface GFMallAddressAdministerFooterCell ()
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
@implementation GFMallAddressAdministerFooterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubView];
}
- (void)setupSubView{
    
    [self.editBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
    [self.deleteBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)editAction:(id)sender {
    if (self.editBlock) {
        self.editBlock(self.indexPath);
    }
   
}
- (IBAction)delAction:(id)sender {
    if (self.delBlock) {
        self.delBlock(self.indexPath);
    }
}
- (void)setupShowChooseAddressSate:(BOOL)showState{
    
    self.titleLabel.hidden = !showState;
}
@end
