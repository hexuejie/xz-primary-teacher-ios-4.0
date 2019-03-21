//
//  NewRewardFooterReusableView.m
//  TeacherPro
//
//  Created by 何学杰 on 2019/1/3.
//  Copyright © 2019 ZNXZ. All rights reserved.
//

#import "NewRewardFooterReusableView.h"

@implementation NewRewardFooterReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    

    _tipLabel.text = [NSString stringWithFormat:@"%@学豆最多不超过5个哦",_leftLabel.text];
    self.countStr = @"0";
    
    
//    tipLabel
    
}
- (void)setIsreward:(BOOL)isreward{
    _isreward = isreward;
    if ([_countLabel.text integerValue] == 0) {
        if (_isreward) {
            _leftLabel.text = @"奖励";
            _addButton.selected = NO;
            _decreatButton.selected = YES;
            
            
        }else{
            _addButton.selected = YES;
            _decreatButton.selected = NO;
            _leftLabel.text = @"扣罚";
            
        }
        _tipLabel.text = [NSString stringWithFormat:@"%@学豆最多不超过5个哦",_leftLabel.text];
    }
    
}

- (IBAction)leftButtonClick:(UIButton *)sender {
    if (sender.selected == YES) {
        return;
    }
    
    _countLabel.text  =  [NSString stringWithFormat:@"%ld",[_countLabel.text integerValue]-1];
    
    _addButton.selected = NO;
    _decreatButton.selected = NO;
    if (_isreward ) {
        if ([_countLabel.text integerValue] == 0) {
            _decreatButton.selected = YES;
        }else if ([_countLabel.text integerValue] == 5) {
            _addButton.selected = YES;
        }
    }else{
        if ([_countLabel.text integerValue] == 0) {
            _addButton.selected = YES;
        }else if ([_countLabel.text integerValue] == -5) {
            _decreatButton.selected = YES;
        }
    }
    self.countStr = _countLabel.text;
    
}

- (IBAction)rightButtonClick:(UIButton *)sender {
    
    if (sender.selected == YES) {
        return;
    }
    
    _countLabel.text  =  [NSString stringWithFormat:@"%ld",[_countLabel.text integerValue]+1];
    
    _addButton.selected = NO;
    _decreatButton.selected = NO;
    if (_isreward ) {
        if ([_countLabel.text integerValue] == 0) {
            _decreatButton.selected = YES;
        }else if ([_countLabel.text integerValue] == 5) {
            _addButton.selected = YES;
        }
    }else{
        if ([_countLabel.text integerValue] == 0) {
            _addButton.selected = YES;
        }else if ([_countLabel.text integerValue] == -5) {
            _decreatButton.selected = YES;
        }
    }
    self.countStr = _countLabel.text;
    
}
@end
