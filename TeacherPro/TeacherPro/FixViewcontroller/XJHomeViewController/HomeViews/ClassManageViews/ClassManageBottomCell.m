//
//  ClassManageBottomCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/5/31.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "ClassManageBottomCell.h"
#import "ProUtils.h"
#import "PublicDocuments.h"
#import "ClassManageModel.h"
#import "Masonry.h"

@interface ClassManageBottomCell()
@property (weak, nonatomic) IBOutlet UIButton *transferBtn;
@property (weak, nonatomic) IBOutlet UIButton *dissolutionBtn;
@property (weak, nonatomic) IBOutlet UIButton *eixtBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomBackgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImgV;

@end
@implementation ClassManageBottomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
  
    
//    self.bottomBackgroundView.backgroundColor = UIColorFromRGB(0xf7f7f7);
    [self setupBtn: self.transferBtn withColor:project_main_blue withFont:fontSize_15];
    
    [self setupBtn: self.dissolutionBtn withColor:UIColorFromRGB(0xc24e5c) withFont:fontSize_15];
    [self setupBtn: self.eixtBtn withColor:UIColorFromRGB(0xff617a) withFont:fontSize_15];
    [self.eixtBtn mas_updateConstraints:^(MASConstraintMaker *make) {
       
        make.width.equalTo(@((IPHONE_WIDTH-60)/2));
        
    }];
    

    UIImage * tempImage =  [UIImage imageNamed:@"class_detail_teacher_bg"]  ;
    // 指定为拉伸模式，伸缩后重新赋值
    tempImage = [tempImage resizableImageWithCapInsets:UIEdgeInsetsMake(10, 15, 15, 10) resizingMode:UIImageResizingModeStretch];
    
    self.bgImgV.image =tempImage;
    
 
    
}
-(void)layoutSubviews
{
    
   
    [super layoutSubviews];
//    self.bgImgV.backgroundColor = project_background_gray;
//    self.bgImgV.layer.cornerRadius = 5;
//    self.bgImgV.layer.borderWidth = 0.5;
//    self.bgImgV.layer.borderColor = UIColorFromRGB(0xCBCBCB).CGColor;
//    self.bgImgV.layer.masksToBounds = YES;
}
- (void)setupBtn:(UIButton *)btn  withColor:(UIColor *) color  withFont:(UIFont *)font {

    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[ProUtils createImageWithColor:color withFrame:CGRectMake(0, 0, 1, 1)] forState:UIControlStateNormal];
    btn.titleLabel.font = font;
    btn.layer.cornerRadius = FITSCALE((44-10)/2);
    btn.layer.masksToBounds = YES;
    [btn mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.height.equalTo(@(FITSCALE(34)));
        
    }];
    
}

- (void)setupInfo:(ClassManageModel *)model{

    if ([model.adminTeacher integerValue] ==  1) {
        self.transferBtn.hidden = NO;
        self.dissolutionBtn.hidden = NO;
        self.eixtBtn.hidden = YES;
    }else{
    
        self.transferBtn.hidden = YES;
        self.dissolutionBtn.hidden = YES;
        self.eixtBtn.hidden = NO;
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)transferAction:(id)sender {
    if (self.bottomBlock) {
         self.bottomBlock(bottomButtonType_transfer,self.indexPath);
    }
   
    
}
- (IBAction)dissolutionAction:(id)sender {
    if (self.bottomBlock) {
        self.bottomBlock(bottomButtonType_dissolution,self.indexPath);
    }
    
}
- (IBAction)eixtAction:(id)sender {
    if (self.bottomBlock) {
        self.bottomBlock(bottomButtonType_eixt,self.indexPath);
    }
    
}

@end
