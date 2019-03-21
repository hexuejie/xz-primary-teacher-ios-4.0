//
//  RewardCell.m
//  AplusKidsMasterPro
//
//  Created by DCQ on 2017/3/9.
//  Copyright © 2017年 neon. All rights reserved.
//

#import "RewardCell.h"
#import "PublicDocuments.h"
#import "ProUtils.h"
#import "AlertView.h"
@interface RewardCell()

@property (weak, nonatomic) IBOutlet UIImageView *selelcedImg;
@property (weak, nonatomic) IBOutlet UILabel *studentName;//学生名字

@property (weak, nonatomic) IBOutlet UILabel *rewardName;//奖励豆
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *leftImgV;

@property (weak, nonatomic) IBOutlet UIImageView *centerImgV;
@property (weak, nonatomic) IBOutlet UIImageView *rightImgV;

@property (weak, nonatomic) IBOutlet UIView *iconBgV;
@end
@implementation RewardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bottomLineView.backgroundColor = project_line_gray;
    self.detailLabel.textColor = UIColorFromRGB(0x6b6b6b);
    self.detailLabel.font = fontSize_14;
    self.studentName.textColor = UIColorFromRGB(0x6b6b6b);
    self.studentName.font = fontSize_14;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tabAction)];
    [self.iconBgV addGestureRecognizer:tap];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupStudentInfo:(NSDictionary *)info setupUnfinished:(BOOL)isUnfinished{
//    self.studentName.text = info[@"studentName"];
//     NSString * key = @"";
//    //未完成
//    if (!info[@"scoreTotal"]) {
//        key = @"D";
//    }else{
//        if ([info[@"scoreLevel"] isKindOfClass:[NSString class]] && [info[@"scoreLevel"] length] >0 ) {
//           key = info[@"scoreLevel"];
//        }else{
//            key = @"D";
//        }
//    }
//    
//    NSString * imgName = [NSString stringWithFormat:@"level_%@_icon",key];
//   
//    [self setupCoinNumber:[NSString stringWithFormat:@"%@",info[@"coin"]]];
    self.studentName.text = info[@"studentName"];
    
    //未完成
    if (isUnfinished) {
        NSString * rewardName = [NSString  stringWithFormat:@"扣除%@豆",[NSString stringWithFormat:@"%@",info[@"coin"]]];
        self.rewardName.text = rewardName;
        self.detailLabel.text = @"";
        return ;
    }
    
    //除开未完成其它的显示
    
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
        detailText  = [NSString stringWithFormat:@"作业:%@\n%@",key,feedBack];
    }else{
        detailText  = [NSString stringWithFormat:@"作业:%@",key];
    }
    self.detailLabel.attributedText = [ProUtils setAttributedText:detailText withColor:UIColorFromRGB(0xff5555) withRange:[detailText rangeOfString:key] withFont:fontSize_14]  ;

//    if ([info[@"homeworkFeedback"] isEqualToString:@"photo"] || [info[@"homeworkFeedback"] isEqualToString:@"sound"] ||[info[@"homeworkFeedback"] isEqualToString:@"signature"] ) {
//        
//        NSString * key = @"";
//        if (info[@"finishTime"]) {
//            key = @"已反馈";
//        }else{
//            key = @"未反馈";
//        }
//        //        NSString * imgName = [NSString stringWithFormat:@"level_%@_icon",key];
//        //        [self.levelImgV setImage:[UIImage imageNamed:imgName]];
//        self.detailLabel.text = [NSString stringWithString: key];
//    }else{
//        
//        NSString * key = @"";
//        //未完成
//        if (!info[@"scoreTotal"]) {
//            
//            key = @"未完成";
//            
//        }else{
//            
//            if ([info[@"scoreLevel"] isKindOfClass:[NSString class]] && [info[@"scoreLevel"] length] >0 ) {
//                key = info[@"scoreLevel"];
//            }else{
//                
//                key = @"未";
//            }
//        }
//        
//        NSString * feedBack = @"";
//        if (info[@"finishTime"]) {
//            feedBack = @"已反馈";
//        }else{
//            feedBack = @"未反馈";
//        }
//        NSString * detailText = [NSString stringWithFormat:@"作业:%@\n%@",key,feedBack];
//        
//        self.detailLabel.attributedText = [ProUtils setAttributedText:detailText withColor:UIColorFromRGB(0xff5555) withRange:[detailText rangeOfString:key] withFont:fontSize_14]  ;
//
////        self.detailLabel.text = [NSString stringWithString:[NSString stringWithFormat:@"作业:%@\n%@",key,feedBack]];
//        //        NSString * imgName = [NSString stringWithFormat:@"level_%@_icon",key];
//        //        [self.levelImgV setImage:[UIImage imageNamed:imgName]];
//        
//    }
    [self setupCoinNumber:[NSString stringWithFormat:@"%@",info[@"coin"]]];
    
    
    //图标
    if (info[@"medals"]) {
        NSArray *  medals = info[@"medals"];
        if([medals count]==0){
            self.centerImgV.hidden = YES;
            self.rightImgV.hidden = YES;
            self.leftImgV.hidden = YES;
            self.iconBgV.hidden =YES;
        }else if ([medals count]==1){
            
            self.centerImgV.hidden = YES;
            self.rightImgV.hidden = YES;
        }else if ([medals count] == 2){
            self.rightImgV.hidden = YES;
        }
        for (int i = 0; i< [medals count]; i++) {
            NSString * imageName= [NSString stringWithFormat:@"student_results_%@", medals[i]];
            if (i == 0) {
                self.leftImgV.image = [UIImage imageNamed:imageName];
            }else if (i ==1){
                self.centerImgV.image = [UIImage imageNamed:imageName];
            }else{
                self.rightImgV.image =  [UIImage imageNamed:imageName];
            }
        }
        
    }else{
        
        self.leftImgV.hidden = YES;
        self.rightImgV.hidden = YES;
        self.centerImgV.hidden = YES;
        self.iconBgV.hidden =YES;
    }
    

}
- (void)setupSelectedImgState:(BOOL)YesOrNo{
    if (YesOrNo) {
        self.selelcedImg.image = [UIImage imageNamed:@"batchselect_icon"];
    }else{
        self.selelcedImg.image = [UIImage imageNamed:@"batchunselect_icon"];
    }
 
}
- (void)setupSelectedImgHidden:(BOOL)YesOrNo{
      self.selelcedImg.hidden = YesOrNo;
    
    
}
- (void)setupCoinNumber:(NSString *)coin{

    NSString * rewardName = [NSString  stringWithFormat:@"奖励%@豆",coin];
    self.rewardName.text = rewardName;
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


@end
