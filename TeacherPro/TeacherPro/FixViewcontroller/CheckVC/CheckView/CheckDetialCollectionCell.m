//
//  CheckDetialCollectionCell.m
//  TeacherPro
//
//  Created by 何学杰 on 2018/12/24.
//  Copyright © 2018 ZNXZ. All rights reserved.
//

#import "CheckDetialCollectionCell.h"
#import "PublicDocuments.h"
#import "UIImageView+WebCache.h"

@implementation CheckDetialCollectionCell

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
    [self.headerImage  sd_setImageWithURL:[NSURL URLWithString:avatar]placeholderImage:  [UIImage imageNamed:placeholderImgName]];
    self.nameLabel.text = _dataDic[@"studentName"];
    
    self.CheckUpImage.hidden = YES;
    self.checkGoodImage.hidden = YES;
    self.checkSpeedImage.hidden = YES;
   NSArray *medals = _dataDic[@"medals"];
    for (NSString *strMedals in medals) {
        if ([strMedals isEqualToString:@"Progressive"]) {
            self.CheckUpImage.hidden = NO;
        }else if([strMedals isEqualToString:@"Top3"]){
            self.checkGoodImage.hidden = NO;
        }else if([strMedals isEqualToString:@"Speedstar"]){
            self.checkSpeedImage.hidden = NO;
        }
    }
}

//
///**
// * 作业进步达人
// */
//Progressive,
///**
// * 作业top3
// */
//Top3,
///**
// * 作业速度之星
// */
//Speedstar
@end
