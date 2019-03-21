//
//  GratitudeCurrencyCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/7/6.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "GratitudeCurrencyCell.h"
#import "ProUtils.h"
#import "PublicDocuments.h"
#import "GratitudeCurrencyListModel.h"
@interface GratitudeCurrencyCell()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;
@property (weak, nonatomic) IBOutlet UIButton *giftChangeBtn;

@end
@implementation GratitudeCurrencyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubview];
}

- (void)setupSubview{
   self.giftChangeBtn.hidden = YES;
    self.timeLabel.textColor = UIColorFromRGB(0x6b6b6b);
    self.numberLabel.textColor = UIColorFromRGB(0x6b6b6b);
    self.detailLabel.textColor = UIColorFromRGB(0x6b6b6b);
    self.timeLabel.font = fontSize_13;
    self.numberLabel.font = fontSize_13;
    self.detailLabel.font = fontSize_13;
    self.bottomLine.backgroundColor = project_line_gray;
    self.giftChangeBtn.backgroundColor = project_main_blue;
}

- (void)setupGratitudeCellInfo:(GratitudeCurrencyModel *)info{
   
    if (info.ctime.length >10) {
      self.timeLabel.text = [info.ctime substringToIndex:10];
    }else{
    
        self.timeLabel.text =  info.ctime ;
    }
    
    self.numberLabel.text = [NSString stringWithFormat:@"%@",info.count];
    self.detailLabel.text = info.comment;
    
}

- (void)giftExchangeConsumption{
    self.giftChangeBtn.hidden = NO;
    self.detailLabel.hidden = YES;
}
- (void)giftExchangeObtain{
    
    self.giftChangeBtn.hidden = YES;
    self.detailLabel.hidden = NO;
}
- (IBAction)changeBtnAction:(id)sender {
    if (self.giftChangeBlock) {
        self.giftChangeBlock(self.indexPath);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
