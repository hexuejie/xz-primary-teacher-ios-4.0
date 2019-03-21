
//
//  BookHomeworkTypeCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/9/7.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BookHomeworkTypeCell.h"
#import "PublicDocuments.h"
#import "ProUtils.h"


@interface BookHomeworkTypeCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (assign, nonatomic) BookHomeworkType type;

@property (weak, nonatomic) IBOutlet UIImageView *selectedImgV;
@property (weak, nonatomic) IBOutlet UIView *bottomLineV;

@end
@implementation BookHomeworkTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubview];
}

- (void)setupSubview{
//    self.titleLabel.font = systemFontSize(16);
//    self.titleLabel.textColor = UIColorFromRGB(0x525B66);
//    self.rightBtn.layer.masksToBounds = YES;
//    self.rightBtn.layer.cornerRadius = 5;
//    self.rightBtn.layer.borderWidth = 1;
//    self.rightBtn.layer.borderColor = project_main_blue.CGColor;
//    [self.rightBtn setImage:[UIImage imageNamed:@"goto_change"] forState:UIControlStateNormal];
//    [self.rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 100)];
    [self.rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 55, 0, -5)];
    self.rightBtn.titleLabel.numberOfLines = 1;

    [self.rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, - self.rightBtn.imageView.image.size.width, 0, self.rightBtn.imageView.image.size.width)];
//    [self.rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, self.rightBtn.titleLabel.bounds.size.width, 0, -self.rightBtn.titleLabel.bounds.size.width)];
    

}
- (void)setupBookTitle:(NSString *)title withIsHomework:(BOOL )isHomework withImgName:(NSString *)imgName{

    if (isHomework) {

//        stateColor = [UIColor redColor];
//        self.rightBtn.selected = YES;
//        [self.rightBtn setBackgroundColor:HexRGB(0x525B66)];
        [self.rightBtn setTitle:@"已布置" forState:UIControlStateNormal];
//        [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        self.type = BookHomeworkType_change;
    }else{

        self.rightBtn.selected = NO;
//        [self.rightBtn setBackgroundColor:project_main_blue];
        [self.rightBtn setTitle:@"" forState:UIControlStateNormal];
//        [self.rightBtn setTitleColor:project_main_blue forState:UIControlStateNormal];
        [self.rightBtn setBackgroundColor:[UIColor whiteColor]];
        self.type = BookHomeworkType_setup;
    }
    NSString * titleStr = [NSString stringWithFormat:@"%@",title];
    self.titleLabel.text = titleStr;
    [self.iconImgV setImage:[UIImage imageNamed:imgName]];
    self.selectedImgV.hidden = YES;
    
}
//////// 以下为绘本 以上为绘本以外的赋值
- (void)setupCartoonTitle:(NSString *)title   withImgName:(NSString *)imgName withState:(BOOL)isSelected {
 
    self.titleLabel.text =  title;
    self.rightBtn.hidden = YES;
    self.selectedImgV.hidden = NO;
    [self.iconImgV setImage:[UIImage imageNamed:imgName]];
    NSString * imageName = @"homework_unselected";
    if (isSelected) {
        imageName = @"homework_selected";
    }
    self.selectedImgV.image = [UIImage imageNamed:imageName];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)rightButtonAction:(id)sender {
     if (self.rightButtonBlock) {
            self.rightButtonBlock(self.indexPath,self.type);
  }
   
}

@end
