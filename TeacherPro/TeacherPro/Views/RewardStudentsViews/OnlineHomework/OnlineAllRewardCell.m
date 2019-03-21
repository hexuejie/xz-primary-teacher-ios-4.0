//
//  OnlineAllRewardCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/8/15.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "OnlineAllRewardCell.h"
#import "PublicDocuments.h"
#import "AlertView.h"
#import "ProUtils.h"
#import "UIImageView+WebCache.h"
@interface OnlineAllRewardCell()
@property (weak, nonatomic) IBOutlet UILabel *studentName;//学生名字

@property (weak, nonatomic) IBOutlet UILabel *rewardName;//奖励豆
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;


@property (weak, nonatomic) IBOutlet UIView *iconBgV;

@property (weak, nonatomic) IBOutlet UIImageView *detailArrrow;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconBgWidth;


@property (weak, nonatomic) IBOutlet UIButton *leftBtn;

@property (weak, nonatomic) IBOutlet UIButton *centerBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIButton *itemBtn;
@property (weak, nonatomic) IBOutlet UIImageView *userImgV;


@end
@implementation OnlineAllRewardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubview];
    
}


- (void)setupSubview{
    self.userImgV.image = [UIImage imageNamed:@"student_img"];
    self.bottomLineView.backgroundColor = project_line_gray;
    self.detailLabel.textColor = UIColorFromRGB(0x6b6b6b);
    self.detailLabel.font = fontSize_13;
    self.studentName.textColor = UIColorFromRGB(0x6b6b6b);
    self.studentName.font = fontSize_14;
    
    self.rewardName.font = fontSize_13;
    
 

    self.nameWidth.constant =  FITSCALE(72);
 
    
    self.itemBtn.backgroundColor = UIColorFromRGB(0xFFE8C9);
    [self.itemBtn setTitleColor: UIColorFromRGB(0xAA7B5D) forState:UIControlStateNormal];
    self.itemBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    self.itemBtn.hidden = YES;
    [self.itemBtn addTarget:self action:@selector(itemAction:) forControlEvents:UIControlEventTouchUpInside];
    self.itemBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
}
- (void)itemAction:(UIButton *)itemBtn{
    
    if (self.selectedBlock) {
        self.selectedBlock(self.indexPath);
    }
}

- (void)setupStudentInfo:(NSDictionary *)info  withIsShow:(BOOL)isShow {
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
   //完成  未完成  完成的等级
    NSString * completeStr = @"";
    completeStr = [self getCompleteString:info];
    NSString * detailText = @"";
    
    if ([completeStr isEqualToString:@"未完成"]||[completeStr isEqualToString:@"完成"]) {
        detailText  = [NSString stringWithFormat:@"%@",completeStr];
    }else{
        detailText  = [NSString stringWithFormat:@"作业成绩:%@",completeStr];
    }
    self.detailLabel.attributedText = [ProUtils setAttributedText:detailText withColor:project_main_blue withRange:[detailText rangeOfString:completeStr] withFont:fontSize_13];
    BOOL isUnknowQuestions = NO;
    if ([info objectForKey:@"unknowQuestions"] && [[info objectForKey:@"unknowQuestions"] count] >0) {
        self.itemBtn.hidden = NO;
        self.iconBgV.hidden = YES;
        isUnknowQuestions = YES;
        NSString *itemTitle = [NSString stringWithFormat:@"有%ld题不会做",[[info objectForKey:@"unknowQuestions"] count]];
        [self.itemBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.itemBtn.backgroundColor = UIColorFromRGB(0xF38826);
        
        [self.itemBtn setTitle:itemTitle forState:UIControlStateNormal];
    }else{
        //设置显示图标
        [self confightMedalsImgV:info];
    }
    
   //设置显示奖励的学豆
    [self setupCoinNumber:[NSString stringWithFormat:@"%@",info[@"coin"]] withIsShow: isShow  withCompleteStr: completeStr withIsUnknowQuestions:isUnknowQuestions   ];
  
}

- (NSString *)getCompleteString:(NSDictionary *)info{
    NSString * completeStr = @"";
    //先检查是否反馈
    if ([info[@"homeworkFeedback"] isEqualToString:@"none"]) {
        //完成
        if (info[@"finishTime"]) {
            
            //完成了且有分数
            if ([info[@"scoreLevel"] isKindOfClass:[NSString class]] && [info[@"scoreLevel"] length] >0 ) {
                completeStr = info[@"scoreLevel"];
            }else{
                //完成了没分数
                completeStr = @"完成";
            }
            
        }else{
            //未完成
            completeStr = @"未完成";
        }
        
        
    }else{
        //需要反馈
        
        if (info[@"finishTime"]) {
            //完成了且有分数
            if ([info[@"scoreLevel"] isKindOfClass:[NSString class]] && [info[@"scoreLevel"] length] >0 ) {
                completeStr = info[@"scoreLevel"];
            }else{
                //完成了没分数
                completeStr = @"完成";
            }
            
            
        }else{
            completeStr = @"未完成";
            
        }
        
    }
    return completeStr;
}

- (void)confightMedalsImgV:(NSDictionary *)info{
    
    //图标
    if (info[@"medals"]) {
        NSArray *  medals = info[@"medals"];
        if([medals count] == 0){
            
            self.iconBgV.hidden =YES;
            
            self.centerBtn.hidden = YES;
            self.rightBtn.hidden = YES;
            self.leftBtn.hidden = YES;
            
        }else if ([medals count]==1){
            
            self.centerBtn.hidden = YES;
            self.rightBtn.hidden = YES;
        }else if ([medals count] == 2){
            
            self.rightBtn.hidden = YES;
        }else{
            
            self.iconBgV.hidden =NO;
            self.centerBtn.hidden = NO;
            self.rightBtn.hidden = NO;
            self.leftBtn.hidden = NO;
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
         //无图标
        self.iconBgV.hidden =YES;
        self.centerBtn.hidden = YES;
        self.rightBtn.hidden = YES;
        self.leftBtn.hidden = YES;
    }
    
}
- (void)setupCoinNumber:(NSString *)coin withIsShow:(BOOL)isShow  withCompleteStr:(NSString *)completeStr withIsUnknowQuestions:(BOOL)isUnknowQuestions{
    NSString * rewardName = @"";
    if (isShow) {
        rewardName = [NSString  stringWithFormat:@"奖励学豆: %@",coin];
        self.rewardName.textColor = UIColorFromRGB(0x6b6b6b);
        self.rewardName.attributedText = [ProUtils setAttributedText:rewardName withColor:UIColorFromRGB(0xff5555) withRange:[rewardName rangeOfString:coin] withFont:fontSize_13];
        self.detailArrrow.hidden = NO;
    }else{
        if (![completeStr isEqualToString:@"未完成"]) {
             if (isUnknowQuestions) {
                  rewardName = @"";
             }else{
                 rewardName = [NSString  stringWithFormat:@"查看详情"];
             }
            self.rewardName.textColor = UIColorFromRGB(0x6b6b6b);
            self.detailArrrow.hidden = NO;
        }else{
            self.detailArrrow.hidden = YES;
            rewardName = @"";
        }
            self.rewardName.text = rewardName;
    }
 

}

- (IBAction)showIcon:(id)sender {
    [self tabAction];
}

- (void)tabAction{
    
    NSArray * items = @[ MMItemMake(@"确定", MMItemTypeHighlight, nil)];
    NSArray * logos = @[@{@"img":@"student_results_Top3",@"title":@"前 三 名:",@"detail":@"当前作业成绩前三名"},
                        @{@"img":@"student_results_Progressive",@"title":@"进步达人:",@"detail":@"只要当次综合分高于上次作业综合分都为进步达人"},
                        @{@"img":@"student_results_Speedstar",@"title":@"速度之星:",@"detail":@"交作业最快并成绩为A的前三名"},
                        @{@"img":@"student_results_Regress",@"title":@"退      步:",@"detail":@"当次作业综合成绩低于上次作业成绩"},
                        ];
    AlertView * alert = [[AlertView alloc] initWithTitle:@"标识说明" logoInstructions:logos  items:items ];
    
    [alert show];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
