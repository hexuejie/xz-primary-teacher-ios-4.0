
//
//  GratitudeTopView.m
//  TeacherPro
//
//  Created by DCQ on 2018/1/9.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "GratitudeTopView.h"
@interface GratitudeTopView()
@property (weak, nonatomic) IBOutlet UIButton *giftRulesBtn;
@property (weak, nonatomic) IBOutlet UILabel *giftNumbelLabel;

@property (weak, nonatomic) IBOutlet UIButton *giftChangeBtn;
@end
@implementation GratitudeTopView
- (void)awakeFromNib{
    [super awakeFromNib];
    [self setupSubview];
}
- (void)setupSubview{
    
    self.giftNumbelLabel.textColor = [UIColor whiteColor];
    self.giftNumbelLabel.font = [UIFont boldSystemFontOfSize:18];
//    self.giftRulesBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
}

- (IBAction)giftMallBtnAction:(id)sender {
    if (self.giftMallBtnBlock) {
        self.giftMallBtnBlock();
    }
}
- (IBAction)rulesBtnAction:(id)sender {
    if (self.rulesBtnBlock) {
        self.rulesBtnBlock();
    }
}
- (void)setupNumber:(NSString *)number{
    
    self.giftNumbelLabel.text = number;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
