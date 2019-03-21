//
//  YWDDDetailBottomView.m
//  TeacherPro
//
//  Created by DCQ on 2018/1/19.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "YWDDDetailBottomView.h"
#import "PublicDocuments.h"
#import "ProUtils.h"
@interface YWDDDetailBottomView()
@property (weak, nonatomic) IBOutlet UILabel  *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet  UIView  *topLine;
@end
@implementation YWDDDetailBottomView
- (void)awakeFromNib{
    [super awakeFromNib];
    [self setupSubview];
}
- (void)setupSubview {
    self.titleLabel.font = fontSize_14;
    self.titleLabel.textColor = UIColorFromRGB(0x6b6b6b);
    self.topLine.backgroundColor = project_line_gray;
    
    self.sureButton.titleLabel.backgroundColor = self.sureButton.backgroundColor;
    self.sureButton.imageView.backgroundColor = self.sureButton.backgroundColor;
    
    
    
    //在使用一次titleLabel和imageView后才能正确获取titleSize
 
    CGFloat interval = 4.0;
    self.sureButton.imageEdgeInsets = UIEdgeInsetsMake(0, -interval/2, 0,  interval/2);
    self.sureButton.titleEdgeInsets = UIEdgeInsetsMake(0,  interval/2, 0, -interval/2);
    [self.sureButton addTarget:self action:@selector(sureBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.titleLabel.text = @"请您选择布置的作业题";
}

- (void)sureBtnAction:(id)sender{
    
    if (self.sureBlock) {
        self.sureBlock();
    }
}


- (void)setupTitleNumber:(NSString *)titleNumber withTimer:(NSString *)timer {
    NSString * title = [NSString stringWithFormat:@"您选择了%@段  %@",titleNumber,timer];
    NSRange  range = [title rangeOfString:titleNumber];
    UIColor * numberColor =  UIColorFromRGB(0xef0224);
    NSMutableAttributedString *titleAttributed  = [[NSMutableAttributedString alloc]initWithString:title];
    
    [titleAttributed addAttribute:NSFontAttributeName
     
                       value: fontSize_14
     
                       range:range];
    [titleAttributed addAttribute:NSForegroundColorAttributeName
     
                       value:numberColor
     
                       range:range];
    
    NSRange  timerRange = [title rangeOfString:timer];
    UIColor * timerColor =  UIColorFromRGB(0x9D9D9D);
    [titleAttributed addAttribute:NSFontAttributeName
     
                       value: fontSize_14
     
                       range:timerRange];
    [titleAttributed addAttribute:NSForegroundColorAttributeName
     
                       value:timerColor
     
                       range:timerRange];
    self.titleLabel.attributedText = titleAttributed;
}
- (void)setupButtonActivation:(BOOL )enabled{
    self.sureButton.enabled = enabled;
}
- (void)setupButtonTitle:(NSString *)btnTitle{
    [self.sureButton setTitle:btnTitle forState:UIControlStateNormal];
}
 
@end
