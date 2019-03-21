//
//  ReleaseStyleCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/6/12.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "ReleaseStyleCell.h"
#import "PublicDocuments.h"
#import "ProUtils.h"

@interface ReleaseStyleCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;
@property (weak, nonatomic) IBOutlet UILabel *iconTitleLabel;

@property (strong, nonatomic) NSArray * styleData;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImgV;

@end
@implementation ReleaseStyleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    NSDictionary * grade = @{@"img":@"homework_group",@"title":@"布置班级",@"detail":@"请选择布置班级"};
    NSDictionary * feedback  = @{@"img":@"homework_feedback",@"title":@"反馈方式",@"detail":@"选择反馈方式"};
    NSDictionary * completeDate = @{@"img":@"homework_completeDate",@"title":@"截止时间",@"detail":@"选择截止时间"};
    self.styleData = [NSArray arrayWithObjects:grade,feedback,completeDate, nil];
    
    self.lineView.backgroundColor = project_line_gray;
}

- (void)setupReleaseHomeworkStyle:(ReleaseStyle )style withDetail:(NSString *)detail{
    
    NSDictionary * info ;
    if (style == ReleaseStyle_ReleaseGrade) {
        info =  self.styleData[0];
    }else if (style == ReleaseStyle_ReleaseFeedback){
        info =  self.styleData[1];
    }else if (style == ReleaseStyle_ReleaseCompleteDate){
        info =  self.styleData[2];
    }
    self.iconImgV.image = [UIImage imageNamed:info[@"img"]];
    self.iconImgV.contentMode = UIViewContentModeScaleAspectFit;
    self.iconTitleLabel.text = info[@"title"];
    if (detail) {
        if (style == ReleaseStyle_ReleaseGrade) {
//            NSRange range = NSMakeRange(4, detail.length-4);
//            self.detailLabel.attributedText = [self setAttributedText:detail withColor:self.detailLabel.textColor withRange:range];
            self.detailLabel.text = detail;
        }else
            self.detailLabel.text = detail;
        
    }else
        self.detailLabel.text =  info[@"detail"];
}
- (NSAttributedString *)setAttributedText:(NSString *)text withColor:(UIColor *)color withRange:(NSRange )range{
    
    NSMutableAttributedString *Attributed  = [[NSMutableAttributedString alloc]initWithString:text];
    
    
    
    [Attributed addAttribute:NSFontAttributeName
     
                       value: fontSize_12
     
                       range:range];
    [Attributed addAttribute:NSForegroundColorAttributeName
     
                       value:color
     
                       range:range];
    
    return Attributed;
}

- (void)hiddeArrow{

    self.arrowImgV.hidden = YES;
}
@end
