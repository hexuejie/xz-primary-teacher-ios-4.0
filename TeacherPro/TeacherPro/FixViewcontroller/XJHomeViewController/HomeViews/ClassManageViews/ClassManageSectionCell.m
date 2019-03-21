//
//  ClassManageSectionCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/5/31.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "ClassManageSectionCell.h"
#import "PublicDocuments.h"
#import "ClassManageModel.h"
#import "Masonry.h"
@interface ClassManageSectionCell()
@property (weak, nonatomic) IBOutlet UIView *leftLinView;
@property (weak, nonatomic) IBOutlet UIView *centerLineView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;//管理员姓名
@property (weak, nonatomic) IBOutlet UILabel *userNameShorthandLabel;//管理员简写
@property (weak, nonatomic) IBOutlet UILabel *teacherLabel;//教师
@property (weak, nonatomic) IBOutlet UILabel *teacherNumberLabel;//教师数
@property (weak, nonatomic) IBOutlet UILabel *studentLabel;//学生
@property (weak, nonatomic) IBOutlet UILabel *studentNumberLabel;//学生数
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImgV;

@property (weak, nonatomic) IBOutlet UIImageView *bottomBgImgV;
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UIImageView *bigBgImgV;
@property (weak, nonatomic) IBOutlet UIImageView *smallBgImgV;
@property (weak, nonatomic) IBOutlet UIImageView *sectionTImgV;

@end
@implementation ClassManageSectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.leftLinView.backgroundColor = UIColorFromRGB(0xe8e8e8);
    self.centerLineView.backgroundColor = UIColorFromRGB(0xe8e8e8);
    
    self.titleLabel.textColor =  UIColorFromRGB(0x6b6b6b);
    self.titleLabel.font = fontSize_15;
    
    self.teacherLabel.textColor = UIColorFromRGB(0x6b6b6b);
    self.teacherLabel.font = fontSize_13;
    
    self.studentLabel.textColor = UIColorFromRGB(0x6b6b6b);
    self.studentLabel.font = fontSize_13;
    
    self.userNameLabel.textColor = UIColorFromRGB(0x6b6b6b);
    self.userNameLabel.font = fontSize_14;
    
    self.userNameShorthandLabel.textColor = [UIColor whiteColor];
    self.userNameShorthandLabel.font = fontSize_14;
    self.userNameShorthandLabel.backgroundColor = project_main_blue;
    self.userNameShorthandLabel.layer.cornerRadius = 35/2;
    self.userNameShorthandLabel.layer.masksToBounds = YES;
  
    self.backgroundColor = [UIColor clearColor];
    self.bottomView.backgroundColor = [UIColor clearColor];
    self.bigBgImgV.hidden = YES;
    
    
    CGFloat top = 10; // 顶端盖高度
    CGFloat bottom = 10 ; // 底端盖高度
    CGFloat left = 5; // 左端盖宽度
    CGFloat right = 5; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
  
    UIImage * image = [UIImage imageNamed:@"class_manage_bottom3"]  ;
    // 指定为拉伸模式，伸缩后重新赋值
    image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    [self.bottomBgImgV setImage:image];
    
    
    UIImage * bigimage = [UIImage imageNamed:@"class_section_bg1"]  ;
    // 指定为拉伸模式，伸缩后重新赋值
    bigimage = [bigimage resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    [self.bigBgImgV setImage:bigimage];
   
//    UIImage * smallimage = [UIImage imageNamed:@"class_section_bg2"]  ;
//    // 指定为拉伸模式，伸缩后重新赋值
//    smallimage = [smallimage resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
//    [self.smallBgImgV setImage:smallimage];
    
   
    UIImage * sectionImage = [UIImage imageNamed:@"class_section_title_bg1"]  ;
    // 指定为拉伸模式，伸缩后重新赋值
    sectionImage = [sectionImage resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    [self.sectionTImgV setImage:sectionImage];
    
    
    [self.rightView mas_updateConstraints:^(MASConstraintMaker *make) {
       
        make.width.equalTo(@(FITSCALE(120)));
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setupCellInfo:(ClassManageModel *) info withEditState:(BOOL) edit{

    if (edit) {
        self.arrowImgV.hidden = YES;
        self.bigBgImgV.hidden = NO;
    }else{
        self.bigBgImgV.hidden = YES;
        self.arrowImgV.hidden =  NO;
    }
    
    UIColor * sorthandColor;
    if ([info.adminTeacher integerValue] == 1) {
        
        sorthandColor = UIColorFromRGB(0xff617a);
    }else{
    
        sorthandColor = project_main_blue;
    }
    self.userNameShorthandLabel.backgroundColor =  sorthandColor;
    self.titleLabel.text = [NSString stringWithFormat:@"%@ %@", info.gradeName,info.clazzName ];
    self.userNameLabel.text = info.adminName;
    if (info.adminName.length >0 ) {
        self.userNameShorthandLabel.text = [info.adminName substringToIndex:1];
    }else{
    
        self.userNameShorthandLabel.text = @"";
    }
    
    
    NSString * studentNumber = [NSString stringWithFormat:@"%@人",info.studentCount ];
    
  
    
    UIColor * color ;
    if ([info.studentCount integerValue] >0) {
        color =  UIColorFromRGB(0x6b6b6b);
    }else{
        
        color = [UIColor redColor];
    }
    
    NSRange rangeStu= [studentNumber  rangeOfString:[NSString stringWithFormat:@"%@",info.studentCount]];
    self.studentNumberLabel.attributedText = [self setAttributedText:studentNumber withColor:color withRange:rangeStu];
    
    NSString *  teacherNumber = [NSString stringWithFormat:@"%@人",info.teacherCount ];
    
    
    
    UIColor * colorTea ;
    if ([info.teacherCount integerValue] >0) {
        colorTea =  UIColorFromRGB(0x6b6b6b);
    }else{
        
        colorTea = [UIColor redColor];
    }
    NSRange range= [teacherNumber  rangeOfString:[NSString stringWithFormat:@"%@",info.teacherCount]];
  
    
    self.teacherNumberLabel.attributedText = [self setAttributedText:teacherNumber withColor:colorTea  withRange:range];
    
}

- (NSAttributedString *)setAttributedText:(NSString *)text withColor:(UIColor *)color withRange:(NSRange )range{
    
    NSMutableAttributedString *Attributed  = [[NSMutableAttributedString alloc]initWithString:text];
    
    
    
    [Attributed addAttribute:NSFontAttributeName
     
                       value: fontSize_16
     
                       range:range];
    [Attributed addAttribute:NSForegroundColorAttributeName
     
                       value:color
     
                       range:range];
  
    return Attributed;
}

@end
