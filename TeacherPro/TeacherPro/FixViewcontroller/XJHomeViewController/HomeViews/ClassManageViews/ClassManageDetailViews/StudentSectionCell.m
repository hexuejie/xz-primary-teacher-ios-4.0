//
//  StudentCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/5/14.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "StudentSectionCell.h"
#import "UIImageView+WebCache.h"
#import "PublicDocuments.h"
#import "Masonry.h"
@interface StudentSectionCell()
@property (weak, nonatomic) IBOutlet UIImageView *studentImgV;
@property (weak, nonatomic) IBOutlet UILabel *studentNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *studentCoinLabel;
@property (weak, nonatomic) IBOutlet UILabel *isOpenLabel;
@property (weak, nonatomic) IBOutlet UIImageView *isOpenImgV;
@property (weak, nonatomic) IBOutlet UIButton *isOpenOrCloseBtn;

@property (weak, nonatomic) IBOutlet UILabel *top3Count;
@property (weak, nonatomic) IBOutlet UILabel *progressiveCount;
@property (weak, nonatomic) IBOutlet UILabel *speedstarCount;

@property (weak, nonatomic) IBOutlet UIView *arrowView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIImageView *oneImgV;
@property (weak, nonatomic) IBOutlet UIImageView *towImgV;
@property (weak, nonatomic) IBOutlet UIImageView *threeImgV;

@end
@implementation StudentSectionCell

- (void)awakeFromNib{
    [super awakeFromNib];

    self.studentNameLabel.font = fontSize_15;
    self.studentCoinLabel.font = fontSize_14;
    self.top3Count.font = fontSize_12;
    self.progressiveCount.font = fontSize_12;
    self.speedstarCount.font = fontSize_12;
    self.studentImgV.layer.borderColor = UIColorFromRGB(0xe8e8e8).CGColor;
    self.lineView.backgroundColor = UIColorFromRGB(0xEBEBEB);
    UIView * bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor clearColor];
    self.selectedBackgroundView = bgView;
}
- (void)setupStudentInfo:(ClassDetailStudentModel *)model{

    UIImage * placeholderImg = nil;
    if ([model.sex isEqualToString:@"male"]) {
        placeholderImg = [UIImage imageNamed:@"student_img"];
    }else  {
       placeholderImg = [UIImage imageNamed:@"student_img"];
    }
    [self.studentImgV sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:placeholderImg];
    NSString * studentName = model.name;
    if (model.name && model.name.length>5) {
        studentName = [studentName substringToIndex:5];
    }
    self.studentNameLabel.text = studentName;
    self.studentCoinLabel.text = [NSString stringWithFormat:@"%@ 豆",model.coin];
    self.top3Count.text = [NSString stringWithFormat:@"x%@",model.top3Count];
    self.progressiveCount.text = [NSString stringWithFormat:@"x%@",model.progressiveCount];
    self.speedstarCount.text = [NSString stringWithFormat:@"x%@",model.speedstarCount];
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
        
        CGFloat offset= 40 *scale_x;
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


 
- (void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
       [self clearColor];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
   
    // Configure the view for the selected state
    [self clearColor];
}

- (void)clearColor{

    self.topView.backgroundColor = [UIColor clearColor];
    self.bottomView.backgroundColor = [UIColor clearColor];
    self.studentNameLabel.backgroundColor = [UIColor clearColor];
    self.studentCoinLabel.backgroundColor = [UIColor clearColor];
    self.top3Count.backgroundColor = [UIColor clearColor];
    self.progressiveCount.backgroundColor = [UIColor clearColor];
    self.speedstarCount.backgroundColor = [UIColor clearColor];
    self.lineView.backgroundColor = UIColorFromRGB(0xEBEBEB);
    self.oneImgV.backgroundColor = [UIColor clearColor];
    self.towImgV.backgroundColor = [UIColor clearColor];
    self.threeImgV.backgroundColor = [UIColor clearColor];
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
@end
