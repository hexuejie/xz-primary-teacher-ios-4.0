
//
//  StudentHomeworkKHLXInfoCell.m
//  TeacherPro
//
//  Created by DCQ on 2018/2/1.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "StudentHomeworkKHLXInfoCell.h"
#import "PublicDocuments.h"

@interface StudentHomeworkKHLXInfoCell ()
@property (weak, nonatomic) IBOutlet UILabel *khlxLabel;
@property (weak, nonatomic) IBOutlet UILabel *khlxRightLabel;
@property (weak, nonatomic) IBOutlet UILabel *khlxWrongLabel;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end
@implementation StudentHomeworkKHLXInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.khlxLabel.font = fontSize_14;
    self.khlxLabel.textColor = UIColorFromRGB(0x6b6b6b);
    self.khlxRightLabel.font = fontSize_14;
    self.khlxRightLabel.textColor = UIColorFromRGB(0x6b6b6b);
    self.khlxWrongLabel.font = fontSize_14;
    self.khlxWrongLabel.textColor = UIColorFromRGB(0x6b6b6b);
    
    [self.btn setTitleColor:UIColorFromRGB(0x6b6b6b) forState:UIControlStateNormal];
    self.btn.titleLabel.font = fontSize_14;
    self.btn.layer.masksToBounds = YES;
    self.btn.layer.borderColor = UIColorFromRGB(0x6b6b6b).CGColor;
    self.btn.layer.borderWidth = 1;
    self.btn.layer.cornerRadius = 4;
}
- (void)setupRightNumber:(NSNumber *)rightNumber  andWrongNumber:(NSNumber *)wrongNumber{
    
    self.khlxRightLabel.text = [NSString stringWithFormat:@"%@",rightNumber];
    self.khlxWrongLabel.text = [NSString stringWithFormat:@"%@",wrongNumber];
}

- (IBAction)detailBtnAction:(id)sender {
    if (self.detailBlock) {
        self.detailBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
