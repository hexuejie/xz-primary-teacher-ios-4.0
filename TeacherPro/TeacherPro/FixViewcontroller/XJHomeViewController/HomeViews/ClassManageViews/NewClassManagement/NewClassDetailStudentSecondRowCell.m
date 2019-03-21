
//
//  NewClassDetailStudentSecondRowCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/8/3.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "NewClassDetailStudentSecondRowCell.h"
#import "PublicDocuments.h"
#import "ClassDetailStudentModel.h"
#import "ProUtils.h"
@interface NewClassDetailStudentSecondRowCell()
@property (weak, nonatomic) IBOutlet UILabel *titlefist;
@property (weak, nonatomic) IBOutlet UILabel *titlespeed;
@property (weak, nonatomic) IBOutlet UILabel *titleprogress;
@property (weak, nonatomic) IBOutlet UILabel *titlecoin;
@property (weak, nonatomic) IBOutlet UIImageView *bgImgV;
@property (weak, nonatomic) IBOutlet UIImageView *centerLine;

@end
@implementation NewClassDetailStudentSecondRowCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titlefist.textColor = UIColorFromRGB(0x898989);
    self.titlefist.font = fontSize_12;
    
    self.titlespeed.textColor = UIColorFromRGB(0x898989);
    self.titlespeed.font = fontSize_12;
    
    self.titleprogress.textColor = UIColorFromRGB(0x898989);
    self.titleprogress.font = fontSize_12;
    
    self.titlecoin.textColor = UIColorFromRGB(0x898989);
    self.titlecoin.font = fontSize_12;
    self.backgroundColor = [UIColor clearColor];
    
    CGFloat top = 25; // 顶端盖高度
    CGFloat bottom = 25; // 底端盖高度
    CGFloat left = 25; // 左端盖宽度
    CGFloat right = 25; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    
    UIImage * image = [UIImage imageNamed:@"class_teacher_bg"]  ;
    // 指定为拉伸模式，伸缩后重新赋值
    image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    self.bgImgV.image = image;
    self.centerLine.backgroundColor = project_line_gray;
}
- (void)setupCellInfo:(ClassDetailStudentModel *)model{
    NSString * titleCoin = [NSString stringWithFormat:@"学豆：%@个",model.coin];
    NSRange rangeStu= [titleCoin  rangeOfString:[NSString stringWithFormat:@"%@",model.coin]];
    NSAttributedString * attributtedString = [ProUtils setAttributedText:titleCoin withColor:UIColorFromRGB(0x77d684) withRange:rangeStu withFont:fontSize_12];
 
    self.titlecoin.attributedText = attributtedString;
    
    NSString * titlefist = [NSString stringWithFormat:@"前三名：%@次",model.top3Count];
    rangeStu = [titlefist  rangeOfString:[NSString stringWithFormat:@"%@",model.top3Count]];
     attributtedString = [ProUtils setAttributedText:titlefist withColor:UIColorFromRGB(0xFF5555) withRange:rangeStu withFont:fontSize_12];
    self.titlefist.attributedText = attributtedString;
    
    NSString * titleprogress = [NSString stringWithFormat:@"进步奖：%@次",model.progressiveCount];
    rangeStu = [titleprogress  rangeOfString:[NSString stringWithFormat:@"%@",model.progressiveCount]];
    attributtedString = [ProUtils setAttributedText:titleprogress withColor:UIColorFromRGB(0xFF5555) withRange:rangeStu withFont:fontSize_12];
    self.titleprogress.attributedText = attributtedString;
    
    NSString * titlespeed = [NSString stringWithFormat:@"完成最快：%@次",model.speedstarCount];
    rangeStu = [titlespeed  rangeOfString:[NSString stringWithFormat:@"%@",model.speedstarCount]];
    attributtedString = [ProUtils setAttributedText:titlespeed withColor:UIColorFromRGB(0xFF5555) withRange:rangeStu withFont:fontSize_12];
    self.titlespeed.attributedText = attributtedString;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
