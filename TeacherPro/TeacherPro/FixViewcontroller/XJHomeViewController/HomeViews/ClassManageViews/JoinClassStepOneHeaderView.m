//
//  JoinClassStepOneHeaderView.m
//  TeacherPro
//
//  Created by DCQ on 2017/5/10.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "JoinClassStepOneHeaderView.h"
#import "CommonConfig.h"
#import "ProUtils.h"

@interface JoinClassStepOneHeaderView ()
@property (weak, nonatomic) IBOutlet UIView *tfBackgroudView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *chackBtn;

@end
@implementation JoinClassStepOneHeaderView
- (void)awakeFromNib{
    [super awakeFromNib];
    [self stepSubviews];
}

- (void)stepSubviews{

//    [self.tfBackgroudView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(FITSCALE(40));
//        
//    }];
//    
//    [self.chackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(FITSCALE(50));
//        
//    }];
//    self.chackBtn.layer.cornerRadius = FITSCALE(50/2);
//    self.tfBackgroudView.layer.cornerRadius = FITSCALE(40/2);
    self.chackBtn.titleLabel.font = fontSize_16;
    [self.chackBtn addTarget:self action:@selector(chackButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.textField.font = fontSize_15;
    [self.textField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    
}

#pragma mark - Notification Method
-(void)textFieldEditChanged:(UITextField *)textField
{
    
    [ProUtils phoneTextFieldEditChanged:textField];
    
}
- (void)chackButtonAction:(id)sender{
    
    if (self.textField.text.length <=0) {
        [ProUtils shake:self.textField];
        return;
    }
    [self.textField resignFirstResponder];
    if(self.chackBtnBlcok){
    
        self.chackBtnBlcok(self.textField.text);
    }
    
}

- (void)becomeFirstResponder{

    [self.textField becomeFirstResponder];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
