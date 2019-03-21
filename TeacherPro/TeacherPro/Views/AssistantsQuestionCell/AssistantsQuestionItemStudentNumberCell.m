
//
//  AssistantsQuestionItemStudentNumberCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/11/10.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "AssistantsQuestionItemStudentNumberCell.h"
#import "PublicDocuments.h"
#import "ProUtils.h"
@interface AssistantsQuestionItemStudentNumberCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImgV;

@end

@implementation AssistantsQuestionItemStudentNumberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupSubView];
}
- (void)setupSubView{
    self.titleLabel.font = fontSize_14;
    self.titleLabel.textColor = project_main_blue;
    
}
- (void)setupTitle:(NSString *)title withOpenState:(BOOL )state{
    
    if (title) {
        NSString * tempStr = [NSString  stringWithFormat:@"本题有%@名同学有疑问",title];
        NSRange range = [tempStr rangeOfString:title];
        UIColor * color = UIColorFromRGB(0xF40017);
        self.titleLabel.attributedText = [ProUtils setAttributedText:tempStr withColor:color withRange:range withFont:fontSize_15];
//        self.titleLabel.text = tempStr;
        NSString * arrowName = @"";
        if (state) {
            arrowName = @"content_image_close";
        }else{
            arrowName = @"content_image_open";
        }
        self.arrowImgV.image =[UIImage imageNamed:arrowName];
    }else{
        self.titleLabel.text = @"本题没有学生有疑问";
        self.arrowImgV.hidden = YES;
    }
    
}
@end
