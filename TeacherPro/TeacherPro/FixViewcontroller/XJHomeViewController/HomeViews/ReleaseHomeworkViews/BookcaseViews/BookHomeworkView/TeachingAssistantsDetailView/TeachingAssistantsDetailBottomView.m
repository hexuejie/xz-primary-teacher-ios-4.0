
//
//  TeachingAssistantsDetailBottomView.m
//  TeacherPro
//
//  Created by DCQ on 2017/11/6.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "TeachingAssistantsDetailBottomView.h"
#import "PublicDocuments.h"
#import "ProUtils.h"
@interface TeachingAssistantsDetailBottomView()
@property (weak, nonatomic) IBOutlet UILabel  *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet  UIView  *topLine;
@end

@implementation TeachingAssistantsDetailBottomView
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
    CGSize titleSize = self.sureButton.titleLabel.bounds.size;
    CGSize imageSize = self.sureButton.imageView.bounds.size;
    CGFloat interval = 4.0;
    self.sureButton.imageEdgeInsets = UIEdgeInsetsMake(0, -interval/2, 0,  interval/2);
    self.sureButton.titleEdgeInsets = UIEdgeInsetsMake(0,  interval/2, 0, -interval/2);
    [self.sureButton addTarget:self action:@selector(sureBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)sureBtnAction:(id)sender{
    
    if (self.sureBlock) {
        self.sureBlock();
    }
}


- (void)setupTitleNumber:(NSString *)titleNumber withType:(NSString *)type {
    NSString * title = [NSString stringWithFormat:@"您选择了%@道教辅%@",titleNumber,type];
    NSRange  range = [title rangeOfString:titleNumber];
      UIColor * numberColor =  UIColorFromRGB(0xef0224);
    self.titleLabel.attributedText =[ ProUtils  setAttributedText:title  withColor:numberColor withRange:range withFont:fontSize_14];
}
- (void)setupButtonActivation:(BOOL )enabled{
    self.sureButton.enabled = enabled;
}
- (void)setupButtonTitle:(NSString *)btnTitle{
    [self.sureButton setTitle:btnTitle forState:UIControlStateNormal];
}
@end
