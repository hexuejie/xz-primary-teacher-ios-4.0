
//
//  OnlineUnfinishedLookCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/8/15.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "OnlineUnfinishedLookCell.h"
#import "PublicDocuments.h"
#import "ProUtils.h"
#import "UIImageView+WebCache.h"
@interface OnlineUnfinishedLookCell()
 
@property (weak, nonatomic) IBOutlet UILabel *studentName;//学生名字

@property (weak, nonatomic) IBOutlet UIView *bottomLineView;

@property (weak, nonatomic) IBOutlet UILabel *rewardName;//奖励豆
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameWith;
@property (weak, nonatomic) IBOutlet UIImageView *userImgV;


@end

@implementation OnlineUnfinishedLookCell

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
    
    NSString * rewardName = [NSString  stringWithFormat:@"扣除%@豆",[NSString stringWithFormat:@"%@",info[@"coin"]]];
    self.rewardName.text = rewardName;
    

    
}


- (void)setupCoinNumber:(NSString *)coin{
    
    NSString * rewardName = [NSString  stringWithFormat:@"扣除%@豆",coin];
    self.rewardName.text = rewardName;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
