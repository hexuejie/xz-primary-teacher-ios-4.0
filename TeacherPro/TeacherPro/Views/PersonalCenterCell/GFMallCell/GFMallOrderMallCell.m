//
//  GFMallOrderMallCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/12/5.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "GFMallOrderMallCell.h"
#import "GFMallListModel.h"
#import "UIImageView+WebCache.h"
#import "PublicDocuments.h"


@interface GFMallOrderMallCell ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *jianBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (assign, nonatomic)  NSInteger  allNumber;
@property (weak, nonatomic) IBOutlet UILabel *exchangeLabel;

@end
@implementation GFMallOrderMallCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubView];
}

- (void)setupSubView{
    self.allNumber = 1;
    self.timerLabel.textColor = UIColorFromRGB(0xE38A5B);
    self.timerLabel.font = fontSize_11;
    self.timerLabel.textAlignment = NSTextAlignmentLeft;
    self.detailLabel.textColor = UIColorFromRGB(0x7A7A7A);
    self.nameLabel.textColor = UIColorFromRGB(0x6b6b6b);
    self.exchangeLabel.textColor = UIColorFromRGB(0x6b6b6b);
    
    self.detailLabel.font = fontSize_14;
    self.nameLabel.font = fontSize_14;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setupModel:(GFMallModel *)model{
    self.nameLabel.text = model.giftName;
    self.detailLabel.text = model.giftDesc;
    [self.imgV sd_setImageWithURL:[NSURL URLWithString:model.giftLogo]];
    self.imgV.contentMode = UIViewContentModeScaleAspectFit;
    self.timerLabel.text = [NSString stringWithFormat:@"*今日兑换将于下月五号发放"];
}
- (IBAction)jianButtonAction:(id)sender {
    
    if (self.allNumber != 1) {
        self.allNumber--;
    }
    self.numberLabel.text =[NSString stringWithFormat:@"%ld",self.allNumber];
    if (self.giftBlock) {
        self.giftBlock(self.allNumber);
    }
}
- (IBAction)addButtonAction:(id)sender {
    if (self.allNumber < 99) {
        self.allNumber ++;
    }
    
    self.numberLabel.text =[NSString stringWithFormat:@"%ld",self.allNumber];
    if (self.giftBlock) {
        self.giftBlock(self.allNumber);
    }
}

@end
