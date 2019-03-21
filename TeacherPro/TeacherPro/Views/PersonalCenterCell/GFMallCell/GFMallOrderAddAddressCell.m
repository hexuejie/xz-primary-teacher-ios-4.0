//
//  GFMallOrderAddAddressCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/12/5.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "GFMallOrderAddAddressCell.h"
#import "PublicDocuments.h"
#import "ProUtils.h"
@interface GFMallOrderAddAddressCell()
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@end
@implementation GFMallOrderAddAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubView];
}
- (void)setupSubView{
    
    self.addBtn.layer.masksToBounds = YES;
    self.addBtn.layer.cornerRadius = 44/2;
    self.addBtn.layer.borderWidth = 1;
    self.addBtn.layer.borderColor = [UIColor clearColor].CGColor;
    self.addBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0,0);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)addAction:(id)sender {
    if (self.addBlock) {
        self.addBlock();
    }
}

@end
