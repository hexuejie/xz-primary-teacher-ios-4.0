
//
//  TeacherSectionCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/5/14.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "TeacherSectionCell.h"
#import "SessionHelper.h"
#import "SessionModel.h"
#import "PublicDocuments.h"
#import "ProUtils.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
@interface TeacherSectionCell ()
@property (weak, nonatomic) IBOutlet UILabel *teacherNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *teacherCourseLabel;

@property (weak, nonatomic) IBOutlet UILabel *isOpenLabel;
@property (weak, nonatomic) IBOutlet UIImageView *isOpenImgV;
@property (weak, nonatomic) IBOutlet UIButton *isOpenOrCloseBtn;
@property (weak, nonatomic) IBOutlet UIImageView *isAdminIcon;
@property (weak, nonatomic) IBOutlet UIView *arrowView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImgV;
@property (weak, nonatomic) IBOutlet UIImageView *teacherImgV;
@property (weak, nonatomic) IBOutlet UIImageView *detailArrow;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;

@end
@implementation TeacherSectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
 
    // Initialization code
    self.teacherNameLabel.font = fontSize_14;
    self.teacherCourseLabel.font = fontSize_13;
  
    UIView * bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor clearColor];
    self.selectedBackgroundView =bgView;
    self.backgroundColor = [UIColor clearColor];
   
   
 
    self.bgImgV.backgroundColor = [UIColor whiteColor];
//    CGFloat top = 25; // 顶端盖高度
//    CGFloat bottom = 25 ; // 底端盖高度
//    CGFloat left = 10; // 左端盖宽度
//    CGFloat right = 10; // 右端盖宽度
//    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
//    
//    UIImage * image = [UIImage imageNamed:@"class_detail_bg"]  ;
//    // 指定为拉伸模式，伸缩后重新赋值
//    image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
//    [self.bgImgV setImage:image];
    
    [self.teacherImgV setImage:[UIImage imageNamed:@"student_img"]];
    self.teacherImgV.layer.borderColor = UIColorFromRGB(0xe8e8e8).CGColor;
    self.teacherImgV.layer.masksToBounds = YES;
    self.teacherImgV.layer.borderWidth = 0.5;
    self.teacherImgV.layer.cornerRadius = 40/2;
 
    
    self.detailArrow.hidden =YES;
    
    self.bottomLine.backgroundColor = project_line_gray;
    
}
- (void)setupCellInfo:(ClassDetailTeacherModel *)model isAdmin:(BOOL)isAdmin{

   
    UIImage * placeholderImg = nil;
    if ([model.sex isEqualToString:@"male"]) {
        placeholderImg = [UIImage imageNamed:@"tearch_man"];
    }else if([model.sex isEqualToString:@"female"]){
        placeholderImg = [UIImage imageNamed:@"tearch_wuman"];
        
    }else  {
        placeholderImg = [UIImage imageNamed:@"tearch_wuman"];
    }
    
    [self.teacherImgV sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:placeholderImg];

    if ([model.adminTeacher integerValue]== 1) {
        self.isAdminIcon.hidden = NO;
    }else{
        self.isAdminIcon.hidden = YES;
        
    }
    
    NSString * teacherId;
    if ([[SessionHelper sharedInstance] checkSession]) {
        teacherId =  [[SessionHelper sharedInstance] getAppSession].teacherId ;
    }
    if (![model.teacherId isEqualToString: teacherId] && !isAdmin) {
         self.arrowView.hidden = YES;
    }else{
        self.arrowView.hidden = NO;
    }
    
    NSString * teacherName = @"";
    NSString * phone = [ProUtils replacingCenterPhone:model.teacherPhone withReplacingSymbol:@"*"];
    
    if (model.teacherName && model.teacherName.length >0) {
        teacherName  = model.teacherName;
        if ([teacherName length]>5) {
            teacherName = [teacherName substringToIndex:5];
        }
         teacherName = [NSString stringWithFormat:@"%@(%@)",teacherName,phone];
        NSRange range = [teacherName rangeOfString:[NSString stringWithFormat:@"(%@)",phone]];
        
        NSAttributedString * teacherAttributedString = [ProUtils setAttributedText:teacherName withColor:UIColorFromRGB(0x898989) withRange:range withFont:fontSize_12];
          self.teacherNameLabel.attributedText = teacherAttributedString;
    }else{
    
        teacherName = phone;
        self.teacherNameLabel.text = teacherName;
    }
    

    
//    self.teacherNameLabel.text = model.teacherName;
    self.teacherCourseLabel.text = model.subjectNames ;
    
}
- (void)setupCellOpenState:(BOOL )isOpen{

    if (isOpen) {
        self.isOpenImgV.image = [UIImage imageNamed:@"class_close"];
        self.isOpenLabel.text = @"收起";
    }else{
        self.isOpenImgV.image = [UIImage imageNamed:@"class_open"];
        self.isOpenLabel.text = @"展开";
    
    }
    self.isOpenOrCloseBtn.selected = isOpen;
}


- (void)setupTableviewCellEdit:(BOOL)edit{
    
    if (edit) {
        
        CGFloat offset= 50 *scale_x;
        [self.arrowView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo([self.contentView superview].mas_trailing).offset(offset );
        }];
        
    }else{
        CGFloat offset= 0 *scale_x;
        [self.arrowView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo([self.contentView superview].mas_trailing).offset(offset);
        }];
    }
}


- (IBAction)openOrCloseAction:(id)sender {
    self.isOpenOrCloseBtn.selected = !self.isOpenOrCloseBtn.selected;
    if (self.btnBlock) {
        self.btnBlock(self.indexPath,self.isOpenOrCloseBtn.selected);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
  
    // Configure the view for the selected state
}
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self clearSysImage];
    
}

-(void)layoutSubviews
{
    
    [self clearSysImage];
    [super layoutSubviews];
}

- (void)clearSysImage{
    for (UIControl *control in self.subviews){
        if (![control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
          control.backgroundColor = [UIColor clearColor];
        }
    }
    
}
- (void)showDetailArrow{

    self.detailArrow.hidden = NO;
    self.isOpenImgV.hidden = YES;
}

- (void)hiddenDetailArrow{
    
    self.detailArrow.hidden = YES;
    self.isOpenImgV.hidden = YES;
}
@end
