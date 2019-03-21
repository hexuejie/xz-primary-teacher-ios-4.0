//
//  OnlineUnfinishedCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/8/15.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "OnlineUnfinishedAdjustCell.h"
#import "PublicDocuments.h"
#import "ProUtils.h"
#import "UIImageView+WebCache.h"
@interface OnlineUnfinishedAdjustCell()
@property (weak, nonatomic) IBOutlet UIImageView *selelcedImg;
@property (weak, nonatomic) IBOutlet UILabel *studentName;//学生名字

@property (weak, nonatomic) IBOutlet UILabel *rewardName;//奖励豆
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;

@property (weak, nonatomic) IBOutlet UIImageView *userImgV;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameWith;
@end
@implementation OnlineUnfinishedAdjustCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubview];
}

-(void)setupSubview{
    self.userImgV.image = [UIImage imageNamed:@"student_img"];
    self.bottomLineView.backgroundColor = project_line_gray;
  
    self.studentName.textColor = UIColorFromRGB(0x6b6b6b);
    self.studentName.font = fontSize_14;
    self.rewardName.font = fontSize_13;
    self.nameWith.constant = FITSCALE(72);
}
- (void)setupStudentInfo:(NSDictionary *)info  {
    
  
    NSString * name  = info[@"studentName"];
    NSString * avatar = info[@"avatar"];
    NSString * placeholderImgName = @"";
    if ([info[@"sex"] isEqualToString:@"female"]) {
        placeholderImgName =  @"student_wuman";
    }else if ([info[@"sex"] isEqualToString:@"male"]){
        placeholderImgName =  @"student_man";
    }else{
        placeholderImgName =  @"student_wuman";
    }
    [self.userImgV sd_setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:[UIImage imageNamed: placeholderImgName]];
    
    if (name && name.length >5) {
        name = [name substringToIndex:5];
    }
    self.studentName.text = name;

    NSString * rewardName = [NSString  stringWithFormat:@"扣罚学豆:%@",[NSString stringWithFormat:@"%@",info[@"coin"]]];
//    self.rewardName.text = rewardName;
    self.rewardName.textColor = UIColorFromRGB(0x6b6b6b);
    self.rewardName.attributedText = [ProUtils setAttributedText:rewardName withColor:UIColorFromRGB(0xff5555) withRange:[rewardName rangeOfString:[NSString stringWithFormat:@"%@",info[@"coin"]]] withFont:fontSize_13];
   
    //金币
//    [self setupCoinNumber:[NSString stringWithFormat:@"%@",info[@"coin"]]];

}


- (void)setupCoinNumber:(NSString *)coin{
    
    NSString * rewardName = [NSString  stringWithFormat:@"扣罚学豆: %@",coin];
    self.rewardName.textColor = UIColorFromRGB(0x6b6b6b);
    self.rewardName.attributedText = [ProUtils setAttributedText:rewardName withColor:UIColorFromRGB(0xff5555) withRange:[rewardName rangeOfString:coin] withFont:fontSize_13];
    
    self.rewardName.text = rewardName;
}

- (void)setupSelectedImgState:(BOOL)YesOrNo{
    if (YesOrNo) {
        self.selelcedImg.image = [UIImage imageNamed:@"adjust_select_icon"];
    }else{
        self.selelcedImg.image = [UIImage imageNamed:@"adjust_unselect_icon"];
    }
    
}
- (void)setupSelectedImgHidden:(BOOL)YesOrNo{
    self.selelcedImg.hidden = YesOrNo;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
