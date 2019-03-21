//
//  ChooseRecipientInfoCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/6/26.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "ChooseRecipientInfoCell.h"
#import "ReceuvedMessageModel.h"
#import "UIImageView+WebCache.h"
#import "PublicDocuments.h"
@interface ChooseRecipientInfoCell()
@property (weak, nonatomic) IBOutlet UIImageView *bottomLineImgV;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *userImgV;
 
@property (weak, nonatomic) IBOutlet UIImageView *selectedImgV;
@end
@implementation ChooseRecipientInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubview];
}
- (void)setupSubview{

    self.userName.font = fontSize_15;
    self.userName.textColor = UIColorFromRGB(0x6b6b6b);
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setupCellInfo:(StudentsModel *)model{

    self.userName.text = model.studentName;
    
    UIImage * placeholderImg = nil;
    if ([model.sex isEqualToString:@"male"]) {
        placeholderImg = [UIImage imageNamed:@"student_man"];
    }else if([model.sex isEqualToString:@"female"]){
        placeholderImg = [UIImage imageNamed:@"student_wuman"];
        
    }else  {
        placeholderImg = [UIImage imageNamed:@"student_img"];
    }
    [self.userImgV sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:placeholderImg];
    
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
