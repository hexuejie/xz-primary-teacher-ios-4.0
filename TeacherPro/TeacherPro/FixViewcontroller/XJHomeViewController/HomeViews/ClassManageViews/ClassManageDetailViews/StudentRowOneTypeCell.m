//
//  StudentRowOneTypeCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/6/1.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "StudentRowOneTypeCell.h"
#import "PublicDocuments.h"
#import "ProUtils.h"
#import "Masonry.h"
@interface StudentRowOneTypeCell()
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIImageView *bgImgV;

@end
@implementation StudentRowOneTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupBtn: self.leftBtn withColor:project_main_blue withFont:fontSize_14];
    
    [self setupBtn: self.rightBtn withColor:project_main_blue withFont:fontSize_14];
    
    CGFloat top = 25; // 顶端盖高度
    CGFloat bottom = 25 ; // 底端盖高度
    CGFloat left = 10; // 左端盖宽度
    CGFloat right = 10; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    
    UIImage * image = [UIImage imageNamed:@"class_teacher_bg"]  ;
    // 指定为拉伸模式，伸缩后重新赋值
    image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    self.bgImgV.image = image;
    
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
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)leftAction:(id)sender {
    if (self.touchBlock) {
        self.touchBlock(StudentRowOneTypeCellTouchType_sendMessage, self.index);
    }
}
- (IBAction)rightAction:(id)sender {
    if (self.touchBlock) {
        self.touchBlock(StudentRowOneTypeCellTouchType_Info, self.index);
    }
}

@end
