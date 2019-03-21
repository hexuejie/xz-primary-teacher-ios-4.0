
//
//  SubjectsUserInfoNewCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/8/2.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "SubjectsUserInfoNewCell.h"
#import "PublicDocuments.h"
#import "UIImageView+WebCache.h"
@interface SubjectsUserInfoNewCell()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;
@property (weak, nonatomic) IBOutlet UIImageView *userImgV;

@end
@implementation SubjectsUserInfoNewCell
- (void)setupInfoTitle:(NSAttributedString *)titleAttributedString withUrlImg:(NSString *)imgUrl withPlaceholderImageImg:(NSString *)imgName{

//    self.title.text = title;
    self.title.attributedText = titleAttributedString;
//    self.userImgV.image = [UIImage imageNamed:imgName];
    
    self.userImgV.layer.masksToBounds = YES;
    self.userImgV.layer.borderWidth = 0.5;
    self.userImgV.layer.cornerRadius = 40/2;
    self.userImgV.layer.borderColor = [UIColor clearColor].CGColor;
   [self.userImgV sd_setImageWithURL:[NSURL URLWithString:imgUrl]  placeholderImage:[UIImage imageNamed:imgName]];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bottomLine.backgroundColor = project_line_gray;
    self.title.textColor = project_main_blue;
    self.title.font = fontSize_14;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
