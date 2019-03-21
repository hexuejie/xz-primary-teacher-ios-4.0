//
//  InvitationJoinTeacherCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/8/4.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "InvitationJoinTeacherCell.h"
#import "PublicDocuments.h"
#import "QueryJoiningTeacherModel.h"
#import "UIImageView+WebCache.h"
#import "ProUtils.h"
@interface InvitationJoinTeacherCell()
@property (weak, nonatomic) IBOutlet UIView *bottomLine;
@property (weak, nonatomic) IBOutlet UILabel *subjectsLabel;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *userImgV;

@end
@implementation InvitationJoinTeacherCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubview];
}

- (void)setupSubview{

    self.userName.textColor = project_main_blue;
    self.userName.font = fontSize_14;
    
    self.subjectsLabel.textColor = UIColorFromRGB(0x898989);
    self.subjectsLabel.font = fontSize_14;
    
    self.bottomLine.backgroundColor =  project_line_gray;
    
}

- (void)setupTeacherInfo:(JoiningTeacherModel *)model{
 
    UIImage *  placeholderImg =  nil;
    if ([model.sex isEqualToString:@"female"]) {
        
        placeholderImg = [UIImage imageNamed:@"tearch_wuman"];
    }else if ([model.sex isEqualToString:@"male"]){
        placeholderImg = [UIImage imageNamed:@"tearch_man"];
    } else{
        placeholderImg = [UIImage imageNamed:@"tearch_wuman"];
    }
    
    [self.userImgV sd_setImageWithURL:[NSURL URLWithString:model.thumbnail] placeholderImage:placeholderImg];
    NSString * teacherName = @"";
    NSString * phone = [ProUtils replacingCenterPhone:model.teacherPhone withReplacingSymbol:@"*"];
    
    if ([model.isRegister integerValue] == 1) {
          teacherName  = model.teacherName;
    }else{
         teacherName  = @"未注册";
        
    }
    
    
  
    teacherName = [NSString stringWithFormat:@"%@(%@)",teacherName,phone];
    NSRange range = [teacherName rangeOfString:[NSString stringWithFormat:@"(%@)",phone]];
    
    NSAttributedString * teacherAttributedString = [ProUtils setAttributedText:teacherName withColor:UIColorFromRGB(0x898989) withRange:range withFont:fontSize_12];
    self.userName.attributedText =teacherAttributedString  ;
    
//    if (model.teacherName && model.teacherName.length >0) {
//        teacherName  = model.teacherName;
//        teacherName = [NSString stringWithFormat:@"%@(%@)",teacherName,phone];
//        NSRange range = [teacherName rangeOfString:[NSString stringWithFormat:@"(%@)",phone]];
//        
//        NSAttributedString * teacherAttributedString = [ProUtils setAttributedText:teacherName withColor:UIColorFromRGB(0x898989) withRange:range withFont:fontSize_12];
//    
//         self.userName.attributedText =teacherAttributedString  ;
//    }else{
//        
//          teacherName = phone;
//         self.userName.text = teacherName  ;
// 
//    }
    
    self.subjectsLabel.text = model.subjectNames ;
   
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
