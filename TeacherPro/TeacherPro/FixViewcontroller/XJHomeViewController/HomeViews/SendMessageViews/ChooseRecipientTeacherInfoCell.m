//
//  ChooseRecipientTeacherInfoCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/6/28.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "ChooseRecipientTeacherInfoCell.h"
#import "PublicDocuments.h"
#import "ReceuvedMessageModel.h"
#import "UIImageView+WebCache.h"
@interface ChooseRecipientTeacherInfoCell()
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userPhone;
@property (weak, nonatomic) IBOutlet UIImageView *userImV;

@property (weak, nonatomic) IBOutlet UIImageView *selectedImgV;

@end
@implementation ChooseRecipientTeacherInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubview];
}

- (void)setupSubview{

    self.userPhone.textColor = UIColorFromRGB(0x9f9f9f);
    self.userName.textColor = UIColorFromRGB(0x6b6b6b);
    self.userName.font = fontSize_15;
    self.userPhone.font = fontSize_11;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setupCellInfo:(ReceuvedTeacherContacts *)model{

    UIImage *  placeholderImg =  nil;
    if ([model.sex isEqualToString:@"female"]) {
        
        placeholderImg = [UIImage imageNamed:@"tearch_wuman"];
    }else if ([model.sex  isEqualToString:@"male"]){
        placeholderImg = [UIImage imageNamed:@"tearch_man"];
    } else{
        placeholderImg = [UIImage imageNamed:@"tearch_wuman"];
    }
    [self.userImV sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:placeholderImg];
    self.userPhone.text = model.teacherPhone;
    self.userName.text = model.teacherName;
}

- (void)setupSelectedImgState:(BOOL)YesOrNo{
     NSString * selectedNameImg = @"";
    if (YesOrNo) {
        selectedNameImg = @"message_selected";
    }else{
        selectedNameImg = @"message_selected_normal";
    }
    
    self.selectedImgV.image =  [UIImage imageNamed:selectedNameImg];
}
@end
