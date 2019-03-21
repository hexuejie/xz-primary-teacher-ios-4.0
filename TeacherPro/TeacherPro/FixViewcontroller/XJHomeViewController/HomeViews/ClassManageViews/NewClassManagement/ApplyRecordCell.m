//
//  ApplyRecordCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/8/24.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "ApplyRecordCell.h"
#import "ApplyRecordModel.h"
#import "PublicDocuments.h"
#import "ProUtils.h"
#import "UIImageView+WebCache.h"
@interface ApplyRecordCell()
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *classImgV;

@end
@implementation ApplyRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubview];
}

- (void)setupSubview{

    self.contentLabel.font = fontSize_12;
    self.contentLabel.textColor = UIColorFromRGB(0x898989);
    self.btn.titleLabel.font = fontSize_10;
    self.btn.layer.cornerRadius = 4;
    self.btn.layer.borderColor = project_main_blue.CGColor;
    self.btn.layer.borderWidth = 0.5;
    
    self.btn.layer.masksToBounds = YES;
    [self.btn addTarget:self action:@selector(urgedAction:) forControlEvents:UIControlEventTouchUpInside];
    self.timerLabel.font = fontSize_10;
    self.timerLabel.textColor = UIColorFromRGB(0x898989);
    self.bottomLineView.backgroundColor = project_line_gray;
}

- (void)urgedAction:(UIButton *)btn{

    if (!btn.selected) {
        btn.selected = YES;
        if (self.urgedBlock) {
            self.urgedBlock(self.index);
        }
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setupCellInfo:(ApplyRecordModel *)model{

    [self.classImgV sd_setImageWithURL:[NSURL URLWithString:model.clazzLogo] placeholderImage:[UIImage imageNamed:@"student_img"]];
 
    NSString * contentText = [NSString stringWithFormat:@"您申请加入%@\n的%@%@",model.teacherName,model.gradeName,model.clazzName];
    NSRange  rangeT = [contentText rangeOfString:model.teacherName];
    NSRange rangeG = [contentText rangeOfString:model.gradeName];
    NSRange rangeC = [contentText rangeOfString:model.clazzName];
    
     self.contentLabel.attributedText = [self getContentText:contentText withRangeT:rangeT withRangeG:rangeG withRangeC:rangeC];
    
    if ([model.callStatus integerValue] == 1) {
        self.btn.selected = YES;
        [self.btn setTitleColor:UIColorFromRGB(0x898989) forState:UIControlStateNormal];
        self.btn.layer.borderColor = UIColorFromRGB(0x898989).CGColor;
 
    }else{
   
        self.btn.selected = NO;
        [self.btn setTitleColor:project_main_blue forState:UIControlStateNormal];
        self.btn.layer.borderColor = project_main_blue.CGColor;
    }
 
    
    NSString * time = [ProUtils compareCurrentTime:[NSString stringWithFormat:@"%@", model.ctime]];
    self.timerLabel.text = [NSString stringWithFormat:@"(%@)",time];
    
}

- (NSAttributedString *)getContentText:(NSString *)contentText withRangeT:(NSRange )rangeT withRangeG:(NSRange )rangeG withRangeC:(NSRange )rangeC {

    NSMutableAttributedString *Attributed  = [[NSMutableAttributedString alloc]initWithString:contentText];
    
    [Attributed addAttribute:NSFontAttributeName
     
                       value: self.contentLabel.font
     
                       range:rangeT];
    [Attributed addAttribute:NSForegroundColorAttributeName
     
                       value:project_main_blue
     
                       range:rangeT];
    
    
    [Attributed addAttribute:NSFontAttributeName
     
                       value:  self.contentLabel.font
     
                       range:rangeG];
    [Attributed addAttribute:NSForegroundColorAttributeName
     
                       value:project_main_blue
     
                       range:rangeG];
    
    [Attributed addAttribute:NSFontAttributeName
     
                       value:  self.contentLabel.font
     
                       range:rangeC];
    [Attributed addAttribute:NSForegroundColorAttributeName
     
                       value:project_main_blue
     
                       range:rangeC];
    

    return Attributed;
}
@end
