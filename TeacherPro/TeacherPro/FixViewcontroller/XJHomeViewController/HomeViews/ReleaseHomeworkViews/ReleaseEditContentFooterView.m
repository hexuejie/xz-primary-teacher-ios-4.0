//
//      ┏┛ ┻━━━━━┛ ┻┓
//      ┃　　　　　　 ┃
//      ┃　　　━　　　┃
//      ┃　┳┛　  ┗┳　┃
//      ┃　　　　　　 ┃
//      ┃　　　┻　　　┃
//      ┃　　　　　　 ┃
//      ┗━┓　　　┏━━━┛
//        ┃　　　┃   神兽保佑
//        ┃　　　┃   代码无BUG！
//        ┃　　　┗━━━━━━━━━┓
//        ┃　　　　　　　    ┣┓
//        ┃　　　　         ┏┛
//        ┗━┓ ┓ ┏━━━┳ ┓ ┏━┛
//          ┃ ┫ ┫   ┃ ┫ ┫
//          ┗━┻━┛   ┗━┻━┛
//
//  EditContentFooterView.m
//  TeacherPro
//
//  Created by DCQ on 2017/6/13.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "ReleaseEditContentFooterView.h"
#import "PublicDocuments.h"
@interface ReleaseEditContentFooterView()
@property (weak, nonatomic) IBOutlet UIButton *textViewButton;//文字
@property (weak, nonatomic) IBOutlet UIButton *todoButton;//事项
@property (weak, nonatomic) IBOutlet UIButton *photoButton;//图片
@property (weak, nonatomic) IBOutlet UIButton *voiceButton;//语音
@property (weak, nonatomic) IBOutlet UIView *buttonSuperView;
@property (weak, nonatomic) IBOutlet UIView *topLineView;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;

@end
@implementation ReleaseEditContentFooterView
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self configView];
    
}

- (void)configView{
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 0, 14);
    self.textViewButton.imageEdgeInsets = insets;
    self.todoButton.imageEdgeInsets = insets;
    self.photoButton.imageEdgeInsets = insets;
    self.voiceButton.imageEdgeInsets = insets;
    
    self.textViewButton.tag = ReleaseEditContentFooterViewType_textViewButton;
    self.todoButton.tag = ReleaseEditContentFooterViewType_todoButton;
    self.photoButton.tag = ReleaseEditContentFooterViewType_photoButton;
    self.voiceButton.tag = ReleaseEditContentFooterViewType_voiceButton;
    [self.textViewButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self. todoButton   addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.photoButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.voiceButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIColor * selectedColor =  HexRGB(0x33AAFF);
    UIColor * noramlColor =  UIColorFromRGB(0xB3B3B3);
    [self setupButtton:self.textViewButton withSelectedTitleColor:selectedColor withNormalTitleColor:noramlColor];
    [self setupButtton:self.todoButton withSelectedTitleColor:selectedColor withNormalTitleColor:noramlColor];
    [self setupButtton:self.photoButton withSelectedTitleColor:selectedColor withNormalTitleColor:noramlColor];
    [self setupButtton:self.voiceButton withSelectedTitleColor:selectedColor withNormalTitleColor:noramlColor];
    

    self.topLineView.backgroundColor = project_line_gray;
    self.bottomLineView.backgroundColor = project_line_gray;
    
}

- (void)setupButtton:(UIButton *)btn withSelectedTitleColor:(UIColor *)selectedColor withNormalTitleColor:(UIColor *) normalTitleColor{


    [btn setTitleColor:normalTitleColor forState:UIControlStateNormal];
    [btn setTitleColor:selectedColor forState:UIControlStateSelected];
}
- (void)buttonSelectedTag:(ReleaseEditContentFooterViewType)tag{
    
    for (id view in self.buttonSuperView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton * btn = view;
            btn.selected = NO;
        }
    }
    UIButton * btn = [self.buttonSuperView viewWithTag:tag];
    btn.selected = YES;
}
- (void)buttonAction:(UIButton *)sender{

    
    if (self.buttonsBlock) {
        self.buttonsBlock(sender.tag);
    }
}

@end
