//
//  JFTopicParseNewBottomView.m
//  TeacherPro
//
//  Created by DCQ on 2017/12/21.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "JFTopicParseNewBottomView.h"
#import "ProUtils.h"
#import "PublicDocuments.h"
@interface JFTopicParseNewBottomView()

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property(nonatomic, assign) BOOL selectedState;
@end
@implementation JFTopicParseNewBottomView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setupSubview];
}


- (void)setupSubview{
    self.selectedState = YES;
    
    
    
//    UIEdgeInsets edge = UIEdgeInsetsMake(0, 0, 0, 10);
//    [self.sureBtn setImageEdgeInsets: edge];
//    [self.sureBtn setImage:[UIImage imageNamed:@"sure_btn_icon"] forState:UIControlStateNormal];
    self.sureBtn.layer.cornerRadius = 45/2;
    self.sureBtn.layer.masksToBounds = YES;
    self.sureBtn.layer.borderWidth = 1;
    self.sureBtn.layer.borderColor = [UIColor clearColor].CGColor;
    [self.sureBtn addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)sureAction:(id)sender{
    
    if (self.sureBlock) {
        self.sureBlock(self.selectedState);
    }
}
@end
