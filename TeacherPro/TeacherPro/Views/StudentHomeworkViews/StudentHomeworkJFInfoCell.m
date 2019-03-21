//
//  StudentHomeworkJFInfoCell.m
//  TeacherPro
//
//  Created by DCQ on 2018/8/13.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "StudentHomeworkJFInfoCell.h"
#import "PublicDocuments.h"
@interface StudentHomeworkJFInfoCell()
@property (weak, nonatomic) IBOutlet UILabel *jfLabel;
@property (weak, nonatomic) IBOutlet UILabel *jfUnLabel;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;

@end
@implementation StudentHomeworkJFInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.jfLabel.font = fontSize_14;
    self.jfLabel.textColor = UIColorFromRGB(0x6b6b6b);
     self.jfUnLabel.font = fontSize_14;
    [self.btn setTitleColor:UIColorFromRGB(0x6b6b6b) forState:UIControlStateNormal];
    self.btn.titleLabel.font = fontSize_14;
    self.btn.layer.masksToBounds = YES;
    self.btn.layer.borderColor = UIColorFromRGB(0x6b6b6b).CGColor;
    self.btn.layer.borderWidth = 1;
    self.btn.layer.cornerRadius = 4;
}
- (void)setupInfoCell:(NSArray *) unknowQuestions{
    
    if (unknowQuestions && [unknowQuestions count] > 0) {
        self.iconImgV.hidden = NO;
        self.jfUnLabel.hidden = NO;
    }else{
        self.iconImgV.hidden = YES;
        self.jfUnLabel.hidden = YES;
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)detailAction:(id)sender {
    
    if (self.jfDetailBlock) {
        self.jfDetailBlock();
    }
}

@end
