//
//  UnOnlineRewardCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/8/15.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "UnOnlineRewardCell.h"
#import "PublicDocuments.h"
#import "ProUtils.h"

@interface UnOnlineRewardCell()
@property (weak, nonatomic) IBOutlet UILabel *studentName;//学生名字

@property (weak, nonatomic) IBOutlet UILabel *rewardName;//奖励豆
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameWith;
@property (weak, nonatomic) IBOutlet UIButton *itemBtn;


@end
@implementation UnOnlineRewardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubview];
}

-(void)setupSubview{
    
    self.bottomLineView.backgroundColor = project_line_gray;
    
    self.studentName.textColor = UIColorFromRGB(0x6b6b6b);
    self.studentName.font = fontSize_14;
    self.rewardName.font = fontSize_13;
    self.rewardName.textColor = UIColorFromRGB(0xFF2537);
    self.nameWith.constant = FITSCALE(72);
    self.itemBtn.backgroundColor = UIColorFromRGB(0xFFE8C9);
    [self.itemBtn setTitleColor: UIColorFromRGB(0xAA7B5D) forState:UIControlStateNormal];
    self.itemBtn.hidden = YES;
    [self.itemBtn addTarget:self action:@selector(itemAction:) forControlEvents:UIControlEventTouchUpInside];
    self.itemBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
}


- (void)setupStudentInfo:(NSDictionary *)info  {
    
    if ([info objectForKey:@"unknowQuestions"] && [[info objectForKey:@"unknowQuestions"] count] >0) {
        self.itemBtn.hidden = NO;
//        NSString * unknowQuestions = [[info objectForKey:@"unknowQuestions"] componentsJoinedByString:@","];
//        NSString *itemTitle = [NSString stringWithFormat:@"不会做%@题",unknowQuestions];
        NSString *itemTitle = [NSString stringWithFormat:@"有%ld题不会做",[[info objectForKey:@"unknowQuestions"] count]];
//        CGSize size = [itemTitle sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
//        if (size.width > 120) {
            [self.itemBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            self.itemBtn.backgroundColor = UIColorFromRGB(0xD2200D);
            self.itemBtn.backgroundColor = UIColorFromRGB(0xF38826);
        
//        }
       [self.itemBtn setTitle:itemTitle forState:UIControlStateNormal];
        self.rewardName.hidden = YES;
    }else{
        self.rewardName.hidden = NO;
    }
    
 
    NSString * name  = info[@"studentName"];
    
    if (name && name.length >5) {
        name = [name substringToIndex:5];
    }
    self.studentName.text = name;
    
    NSString * key = @"";
    UIColor * textColor ;
    //完成
    if (info[@"finishTime"]) {
          //完成了没分数
          key = @"完成";
         textColor = UIColorFromRGB(0x6b6b6b);
    }else{
        //未完成
        key = @"未完成";
        textColor = UIColorFromRGB(0xFF2537);
    }
    self.rewardName.textColor =textColor;
    self.rewardName.text = key;
    
    
    
}
- (void)itemAction:(UIButton *)itemBtn{
    
    if (self.selectedBlock) {
        self.selectedBlock(self.indexPath);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
