//
//  StudentHomeworkUnitSectionCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/7/9.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "StudentHomeworkUnitSectionCell.h"
#import "PublicDocuments.h"
#import "UIImageView+WebCache.h"
@interface StudentHomeworkUnitSectionCell()
@property (weak, nonatomic) IBOutlet UIButton *unitDetailBtn;//作业详情
@property (weak, nonatomic) IBOutlet UILabel *rewardCoinLabel;//奖励学豆
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;//分数
@property (weak, nonatomic) IBOutlet UILabel *unitNameLabel;//单元名字
@property (weak, nonatomic) IBOutlet UIImageView *unitImg;
@property (weak, nonatomic) IBOutlet UIImageView *bottomLineImgV;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImgV;

@end
@implementation StudentHomeworkUnitSectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubview];
}

-(void)setupSubview{

    self.unitImg.backgroundColor = [UIColor clearColor];
    self.unitDetailBtn.titleLabel.font = fontSize_14;
    [self.unitDetailBtn setTitleColor:project_main_blue forState:UIControlStateNormal];
    
    self.scoreLabel.font = fontSize_14;
    self.rewardCoinLabel.font = fontSize_14;
    self.unitNameLabel.font = fontSize_14;
    self.unitNameLabel.textColor = UIColorFromRGB(0x6b6b6b);
//    self.scoreLabel.textColor = UIColorFromRGB(0xff2e2e);
    self.scoreLabel.textColor = UIColorFromRGB(0x2E8AFF);
    self.rewardCoinLabel.textColor = UIColorFromRGB(0x6b6b6b);
    self.bottomLineImgV.backgroundColor = project_line_gray;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)unitDetailAction:(id)sender {
    if (self.unitDetailBlock) {
        self.unitDetailBlock(self.index);
    }
}
- (void)setupUnitSectionInfo:(NSDictionary *)dic  withImageName:(NSString *)imageName withType:(NSString *)type{

 
 
    NSString * title = @"";
    if (dic[@"typeCn"]) {
        title = dic[@"typeCn"];
    }else if (dic[@"unitName"]) {
        title = dic[@"unitName"];
    }
    self.unitNameLabel.text = title;
    NSString * score = @"";
    
    if([type isEqualToString:@"zxlx"]){
        if (dic[@"score"]) {
            if([dic[@"score"] integerValue]<0){
                score = @"未完成";
                self.unitDetailBtn.hidden = YES;
                self.arrowImgV.hidden = YES;
            }else{
                score = [ NSString stringWithFormat:@"%@分",dic[@"score"]];
                self.unitDetailBtn.hidden = NO;
                self.arrowImgV.hidden = NO;
            }
        }

    }else{
        if (dic[@"score"]) {
            if([dic[@"score"] integerValue] < 0){
                score = @"未完成";
                self.unitDetailBtn.hidden = YES;
                self.arrowImgV.hidden = YES;
            }else{
                score = @"完成";
          
                self.unitDetailBtn.hidden = YES;
                 self.arrowImgV.hidden = YES;
            }
        }

    
    }
   
    
    self.scoreLabel.text = score;
//    self.unitImg.image = [UIImage imageNamed:dic[@"logo"]];
//    if ( imageName.length > 0) {
         self.unitImg.image = [UIImage imageNamed:imageName];
//    }else
//        [self.unitImg sd_setImageWithURL:[NSURL URLWithString:dic[@"logo"]] placeholderImage:nil];
}
@end
