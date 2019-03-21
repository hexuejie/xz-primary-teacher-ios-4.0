//
//  OnlineRewardsAdjustCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/8/15.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "OnlineRewardsAdjustCell.h"
#import "PublicDocuments.h"
#import "ProUtils.h"
#import "AlertView.h"
#import "UIImageView+WebCache.h"
@interface OnlineRewardsAdjustCell()

@property (weak, nonatomic) IBOutlet UIImageView *selelcedImg;
@property (weak, nonatomic) IBOutlet UILabel *studentName;//学生名字

@property (weak, nonatomic) IBOutlet UILabel *rewardName;//奖励豆
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
//@property (weak, nonatomic) IBOutlet UIImageView *leftImgV;
//
//@property (weak, nonatomic) IBOutlet UIImageView *centerImgV;
//@property (weak, nonatomic) IBOutlet UIImageView *rightImgV;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameWith;

@property (weak, nonatomic) IBOutlet UIView *iconBgV;

@property (weak, nonatomic) IBOutlet UIButton *leftBtn;

@property (weak, nonatomic) IBOutlet UIButton *centerBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIImageView *userImgV;

@end
@implementation OnlineRewardsAdjustCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubview];
}

-(void)setupSubview{
    self.userImgV.image = [UIImage imageNamed:@"student_img"];
    self.bottomLineView.backgroundColor = project_line_gray;
    self.detailLabel.textColor = UIColorFromRGB(0x6b6b6b);
    self.detailLabel.font = fontSize_14;
    self.studentName.textColor = UIColorFromRGB(0x6b6b6b);
    self.studentName.font = fontSize_14;
    self.rewardName.font = fontSize_13;
//    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
//    [self.iconBgV addGestureRecognizer:tap];
    self.nameWith.constant = FITSCALE(72);
}


- (void)tapAction{
    
    NSArray * items = @[ MMItemMake(@"确定", MMItemTypeHighlight, nil)];
    NSArray * logos = @[@{@"img":@"student_results_Top3",@"title":@"前 三 名:",@"detail":@"当前作业成绩前三名"},
                        @{@"img":@"student_results_Progressive",@"title":@"进步达人:",@"detail":@"只要当次综合分高于上次作业综合分都为进步达人"},
                        @{@"img":@"student_results_Speedstar",@"title":@"速度之星:",@"detail":@"交作业最快并成绩为A的前三名"},
                        @{@"img":@"student_results_Regress",@"title":@"退      步:",@"detail":@"当次作业综合成绩低于上次作业成绩"},
                        ];
    AlertView * alert = [[AlertView alloc] initWithTitle:@"标识说明" logoInstructions:logos  items:items ];
    
    [alert show];
}


- (void)setupStudentInfo:(NSDictionary *)info  {
    //名字
   
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
 
    
    //作业得分
    NSString * key = @"";
    NSString * feedBack = @"";
    //先检查是否反馈
    if ([info[@"homeworkFeedback"] isEqualToString:@"none"]) {
        //完成
        if (info[@"finishTime"]) {
            
            //完成了且有分数
            if ([info[@"scoreLevel"] isKindOfClass:[NSString class]] && [info[@"scoreLevel"] length] >0 ) {
                key = info[@"scoreLevel"];
            }else{
                //完成了没分数
                key = @"完成";
            }
            
        }else{
            //未完成
            key = @"未";
        }
        
    }else{
        //需要反馈
        
        if (info[@"finishTime"]) {
            //完成了且有分数
            if ([info[@"scoreLevel"] isKindOfClass:[NSString class]] && [info[@"scoreLevel"] length] >0 ) {
                key = info[@"scoreLevel"];
            }else{
                //完成了没分数
                key = @"完成";
            }
            
            
            feedBack = @"已反馈";
        }else{
            key = @"未";
            feedBack = @"未反馈";
        }
        
    }
    NSString * detailText = @"";
    if ([feedBack length] >0) {
        detailText  = [NSString stringWithFormat:@"作业: %@",key];
    }else{
        detailText  = [NSString stringWithFormat:@"作业成绩: %@",key];
    }
 
    self.detailLabel.attributedText = [ProUtils setAttributedText:detailText withColor:project_main_blue withRange:[detailText rangeOfString:key] withFont:fontSize_13];
    [self showIconInfo:info];
    //金币
     [self setupCoinNumber:[NSString stringWithFormat:@"%@",info[@"coin"]]];
    
}

- (void)showIconInfo:(NSDictionary *)info{
    //图标
    if (info[@"medals"]) {
        NSArray *  medals = info[@"medals"];
        if([medals count]==0){
            
            self.centerBtn.hidden = YES;
            self.rightBtn.hidden = YES;
            self.leftBtn.hidden = YES;
            self.iconBgV.hidden =YES;
        }else if ([medals count]==1){
            
            self.centerBtn.hidden = YES;
            self.rightBtn.hidden = YES;
        }else if ([medals count] == 2){
            
            self.rightBtn.hidden = YES;
        }else{
            self.centerBtn.hidden = NO;
            self.rightBtn.hidden = NO;
            self.leftBtn.hidden = NO;
            self.iconBgV.hidden =NO;
        }
        for (int i = 0; i< [medals count]; i++) {
            NSString * imageName= [NSString stringWithFormat:@"student_results_%@", medals[i]];
            if (i == 0) {
                
                [self.leftBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
                
            }else if (i ==1){
                
                [self.centerBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
            }else{
                
                [self.rightBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
            }
        }
        
    }else{
        
        
        self.iconBgV.hidden =YES;
        self.centerBtn.hidden = YES;
        self.rightBtn.hidden = YES;
        self.leftBtn.hidden = YES;
    }
    
    
}
- (IBAction)showIcon:(id)sender {
    [self tapAction];
}

- (void)setupCoinNumber:(NSString *)coin{
    
    NSString * rewardName = [NSString  stringWithFormat:@"奖励学豆: %@",coin];
    self.rewardName.textColor = UIColorFromRGB(0x6b6b6b);
    self.rewardName.attributedText = [ProUtils setAttributedText:rewardName withColor:UIColorFromRGB(0xff5555) withRange:[rewardName rangeOfString:coin] withFont:fontSize_13];
//    self.rewardName.text = rewardName;
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
