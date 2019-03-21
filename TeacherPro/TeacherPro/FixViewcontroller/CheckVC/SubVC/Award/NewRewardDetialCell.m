//
//  NewRewardDetialCell.m
//  TeacherPro
//
//  Created by 何学杰 on 2019/1/3.
//  Copyright © 2019 ZNXZ. All rights reserved.
//

#import "NewRewardDetialCell.h"
#import "UIImageView+WebCache.h"

@implementation NewRewardDetialCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    
    NSString * avatar = _dataDic[@"avatar"];
    NSString * placeholderImgName = @"";
    if ([_dataDic[@"sex"] isEqualToString:@"female"]) {
        placeholderImgName =  @"student_wuman";
    }else if ([_dataDic[@"sex"] isEqualToString:@"male"]){
        placeholderImgName =  @"student_man";
    }else{
        placeholderImgName =  @"student_wuman";
    }
    [self.logoImageView  sd_setImageWithURL:[NSURL URLWithString:avatar]placeholderImage:  [UIImage imageNamed:placeholderImgName]];
    self.nameLabel.text = _dataDic[@"studentName"];
    
    self.tagImage.hidden = NO;
    NSString *strMedals = _dataDic[@"scoreLevel"];
    if ([strMedals isEqualToString:@"A"]) {
        self.tagImage.image = [UIImage imageNamed:@"Group 10 CopyAA"];
    }else if([strMedals isEqualToString:@"B"]){
        self.tagImage.image = [UIImage imageNamed:@"Group 10 CopyBB"];
    }else if([strMedals isEqualToString:@"C"]){
        self.tagImage.image = [UIImage imageNamed:@"Group 10 CopyCC"];
    }else{
        self.tagImage.hidden = YES;
    }
}


@end
