//
//  HomeworkConfirmationPreviewView.m
//  TeacherPro
//
//  Created by DCQ on 2017/9/22.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "HomeworkConfirmationPreviewView.h"

@interface HomeworkConfirmationPreviewView()
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UIButton *dltBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end
@implementation HomeworkConfirmationPreviewView

- (void)awakeFromNib{
    
    [super awakeFromNib];
    [self setupSubview];
}

- (void)setupSubview{
 
    self.bgView.alpha = 0.5;
    self.bgView.backgroundColor = [UIColor blackColor];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenView)];
    [self.bgView addGestureRecognizer:tap];
    [self.dltBtn addTarget:self action:@selector(hiddenView) forControlEvents:UIControlEventTouchUpInside];
}

- (void)hiddenView{
    
    self.hidden = YES;
}
- (void)setupImageView:(NSString *)imageName{
 
    self.imgV.image = [UIImage imageNamed:imageName];
}
@end
