
//
//  HomeworkProblemsDetailBottomView.m
//  TeacherPro
//
//  Created by DCQ on 2018/1/22.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "HomeworkProblemsDetailBottomView.h"
#import "PublicDocuments.h"
#import "ProUtils.h"
@interface HomeworkProblemsDetailBottomView ()
@property (weak, nonatomic) IBOutlet UIView *lineV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@end
@implementation HomeworkProblemsDetailBottomView
- (void)awakeFromNib{
    [super awakeFromNib];
    [self setupSubview];
}

- (void)setupSubview{
    
    self.titleLabel.font = fontSize_13;
    self.titleLabel.textColor = UIColorFromRGB(0x6b6b6b);
    self.lineV.backgroundColor = project_line_gray;
    self.titleLabel.text = @"请您选择题目";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}
- (void)setupNomarlTitle:(NSString *)title{
    
    self.titleLabel.text = title;
}
- (void)setupTitleNumber:(NSString *)titleNumber withTimer:(NSString *)timer {
    NSString * title = [NSString stringWithFormat:@"您选择了%@道习题  %@",titleNumber,timer];
    NSRange  range = [title rangeOfString:titleNumber];
    UIColor * numberColor =  UIColorFromRGB(0xef0224);
    NSMutableAttributedString *titleAttributed  = [[NSMutableAttributedString alloc]initWithString:title];
    
    [titleAttributed addAttribute:NSFontAttributeName
     
                            value: fontSize_13
     
                            range:range];
    [titleAttributed addAttribute:NSForegroundColorAttributeName
     
                            value:numberColor
     
                            range:range];
    
    NSRange  timerRange = [title rangeOfString:timer];
    UIColor * timerColor =  UIColorFromRGB(0x9D9D9D);
    [titleAttributed addAttribute:NSFontAttributeName
     
                            value: fontSize_13
     
                            range:timerRange];
    [titleAttributed addAttribute:NSForegroundColorAttributeName
     
                            value:timerColor
     
                            range:timerRange];
    self.titleLabel.attributedText = titleAttributed;
}
- (IBAction)btnAction:(id)sender {
    if (self.sureBlock) {
        self.sureBlock();
    }
}
- (void)setupButtonActivation:(BOOL )enabled{
    self.sureButton.enabled = enabled;
}

- (void)setupButtonTitle:(NSString *)title{
    
    [self.sureButton setTitle:title forState:UIControlStateNormal];
}
@end
