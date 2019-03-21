
//
//  GFMallOrderBottomView.m
//  TeacherPro
//
//  Created by DCQ on 2017/12/5.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "GFMallOrderBottomView.h"
#import "SessionHelper.h"
#import "SessionModel.h"
#import "ProUtils.h"
#import "PublicDocuments.h"
@interface GFMallOrderBottomView ()
@property (weak, nonatomic) IBOutlet UILabel *availabilityCoinLabel;
@property (weak, nonatomic) IBOutlet UILabel *payCoinLabel;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;


@end
@implementation GFMallOrderBottomView
- (void)awakeFromNib{
    [super awakeFromNib];
    [self setupSubView];
}

- (void)setupSubView{
    SessionModel *sesstion = [[SessionHelper sharedInstance] getAppSession];
    [self setupAvailableCoin:[NSString stringWithFormat:@"%@",sesstion.coin]];
    self.sureBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    
    
}

- (void)setupAvailableCoin:(NSString *)coin{
    
    NSString * coinText = [NSString stringWithFormat:@"可用感恩币：%@",coin];
    UIColor * color = UIColorFromRGB(0xF40000);
    NSRange range = [coinText rangeOfString:[NSString stringWithFormat:@"%@",coin]];
    self.availabilityCoinLabel.attributedText = [ProUtils setAttributedText:coinText withColor:color withRange:range withFont:fontSize_14];
}
- (void)setupPayCoin:(NSString *)payCoin{
    SessionModel *sesstion = [[SessionHelper sharedInstance] getAppSession];
    if ([sesstion.coin integerValue] >=[payCoin integerValue]) {
        self.sureBtn.enabled = YES;
        self.sureBtn.backgroundColor = project_main_blue;
    }else{
        self.sureBtn.enabled = NO;
         self.sureBtn.backgroundColor = UIColorFromRGB(0x6C6C6C);
    }
     self.payCoinLabel.text = [NSString stringWithFormat:@"实付：%@感恩币",payCoin];
}

- (IBAction)sureAction:(id)sender {
    if (self.sureBlock) {
        self.sureBlock();
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
