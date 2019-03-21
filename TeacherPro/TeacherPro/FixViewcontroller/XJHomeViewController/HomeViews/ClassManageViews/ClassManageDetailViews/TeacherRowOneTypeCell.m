//
//  TeacherRowOneTypeCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/6/1.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "TeacherRowOneTypeCell.h"

#import "PublicDocuments.h"
#import "ProUtils.h"
#import "Masonry.h"


@interface TeacherRowOneTypeCell()
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIImageView *bgImgV;
@property (assign, nonatomic) BOOL  isAdmin;
@property (assign, nonatomic) BOOL  oneself;//是自己还是其它人表示
@end
@implementation TeacherRowOneTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
 
    
    [self setupBtn: self.leftBtn withColor:project_main_blue withFont:fontSize_14];
    
    [self setupBtn: self.rightBtn withColor:UIColorFromRGB(0xc24e5c) withFont:fontSize_14];
   
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
- (void)setupCellIsAdmin:(BOOL)isAdmin{
    self.isAdmin = isAdmin;
    if (isAdmin) {
        [self.rightBtn setTitle:@"解散班级" forState:UIControlStateNormal];
     
    }else{
       [self.rightBtn setTitle:@"退出班级" forState:UIControlStateNormal];
    }
    
}



- (IBAction)leftAction:(id)sender {
    TeacherRowOneTypeCellTouchType    type = TeacherRowOneTypeCellTouchType_ChangeCourse;
   //管理员
    if (self.isAdmin) {
        //是自己
        if (self.oneself) {
            type = TeacherRowOneTypeCellTouchType_HomeworkReview;
        }else{
            type = TeacherRowOneTypeCellTouchType_ChangeCourse;
        }
    }
      //不是管理员
    else{
        
        if (self.oneself) {
            type = TeacherRowOneTypeCellTouchType_HomeworkReview;
        }
        
    }
    if (self.touchBlock) {
        self.touchBlock(type, self.index);
        
    }
}
- (IBAction)rightAction:(id)sender {
    TeacherRowOneTypeCellTouchType  type = TeacherRowOneTypeCellTouchType_normal;
//    if (self.isAdmin) {
//        type = TeacherRowOneTypeCellTouchType_DissolutionClasss;
//    }else{
//    
//        type = TeacherRowOneTypeCellTouchType_ExitClass;
//    }
    
    
    
    //管理员
    if (self.isAdmin) {
        //是自己
        if (self.oneself) {
            type = TeacherRowOneTypeCellTouchType_ChangeCourse;
        }else{
             type = TeacherRowOneTypeCellTouchType_KickedOut;
        }
    }
    //不是管理员
    else{
         if (self.oneself) {
            type = TeacherRowOneTypeCellTouchType_ChangeCourse;
        }
        
    }
    if (self.touchBlock) {
        self.touchBlock(type, self.index);
    }
}

- (void)setupCellIsAdmin:(BOOL)isAdmin withOneself:(BOOL )oneself{

    self.isAdmin = isAdmin;
    self.oneself = oneself;
    
    UIColor * rightColor ;
    UIColor * leftColor ;
    if (isAdmin) {
        if (oneself) {
            leftColor = UIColorFromRGB(0x77d684);
            rightColor = project_main_blue;
             [self.rightBtn setTitle:@"修改科目" forState:UIControlStateNormal];
             [self.leftBtn setTitle:@"作业回顾" forState:UIControlStateNormal];
        }else{
        
            leftColor = project_main_blue;
            rightColor = UIColorFromRGB(0xc24e5c);
            [self.rightBtn setTitle:@"踢出班级" forState:UIControlStateNormal];
            [self.leftBtn setTitle:@"修改科目" forState:UIControlStateNormal];

        }
        
    }else{
        leftColor  = UIColorFromRGB(0x77d684);
        rightColor = project_main_blue;
        [self.rightBtn setTitle:@"修改科目" forState:UIControlStateNormal];
        [self.leftBtn setTitle:@"作业回顾" forState:UIControlStateNormal];
    }

    [self setupBtn:self.rightBtn withColor:rightColor  withFont:fontSize_14];
    [self setupBtn:self.leftBtn withColor:leftColor  withFont:fontSize_14];

}
@end
