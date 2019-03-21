
//
//  HWUnfinishedCell.m
//  TeacherPro
//
//  Created by DCQ on 2018/7/12.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "HWUnfinishedCell.h"
#import "PublicDocuments.h"
#import "UIImageView+WebCache.h"
@interface HWUnfinishedCell()
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
@property (weak, nonatomic) IBOutlet UILabel *studentName;
@property (weak, nonatomic) IBOutlet UILabel *hwState;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImgV;

@end
@implementation HWUnfinishedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubView];
}
- (void)setupSubView{
    
    self.studentName.textColor = UIColorFromRGB(0x6b6b6b);
    self.studentName.font = fontSize_13;
    self.hwState.font = fontSize_13;
}
- (void)setupStudentDic:(NSDictionary *)studentDic{
  
    NSString * avatar = studentDic[@"avatar"];
    NSString * placeholderImgName = @"";
    if ([studentDic[@"sex"] isEqualToString:@"female"]) {
          placeholderImgName =  @"student_wuman";
    }else if ([studentDic[@"sex"] isEqualToString:@"male"]){
        placeholderImgName =  @"student_man";
    }else{
        placeholderImgName =  @"student_wuman";
    }
    [self.imgIcon   sd_setImageWithURL:[NSURL URLWithString:avatar]placeholderImage: [UIImage imageNamed:placeholderImgName]];
    self.studentName.text = studentDic[@"studentName"];
    self.hwState.text = @"未完成";
    self.hwState.textColor = UIColorFromRGB(0xE81122);
    self.arrowImgV.hidden = YES;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
