//
//  BookHomeworkAdjustmentRepeatedNumberCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/9/7.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BookHomeworkAdjustmentRepeatedNumberCell.h"
#import "PublicDocuments.h"

@interface BookHomeworkAdjustmentRepeatedNumberCell()
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (assign, nonatomic) NSInteger  number;
@end
@implementation BookHomeworkAdjustmentRepeatedNumberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubview];
}

- (void)setupSubview{

    self.detailLabel.textColor = UIColorFromRGB(0x6b6b6b);
    self.detailLabel.font = fontSize_14;
    self.numberLabel.textColor = UIColorFromRGB(0x6b6b6b);
    self.numberLabel.font = fontSize_14;
    self.number = 1;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)subtractionButtonAction:(id)sender {
    
    self.number --;
    if (self.number < 1) {
        self.number = 1;
    }
    [self updateNumber:self.number];
}
- (IBAction)addButtonAction:(id)sender {
    self.number++;
    [self updateNumber:self.number];
}

- (void)updateNumber:(NSInteger )number{

     self.numberLabel.text = [NSString stringWithFormat:@"%zd",self.number];
    if (self.adjustmentBlock) {
        self.adjustmentBlock(number); 
    }
   
}
@end
