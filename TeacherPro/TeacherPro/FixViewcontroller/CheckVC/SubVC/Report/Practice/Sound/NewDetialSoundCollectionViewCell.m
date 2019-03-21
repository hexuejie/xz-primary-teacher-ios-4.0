//
//  NewDetialSoundCollectionViewCell.m
//  TeacherPro
//
//  Created by 何学杰 on 2019/1/15.
//  Copyright © 2019 ZNXZ. All rights reserved.
//

#import "NewDetialSoundCollectionViewCell.h"
#import "PublicDocuments.h"
#import "UIImageView+WebCache.h"

@implementation NewDetialSoundCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backGroundButton.layer.masksToBounds = YES;
    self.backGroundButton.layer.cornerRadius = 56/2;
    
    self.headerImage.layer.masksToBounds = YES;
    self.headerImage.layer.cornerRadius = 46/2;
    
    self.headerImage.backgroundColor = [UIColor redColor];
//    report_sound_playing
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
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:[UIImage imageNamed:placeholderImgName]];
    self.nameLabel.text = _dataDic[@"studentName"];
    
}

//- (void)isPlay

@end
