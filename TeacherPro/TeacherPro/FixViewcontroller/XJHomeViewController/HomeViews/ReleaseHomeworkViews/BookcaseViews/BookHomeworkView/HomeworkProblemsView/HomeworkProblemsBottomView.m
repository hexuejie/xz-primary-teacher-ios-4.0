
//
//  HomeworkProblemsBottomView.m
//  TeacherPro
//
//  Created by DCQ on 2018/1/22.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "HomeworkProblemsBottomView.h"
#import "PublicDocuments.h"

@interface HomeworkProblemsBottomView ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIView *topLineV;

@end
@implementation HomeworkProblemsBottomView
- (void)awakeFromNib{
    
    [super awakeFromNib];
    [self setupSubView];
}
- (void)setupSubView{
    self.bgView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    self.topLineV.backgroundColor =  project_line_gray;
    self.sureBtn.layer.masksToBounds = YES;
    self.sureBtn.layer.cornerRadius = 25;
    self.sureBtn.layer.borderWidth = 1;
}
- (IBAction)sureAction:(id)sender {
    if (self.btnActionBlock) {
        self.btnActionBlock();
    }
    
}

@end
