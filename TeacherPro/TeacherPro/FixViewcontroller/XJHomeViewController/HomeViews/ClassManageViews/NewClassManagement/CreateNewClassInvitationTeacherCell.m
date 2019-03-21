//
//  CreateNewClassInvitationTeacherCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/8/2.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "CreateNewClassInvitationTeacherCell.h"
#import "PublicDocuments.h"
#import "ProUtils.h"
#import "UIImageView+WebCache.h"
@interface CreateNewClassInvitationTeacherCell()
@property (weak, nonatomic) IBOutlet UIImageView *userImgV;
@property (weak, nonatomic) IBOutlet UILabel *usernameAndPhone;
@property (weak, nonatomic) IBOutlet UILabel *subjectsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgv;//表示已注册 未注册
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;

@end
@implementation CreateNewClassInvitationTeacherCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubview];
}

- (void)setupSubview{

    self.bottomLine.backgroundColor = project_line_gray;
    self.usernameAndPhone.textColor = project_main_blue;
    self.usernameAndPhone.font = fontSize_14;
    self.subjectsLabel.textColor = UIColorFromRGB(0x898989);
    self.subjectsLabel.font = fontSize_14;
    self.userImgV.layer.masksToBounds = YES;
    self.userImgV.layer.borderWidth = 0.5;
    self.userImgV.layer.cornerRadius = 40/2;
    self.userImgV.layer.borderColor = [UIColor clearColor].CGColor;
    
}

- (void)setupInvitationInfo:(NSDictionary *)info{

    UIImage *placeholderImage = [UIImage imageNamed:@"student_img"];
    
    if (info[@"sex"]) {
            if ([info[@"sex"] isEqualToString:@"male"]) {
                placeholderImage =[UIImage imageNamed: @"tearch_man"];
            }else if([info[@"sex"] isEqualToString:@"female"]){
                placeholderImage =[UIImage imageNamed:  @"tearch_wuman"];
            }
            
        }
    
    [self.userImgV sd_setImageWithURL:[NSURL URLWithString:info[@"avatar"]] placeholderImage:placeholderImage];
    
    
   
     NSString * subjects =@"";
    for (NSDictionary * dic in info[@"subjects"]) {
        if (subjects.length == 0) {
            subjects = dic[@"subjects"];
        }else{
            subjects = [subjects stringByAppendingFormat:@",%@", dic[@"subjects"]];
        }
    }
    self.subjectsLabel.text = subjects;
//    if ([info[@"register"] integerValue] == 1) {
        NSString * tempPhone = [ProUtils replacingCenterPhone:info[@"phone"] withReplacingSymbol:@"*" ];
    
        if ([info[@"register"] integerValue] == 1) {
           self.iconImgv.hidden = NO;
        }else{
           self.iconImgv.hidden = YES;
        }
        NSString * usernameAndPhone = [NSString stringWithFormat:@"%@(%@)",info[@"teacherName"],tempPhone];
       NSRange rangeStu = [usernameAndPhone  rangeOfString:[NSString stringWithFormat:@"(%@)",tempPhone]];
      NSAttributedString * attributtedString = [ProUtils setAttributedText:usernameAndPhone withColor:UIColorFromRGB(0x898989) withRange:rangeStu withFont:fontSize_12];
        self.usernameAndPhone.attributedText = attributtedString;
//        self.usernameAndPhone.text = [NSString stringWithFormat:@"%@(%@)",info[@"teacherName"],info[@"phone"]];
//    }else{
//        
//        self.usernameAndPhone.text = info[@"phone"];
//        self.iconImgv.hidden = YES;
//    }
}

 
- (IBAction)deleteAction:(id)sender {
    if (self.deleteBlock) {
        self.deleteBlock(self.index);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
